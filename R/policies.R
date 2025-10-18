#' Adaptive Gain (Inverted-U) demo performance curve
#' @param x numeric arousal axis
#' @param k shape (>0)
#' @param scale global scale
adaptive_gain_perf <- function(x, k = 0.4, scale = 1) {
  scale * x * exp(-k * x)
}

#' Dual-Criterion (SDT): compute criteria and hysteresis lines
#' @return list with crit_hl, crit_lapse, hi_enter, hi_exit, lo_enter, lo_exit
sdt_dual_criterion <- function(
  criterion_tightness = 0.60,
  coupling            = 0.70,
  hys_margin          = 0.15,
  base_hl             =  1.60,
  base_lapse          = -1.60,
  move_range          =  1.00
) {
  crit_hl    <- base_hl   - criterion_tightness * move_range
  crit_lapse <- base_lapse + criterion_tightness * move_range * coupling
  hi_enter <- crit_hl;    hi_exit <- crit_hl    - hys_margin
  lo_enter <- crit_lapse; lo_exit <- crit_lapse + hys_margin
  list(crit_hl=crit_hl, crit_lapse=crit_lapse,
       hi_enter=hi_enter, hi_exit=hi_exit,
       lo_enter=lo_enter, lo_exit=lo_exit)
}

#' Hysteresis state machine: "Normal" / "HL" / "Lapse"
sdt_classify_hysteresis <- function(e, lo_enter, lo_exit, hi_enter, hi_exit) {
  state <- "Normal"; out <- character(length(e))
  for (i in seq_along(e)) {
    x <- e[i]
    if (state == "Normal") {
      if (x > hi_enter) state <- "HL" else if (x < lo_enter) state <- "Lapse"
    } else if (state == "HL") {
      if (x < hi_exit) state <- "Normal"
    } else if (state == "Lapse") {
      if (x > lo_exit) state <- "Normal"
    }
    out[i] <- state
  }
  out
}

.clamp01 <- function(x) pmax(0, pmin(1, x))
.z <- function(x) if (length(x) > 1 && stats::sd(x) > 0) (x - mean(x))/stats::sd(x) else rep(0, length(x))

#' Time-on-Task decision-threshold controller (policy)
#' @param phys_opt optional list with pre/post short windows: RMSSD_pre/post, TEPR_pre/post, Tremor_pre/post
#' @return vector of thresholds over time t
time_on_task_threshold <- function(
  t,
  c_start               = 0.70,
  c_floor               = 0.50,
  onset_min             = 30,
  fatigue_half_life_min = 21,
  microbreak_min        = 60,
  microbreak_reset_fixed= 0.08,
  microbreak_decay_min  = 2,
  phys_opt              = NULL
) {
  tau  <- fatigue_half_life_min / log(2)
  base <- ifelse(t < onset_min, c_start,
                 c_floor + (c_start - c_floor) * exp(-(t - onset_min)/tau))

  # physiology-proportional reset?
  reset_val <- microbreak_reset_fixed
  if (!is.null(phys_opt)) {
    if (all(c("RMSSD_pre","RMSSD_post","TEPR_pre","TEPR_post","Tremor_pre","Tremor_post") %in% names(phys_opt))) {
      d_hrv  <- mean(phys_opt$RMSSD_post)  - mean(phys_opt$RMSSD_pre)   # ↑ good
      d_tepr <- mean(phys_opt$TEPR_post)   - mean(phys_opt$TEPR_pre)    # ↓ good
      d_tr   <- mean(phys_opt$Tremor_post) - mean(phys_opt$Tremor_pre)  # ↓ good
      phi <- 0.5*.clamp01(.z(d_hrv)) + 0.3*.clamp01(.z(-d_tepr)) + 0.2*.clamp01(.z(-d_tr))
      alpha <- 0.35
      gap   <- c_start - base
      reset_val <- alpha * phi * gap
    }
  }

  boost <- if (!is.na(microbreak_min)) {
    ifelse(t >= microbreak_min, reset_val * exp(-(t - microbreak_min)/microbreak_decay_min), 0)
  } else 0
  pmin(c_start, pmax(c_floor, base + boost))
}

# ---- Demo evidence utilities for plots (non-clinical) ----
evidence_demo_distributions <- function(n = 2000) {
  set.seed(1)
  data.frame(
    x = c(stats::rnorm(n, -2, 1), stats::rnorm(n, 0, 1), stats::rnorm(n, 2, 1)),
    class = factor(rep(c("Lapse","Optimal/Normal","High-Load"), each = n), 
                   levels = c("Lapse","Optimal/Normal","High-Load"))
  )
}

evidence_demo_timeseries <- function(T = 400, phi = 0.92, mu = 0.02, sd = 0.12) {
  set.seed(42)
  e <- numeric(T)
  for (t in 2:T) e[t] <- phi*e[t-1] + stats::rnorm(1, mu, sd)
  e
}

