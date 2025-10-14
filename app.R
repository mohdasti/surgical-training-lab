# ============================================================================
# SURGICAL TRAINING LAB - WORKING VERSION
# ============================================================================

# Load only essential packages to avoid conflicts
library(shiny)
library(plotly)
library(DT)
library(shinyjs)
library(htmltools)

# Source only the modules we need
source("R/threshold_utils.R")
source("R/mod_inverted_u_adjuster.R")
source("R/mod_unified_sensitivity.R")
source("R/mod_fatigue_adaptive.R")

# ============================================================================
# UI
# ============================================================================

ui <- fluidPage(
  # Initialize shinyjs
  shinyjs::useShinyjs(),
  
  # Custom CSS
  tags$head(
    tags$style(HTML("
      body {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        background: #f8f9fa;
        font-size: 14px;
      }
      
      .main-container {
        background: white;
        border-radius: 10px;
        padding: 30px;
        margin: 20px auto;
        max-width: 1200px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      }
      
      /* Improve text sizes */
      h1 { font-size: 2.5rem; }
      h2 { font-size: 2rem; }
      h3 { font-size: 1.5rem; }
      h4 { font-size: 1.25rem; }
      h5 { font-size: 1.1rem; }
      h6 { font-size: 1rem; }
      
      /* Slider improvements */
      .shiny-input-container {
        font-size: 14px;
      }
      
      .shiny-input-container label {
        font-size: 14px !important;
        font-weight: 600;
      }
      
      .js-irs-0 .irs-single, .js-irs-1 .irs-single, .js-irs-2 .irs-single, 
      .js-irs-3 .irs-single, .js-irs-4 .irs-single, .js-irs-5 .irs-single {
        font-size: 12px !important;
        font-weight: bold;
      }
      
      .js-irs-0 .irs-min, .js-irs-0 .irs-max, .js-irs-1 .irs-min, .js-irs-1 .irs-max,
      .js-irs-2 .irs-min, .js-irs-2 .irs-max, .js-irs-3 .irs-min, .js-irs-3 .irs-max,
      .js-irs-4 .irs-min, .js-irs-4 .irs-max, .js-irs-5 .irs-min, .js-irs-5 .irs-max {
        font-size: 10px !important;
      }
      
      /* Table improvements */
      table {
        font-size: 14px;
      }
      
      table td {
        font-size: 14px;
        padding: 4px 8px;
      }
      
      /* Button improvements */
      .btn {
        font-size: 13px;
        padding: 6px 12px;
      }
      
      /* Well panel improvements */
      .well {
        font-size: 14px;
      }
      
      /* Plot improvements */
      .plot-container {
        font-size: 14px;
      }
    "))
  ),
  
  div(class = "main-container",
    # Header
    div(style = "text-align: center; margin-bottom: 30px;",
      h1("🧪 Surgical Training Lab", 
         style = "color: #2c3e50; margin-bottom: 10px;"),
      p("Interactive Theory Explorer", 
        style = "color: #7f8c8d; font-size: 1.2em; margin-bottom: 20px;")
    ),
    
    # How to use section
    div(style = "background: #e8f5e8; padding: 20px; border-radius: 8px; margin-bottom: 30px;",
      h4("💡 How to Use:", style = "margin-top: 0; color: #27ae60;"),
      tags$ol(
        tags$li("Select a cognitive paradigm from the dropdown below"),
        tags$li("Adjust theory-specific parameters using the controls"),
        tags$li("Observe how threshold values change in real-time"),
        tags$li("Compare different paradigms by switching between them"),
        tags$li("Use scenario presets for common surgical situations")
      )
    ),
    
    # All three cognitive paradigms
    h2("🧪 All Cognitive Paradigms"),
    p("Scroll down to explore all three cognitive theory paradigms:"),
    
    h3("🎯 Inverted-U Zone Adjuster (Adaptive Gain Theory)"),
    mod_inverted_u_adjuster_ui("inverted_u"),
    
    hr(),
    
    h3("🔀 Unified Sensitivity Slider (Resource Competition)"),
    mod_unified_sensitivity_ui("sensitivity"),
    
    hr(),
    
    h3("⏰ Fatigue-Adaptive Thresholds (Vigilance Decrement)"),
    mod_fatigue_adaptive_ui("fatigue")
  )
)

# ============================================================================
# SERVER
# ============================================================================

server <- function(input, output, session) {
  
  # All three cognitive paradigms
  inverted_u <- mod_inverted_u_adjuster_server("inverted_u", 
    cfg = list(
      high_min = 0.40,
      high_max = 0.80,
      lapse_min = 0.70,
      lapse_max = 0.95
    )
  )
  
  sensitivity <- mod_unified_sensitivity_server("sensitivity",
    cfg = list(
      high_min = 0.40,
      high_max = 0.80,
      lapse_min = 0.70,
      lapse_max = 0.95
    )
  )
  
  fatigue <- mod_fatigue_adaptive_server("fatigue",
    cfg = list(
      current_time = reactive({ Sys.time() }),
      high_min = 0.40,
      high_max = 0.80,
      lapse_min = 0.70,
      lapse_max = 0.95
    )
  )
}

# ============================================================================
# RUN APP
# ============================================================================

shinyApp(ui, server)