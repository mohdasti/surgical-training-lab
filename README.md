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

## 🚀 Getting Started

### **Quick Start:**

```bash
# 1. Clone the repository
git clone https://github.com/mohdasti/surgical-training-lab.git
cd surgical-training-lab

# 2. Install dependencies (in R)
install.packages(c("shiny", "bslib", "plotly", "DT", "shinyjs",
                   "tidyverse", "zoo"))

# 3. Run the app
Rscript -e "shiny::runApp('app.R', port=3839, launch.browser=TRUE)"
```

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
├── app.R                          # Main Shiny application (simplified interface)
├── R/                             # Modules and utilities
│   ├── mod_inverted_u_adjuster.R         # Inverted-U paradigm
│   ├── mod_unified_sensitivity.R         # Unified sensitivity paradigm
│   ├── mod_fatigue_adaptive.R            # Fatigue-adaptive paradigm
│   ├── threshold_utils.R                 # Threshold calculation utilities
│   ├── ui_constants.R                    # UI constants
│   └── ui_theme.R                        # Theme
├── config/
│   └── config.yml                 # Configuration parameters
└── README.md                      # This file
```

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
