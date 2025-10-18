# Tests for policy controllers in R/policies.R

library(testthat)

# Source the policy functions
source("../../R/policies.R")

# ============================================================================
# Adaptive Gain Tests
# ============================================================================

test_that("adaptive_gain_perf returns correct shape", {
  x <- seq(0, 10, length.out = 100)
  perf <- adaptive_gain_perf(x, k = 0.4, scale = 1)
  
  # Should return same length
  expect_equal(length(perf), length(x))
  
  # Should have a peak (inverted-U)
  expect_true(max(perf) > perf[1])
  expect_true(max(perf) > perf[length(perf)])
  
  # Peak should be positive
  expect_true(max(perf) > 0)
})

test_that("adaptive_gain_perf k parameter affects sharpness", {
  x <- seq(0, 10, length.out = 100)
  perf_sharp <- adaptive_gain_perf(x, k = 1.0, scale = 1)
  perf_broad <- adaptive_gain_perf(x, k = 0.1, scale = 1)
  
  # Broader curve (lower k) should have higher peak
  # Sharp curve (higher k) has narrower, lower peak
  expect_true(max(perf_broad) > max(perf_sharp))
  
  # Peak location should shift left as k increases
  peak_sharp <- which.max(perf_sharp)
  peak_broad <- which.max(perf_broad)
  expect_true(peak_sharp < peak_broad)
})

# ============================================================================
# Dual-Criterion (SDT) Tests
# ============================================================================

test_that("sdt_dual_criterion returns 6 thresholds", {
  th <- sdt_dual_criterion()
  
  expect_type(th, "list")
  expect_equal(length(th), 6)
  expect_true(all(c("crit_hl", "crit_lapse", "hi_enter", "hi_exit", "lo_enter", "lo_exit") %in% names(th)))
})

test_that("sdt_dual_criterion hysteresis creates enter/exit gap", {
  th <- sdt_dual_criterion(hys_margin = 0.15)
  
  # Enter should be farther from center than exit
  expect_true(th$hi_enter > th$hi_exit)
  expect_true(th$lo_enter < th$lo_exit)
  
  # Gap should be approximately hys_margin
  expect_equal(th$hi_enter - th$hi_exit, 0.15, tolerance = 0.01)
  expect_equal(th$lo_exit - th$lo_enter, 0.15, tolerance = 0.01)
})

test_that("sdt_dual_criterion criterion_tightness moves criteria", {
  th_loose <- sdt_dual_criterion(criterion_tightness = 0.0)
  th_tight <- sdt_dual_criterion(criterion_tightness = 1.0)
  
  # Tighter criteria should be closer to zero (narrower normal zone)
  expect_true(abs(th_tight$crit_hl) < abs(th_loose$crit_hl))
  expect_true(abs(th_tight$crit_lapse) < abs(th_loose$crit_lapse))
})

test_that("hysteresis reduces chatter", {
  set.seed(7)
  e <- evidence_demo_timeseries(T = 300, phi = 0.98, mu = 0.0, sd = 0.1)
  th <- sdt_dual_criterion(criterion_tightness = 0.6, coupling = 0.7, hys_margin = 0.15)
  
  # Naive classification
  naive <- ifelse(e > th$hi_enter, "HL", ifelse(e < th$lo_enter, "Lapse", "Normal"))
  
  # Hysteresis classification
  hys <- sdt_classify_hysteresis(e, th$lo_enter, th$lo_exit, th$hi_enter, th$hi_exit)
  
  # Count state transitions
  flips_naive <- sum(diff(as.numeric(factor(naive))) != 0)
  flips_hys   <- sum(diff(as.numeric(factor(hys))) != 0)
  
  # Hysteresis should reduce transitions
  expect_true(flips_hys <= flips_naive)
})

test_that("sdt_classify_hysteresis maintains state correctly", {
  # Simple test case
  e <- c(-2, -1.5, -1.0, 0, 1.0, 1.5, 2.0)
  states <- sdt_classify_hysteresis(e, lo_enter = -1.2, lo_exit = -1.0, 
                                     hi_enter = 1.2, hi_exit = 1.0)
  
  expect_equal(length(states), length(e))
  expect_true(all(states %in% c("Normal", "HL", "Lapse")))
})

test_that("evidence_demo_distributions returns correct structure", {
  df <- evidence_demo_distributions(n = 100)
  
  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 300)  # 3 classes × 100 each
  expect_true("x" %in% names(df))
  expect_true("class" %in% names(df))
  expect_equal(length(unique(df$class)), 3)
})

test_that("evidence_demo_timeseries returns correct length", {
  e <- evidence_demo_timeseries(T = 100)
  
  expect_equal(length(e), 100)
  expect_type(e, "double")
})

# ============================================================================
# Time-on-Task Tests
# ============================================================================

