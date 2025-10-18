#!/usr/bin/env Rscript
# Dependency checker and installer for Surgical Training Lab

cat("=== Surgical Training Lab - Dependency Checker ===\n\n")

# Required packages
required_packages <- c(
  "shiny",
  "bslib", 
  "ggplot2",
  "plotly",
  "DT",
  "shinyjs",
  "htmltools",
  "jsonlite"
)

# Check which packages are missing
cat("Checking required packages...\n")
missing_packages <- c()
installed_packages <- c()

for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    ver <- as.character(packageVersion(pkg))
    installed_packages <- c(installed_packages, pkg)
    cat("  ✓", pkg, "(", ver, ")\n")
  } else {
    missing_packages <- c(missing_packages, pkg)
    cat("  ✗", pkg, "- NOT INSTALLED\n")
  }
}

cat("\n")

# Install missing packages if needed
if (length(missing_packages) > 0) {
  cat("Missing packages:", paste(missing_packages, collapse = ", "), "\n\n")
  cat("Would you like to install them? (y/n): ")
  
  if (interactive()) {
    response <- tolower(trimws(readline()))
    if (response == "y" || response == "yes") {
      cat("\nInstalling missing packages...\n")
      install.packages(missing_packages, repos = "https://cran.r-project.org")
      cat("\n✓ Installation complete!\n")
    }
  } else {
    cat("\nTo install missing packages, run:\n")
    cat("  install.packages(c('", paste(missing_packages, collapse = "', '"), "'))\n", sep = "")
  }
} else {
  cat("✓ All required packages are installed!\n\n")
  
  # Test loading key files
  cat("Testing app components...\n")
  tryCatch({
    suppressPackageStartupMessages({
      library(shiny)
      library(bslib)
      library(ggplot2)
    })
    source("R/policies.R")
    cat("  ✓ R/policies.R\n")
    source("R/theme.R")
    cat("  ✓ R/theme.R\n")
    cat("\n✓ App is ready to run!\n")
    cat("\nTo launch the app, run:\n")
    cat("  shiny::runApp()\n")
  }, error = function(e) {
    cat("  ✗ Error:", conditionMessage(e), "\n")
  })
}

