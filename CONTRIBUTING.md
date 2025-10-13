# Contributing to Surgical Training Lab 🧪

Thank you for your interest in contributing to the Surgical Training Lab! This tool thrives on community contributions from researchers, educators, and cognitive scientists.

---

## 🎯 Types of Contributions

### **1. 🔬 New Cognitive Paradigms**

Implement cognitive theories as interactive modules.

**What we're looking for:**
- Well-established cognitive theories from peer-reviewed literature
- Clear parameter definitions
- Educational value for students and researchers

**Examples:**
- Dual-task interference models
- Working memory capacity models
- Attentional narrowing theories

**Process:**
1. Open a feature request issue describing the theory
2. Include research citations
3. Discuss implementation approach
4. Submit PR with code + documentation

---

### **2. 📚 Educational Materials**

Create lesson plans, assignments, or tutorials.

**What we're looking for:**
- Graduate-level course materials
- Workshop activities
- Assessment rubrics
- Student exercises

**How to contribute:**
1. Open an "Educational Use Case" issue
2. Share your materials (with permission)
3. We'll add them to a `/teaching` directory

---

### **3. 🐛 Bug Fixes**

Help make the Training Lab more stable.

**What we're looking for:**
- UI/UX improvements
- Parameter validation
- Error handling
- Performance optimization

**Process:**
1. Open a bug report issue
2. Discuss the fix
3. Submit PR with clear description

---

### **4. 📖 Documentation**

Improve or expand documentation.

**What we're looking for:**
- Theory explanations
- Parameter guides
- Use case examples
- Research citations

---

## 🚀 Getting Started

### **1. Fork and Clone**

```bash
# Fork the repo on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/surgical-training-lab.git
cd surgical-training-lab

# Add upstream remote
git remote add upstream https://github.com/mohdasti/surgical-training-lab.git
```

### **2. Set Up Environment**

```r
# Install dependencies
install.packages(c("shiny", "bslib", "plotly", "tidyverse", 
                   "data.table", "zoo", "R6", "gt", "DT"))
```

### **3. Create a Branch**

```bash
# Create a feature branch
git checkout -b feature/your-feature-name

# For paradigms:
git checkout -b paradigm/theory-name

# For bugs:
git checkout -b fix/bug-description
```

### **4. Make Changes**

Follow our code structure (see below).

### **5. Test Locally**

```bash
# Run the app
Rscript -e "shiny::runApp('app.R', launch.browser=TRUE)"

# Verify:
# - App loads without errors
# - All three existing paradigms work
# - Your changes work as expected
# - No console errors
```

### **6. Commit and Push**

```bash
git add .
git commit -m "Add: Brief description of changes"
git push origin feature/your-feature-name
```

### **7. Open a Pull Request**

- Go to your fork on GitHub
- Click "New Pull Request"
- Fill out the PR template
- Link to related issues

---

## 📁 Code Structure

### **Module Pattern**

All paradigms follow this structure:

```r
# R/mod_your_paradigm.R

# UI Function
mod_your_paradigm_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Your UI elements
  )
}

# Server Function
mod_your_paradigm_server <- function(id, reactive_inputs) {
  moduleServer(id, function(input, output, session) {
    # Return reactive values
    return(list(
      high_load_threshold = reactive({ ... }),
      lapse_threshold = reactive({ ... })
    ))
  })
}
```

### **Required Components**

Every new paradigm must include:

1. **UI Function** - User controls
2. **Server Function** - Reactive logic
3. **Documentation** - Theory background
4. **Citations** - Research papers
5. **Default Parameters** - Sensible starting values

---

## 🔬 Implementing a New Paradigm

### **Step-by-Step Guide:**

#### **1. Research Foundation**

Ensure your paradigm is based on:
- ✅ Peer-reviewed cognitive theory
- ✅ Clear operational definitions
- ✅ Testable predictions

#### **2. Create Module File**

```r
# R/mod_your_theory.R

#' Your Theory Name
#'
#' Brief description of the cognitive theory
#'
#' @description
#' Detailed explanation of how the theory works
#' and how it affects threshold adjustments.
#'
#' @section Theory Background:
#' Cite key papers and explain core concepts
#'
#' @section Parameters:
#' * parameter1: What it does
#' * parameter2: What it does
#'
#' @references
#' Author, A. (Year). Title. Journal.
#'
#' @param id Module namespace ID
#' @export
mod_your_theory_ui <- function(id) {
  # ... implementation
}

mod_your_theory_server <- function(id, reactive_inputs) {
  # ... implementation
}
```

#### **3. Add to Router**

Edit `R/mod_controls_router.R` to include your paradigm:

```r
# Add to dropdown options
"Your Theory Name" = "your_theory"

# Add server call
your_theory_thresholds <- mod_your_theory_server(...)

# Add to routing logic
if (input$paradigm == "your_theory") {
  return(your_theory_thresholds())
}
```

#### **4. Update Documentation**

Add to `README.md`:

```markdown
### **4. Your Theory Name** (Citation)

**Theory:** Brief explanation

**What it does:** How it adjusts thresholds

**Parameters:** List of adjustable parameters

**Use Case:** When to use this paradigm
```

