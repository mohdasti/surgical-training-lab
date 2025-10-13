library(shiny)
library(bslib)
library(plotly)
library(DT)
library(shinyjs)
library(tidyverse)
library(zoo)

# Source required modules
source("R/ui_constants.R")
source("R/ui_theme.R")
source("R/mod_scenario_presets.R")
source("R/mod_inverted_u_adjuster.R")
source("R/mod_unified_sensitivity.R")
source("R/mod_fatigue_adaptive.R")
source("R/mod_controls_router.R")
source("R/mod_experimental_controls_tab.R")
source("R/threshold_adapter.R")

# ============================================================================
# UI
# ============================================================================

ui <- page_fluid(
  # Initialize shinyjs
  shinyjs::useShinyjs(),
  
  # Custom CSS
  tags$head(
    tags$style(HTML("
      /* Modern, clean design */
      body {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      }
      
      .main-container {
        background: white;
        border-radius: 20px;
        padding: 40px;
        margin: 40px auto;
        max-width: 1400px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      }
      
      .header-banner {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 30px;
        border-radius: 15px;
        margin-bottom: 30px;
        text-align: center;
      }
      
      .header-banner h1 {
        font-size: 2.5em;
        font-weight: 700;
        margin: 0;
        text-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }
      
      .header-banner p {
        font-size: 1.2em;
        margin: 10px 0 0 0;
        opacity: 0.95;
      }
      
      .theory-card {
        background: #f8f9fa;
        border-left: 4px solid #667eea;
        padding: 20px;
        margin: 20px 0;
        border-radius: 8px;
      }
      
      .theory-card h4 {
        color: #667eea;
        margin-top: 0;
      }
      
      /* Kill opacity issues */
      body, .container-fluid, * { opacity: 1 !important; }
      .recalculating { opacity: 1 !important; }
      .recalculating::after { display: none !important; }
      .shiny-busy { opacity: 1 !important; }
      
      /* Button styling */
      .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        border-radius: 8px;
        padding: 12px 24px;
        font-weight: 600;
        transition: all 0.3s ease;
      }
      
      .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 16px rgba(102, 126, 234, 0.3);
      }
      
      /* Info boxes */
      .info-box {
        background: #e3f2fd;
        border-left: 4px solid #2196f3;
        padding: 15px;
        margin: 15px 0;
        border-radius: 5px;
      }
      
      .warning-box {
        background: #fff3cd;
        border-left: 4px solid #ffc107;
        padding: 15px;
        margin: 15px 0;
        border-radius: 5px;
      }
      
      .success-box {
        background: #d4edda;
        border-left: 4px solid #28a745;
        padding: 15px;
        margin: 15px 0;
        border-radius: 5px;
      }
    "))
  ),
  
  # Main container
  div(class = "main-container",
    
    # Header
    div(class = "header-banner",
      h1("🧪 Surgical Training Lab"),
      p("Interactive Exploration of Cognitive Theory Paradigms in Surgical Monitoring")
    ),
    
    # Introduction section
    div(class = "info-box",
      icon("info-circle"), strong(" About This Tool:"),
      p(style = "margin: 10px 0 0 0;",
        "This research and educational platform allows you to explore three cognitive theory paradigms ",
        "for adaptive threshold control in surgical monitoring. Adjust parameters in real-time to see how ",
        "different theoretical frameworks affect alert behavior and decision boundaries."
      )
    ),
    
    # Link to production dashboard
    div(class = "warning-box",
      icon("external-link-alt"), strong(" Looking for Real-Time Monitoring?"),
      p(style = "margin: 10px 0 0 0;",
        "For production-ready live monitoring, visit the ",
        tags$a(href = "https://github.com/mohdasti/surgical-cognitive-dashboard", 
               target = "_blank",
               "Surgical Cognitive Dashboard"),
        ". This Training Lab is designed for research and education."
      )
    ),
    
    # Theory overview cards
    fluidRow(
      column(4,
        div(class = "theory-card",
          h4("🎯 Inverted-U Zone"),
          p(strong("Theory:"), " Adaptive Gain Theory (Aston-Jones & Cohen, 2005)"),
          p(strong("Concept:"), " Performance follows an inverted-U with arousal. ",
            "Adjusts thresholds based on arousal zones (sub-optimal, optimal, hyper-arousal)."),
          p(strong("Key Parameter:"), " Pupil diameter as arousal proxy")
        )
      ),
      column(4,
        div(class = "theory-card",
          h4("🔀 Unified Sensitivity"),
          p(strong("Theory:"), " Resource Competition Model (Norman & Bobrow, 1975)"),
          p(strong("Concept:"), " Finite cognitive resources shared across tasks. ",
            "Single sensitivity slider controls detection vs. false alarm trade-off."),
          p(strong("Key Parameter:"), " System sensitivity level")
        )
      ),
      column(4,
        div(class = "theory-card",
          h4("⏰ Fatigue-Adaptive"),
          p(strong("Theory:"), " Vigilance Decrement (Warm et al., 2008)"),
          p(strong("Concept:"), " Sustained attention degrades over time. ",
            "Lowers thresholds as time-on-task increases to compensate."),
          p(strong("Key Parameter:"), " Time-on-task duration")
        )
      )
    ),
    
    # Horizontal divider
    hr(style = "margin: 30px 0;"),
    
    # Main experimental controls
    h2("🔬 Interactive Theory Explorer", style = "color: #667eea; margin-bottom: 20px;"),
    
    div(class = "success-box",
      icon("lightbulb"), strong(" How to Use:"),
      tags$ol(style = "margin: 10px 0 0 0;",
        tags$li("Select a cognitive paradigm from the dropdown below"),
        tags$li("Adjust theory-specific parameters using the controls"),
        tags$li("Observe how threshold values change in real-time"),
        tags$li("Compare different paradigms by switching between them"),
        tags$li("Use scenario presets for common surgical situations")
      )
    ),
    
    # Experimental controls module
    mod_experimental_controls_tab_ui("exp_controls")
  )
)

