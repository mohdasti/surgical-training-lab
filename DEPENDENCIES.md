# Dependencies - Surgical Training Lab

## Required R Packages

This Shiny application requires the following R packages:

### Core Dependencies

| Package | Min Version | Purpose |
|---------|-------------|---------|
| **shiny** | 1.7.0 | Shiny web application framework |
| **bslib** | 0.5.0 | Bootstrap 5 theming and UI components |
| **ggplot2** | 3.4.0 | Data visualization and plotting |
| **jsonlite** | 1.8.0 | JSON export functionality |
| **htmltools** | 0.5.0 | HTML generation and manipulation |
| **shinyjs** | 2.1.0 | JavaScript operations in Shiny |

### Optional Dependencies

| Package | Min Version | Purpose |
|---------|-------------|---------|
| **plotly** | 4.10.0 | Interactive plots (used in other modules) |
| **DT** | 0.28.0 | Interactive data tables (used in other modules) |
| **gt** | 0.9.0 | Table generation (used in other modules) |
| **dplyr** | 1.1.0 | Data manipulation (used in other modules) |
| **tidyr** | 1.3.0 | Data tidying (used in other modules) |

## Installation

### Option 1: Install All at Once

```r
install.packages(c(
  "shiny",
  "bslib", 
  "ggplot2",
  "plotly",
  "DT",
  "shinyjs",
  "htmltools",
  "jsonlite"
))
```

### Option 2: Use the Dependency Checker

Run the included dependency checker script:

```bash
Rscript check_dependencies.R
```

This script will:
- Check which packages are installed
- Show version numbers
- Optionally install missing packages
- Validate that the app is ready to run

## Verification

To verify all dependencies are correctly installed:

```r
source("check_dependencies.R")
```

Expected output:
```
✓ All required packages are installed!
✓ App is ready to run!
```

## Currently Installed Versions

The app has been tested with these versions:

- **shiny**: 1.11.1
- **bslib**: 0.9.0
- **ggplot2**: 3.5.2
- **plotly**: 4.11.0
- **DT**: 0.34.0
- **shinyjs**: 2.1.0
- **htmltools**: 0.5.8.1
- **jsonlite**: 2.0.0

## Running the App

Once all dependencies are installed:

### Method 1: Using RStudio
1. Open `app.R` in RStudio
2. Click "Run App" button

### Method 2: From R Console
```r
shiny::runApp()
```

### Method 3: Using Launch Script
```bash
Rscript launch_app.R
```

## Troubleshooting

### Missing Package Error
If you get an error like `there is no package called 'xxx'`:

1. Run `Rscript check_dependencies.R` to identify missing packages
2. Install the missing package: `install.packages("xxx")`
3. Try running the app again

### Version Conflicts
If you encounter issues with package versions:

1. Update all packages: `update.packages(ask = FALSE)`
2. Restart R session
3. Run the dependency checker again

### Grid Package
The `grid` package is part of base R and should be automatically available. If you get errors related to `grid`, try:

```r
library(grid)
```

## Additional Notes

- The app uses **Bootstrap 5** via `bslib` for modern UI theming
- **ggplot2** is used for all static plots with the clinical color palette
- The app does not require `renv` or a formal package structure
- All dependencies are standard CRAN packages