---

## 📝 Coding Standards

### **Style Guide**

- **Indentation:** 2 spaces (R standard)
- **Naming:** `snake_case` for functions and variables
- **Comments:** Explain WHY, not WHAT
- **Documentation:** Roxygen2 style for functions

### **Example:**

```r
#' Calculate vigilance-adjusted threshold
#'
#' Lowers threshold based on time-on-task to compensate
#' for vigilance decrement (Warm et al., 2008).
#'
#' @param baseline_threshold Numeric, starting threshold
#' @param time_on_task Numeric, minutes since start
#' @param fatigue_onset Numeric, when decrement begins (minutes)
#' @param max_adjustment Numeric, maximum threshold reduction
#' @return Numeric, adjusted threshold value
calculate_fatigue_threshold <- function(baseline_threshold, 
                                       time_on_task,
                                       fatigue_onset = 30,
                                       max_adjustment = 0.2) {
  if (time_on_task < fatigue_onset) {
    return(baseline_threshold)
  }
  
  # Non-linear fatigue curve
  fatigue_factor <- min(
    (time_on_task - fatigue_onset) / 60,
    1.0
  )
  
  adjustment <- max_adjustment * fatigue_factor
  return(baseline_threshold * (1 - adjustment))
}
```

---

## 🧪 Testing Guidelines

### **Before Submitting PR:**

- [ ] App launches without errors
- [ ] All existing paradigms still work
- [ ] Your paradigm responds to parameter changes
- [ ] No console errors or warnings
- [ ] Tested in Chrome, Firefox, or Safari
- [ ] Parameters have sensible defaults
- [ ] Edge cases handled gracefully

### **Test Cases to Consider:**

- Extreme parameter values
- Rapid parameter changes
- Long-running sessions
- Multiple paradigm switches

---

## 📚 Documentation Requirements

### **For New Paradigms:**

1. **Theory Section in README**
   - Brief explanation
   - Key concepts
   - Research citations (APA format)

2. **Inline Code Comments**
   - Explain cognitive mechanisms
   - Document parameter effects
   - Link to research where relevant

3. **User-Facing Help**
   - Clear parameter labels
   - Tooltips explaining effects
   - Example use cases

---

## 🤝 Code Review Process

### **What to Expect:**

1. **Initial Review (1-3 days)**
   - Maintainer checks code structure
   - Verifies theory implementation
   - Tests functionality

2. **Feedback Round**
   - Suggestions for improvements
   - Requests for clarification
   - Discussion of implementation choices

3. **Revision**
   - Address feedback
   - Make requested changes
   - Update documentation

4. **Approval**
   - Final testing
   - Merge to main branch
   - Added to next release

---

## 🎓 Research Ethics

### **Citation Requirements:**

- ✅ Cite original theory papers
- ✅ Use APA format
- ✅ Include DOI when available
- ✅ Give credit to parameter sources

### **Open Science Principles:**

- ✅ All code is open source (AGPL v3)
- ✅ Methods are fully transparent
- ✅ Reproduce existing implementations accurately
- ✅ Share modifications back to community

---

## 🆚 Training Lab vs. Production Dashboard

**Important:** This is the **research/education** tool.

- ✅ Experimental features welcome
- ✅ Multiple paradigms encouraged
- ✅ Parameter exploration prioritized
- ⚠️ Some instability acceptable

**For production features:** Contribute to the [main dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard) after validation here.

---

## 💡 Ideas for Contributions

### **Easy (Good First Issues):**
- Improve parameter tooltips
- Add preset scenarios
- Fix typos in documentation
- Improve error messages

### **Medium:**
- Add export functionality
- Implement parameter history tracking
- Create visualization improvements
- Add new scenarios

### **Advanced:**
- Implement new cognitive paradigm
- Add multi-paradigm comparison
- Create automated parameter optimization
- Integrate real biosignal data

---

## 📞 Getting Help

### **Questions?**
- 💬 [Open a Discussion](https://github.com/mohdasti/surgical-training-lab/discussions)
- 📧 Contact via GitHub profile
- 📖 Read the [README](README.md) and [COMPARISON](COMPARISON.md)

### **Not Sure Where to Start?**
Look for issues labeled:
- `good first issue`
- `help wanted`
- `documentation`

---

## 🎖️ Recognition

All contributors will be:
- ✅ Listed in CONTRIBUTORS.md
- ✅ Credited in releases
- ✅ Acknowledged in papers (if substantial contribution)
- ✅ Part of the open science community

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the AGPL v3 license.

This ensures:
- 🔬 Research transparency
- 🌐 Web service copyleft
- 📚 Educational use freedom
- 🤝 Community benefits

---

## 🙏 Thank You!

Your contributions help advance:
- 🎓 Education in cognitive neuroscience
- 🔬 Research in surgical performance
- 🏥 Patient safety in operating rooms
- 🌍 Open science globally

**Together, we're building tools that translate cognitive theory into real-world impact!**

---

*Questions about this guide? Open an issue and we'll clarify!*

