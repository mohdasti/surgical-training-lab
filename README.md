# Surgical Training Lab 🧪

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Status: Research Tool](https://img.shields.io/badge/Status-Research_Tool-purple.svg)](https://github.com/mohdasti/surgical-training-lab)
[![R Version: 4.x](https://img.shields.io/badge/R-4.x-blue?logo=r)](https://www.r-project.org/)
[![Shiny App](https://img.shields.io/badge/Shiny-App-blue?logo=rstudio)](https://shiny.rstudio.com/)

**An interactive research and educational tool for exploring cognitive theory paradigms in surgical monitoring.** This app demonstrates three theory-driven approaches to adaptive threshold control, allowing researchers and students to understand the cognitive mechanisms underlying surgical performance.

> **Looking for production monitoring?** See the [Surgical Cognitive Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard) for clinical-grade real-time monitoring.

---

## 🎯 Purpose

This Training Lab is a **research and educational companion** to the production Surgical Cognitive Dashboard. It allows you to:

- **Explore cognitive theories** (Adaptive Gain Theory, Resource Competition, Vigilance Decrement)
- **Compare threshold paradigms** side-by-side
- **Teach concepts** in graduate courses or workshops
- **Prototype new algorithms** before moving to production
- **Understand theory-to-implementation** translation

---

## 🆚 Training Lab vs. Production Dashboard

| Feature | **🧪 Training Lab (This Repo)** | **🏥 [Production Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard)** |
|---------|--------------------------------|------------------------------------------------------------------------------------------|
| **Purpose** | Research & Education | Clinical Monitoring |
| **Audience** | Researchers, Students, Cognitive Scientists | Clinicians, Hospitals, Safety Officers |
| **Priority** | Theory exploration, Learning | Reliability, Patient Safety |
| **Stability** | Experimental, May have opacity issues | Production-ready, Zero opacity |
| **Features** | 3 Paradigms + Presets + Comparison | Live Monitor + ML Diagnostics |
| **Use Case** | "Explore how AGT affects thresholds" | "Monitor a surgeon in real-time" |
| **Updates** | Frequent, experimental | Stable, tested releases |

---

## ✨ Three Cognitive Paradigms

### **1. 🎯 Inverted-U Zone Adjuster** (Adaptive Gain Theory)

Based on the **Yerkes-Dodson Law** and Aston-Jones & Cohen's (2005) **Adaptive Gain Theory**.

**Theory:** Performance follows an inverted-U curve with arousal:
- **Low arousal** (sub-optimal) → Need more challenge
- **Optimal arousal** → Peak performance  
- **High arousal** (hyper-arousal) → Overwhelmed

**What it does:**
- Monitors pupil diameter as proxy for arousal
- Automatically adjusts thresholds based on arousal zone
- Implements the "sweet spot" of performance

**Parameters:**
- **Arousal Zone Boundaries:** Sub-optimal, Optimal, Hyper-arousal
- **Threshold Adjustments:** Different thresholds for each zone
- **Reactivity:** How quickly thresholds adapt

**Use Case:** Surgical training where you want to keep learners in the optimal challenge zone

---

### **2. 🔀 Unified Sensitivity** (Resource Competition Model)

Based on **Norman & Bobrow's (1975) Resource Theory** and **Kahneman's (1973) Capacity Model**.

**Theory:** Cognitive resources are finite and shared:
- High sensitivity → Detect everything (but more false alarms)
- Low sensitivity → Only critical events (but miss subtle signs)

**What it does:**
- Single "sensitivity" slider controls both thresholds
- Lower high-load threshold = more sensitive to overload
- Lower lapse threshold = more sensitive to inattention
- Tradeoff between sensitivity and specificity

**Parameters:**
- **System Sensitivity:** Single value (0-100%)
- **Coupling Factor:** How tightly thresholds move together
- **Baseline Offsets:** Independent threshold baselines

**Use Case:** Research comparing liberal vs. conservative detection strategies

---

### **3. ⏰ Fatigue-Adaptive Thresholds** (Vigilance Decrement Theory)

Based on **Warm et al. (2008) Vigilance Theory** and the **Time-on-Task Effect**.

**Theory:** Sustained attention degrades over time:
- First 10 minutes → Optimal vigilance
- After 30 minutes → Vigilance decrement begins
- After 60 minutes → Significant performance drop

**What it does:**
- Tracks time-on-task automatically
- Lowers thresholds as fatigue increases
- Compensates for reduced operator sensitivity
- Implements non-linear fatigue curves

**Parameters:**
- **Fatigue Onset:** When decrement begins (minutes)
- **Max Adjustment:** Maximum threshold reduction
- **Fatigue Curve:** Linear, exponential, or step function
- **Recovery Rate:** If breaks are implemented

**Use Case:** Long surgical procedures where fatigue is a known factor

---

## 🚀 Getting Started

### **Quick Start:**

```bash
# 1. Clone the repository
git clone https://github.com/mohdasti/surgical-training-lab.git
cd surgical-training-lab

# 2. Install dependencies (in R)
install.packages(c("shiny", "bslib", "plotly", "tidyverse", 
                   "data.table", "zoo", "R6", "gt", "DT"))

# 3. Run the app
Rscript -e "shiny::runApp('app.R', launch.browser=TRUE)"
```

### **Usage:**

1. **Start with Live Monitor** - See the baseline dashboard
2. **Go to Training Lab tab** - Explore the three paradigms
3. **Enable "Use Training Lab Controls"** checkbox
4. **Select a paradigm** from the dropdown
5. **Adjust parameters** and observe effects in real-time
6. **Compare side-by-side** using the comparison drawer

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

## 🧪 Research Features

### **Scenario Presets:**
- **Baseline Surgery** - Standard thresholds
- **High-Stakes Surgery** - Conservative detection
- **Prolonged Surgery** - Fatigue compensation

### **Comparison Mode:**
- Run two paradigms simultaneously
- Compare alert frequencies
- Evaluate tradeoffs

### **Export Capabilities:**
- Log all threshold adjustments
- Export alert patterns
- Analyze decision patterns

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
├── app.R                          # Main Shiny application
├── R/                             # Modules and utilities
│   ├── mod_experimental_controls_tab.R   # Training Lab container
│   ├── mod_inverted_u_adjuster.R         # AGT paradigm
│   ├── mod_unified_sensitivity.R         # Resource model
│   ├── mod_fatigue_adaptive.R            # Vigilance paradigm
│   ├── mod_scenario_presets.R            # Quick presets
│   ├── mod_controls_router.R             # Threshold routing
│   ├── mod_compare_drawer.R              # Side-by-side comparison
│   ├── ui_banner.R                       # Mode indicators
│   ├── fatigue_clock.R                   # Time-on-task tracking
│   └── threshold_adapter.R               # Unified threshold API
├── config/
│   └── config.yml                 # Configuration parameters
└── README.md                      # This file
```

---

## ⚠️ Known Issues

### **Opacity on Data Load:**
Some modules use `renderPlot` which may cause brief opacity overlays when data loads. This is acceptable for a research tool but has been fixed in the production dashboard.

### **Performance:**
With all three paradigms active simultaneously, you may notice slight delays. This is expected and prioritizes feature richness over optimization.

---

## 🤝 Contributing

This is a research tool! Contributions welcome:

1. **New paradigms** - Implement your cognitive theory
2. **Parameter tuning** - Improve default values based on literature
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
Production-ready monitoring system for clinical use. Stable, reliable, patient-safety focused.

**When to use which:**
- **Use Training Lab** → "I want to understand how AGT works"
- **Use Production** → "I need to monitor a surgeon right now"

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
→ Use Inverted-U adjuster to demonstrate arousal-performance relationship

**"I'm researching optimal alert thresholds"**  
→ Use Unified Sensitivity to explore liberal vs. conservative strategies

**"I'm studying fatigue in 8-hour surgeries"**  
→ Use Fatigue-Adaptive to model vigilance decrement

**"I want real-time clinical monitoring"**  
→ Use the [Production Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard) instead

---

*This is a research and educational tool. All data is synthetic. Not for clinical use without extensive validation.*

