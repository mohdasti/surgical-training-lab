library(shiny)
library(plotly)
library(tidyverse)

# Source the utilities
source("R/threshold_utils.R")
source("R/ui_constants.R")
source("R/ui_theme.R")
source("R/mod_unified_sensitivity.R")

# Simple test app with JUST the unified sensitivity module
ui <- fluidPage(
  titlePanel("Test: Unified Sensitivity Module"),
  
  h3("Direct Module Test"),
  mod_unified_sensitivity_ui("test_sensitivity")
)

server <- function(input, output, session) {
  # Initialize the module with empty config
  sensitivity_module <- mod_unified_sensitivity_server("test_sensitivity", cfg = list())
  
  # Debug output
  observe({
    cat("Sensitivity module initialized\n")
    print(names(sensitivity_module))
  })
}

shinyApp(ui, server)

