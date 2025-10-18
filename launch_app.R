#!/usr/bin/env Rscript
# Quick launcher for Surgical Training Lab

cat("=== Launching Surgical Training Lab ===\n\n")

# Check if we're in the right directory
if (!file.exists("app.R")) {
  stop("Error: app.R not found. Please run this script from the app directory.")
}

# Quick dependency check
required <- c("shiny", "bslib", "ggplot2", "jsonlite")
missing <- required[!sapply(required, requireNamespace, quietly = TRUE)]

if (length(missing) > 0) {
  cat("Missing required packages:", paste(missing, collapse = ", "), "\n")
  cat("Please run: Rscript check_dependencies.R\n")
  quit(status = 1)
}

# Load shiny and run
cat("Loading app...\n")
library(shiny)
runApp(".", launch.browser = TRUE)