# ============================================================================
# SERVER
# ============================================================================

server <- function(input, output, session) {
  
  # Simulated real-time data for demonstration
  realtime_data <- reactiveVal(tibble::tibble(
    timestamp = numeric(),
    pupil_diameter = numeric(),
    grip_force = numeric(),
    tremor_amplitude = numeric(),
    state_probs_normal = numeric(),
    state_probs_highload = numeric(),
    state_probs_lapse = numeric(),
    lapse_prob = numeric(),
    final_state = character()
  ))
  
  # Simulate some basic time progression for fatigue paradigm
  simulation_timer <- reactiveTimer(1000)  # Update every second
  current_time_minutes <- reactiveVal(0)
  
  observe({
    simulation_timer()
    current_time_minutes(current_time_minutes() + 0.0167)  # 1 second in minutes
    
    # Reset after 60 minutes
    if (current_time_minutes() > 60) {
      current_time_minutes(0)
    }
    
    # Update simulated data
    t <- current_time_minutes() * 60  # Convert to seconds
    
    # Simple biosignal simulation
    pupil <- 3.5 + 0.3 * sin(t / 30) + rnorm(1, 0, 0.1)
    grip <- 4.5 + 0.5 * sin(t / 20) + rnorm(1, 0, 0.2)
    tremor <- 90 * (1 + 0.002 * t) + rnorm(1, 0, 10)
    
    # Simple state probabilities
    normal_prob <- 0.6 + 0.2 * sin(t / 40)
    highload_prob <- 0.25 + 0.1 * sin(t / 30)
    lapse_prob <- max(0, 0.15 - normal_prob + 0.05 * sin(t / 50))
    
    # Normalize
    total <- normal_prob + highload_prob + lapse_prob
    normal_prob <- normal_prob / total
    highload_prob <- highload_prob / total
    lapse_prob <- lapse_prob / total
    
    new_row <- tibble::tibble(
      timestamp = t,
      pupil_diameter = pupil,
      grip_force = grip,
      tremor_amplitude = tremor,
      state_probs_normal = normal_prob,
      state_probs_highload = highload_prob,
      state_probs_lapse = lapse_prob,
      lapse_prob = lapse_prob,
      final_state = "Simulated"
    )
    
    current_data <- realtime_data()
    updated_data <- dplyr::bind_rows(current_data, new_row)
    
    # Keep only last 100 points
    if (nrow(updated_data) > 100) {
      updated_data <- tail(updated_data, 100)
    }
    realtime_data(updated_data)
  })
  
  # Mount experimental controls module
  experimental <- mod_experimental_controls_tab_server(
    "exp_controls",
    cfg = list(
      current_time = reactive({ current_time_minutes() }),
      high_min = 0.40,
      high_max = 0.80,
      lapse_min = 0.70,
      lapse_max = 0.95
    ),
    existing_thresholds = reactive({
      list(
        high_load_threshold = 0.6,
        lapse_threshold = 0.3,
        source = "baseline"
      )
    })
  )
  
  # Create threshold adapter
  threshold_adapter <- create_threshold_adapter(
    input = list(
      use_experimental = reactive(TRUE),  # Always use experimental in this app
      theta_high = reactive(0.6),
      theta_lapse = reactive(0.3)
    ),
    experimental = experimental
  )
  
  # Display welcome message on startup
  observe({
    showNotification(
      "🎓 Welcome to the Surgical Training Lab! Select a cognitive paradigm to begin exploration.",
      type = "message",
      duration = 10
    )
  })
}

# ============================================================================
# RUN APP
# ============================================================================

shinyApp(ui, server)