test_that("time-on-task half-life property", {
  t <- seq(0, 90, by = 0.25)
  thr <- time_on_task_threshold(t, c_start = 0.70, c_floor = 0.50, onset_min = 30, 
                                 fatigue_half_life_min = 20, microbreak_min = NA)
  
  # At onset + half-life, threshold should be halfway between c_start and c_floor
  y_half <- (0.70 + 0.50) / 2
  idx <- which.min(abs(t - (30 + 20)))
  
  expect_equal(thr[idx], y_half, tolerance = 0.01)
})

test_that("time-on-task pre-onset is flat at c_start", {
  t <- seq(0, 90, by = 1)
  thr <- time_on_task_threshold(t, c_start = 0.70, c_floor = 0.50, onset_min = 30,
                                 fatigue_half_life_min = 20, microbreak_min = NA)
  
  # Before onset, all values should be c_start
  pre_onset_idx <- which(t < 30)
  expect_true(all(abs(thr[pre_onset_idx] - 0.70) < 1e-10))
})

test_that("time-on-task decays toward c_floor after onset", {
  t <- seq(0, 90, by = 1)
  thr <- time_on_task_threshold(t, c_start = 0.70, c_floor = 0.50, onset_min = 30,
                                 fatigue_half_life_min = 20, microbreak_min = NA)
  
  # After onset, threshold should decay
  post_onset_idx <- which(t > 30)
  post_onset_thr <- thr[post_onset_idx]
  
  # Should be monotonically decreasing (or flat at floor)
  diffs <- diff(post_onset_thr)
  expect_true(all(diffs <= 1e-10))  # Allow for numerical precision
  
  # Should approach c_floor
  expect_true(min(post_onset_thr) >= 0.50 - 1e-6)
  expect_true(tail(post_onset_thr, 1) < 0.70)
})

test_that("microbreak reset only applies AFTER break time", {
  t <- seq(0, 90, by = 0.5)
  thr <- time_on_task_threshold(t, c_start = 0.70, c_floor = 0.50, onset_min = 30,
                                 fatigue_half_life_min = 20, microbreak_min = 60,
                                 microbreak_reset_fixed = 0.08, microbreak_decay_min = 2)
  
  # Find the index at microbreak
  break_idx <- which.min(abs(t - 60))
  
  # Threshold should be higher AFTER the break than just before
  idx_before <- max(1, break_idx - 2)  # Slightly before
  idx_after <- min(length(t), break_idx + 2)  # Slightly after
  
  # After should be >= before (due to reset)
  expect_true(thr[idx_after] >= thr[idx_before] - 0.001)  # Small tolerance for numerical issues
})

test_that("microbreak reset decays exponentially", {
  t <- seq(60, 70, by = 0.1)  # 10 minutes after break
  thr <- time_on_task_threshold(t, c_start = 0.70, c_floor = 0.50, onset_min = 30,
                                 fatigue_half_life_min = 20, microbreak_min = 60,
                                 microbreak_reset_fixed = 0.08, microbreak_decay_min = 2)
  
  # Threshold should be decreasing after the break
  diffs <- diff(thr)
  expect_true(all(diffs <= 1e-6))  # Monotonically decreasing
})

test_that("time-on-task without microbreak has no reset", {
  t <- seq(0, 90, by = 1)
  thr_no_break <- time_on_task_threshold(t, c_start = 0.70, c_floor = 0.50, 
                                          onset_min = 30, fatigue_half_life_min = 20,
                                          microbreak_min = NA)
  
  # After onset, should be monotonically decreasing
  post_onset_idx <- which(t > 30)
  diffs <- diff(thr_no_break[post_onset_idx])
  expect_true(all(diffs <= 1e-10))
})

test_that("time-on-task respects c_floor constraint", {
  t <- seq(0, 200, by = 1)  # Very long time
  thr <- time_on_task_threshold(t, c_start = 0.70, c_floor = 0.50, onset_min = 30,
                                 fatigue_half_life_min = 20, microbreak_min = NA)
  
  # All thresholds should be >= c_floor
  expect_true(all(thr >= 0.50 - 1e-10))
  
  # Should approach but not go below c_floor
  expect_true(min(thr) >= 0.50 - 1e-6)
})

# ============================================================================
# Helper Functions Tests
# ============================================================================

test_that(".clamp01 works correctly", {
  expect_equal(.clamp01(c(-1, 0, 0.5, 1, 2)), c(0, 0, 0.5, 1, 1))
})

test_that(".z standardization works", {
  x <- c(1, 2, 3, 4, 5)
  z <- .z(x)
  
  expect_equal(mean(z), 0, tolerance = 1e-10)
  expect_equal(sd(z), 1, tolerance = 1e-10)
})

test_that(".z handles single values", {
  expect_equal(.z(5), 0)
})

test_that(".z handles constant vectors", {
  expect_equal(.z(c(3, 3, 3)), c(0, 0, 0))
})

