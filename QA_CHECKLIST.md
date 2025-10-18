# QA Checklist - Case Study Alignment

## Pre-Launch Checks

- [x] All required packages installed
- [x] R/policies.R loads without errors
- [x] R/theme.R loads without errors
- [x] app.R parses successfully
- [x] UI and server objects defined

## Tab 1: Adaptive Gain (Inverted-U)

### Visual Elements
- [ ] Title shows "Inverted-U intuition"
- [ ] Plot has x-axis labeled "Arousal"
- [ ] Plot has y-axis labeled "Performance (arb.)"
- [ ] Curve is smooth and shows inverted-U shape
- [ ] Clinical teal color (#1f9bb6) used for line

### Interactivity
- [ ] **Changing `k` slider**: Peak shifts horizontally; larger k = sharper curve
- [ ] **Changing `scale` slider**: Y-axis range scales up/down
- [ ] Help icon tooltip: "Targets mid-arousal zone; extremes impair performance."
- [ ] Description text above plot matches tooltip

### Expected Behavior
- `k=0.4`: Moderate curve with peak around arousal=2.5
- `k=1.0`: Sharp peak, narrow optimal zone
- `k=0.1`: Very broad curve, gentle peak

---

## Tab 2: Dual-Criterion (SDT)

### Density Plot
- [ ] Title: "Dual-Criterion (SDT) with Hysteresis"
- [ ] Subtitle shows 6 parameters with values
- [ ] **Blue normal band** between enter lines (lo_enter to hi_enter)
- [ ] **Gray hysteresis slivers** (lo_enter to lo_exit, hi_exit to hi_enter)
- [ ] Three density curves: Lapse (gray), Normal (teal), High-Load (red)
- [ ] **Dashed lines** for enter thresholds (hi_enter, lo_enter)
- [ ] **Dotted lines** for exit thresholds (hi_exit, lo_exit)
- [ ] Text labels: "→ HL enter", "→ HL exit", "Lapse enter ←", "Lapse exit ←"
- [ ] White label: "Decision: Normal" in center
- [ ] **NO LEGEND** (legend.position = "none")

### Timeseries Plot
- [ ] Title: "Hysteresis reduces edge-chatter"
- [ ] **Naive (top)** classification: circles (shape=16)
- [ ] **Hysteresis (bottom)** classification: triangles (shape=17), offset down by 0.06
- [ ] Dashed horizontal lines = enter thresholds
- [ ] Dotted horizontal lines = exit thresholds
- [ ] **Compact legend at bottom**, single row
- [ ] Three legend sections: State (colors), Method (shapes), Threshold (linetypes)
- [ ] Legend items small and condensed

### Interactivity
- [ ] **Changing `criterion_tightness`**: Both criteria move inward (higher tightness)
- [ ] **`coupling=1.0`**: Lapse and HL criteria move symmetrically
- [ ] **`coupling=0.0`**: Only HL criterion moves with tightness
- [ ] **Changing `hys_margin`**: Exit lines move closer to enter lines
- [ ] Help icon tooltip: "One knob moves both criteria; tuning bias, not d′; hysteresis prevents edge chatter."

### Expected Behavior
- Default (tightness=0.60, coupling=0.70): Balanced criteria
- Tightness=0.0: Wide normal zone, loose criteria
- Tightness=1.0: Narrow normal zone, strict criteria
- Hysteresis margin visible as gray bands

---

## Tab 3: Time-on-Task (Fatigue)

### Visual Elements
- [ ] Title: "Time-on-Task (Fatigue-Adaptive): steady → relax → brief reset"
- [ ] Subtitle shows: Onset, Half-life, Microbreak parameters
- [ ] **Pre-onset**: Flat line at `c_start` with gray shaded region
- [ ] **Post-onset**: Exponential decay toward `c_floor`
- [ ] **Onset vertical line** (dashed) at onset_min
- [ ] **Microbreak vertical line** (dashed) at microbreak_min
- [ ] **Half-life marker**: Red dot with arrow at onset + half-life position
- [ ] Annotations: "Start", "Onset", "Half-life → halfway to floor", "Microbreak", "Floor"

### Threshold Behavior
- [ ] Threshold = `c_start` for t < onset_min
- [ ] Threshold decays exponentially after onset
- [ ] **Reset occurs ONLY AFTER microbreak** (not before)
- [ ] Reset decays with time constant `microbreak_decay_min`
- [ ] Final asymptote approaches `c_floor`

### Interactivity
- [ ] **Changing `c_start`**: Starting threshold shifts up/down
- [ ] **Changing `c_floor`**: Floor level shifts up/down
- [ ] **Changing `onset_min`**: Gray region width changes; decay starts later/earlier
- [ ] **Changing `fatigue_half_life_min`**: Decay rate changes; half-life marker moves
- [ ] **Changing `microbreak_min`**: Vertical line and reset position move
- [ ] **Changing `microbreak_reset_fixed`**: Size of reset bump changes
- [ ] **Changing `microbreak_decay_min`**: How quickly reset decays
- [ ] Help icon tooltip: "Hold steady until onset; relax with half-life; microbreak briefly tightens threshold."

### Optional Physiology CSV
- [ ] File upload accepts .csv files
- [ ] Required columns: `RMSSD_pre`, `RMSSD_post`, `TEPR_pre`, `TEPR_post`, `Tremor_pre`, `Tremor_post`
- [ ] When loaded with valid columns: Reset becomes **physiology-proportional**
- [ ] Formula: `reset = alpha * phi * gap` where phi is weighted recovery index
- [ ] Subtitle or annotation indicates proportional reset active

### Expected Behavior
- Default (onset=30, half-life=21, microbreak=60):
  - Flat until t=30
  - Decay for 21 min to reach halfway point
  - At t=60: small upward bump (reset)
  - Reset decays quickly (2 min)
- Without microbreak (microbreak_min=0 or NA): No reset, just decay

---

## Export Policy JSON

### Functionality
- [ ] Radio buttons to select policy: adaptive_gain, dual_criterion, time_on_task
- [ ] Text input for export path (default: "export/policy.json")
- [ ] Download button triggers file download

### Adaptive Gain Export
```json
{
  "kind": "adaptive_gain",
  "params": {
    "k": 0.4,
    "scale": 1.0
  }
}
```

### Dual-Criterion Export
```json
{
  "kind": "dual_criterion",
  "params": {
    "criterion_tightness": 0.60,
    "coupling": 0.70,
    "hys_margin": 0.15,
    "base_hl": 1.60,
    "base_lapse": -1.60,
    "move_range": 1.00
  },
  "thresholds": {
    "crit_hl": 1.00,
    "crit_lapse": -1.18,
    "hi_enter": 1.00,
    "hi_exit": 0.85,
    "lo_enter": -1.18,
    "lo_exit": -1.03
  }
}
```

### Time-on-Task Export
```json
{
  "kind": "time_on_task",
  "params": {
    "c_start": 0.70,
    "c_floor": 0.50,
    "onset_min": 30,
    "fatigue_half_life_min": 21,
    "microbreak_min": 60,
    "microbreak_reset_fixed": 0.08,
    "microbreak_decay_min": 2
  }
}
```

### Validation
- [ ] Parameter names match case study exactly
- [ ] Values reflect current slider positions
- [ ] JSON is valid and pretty-printed
- [ ] Download works in browser

---

## Overall Visual Parity

### Theme & Styling
- [ ] Bootstrap 5 theme active
- [ ] Inter font used throughout
- [ ] Clinical teal accent (#1f9bb6) prominent
- [ ] Light background (#f7f9fc)
- [ ] Help icons styled correctly (circular, teal, hover effect)
- [ ] Tooltips work on hover
- [ ] Plots use theme_minimal with consistent sizing

### Help System
- [ ] Each tab has help icon in title
- [ ] Each tab has description text above plots
- [ ] Text matches case study phrasing
- [ ] Tooltips initialize on page load

---

## Manual Testing Steps

1. **Launch app**: `Rscript launch_app.R` or `shiny::runApp()`
2. **Tab 1 - Adaptive Gain**:
   - Move k slider from 0.1 to 1.0, observe peak sharpening
   - Move scale slider, observe Y-axis range change
3. **Tab 2 - Dual-Criterion**:
   - Set coupling=1.0, move criterion_tightness, observe symmetric movement
   - Set coupling=0.0, move criterion_tightness, observe only HL moves
   - Verify density plot has no legend
   - Verify timeseries has compact bottom legend
4. **Tab 3 - Time-on-Task**:
   - Verify flat region before onset
   - Verify exponential decay after onset
   - Verify microbreak causes upward bump AFTER the line (not before)
   - Verify half-life red dot is at correct position
5. **Export**:
   - Select each policy type
   - Download JSON
   - Open in text editor
   - Verify parameter names

---

## Case Study Alignment Verification

### Parameter Name Consistency

**Adaptive Gain:**
- ✓ `k` (not "kappa" or "sharpness")
- ✓ `scale`

**Dual-Criterion:**
- ✓ `criterion_tightness` (not "tightness")
- ✓ `coupling`
- ✓ `hys_margin` (not "hysteresis_margin")
- ✓ `base_hl` (not "base_high_load")
- ✓ `base_lapse`
- ✓ `move_range`

**Time-on-Task:**
- ✓ `c_start` (not "start_threshold")
- ✓ `c_floor` (not "floor_threshold")
- ✓ `onset_min`
- ✓ `fatigue_half_life_min`
- ✓ `microbreak_min`
- ✓ `microbreak_reset_fixed`
- ✓ `microbreak_decay_min`

### Visual Elements Match Case Study
- ✓ Plots use ggplot2 with minimal theme
- ✓ Color palette: teal (#1f9bb6), gray (#6b7280), red (#bc3c29)
- ✓ Annotations clearly labeled
- ✓ Legends condensed where needed
- ✓ Help text matches QMD phrasing

---

## Sign-off

- [ ] All tabs render without errors
- [ ] All interactive controls work
- [ ] All plots match case study visuals
- [ ] All parameter names match case study
- [ ] Export functionality works
- [ ] Help tooltips display correctly
- [ ] App is ready for deployment

**Tested by**: _________________  
**Date**: _________________  
**Version**: 0.1.0  
**Status**: ☐ Pass  ☐ Fail  ☐ Needs Revision

