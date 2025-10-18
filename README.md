# 🧪 Surgical Training Lab

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Status: Research Tool](https://img.shields.io/badge/Status-Research_Tool-purple.svg)](https://github.com/mohdasti/surgical-training-lab)
[![R Version: 4.x](https://img.shields.io/badge/R-4.x-blue?logo=r)](https://www.r-project.org/)
[![Shiny App](https://img.shields.io/badge/Shiny-App-blue?logo=rstudio)](https://shiny.rstudio.com/)

**An interactive research and educational tool for exploring cognitive theory paradigms in surgical monitoring.** This app demonstrates three theory-driven approaches to adaptive threshold control, allowing researchers and students to understand the cognitive mechanisms underlying surgical performance.

> **Looking for real-time monitoring?** See the [Surgical Cognitive Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard) for production-ready live monitoring with ML diagnostics.

---

## 🎯 Purpose

This Training Lab is a **pure theoretical exploration tool** - no live monitoring, no diagnostics, just **interactive cognitive theory**.

**What This Tool Does:**
- **Explore 3 Cognitive Theories** through interactive parameter controls
- **Compare Threshold Paradigms** side-by-side
- **Teach Cognitive Neuroscience** concepts in surgery
- **Prototype New Algorithms** before production implementation
- **Understand Theory-to-Practice** translation

**What This Tool Does NOT Do:**
- ❌ Real-time surgical monitoring (use [Production Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard))
- ❌ ML model diagnostics (use [Production Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard))
- ❌ Clinical decision support
- ❌ Patient data handling

---

## ✨ Three Cognitive Paradigms

### **1. 🎯 Inverted-U Zone Adjuster** (Adaptive Gain Theory)

**Theory:** Aston-Jones & Cohen's (2005) **Adaptive Gain Theory** + Yerkes-Dodson Law

**Core Concept:**  
Performance follows an inverted-U curve with arousal:
- **Sub-optimal arousal** → Need more challenge
- **Optimal arousal** → Peak performance  
- **Hyper-arousal** → Overwhelmed

**How It Works:**
- Monitors **pupil diameter** as arousal proxy
- Defines three arousal zones with boundaries
- Automatically adjusts thresholds based on current zone
- Implements the "sweet spot" of performance

**Interactive Parameters:**
- 📊 Arousal zone boundaries (sub-optimal ↔ optimal ↔ hyper)
- 🎚️ Threshold adjustments per zone
- ⚡ Adaptation reactivity speed

**Use Case:**  
Surgical training where you want to keep learners in the optimal challenge zone

---

### **2. 🔀 Unified Sensitivity** (Resource Competition Model)

**Theory:** Norman & Bobrow's (1975) **Resource Theory** + Kahneman's (1973) **Capacity Model**

**Core Concept:**  
Cognitive resources are finite and shared:
- **High sensitivity** → Detect everything (more false alarms)
- **Low sensitivity** → Only critical events (miss subtle signs)
- Classic **signal detection theory** trade-off

**How It Works:**
- Single **"sensitivity" slider** controls both thresholds
- Lower high-load threshold = more sensitive to overload
- Lower lapse threshold = more sensitive to inattention
- Explicit precision-recall trade-off

**Interactive Parameters:**
- 🎚️ System sensitivity (0-100%)
- 🔗 Coupling factor (how tightly thresholds move together)
- 📍 Baseline offsets for independent adjustment

**Use Case:**  
Research comparing liberal vs. conservative detection strategies

---

### **3. ⏰ Fatigue-Adaptive Thresholds** (Vigilance Decrement Theory)

**Theory:** Warm et al. (2008) **Vigilance Theory** + **Time-on-Task Effect**

**Core Concept:**  
Sustained attention degrades over time:
- **First 10 minutes** → Optimal vigilance
- **After 30 minutes** → Vigilance decrement begins
- **After 60 minutes** → Significant performance drop

**How It Works:**
- Tracks **time-on-task** automatically
- Lowers thresholds as fatigue increases
- Compensates for reduced operator sensitivity
- Implements non-linear fatigue curves

**Interactive Parameters:**
- ⏰ Fatigue onset time (when decrement begins)
- 📉 Maximum threshold adjustment
- 📈 Fatigue curve shape (linear, exponential, step)
- 🔄 Recovery rate (for break modeling)

**Use Case:**  
Long surgical procedures where fatigue is a known factor

---

## 🎯 Case-Study Alignment

This application implements **three threshold policy controllers** with parameter names and semantics that exactly match the accompanying case study documentation. Each policy is a pure R function in `R/policies.R` with precise mathematical specifications.

### **Policy 1: Adaptive Gain (Inverted-U)**

**Function:** `adaptive_gain_perf(x, k, scale)`

**Purpose:** Demonstrates the inverted-U relationship between arousal and performance.

**Parameters:**
- **`k`** (numeric): Curve sharpness, controls how quickly performance falls off from the peak  
  - Range: 0.1 to 1.0  
  - Default: 0.4  
  - Higher k = sharper peak, narrower optimal zone
- **`scale`** (numeric): Global performance scale factor  
  - Range: 0.5 to 2.0  
  - Default: 1.0

**Theory:** Yerkes-Dodson Law / Adaptive Gain Theory  
**Use Case:** Intuition plot showing optimal mid-arousal performance zone

---

### **Policy 2: Dual-Criterion (Signal Detection Theory)**

**Function:** `sdt_dual_criterion(criterion_tightness, coupling, hys_margin, base_hl, base_lapse, move_range)`

**Purpose:** Two decision criteria (high-load and lapse) with hysteresis to prevent edge chatter.

**Parameters:**
- **`criterion_tightness`** (0–1): How tightly criteria are set  
  - Default: 0.60  
  - 0 = loose (wide normal zone), 1 = tight (narrow normal zone)
- **`coupling`** (0–1): How much the lapse criterion follows the high-load criterion  
  - Default: 0.70  
  - 1 = symmetric movement, 0 = only high-load moves
- **`hys_margin`** (numeric): Hysteresis margin (enter–exit gap)  
  - Range: 0.00 to 0.50  
  - Default: 0.15  
  - Creates "sticky" zones to reduce rapid state transitions
- **`base_hl`** (numeric): Baseline high-load criterion in evidence units  
  - Default: 1.60
- **`base_lapse`** (numeric): Baseline lapse criterion in evidence units  
  - Default: -1.60
- **`move_range`** (numeric): Maximum criterion movement range  
  - Default: 1.00

**Returns:** List with 6 thresholds: `crit_hl`, `crit_lapse`, `hi_enter`, `hi_exit`, `lo_enter`, `lo_exit`

**Theory:** Signal Detection Theory with dual criteria and hysteresis  
**Use Case:** Tuning bias (not sensitivity d′); prevents edge chatter

---

### **Policy 3: Time-on-Task (Fatigue-Adaptive)**

**Function:** `time_on_task_threshold(t, c_start, c_floor, onset_min, fatigue_half_life_min, microbreak_min, microbreak_reset_fixed, microbreak_decay_min, phys_opt)`

**Purpose:** Decision threshold that relaxes with fatigue and briefly tightens after microbreak.

**Parameters:**
- **`t`** (numeric vector): Time in minutes
- **`c_start`** (0–1): Initial decision threshold  
  - Default: 0.70  
  - Held constant until onset
- **`c_floor`** (0–1): Asymptotic floor threshold  
  - Default: 0.50  
  - Target for exponential decay
- **`onset_min`** (numeric): Fatigue onset time in minutes  
  - Default: 30  
  - Threshold relaxes after this point
- **`fatigue_half_life_min`** (numeric): Time to decay halfway from c_start to c_floor  
  - Default: 21  
  - Controls decay rate
- **`microbreak_min`** (numeric): Microbreak time in minutes  
  - Default: 60  
  - NA or 0 for no break
- **`microbreak_reset_fixed`** (0–1): Fixed reset magnitude after break  
  - Default: 0.08  
  - Can be replaced by physiology-proportional reset
- **`microbreak_decay_min`** (numeric): Time constant for reset decay  
  - Default: 2  
  - How quickly the reset benefit fades
- **`phys_opt`** (list, optional): Pre/post physiology for proportional reset  
  - Columns: `RMSSD_pre`, `RMSSD_post`, `TEPR_pre`, `TEPR_post`, `Tremor_pre`, `Tremor_post`  
  - Formula: `reset = alpha * phi * gap` where phi is weighted recovery index

**Returns:** Numeric vector of threshold values over time

**Theory:** Vigilance Decrement / Time-on-Task Effects  
**Use Case:** Hold steady until onset; relax with half-life; microbreak briefly tightens threshold  
**Key Behavior:** Reset applies **ONLY AFTER** microbreak (not before)

---

### **Parameter Name Consistency**

All parameter names in the UI, functions, and JSON exports match the case study exactly:

✓ **No abbreviations** where clarity is needed  
✓ **Underscores** for multi-word parameters (e.g., `criterion_tightness`, not `criterionTightness`)  
✓ **Units in names** where ambiguous (e.g., `onset_min`, `microbreak_min`)  
✓ **Semantic clarity** over brevity (e.g., `hys_margin` instead of `h` or `margin`)

### **JSON Export Format**

Each policy can be exported as JSON with this structure:

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

Download via the **Export Policy** section at the bottom of the app.

---

### **📸 Screenshots & UI Overview**

#### **Tab 1: Adaptive Gain (Inverted-U)**

![Adaptive Gain Screenshot](screenshots/adaptive_gain.png)

*Inverted-U performance curve demonstrating the Yerkes-Dodson Law. Adjust `k` to control curve sharpness.*

#### **Tab 2: Dual-Criterion (SDT)**

![SDT Density Screenshot](screenshots/sdt_density.png)

*Dual-criterion setup with hysteresis bands. Blue zone = Normal decision region; gray slivers = hysteresis zones.*

![SDT Timeseries Screenshot](screenshots/sdt_timeseries.png)

*Hysteresis reduces edge-chatter: circles (naive) vs triangles (hysteresis) show fewer state transitions.*

#### **Tab 3: Time-on-Task (Fatigue)**

![Time-on-Task Screenshot](screenshots/time_on_task.png)

*Fatigue-adaptive threshold with onset, half-life, and microbreak annotations. Reset applies ONLY after break.*

#### **Tab 4: Help & References**

![Help Tab Screenshot](screenshots/help_references.png)

*Educational content with key references, DOI links, and dashboard mapping.*

> **Note:** Screenshots are placeholders. Generate actual screenshots after deployment using browser dev tools or screenshot utilities.

---

### **🔄 Export/Import Workflow**

The app supports a complete configuration save/restore cycle:

**Export Policy:**
1. Adjust sliders to desired values
2. Select policy type (adaptive_gain, dual_criterion, or time_on_task)
3. Click "Export policy JSON"
4. Save the downloaded JSON file

**Import Policy:**
1. Click "Import policy JSON" 
2. Select a previously exported JSON file
3. Sliders automatically update to match the imported configuration
4. Notification confirms: "✓ [Policy Type] imported successfully!"

**Use Cases:**
- 💾 Save configurations for later use
- 📊 Compare different parameter sets
- 🤝 Share policies with colleagues
- 📚 Maintain a library of validated configurations
- 🔬 A/B testing of threshold strategies

---

### **🧬 Physiology-Proportional Reset (Time-on-Task)**

The Time-on-Task policy supports **optional physiology-proportional reset** for microbreaks:

**Download Template:**
1. Click "Download physiology template" in Time-on-Task tab
2. Get CSV with 6 columns: `RMSSD_pre`, `RMSSD_post`, `TEPR_pre`, `TEPR_post`, `Tremor_pre`, `Tremor_post`
3. Replace example values with real pre/post microbreak measurements
4. Upload via file input

**How It Works:**
- Computes weighted recovery index: **φ = 0.5×z(ΔRMSSD) + 0.3×z(−ΔTEPR) + 0.2×z(−ΔTremor)**
- Scales reset: **reset = α × φ × gap** (where α=0.35, gap=c_start−baseline)
- Larger physiological recovery → Larger threshold reset
- More precise than fixed reset

**Example Template Values:**
```csv
RMSSD_pre,RMSSD_post,TEPR_pre,TEPR_post,Tremor_pre,Tremor_post
40,48,0.30,0.20,85,70
```
*Shows positive recovery: RMSSD↑, TEPR↓, Tremor↓*

---

### **⚠️ Important Notes**

#### **Illustrative Demo Data**

> **🔬 All evidence data shown in the plots is illustrative demo data, not clinical traces.**
> 
> - **Adaptive Gain:** Theoretical curve demonstrating Yerkes-Dodson relationship
> - **SDT Distributions:** Simulated evidence from `rnorm()` with fixed means (−2, 0, +2)
> - **SDT Timeseries:** AR(1) process with φ=0.92, not real surgical data
> - **Time-on-Task:** Demonstrates mathematical policy, not actual threshold trace
> 
> **For real-time surgical monitoring with live data,** use the [Surgical Cognitive Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard).

#### **Not a Drift-Diffusion Model**

> **📊 This is Signal Detection Theory (SDT) with hysteresis, not a Drift-Diffusion Model (DDM).**
>
> - **SDT:** Dual decision criteria (high-load and lapse) for state classification
> - **Hysteresis:** Enter/exit thresholds add persistence to prevent edge chatter
> - **Not DDM:** We're modeling decision boundaries, not evidence accumulation dynamics
> - **Why SDT?** Real-time stability, interpretability, and computational efficiency
>
> The evidence axis shows a **z-scored, signed index** (e.g., +w·z(TEPR) − v·z(RMSSD)), not accumulated drift.

---

## 🚀 Getting Started

### **Quick Start:**

```bash
# 1. Clone the repository
git clone https://github.com/mohdasti/surgical-training-lab.git
cd surgical-training-lab

# 2. Check dependencies
Rscript check_dependencies.R

# 3. Launch the app
Rscript launch_app.R
```

**Alternative: From R Console**

```r
# Install dependencies if needed
install.packages(c("shiny", "bslib", "ggplot2", "plotly", "DT", 
                   "shinyjs", "htmltools", "jsonlite"))

# Run the app
shiny::runApp()
```

See [DEPENDENCIES.md](DEPENDENCIES.md) for detailed dependency information.

### **Usage:**

1. **Read the theory cards** - Understand the three paradigms
2. **Explore each paradigm** - All three are displayed simultaneously
3. **Adjust parameters** using the interactive controls (sliders, inputs)
4. **Observe threshold changes** in real-time plots
5. **Compare paradigms** side-by-side to understand differences
6. **Experiment with different values** to see how theories behave

---

## 📚 Educational Use Cases

### **Graduate Course: Cognitive Neuroscience of Surgery**
- **Week 1:** Arousal and performance (Inverted-U)
- **Week 2:** Attention and resource allocation (Unified Sensitivity)
- **Week 3:** Sustained attention and fatigue (Fatigue-Adaptive)

### **Workshop: Human Factors in Healthcare**
- Demo: "Why one threshold doesn't fit all situations"
- Activity: Students adjust parameters and predict outcomes
- Discussion: Theory-to-practice translation challenges

### **Research Lab: Algorithm Development**
- Prototype new paradigms
- Compare against established theories
- Validate on simulated data before clinical testing

---

## 🆚 Training Lab vs. Production Dashboard

| Feature | **🧪 Training Lab (This Repo)** | **🏥 [Production Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard)** |
|---------|--------------------------------|------------------------------------------------------------------------------------------|
| **Purpose** | Theory Exploration | Real-Time Monitoring |
| **Tabs** | 1 (Theory Explorer Only) | 3 (Live Monitor, Training Lab, Diagnostics) |
| **Focus** | Educational/Research | Clinical Safety |
| **Audience** | Researchers, Students, Educators | Clinicians, Hospitals |
| **Features** | 3 Paradigms + Presets + Comparison | Live HUD + GT Tables + ML Diagnostics |
| **Stability** | Experimental | Production-Ready |
| **Updates** | Frequent, Breaking Changes OK | Stable Releases Only |

**Decision Guide:**
- **"I want to understand how cognitive theories affect thresholds"** → Use Training Lab ✅
- **"I need to monitor a surgeon in real-time"** → Use Production Dashboard
- **"I want to teach a grad course on attention"** → Use Training Lab ✅
- **"I need ML model diagnostics"** → Use Production Dashboard

---

## 📖 Theoretical Background

### **Key Papers:**

**Adaptive Gain Theory:**
- Aston-Jones, G., & Cohen, J. D. (2005). An integrative theory of locus coeruleus-norepinephrine function. *Annual Review of Neuroscience*, 28, 403-450.
- Yerkes, R. M., & Dodson, J. D. (1908). The relation of strength of stimulus to rapidity of habit-formation. *Journal of Comparative Neurology and Psychology*, 18(5), 459-482.

**Resource Theory:**
- Kahneman, D. (1973). *Attention and Effort*. Prentice-Hall.
- Norman, D. A., & Bobrow, D. G. (1975). On data-limited and resource-limited processes. *Cognitive Psychology*, 7(1), 44-64.

**Vigilance Decrement:**
- Warm, J. S., Parasuraman, R., & Matthews, G. (2008). Vigilance requires hard mental work and is stressful. *Human Factors*, 50(3), 433-441.
- Mackworth, N. H. (1948). The breakdown of vigilance during prolonged visual search. *Quarterly Journal of Experimental Psychology*, 1(1), 6-21.

---

## 🏗️ Project Structure

```
surgical-training-lab/
├── app.R                          # Main Shiny application (case-study aligned UI)
├── launch_app.R                   # Quick launch script
├── check_dependencies.R           # Dependency checker and installer
├── DESCRIPTION                    # Package metadata and dependencies
├── DEPENDENCIES.md                # Detailed dependency documentation
├── QA_CHECKLIST.md                # Quality assurance checklist
├── R/                             # Policy functions and modules
│   ├── policies.R                 # Core policy functions (case-study aligned)
│   ├── theme.R                    # Clinical bslib theme with Bootstrap 5
│   ├── mod_inverted_u_adjuster.R  # Inverted-U module (legacy)
│   ├── mod_unified_sensitivity.R  # Unified sensitivity module (legacy)
│   ├── mod_fatigue_adaptive.R     # Fatigue-adaptive module (legacy)
│   ├── threshold_utils.R          # Threshold utilities
│   └── [...other modules...]      # Additional utility modules
├── config/
│   └── config.yml                 # Configuration parameters
└── README.md                      # This file
```

**Key Files:**
- **`R/policies.R`**: Pure R functions implementing the three threshold policies
- **`R/theme.R`**: Clinical color palette and Bootstrap 5 theme
- **`app.R`**: Three-tab UI with exact case-study parameter names
- **`QA_CHECKLIST.md`**: Comprehensive testing checklist for visual parity

---

## 🌐 Embedding in Quarto/Netlify

Since you mentioned wanting to embed this in your Quarto case study, here are the options:

### **Option 1: Deploy to shinyapps.io** (Recommended)

```r
# Install rsconnect
install.packages("rsconnect")

# Configure credentials
rsconnect::setAccountInfo(name="your-account", 
                          token="your-token",
                          secret="your-secret")

# Deploy
rsconnect::deployApp("/path/to/surgical-training-lab")
```

Then embed in your Quarto document:

```markdown
## Interactive Theory Explorer

<iframe 
  src="https://your-username.shinyapps.io/surgical-training-lab/" 
  width="100%" 
  height="900px" 
  style="border:1px solid #ddd; border-radius:12px;"
  loading="lazy">
</iframe>
```

### **Option 2: Shinylive (WebAssembly - No Server!)**

Convert to run entirely in browser:

```bash
# Install shinylive
install.packages("shinylive")

# Export to WebAssembly
shinylive::export("app.R", "docs/")

# Add to Quarto site
```

### **Option 3: Screenshot/GIF for Static Case Study**

For a non-interactive case study, capture key visuals.

---

## 🤝 Contributing

This is a research tool! Contributions welcome:

1. **New paradigms** - Implement your cognitive theory
2. **Parameter tuning** - Improve defaults based on literature
3. **Educational materials** - Lesson plans, activities, examples
4. **Bug fixes** - Especially UI/UX improvements

**For production features:** Contribute to the [main dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard) after validation here.

---

## 📜 License

This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0) - see the [LICENSE](LICENSE) file for details.

**Why AGPL v3?** This license ensures that any modifications remain open source, even when deployed as a web service. This is critical for research transparency - all improvements must be shared with the scientific community.

---

## 👨‍💻 Author

**Mohammad Dastgheib**  
PhD Candidate, Cognitive Neuroscience  
Portfolio: [mdastgheib.com](https://mdastgheib.com)  
LinkedIn: [mohdasti](https://linkedin.com/in/mohdasti)  
GitHub: [@mohdasti](https://github.com/mohdasti)

---

## 🔗 Related Projects

### **[Surgical Cognitive Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard)** 🏥
Production-ready monitoring system for clinical use. Includes:
- Live monitoring with 5Hz updates
- GT live tables with reference ranges
- ML diagnostics suite (6 tabs)
- Calibration analysis
- SHAP explainability

See [EMBED_SETUP.md](https://github.com/mohdasti/surgical-cognitive-dashboard/blob/main/EMBED_SETUP.md) for embedding instructions.

---

## 🎓 Citation

If you use this tool in research or education, please cite:

```bibtex
@software{dastgheib2025traininglab,
  author = {Dastgheib, Mohammad},
  title = {Surgical Training Lab: Interactive Cognitive Theory Exploration},
  year = {2025},
  url = {https://github.com/mohdasti/surgical-training-lab},
  note = {Research and educational tool for surgical cognitive monitoring}
}
```

---

## 💡 Example Use Cases

**"I'm teaching a grad course on attention"**  
→ Use Inverted-U adjuster to demonstrate arousal-performance relationship ✅

**"I'm researching optimal alert thresholds"**  
→ Use Unified Sensitivity to explore liberal vs. conservative strategies ✅

**"I'm studying fatigue in 8-hour surgeries"**  
→ Use Fatigue-Adaptive to model vigilance decrement ✅

**"I want to monitor a live surgery"**  
→ Use the [Production Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard) instead

**"I need ML model diagnostics and SHAP plots"**  
→ Use the [Production Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard) instead

---

*This is a research and educational tool. All data is synthetic. Not for clinical use without extensive validation.*
