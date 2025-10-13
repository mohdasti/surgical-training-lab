#' Threshold Calculation Utilities
#'
#' Helper functions for deriving thresholds from different paradigm parameters

#' Derive Thresholds from Inverted-U Zone Boundaries
#'
#' @param b_left Left boundary of optimal zone (arousal proxy, 0-1)
#' @param b_right Right boundary of optimal zone (arousal proxy, 0-1)
#' @param cfg Configuration list with bounds (high_min, high_max, lapse_min, lapse_max)
#' @return List with high_load_threshold and lapse_threshold
#' @export
derive_thresholds_from_zone_bounds <- function(b_left, b_right, cfg = list()) {
  # Get bounds from config or use defaults
  high_min <- cfg$high_min %||% 0.40
  high_max <- cfg$high_max %||% 0.80
  lapse_min <- cfg$lapse_min %||% 0.70
  lapse_max <- cfg$lapse_max %||% 0.95
  
  # Logic: Narrower optimal zone = stricter thresholds
  # Width of optimal zone
  zone_width <- b_right - b_left
  
  # Normalize zone width (typical range: 0.2 to 0.6)
  # Narrower zone (e.g., 0.2) → strict → high thresholds
  # Wider zone (e.g., 0.6) → lenient → low thresholds
  strictness <- 1 - ((zone_width - 0.2) / 0.4)  # 0 = lenient, 1 = strict
  strictness <- max(0, min(1, strictness))
  
  # Map strictness to thresholds
  # High Load: stricter → higher threshold (less sensitive)
  high_load_threshold <- high_min + strictness * (high_max - high_min)
  
  # Lapse: stricter → higher threshold (less sensitive)
  lapse_threshold <- lapse_min + strictness * (lapse_max - lapse_min)
  
  # Ensure logical ordering: lapse > high_load
  if (lapse_threshold <= high_load_threshold) {
    lapse_threshold <- high_load_threshold + 0.05
  }
  
  list(
    high_load_threshold = high_load_threshold,
    lapse_threshold = lapse_threshold,
    source = "inverted_u",
    zone_width = zone_width,
    strictness = strictness
  )
}

#' Derive Thresholds from Unified Sensitivity
#'
#' @param sensitivity Sensitivity level (0 = lenient, 1 = strict)
#' @param cfg Configuration list with bounds
#' @return List with high_load_threshold and lapse_threshold
#' @export
derive_thresholds_from_sensitivity <- function(sensitivity, cfg = list()) {
  # Get bounds from config or use defaults
  high_min <- cfg$high_min %||% 0.40
  high_max <- cfg$high_max %||% 0.80
  lapse_min <- cfg$lapse_min %||% 0.70
  lapse_max <- cfg$lapse_max %||% 0.95
  
  # Sensitivity mapping:
  # Low sensitivity (0) → High thresholds (lenient, fewer alerts)
  # High sensitivity (1) → Low thresholds (strict, more alerts)
  
  # Invert sensitivity for threshold calculation
  strictness <- 1 - sensitivity
  
  # Map to thresholds (higher strictness = higher threshold = less sensitive)
  high_load_threshold <- high_min + strictness * (high_max - high_min)
  lapse_threshold <- lapse_min + strictness * (lapse_max - lapse_min)
  
  # Ensure logical ordering
  if (lapse_threshold <= high_load_threshold) {
    lapse_threshold <- high_load_threshold + 0.05
  }
  
  list(
    high_load_threshold = high_load_threshold,
    lapse_threshold = lapse_threshold,
    source = "unified_sensitivity",
    sensitivity = sensitivity,
    strictness = strictness
  )
}

