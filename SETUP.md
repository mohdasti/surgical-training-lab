# Setup Guide for Surgical Training Lab

## Quick Start (5 minutes)

### 1. Install R and RStudio
- Download R 4.x from [CRAN](https://cran.r-project.org/)
- Download RStudio from [Posit](https://posit.co/download/rstudio-desktop/)

### 2. Install Required Packages

```r
# Core Shiny packages
install.packages(c("shiny", "bslib", "plotly", "DT"))

# Data processing
install.packages(c("tidyverse", "data.table", "zoo"))

# Advanced
install.packages(c("R6", "gt"))
```

### 3. Run the App

**Option A: RStudio**
1. Open `app.R` in RStudio
2. Click "Run App" button
3. App opens in viewer pane or browser

**Option B: Command Line**
```bash
Rscript -e "shiny::runApp('app.R', launch.browser=TRUE)"
```

**Option C: Specific Port**
```bash
Rscript -e "shiny::runApp('app.R', port=3838, launch.browser=FALSE)"
# Then open http://localhost:3838
```

---

## Data Setup (Optional)

The app includes simulated data. To use your own data:

1. Place diagnostic files in `data/diagnostics/`:
   - `calibration.rds`
   - `loso_eval.rds`
   - `model_artifacts.rds`
   - `threshold_sandbox.rds`

2. Update paths in `app.R` if needed

---

## Configuration

Edit `config/config.yml` to adjust:
- Default threshold values
- Biosignal parameters
- Feature extraction windows
- Alert settings

---

## Troubleshooting

### Port Already in Use
```bash
# Kill existing process
pkill -f "shiny::runApp.*3838"
```

### Missing Packages
```r
# Check installed packages
installed.packages()[,"Package"]

# Install missing package
install.packages("PACKAGE_NAME")
```

### Opacity Issues
This is expected in the Training Lab. The production dashboard has resolved these issues.

---

## System Requirements

- **R:** 4.0 or higher
- **Memory:** 2GB+ RAM
- **Browser:** Chrome, Firefox, or Safari
- **OS:** macOS, Linux, or Windows

---

## For Developers

### Module Structure
- `R/mod_*.R` - Shiny modules
- `R/ui_*.R` - UI components
- `R/*_utils.R` - Utility functions

### Adding a New Paradigm
1. Create `R/mod_your_paradigm.R`
2. Add UI function: `mod_your_paradigm_ui()`
3. Add server function: `mod_your_paradigm_server()`
4. Register in `mod_experimental_controls_tab.R`
5. Add to threshold router in `threshold_adapter.R`

---

## Related Projects

- **[Production Dashboard](https://github.com/mohdasti/surgical-cognitive-dashboard)** - Clinical monitoring tool
- **GitHub Project** - Unified roadmap (coming soon)

