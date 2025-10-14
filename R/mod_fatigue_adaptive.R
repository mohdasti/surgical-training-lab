#' Fatigue-Adaptive Thresholds Module
#'
#' @description
#' Time-based threshold adaptation that makes the system more sensitive as
#' time-on-task increases, reflecting cognitive fatigue accumulation.

#' UI for Fatigue-Adaptive Thresholds
#'
#' @param id Module namespace ID
#' @return Shiny UI element
#' @export
mod_fatigue_adaptive_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    p(style = "color: #666; font-size: 0.9em;",
      "Thresholds automatically decrease over time to account for cognitive fatigue. ",
      "The system becomes more sensitive as time-on-task increases."
    ),
    
    # Controls on top
    fluidRow(
      column(12,
        wellPanel(
          h5("⚙️ Fatigue Configuration"),
          fluidRow(
            column(6,
              h6("Baseline Thresholds (t=0)"),
              sliderInput(ns("baseline_high"), "High Load (baseline)", 
                         0.4, 0.8, 0.60, 0.01),
              sliderInput(ns("baseline_lapse"), "Lapse (baseline)", 
                         0.7, 0.95, 0.85, 0.01)
            ),
            column(6,
              h6("Fatigue Timeline"),
              numericInput(ns("t0"), "Start time (minutes)", value = 0, min = 0, max = 180),
              numericInput(ns("t1"), "Full effect time (minutes)", value = 30, min = 1, max = 180),
              selectInput(ns("f_shape"), "Profile shape",
                         choices = c("Linear" = "linear", "Logistic" = "logistic"),
                         selected = "linear")
            )
          ),
          fluidRow(
            column(6,
              h6("Decay Gains"),
              sliderInput(ns("k_high"), "High Load decay", 
                         0, 0.30, 0.15, 0.01),
              sliderInput(ns("k_lapse"), "Lapse decay", 
                         0, 0.25, 0.10, 0.01)
            ),
            column(6,
              h6("Current Time Simulation"),
              sliderInput(ns("time_demo"), "Time-on-Task (minutes)",
                         min = 0, max = 60, value = 0, step = 0.5,
                         animate = animationOptions(interval = 500, loop = TRUE)),
              tags$table(style = "width: 100%; margin-top: 10px;",
                tags$tr(
                  tags$td(strong("High Load:")),
                  tags$td(textOutput(ns("high_threshold_display")), style = "text-align: right; color: #f39c12;")
                ),
                tags$tr(
                  tags$td(strong("Lapse:")),
                  tags$td(textOutput(ns("lapse_threshold_display")), style = "text-align: right; color: #e74c3c;")
                )
              )
            )
          )
        )
      )
    ),
    
    # Plot below (full width)
    fluidRow(
      column(12,
        plotOutput(ns("timeline_plot"), height = "400px")
      )
    )
  )
}

#' Server for Fatigue-Adaptive Thresholds
#'
#' @param id Module namespace ID
#' @param cfg Configuration list. Should include current_time reactive if available.
#' @return List of reactives: profile(), thresholds()
#' @export
mod_fatigue_adaptive_server <- function(id, cfg = list()) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Use external time if provided, otherwise use demo slider
    current_time <- reactive({
      if (!is.null(cfg$current_time) && is.reactive(cfg$current_time)) {
        cfg$current_time()
      } else {
        input$time_demo
      }
    })
    
    # Build profile configuration
    profile_reactive <- reactive({
      list(
        enabled = TRUE,
        t0 = input$t0,
        t1 = input$t1,
        f_shape = input$f_shape,
        k_high = input$k_high,
        k_lapse = input$k_lapse
      )
    })
    
    # Compute thresholds
    thresholds_reactive <- reactive({
      # Functions already loaded, no need to source
      
      baseline <- list(
        high_load_threshold0 = input$baseline_high,
        lapse_threshold0 = input$baseline_lapse
      )
      
      profile <- profile_reactive()
      
      derive_fatigue_adjusted_thresholds(
        current_time(),
        baseline,
        profile,
        cfg
      )
    })
    
    # Display values
    output$time_display <- renderText({
      sprintf("%.1f min", current_time())
    })
    
    output$fatigue_display <- renderText({
      t <- thresholds_reactive()
      sprintf("%.2f (%.0f%%)", t$fatigue_factor, t$fatigue_factor * 100)
    })
    
    output$high_threshold_display <- renderText({
      sprintf("%.2f", thresholds_reactive()$high_load_threshold)
    })
    
    output$lapse_threshold_display <- renderText({
      sprintf("%.2f", thresholds_reactive()$lapse_threshold)
    })
    
    # Plot timeline
    output$timeline_plot <- renderPlot({
      # Functions already loaded, no need to source
      
      # Generate timeline
      t_seq <- seq(0, input$t1 + 10, length.out = 100)
      baseline <- list(
        high_load_threshold0 = input$baseline_high,
        lapse_threshold0 = input$baseline_lapse
      )
      profile <- profile_reactive()
      
      timeline_data <- lapply(t_seq, function(t) {
        thresh <- derive_fatigue_adjusted_thresholds(t, baseline, profile, cfg)
        data.frame(
          time = t,
          high = thresh$high_load_threshold,
          lapse = thresh$lapse_threshold,
          fatigue = thresh$fatigue_factor
        )
      })
      timeline_df <- do.call(rbind, timeline_data)
      
      # Current state
      current_t <- current_time()
      current_thresh <- thresholds_reactive()
      
      par(mar = c(5, 5, 4, 2), cex.lab = 1.2, cex.axis = 1.1, cex.main = 1.3)
      plot(timeline_df$time, timeline_df$high,
           type = "l", col = "#f39c12", lwd = 3,
           xlab = "Time (minutes)", ylab = "Threshold",
           ylim = c(0.3, 1.0), las = 1,
           main = "Threshold Decay Over Time")
      lines(timeline_df$time, timeline_df$lapse, col = "#e74c3c", lwd = 3)
      
      # ALWAYS mark current time with a vertical dashed line
      abline(v = current_t, col = "#3498db", lty = 2, lwd = 2)
      
      # Add points at current thresholds
      points(current_t, current_thresh$high_load_threshold,
             pch = 19, col = "#f39c12", cex = 2)
      points(current_t, current_thresh$lapse_threshold,
             pch = 19, col = "#e74c3c", cex = 2)
      
      # Add text label for current time
      text(current_t, 0.35, 
           sprintf("t = %.1f min", current_t),
           col = "#3498db", pos = 4, cex = 0.8, font = 2)
      
      # Add legend
      legend("topright",
             legend = c("High Load", "Lapse", "Current Time"),
             col = c("#f39c12", "#e74c3c", "#3498db"),
             lwd = c(3, 3, 2),
             lty = c(1, 1, 2),
             bty = "n", cex = 1.0)
    })
    
    # Return reactive interface
    list(
      profile = profile_reactive,
      thresholds = thresholds_reactive
    )
  })
}