#' Derive Thresholds with Fatigue Adjustment
#'
#' @param base_high Base high load threshold
#' @param base_lapse Base lapse threshold  
#' @param time_minutes Current time-on-task in minutes
#' @param fatigue_params List with t0, t1, k_high, k_lapse, f_shape
#' @return List with adjusted thresholds
#' @export
derive_thresholds_with_fatigue <- function(base_high, base_lapse, time_minutes, fatigue_params = list()) {
  # Extract fatigue parameters
  t0 <- fatigue_params$t0 %||% 30      # Fatigue onset time (minutes)
  t1 <- fatigue_params$t1 %||% 90      # Full fatigue time (minutes)
  k_high <- fatigue_params$k_high %||% 0.15     # Adjustment factor for high load
  k_lapse <- fatigue_params$k_lapse %||% 0.20   # Adjustment factor for lapse
  f_shape <- fatigue_params$f_shape %||% "linear"  # Fatigue curve shape
  
  # Compute fatigue factor (0 = no fatigue, 1 = full fatigue)
  if (time_minutes < t0) {
    fatigue_factor <- 0
  } else if (time_minutes >= t1) {
    fatigue_factor <- 1
  } else {
    # Progress through fatigue window
    progress <- (time_minutes - t0) / (t1 - t0)
    
    # Apply curve shape
    fatigue_factor <- switch(f_shape,
      "linear" = progress,
      "exponential" = progress^2,
      "step" = ifelse(progress > 0.5, 1, 0),
      progress  # default to linear
    )
  }
  
  # Lower thresholds as fatigue increases (more sensitive)
  high_adjusted <- base_high * (1 - fatigue_factor * k_high)
  lapse_adjusted <- base_lapse * (1 - fatigue_factor * k_lapse)
  
  # Ensure minimums
  high_adjusted <- max(0.2, high_adjusted)
  lapse_adjusted <- max(0.3, lapse_adjusted)
  
  # Ensure logical ordering
  if (lapse_adjusted <= high_adjusted) {
    lapse_adjusted <- high_adjusted + 0.05
  }
  
  list(
    high_load_threshold = high_adjusted,
    lapse_threshold = lapse_adjusted,
    source = "fatigue_adaptive",
    fatigue_factor = fatigue_factor,
    time_minutes = time_minutes
  )
}

#' Derive Fatigue-Adjusted Thresholds (Alternative Signature)
#'
#' @param time_minutes Current time-on-task in minutes
#' @param baseline List with high_load_threshold0 and lapse_threshold0
#' @param profile List with fatigue parameters (t0, t1, k_high, k_lapse, f_shape)
#' @param cfg Configuration list
#' @return List with adjusted thresholds and fatigue factor
#' @export
derive_fatigue_adjusted_thresholds <- function(time_minutes, baseline, profile, cfg = list()) {
  # Extract baseline thresholds
  base_high <- baseline$high_load_threshold0 %||% 0.60
  base_lapse <- baseline$lapse_threshold0 %||% 0.85
  
  # Extract fatigue profile parameters
  t0 <- profile$t0 %||% 30
  t1 <- profile$t1 %||% 90
  k_high <- profile$k_high %||% 0.15
  k_lapse <- profile$k_lapse %||% 0.20
  f_shape <- profile$f_shape %||% "linear"
  
  # Compute fatigue factor (0 = no fatigue, 1 = full fatigue)
  if (time_minutes < t0) {
    fatigue_factor <- 0
  } else if (time_minutes >= t1) {
    fatigue_factor <- 1
  } else {
    # Progress through fatigue window
    progress <- (time_minutes - t0) / (t1 - t0)
    
    # Apply curve shape
    fatigue_factor <- switch(f_shape,
      "linear" = progress,
      "logistic" = 1 / (1 + exp(-10 * (progress - 0.5))),  # Logistic curve
      "exponential" = progress^2,
      "step" = ifelse(progress > 0.5, 1, 0),
      progress  # default to linear
    )
  }
  
  # Lower thresholds as fatigue increases (more sensitive)
  high_adjusted <- base_high * (1 - fatigue_factor * k_high)
  lapse_adjusted <- base_lapse * (1 - fatigue_factor * k_lapse)
  
  # Ensure minimums
  high_adjusted <- max(0.2, high_adjusted)
  lapse_adjusted <- max(0.3, lapse_adjusted)
  
  # Ensure logical ordering
  if (lapse_adjusted <= high_adjusted) {
    lapse_adjusted <- high_adjusted + 0.05
  }
  
  list(
    high_load_threshold = high_adjusted,
    lapse_threshold = lapse_adjusted,
    source = "fatigue_adaptive",
    fatigue_factor = fatigue_factor,
    time_minutes = time_minutes
  )
}

#' Null-coalescing operator
#' @keywords internal
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

