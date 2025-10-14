#' Controls Router Module
#'
#' @description
#' Central hub for switching between different threshold control paradigms.
#' Provides a unified interface regardless of which control panel is active.

#' UI for Controls Router
#'
#' @param id Module namespace ID
#' @return Shiny UI element
#' @export
mod_controls_router_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    wellPanel(
      style = "background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px;",
      h4("🎛️ Control Source Selection", style = "margin-top: 0; color: white; font-weight: 600;"),
      p("Select which control paradigm should drive the cognitive state thresholds.", 
        style = "margin-bottom: 10px; color: rgba(255, 255, 255, 0.95);"),
      
      radioButtons(
        inputId = ns("control_source"),
        label = NULL,
        choices = c(
          "🎯 Inverted-U Zone Adjuster (Adaptive Gain Theory)" = "inverted_u",
          "🔀 Unified Sensitivity Slider (Resource Competition)" = "sensitivity",
          "⏰ Fatigue-Adaptive Thresholds (Vigilance Decrement)" = "fatigue"
        ),
        selected = "inverted_u",
        inline = FALSE
      )
    ),
    
    conditionalPanel(
      condition = sprintf("input['%s'] == 'inverted_u'", ns("control_source")),
      h4("🎯 Inverted-U Zone Adjuster"),
      mod_inverted_u_adjuster_ui(ns("inverted_u"))
    ),
    
    conditionalPanel(
      condition = sprintf("input['%s'] == 'sensitivity'", ns("control_source")),
      h4("🔀 Unified Sensitivity Slider"),
      mod_unified_sensitivity_ui(ns("sensitivity"))
    ),
    
    conditionalPanel(
      condition = sprintf("input['%s'] == 'fatigue'", ns("control_source")),
      h4("⏰ Fatigue-Adaptive Thresholds"),
      mod_fatigue_adaptive_ui(ns("fatigue"))
    )
  )
}

#' Server for Controls Router
#'
#' @param id Module namespace ID
#' @param cfg Configuration list
#' @param existing_thresholds Reactive returning current thresholds from baseline controls
#' @param preset_overrides Reactive list from scenario presets module (optional)
#' @return List of reactives: active_source(), thresholds(), extras()
#' @export
mod_controls_router_server <- function(id, cfg = list(), existing_thresholds = NULL, preset_overrides = NULL) {
  moduleServer(id, function(input, output, session) {
    # Initialize all experimental modules (with proper IDs matching UI)
    inverted_u <- mod_inverted_u_adjuster_server("inverted_u", cfg)
    sensitivity <- mod_unified_sensitivity_server("sensitivity", cfg)
    fatigue <- mod_fatigue_adaptive_server("fatigue", cfg)
    
    # renderUI REMOVED - now using conditionalPanel in UI (prevents opacity)
    # UI switching is handled by conditionalPanel in mod_controls_router_ui()
    
    # Route thresholds based on active source
    thresholds_routed <- reactive({
      source <- input$control_source
      
      if (source == "inverted_u") {
        inverted_u$thresholds()
      } else if (source == "sensitivity") {
        sensitivity$thresholds()
      } else if (source == "fatigue") {
        fatigue$thresholds()
      } else {
        # Default fallback (should never reach here)
        list(
          high_load_threshold = 0.60,
          lapse_threshold = 0.85,
          source = "error_fallback"
        )
      }
    })
    
    # Collect extras for logging
    extras_reactive <- reactive({
      source <- input$control_source
      
      extras <- list(
        timestamp = Sys.time(),
        source = source
      )
      
      if (source == "inverted_u") {
        extras$zone_bounds <- inverted_u$zone_bounds()
      } else if (source == "sensitivity") {
        extras$sensitivity <- sensitivity$sensitivity()
      } else if (source == "fatigue") {
        extras$profile <- fatigue$profile()
      }
      
      extras
    })
    
    # Return unified interface
    list(
      active_source = reactive({ input$control_source }),
      thresholds = thresholds_routed,
      extras = extras_reactive
    )
  })
}

