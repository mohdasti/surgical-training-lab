#' Inverted-U Zone Adjuster Module
#'
#' @description
#' Interactive control panel that visualizes the inverted-U relationship between
#' arousal and performance. Users drag vertical handles to define zone boundaries,
#' which automatically map to interdependent thresholds.
#'
#' @details
#' The module enforces:
#' - 0.05 ≤ b_left < b_right ≤ 0.95
#' - Minimum gap of 0.10 between boundaries
#' - Monotonic mapping to thresholds (documented in utils_thresholds.R)

#' UI for Inverted-U Zone Adjuster
#'
#' @param id Module namespace ID
#' @return Shiny UI element
#' @export
mod_inverted_u_adjuster_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    p(style = "color: #666; font-size: 0.9em;",
      "Drag the vertical handles to define cognitive state zones. ",
      "The system automatically adjusts thresholds to maintain theoretical consistency."
    ),
    
    # Controls on top
    fluidRow(
      column(12,
        wellPanel(
          h5("📊 Current Configuration"),
          fluidRow(
            column(6,
              tags$table(style = "width: 100%;",
                tags$tr(
                  tags$td(strong("Left Boundary:")),
                  tags$td(textOutput(ns("b_left_display")), style = "text-align: right;")
                ),
                tags$tr(
                  tags$td(strong("Right Boundary:")),
                  tags$td(textOutput(ns("b_right_display")), style = "text-align: right;")
                ),
                tags$hr(),
                tags$tr(
                  tags$td(strong("High Load Threshold:")),
                  tags$td(textOutput(ns("high_threshold_display")), style = "text-align: right; color: #f39c12;")
                ),
                tags$tr(
                  tags$td(strong("Lapse Threshold:")),
                  tags$td(textOutput(ns("lapse_threshold_display")), style = "text-align: right; color: #e74c3c;")
                )
              )
            ),
            column(6,
              h6("Boundary Controls"),
              sliderInput(ns("b_left_slider"), "Left Boundary", 
                         min = 0.05, max = 0.95, value = 0.30, step = 0.01),
              sliderInput(ns("b_right_slider"), "Right Boundary", 
                         min = 0.05, max = 0.95, value = 0.70, step = 0.01),
              p(style = "font-size: 0.8em; color: #666; margin-top: 10px;",
                "Drag the sliders to adjust zone boundaries. Constraints are automatically enforced.")
            )
          )
        )
      )
    ),
    
    # Plot below (full width)
    fluidRow(
      column(12,
        plotOutput(ns("curve_plot"), height = "400px")
      )
    )
  )
}

#' Server for Inverted-U Zone Adjuster
#'
#' @param id Module namespace ID
#' @param cfg Configuration list
#' @return List of reactives: zone_bounds(), thresholds()
#' @export
mod_inverted_u_adjuster_server <- function(id, cfg = list()) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Initialize boundary values
    b_left <- reactiveVal(0.30)
    b_right <- reactiveVal(0.70)
    
    # Enforce constraints on slider changes
    observeEvent(input$b_left_slider, {
      new_left <- input$b_left_slider
      current_right <- b_right()
      min_gap <- cfg$min_gap %||% 0.10
      
      # Ensure min gap
      if (new_left + min_gap > current_right) {
        new_left <- current_right - min_gap
      }
      new_left <- max(0.05, min(0.95, new_left))
      
      b_left(new_left)
    }, ignoreInit = TRUE)
    
    observeEvent(input$b_right_slider, {
      new_right <- input$b_right_slider
      current_left <- b_left()
      min_gap <- cfg$min_gap %||% 0.10
      
      # Ensure min gap
      if (new_right - min_gap < current_left) {
        new_right <- current_left + min_gap
      }
      new_right <- max(0.05, min(0.95, new_right))
      
      b_right(new_right)
    }, ignoreInit = TRUE)
    
    # Compute derived thresholds
    thresholds_reactive <- reactive({
      # Don't re-source, functions already loaded
      derive_thresholds_from_zone_bounds(b_left(), b_right(), cfg)
    })
    
    # Render inverted-U curve with zones using base R graphics
    output$curve_plot <- renderPlot({
      tryCatch({
        cat("DEBUG: Rendering Inverted-U curve plot\n")
        cat("DEBUG: Module namespace:", session$ns(""), "\n")
        cat("DEBUG: Output ID:", session$ns("curve_plot"), "\n")
        # Generate inverted-U curve (normalized Gaussian)
        x <- seq(0, 1, length.out = 200)
        sigma <- 0.18
        y <- exp(-((x - 0.5)^2) / (2 * sigma^2))
        
        # Current boundaries
        left <- b_left()
        right <- b_right()
        
        cat(sprintf("DEBUG: Boundaries - Left: %.2f, Right: %.2f\n", left, right))
        
        # Create base R plot
        par(mar = c(5, 5, 4, 2), cex.lab = 1.2, cex.axis = 1.1, cex.main = 1.3)
        plot(x, y, type = "n", xlim = c(0, 1), ylim = c(0, 1.1),
             xlab = "Arousal Level", ylab = "Performance",
             main = "🧠 Arousal-Performance Relationship (Inverted-U)",
             las = 1)
        
        # Add colored zones
        rect(0, 0, left, 1.1, col = rgb(231/255, 76/255, 60/255, 0.2), border = NA)
        rect(left, 0, right, 1.1, col = rgb(46/255, 204/255, 113/255, 0.2), border = NA)
        rect(right, 0, 1, 1.1, col = rgb(231/255, 76/255, 60/255, 0.2), border = NA)
        
        # Plot the curve
        lines(x, y, col = "#2c3e50", lwd = 3)
        
        # Add boundary lines
        abline(v = left, col = "#e74c3c", lwd = 3, lty = 2)
        abline(v = right, col = "#f39c12", lwd = 3, lty = 2)
        
        # Add zone labels
        text(left/2, 1.05, "Low/Lapse", col = "#e74c3c", font = 2, cex = 1.2)
        text((left+right)/2, 1.05, "Optimal", col = "#27ae60", font = 2, cex = 1.4)
        text((right+1)/2, 1.05, "High/Overload", col = "#e74c3c", font = 2, cex = 1.2)
        
        # Add boundary labels
        legend("topright", legend = c("Left Boundary", "Right Boundary"),
               col = c("#e74c3c", "#f39c12"), lwd = 3, lty = 2, bty = "n", cex = 1.0)
        
        cat("DEBUG: Plot created successfully\n")
        
      }, error = function(e) {
        cat(sprintf("ERROR in curve_plot: %s\n", e$message))
        plot(1, 1, type = "n", axes = FALSE, xlab = "", ylab = "")
        text(1, 1, paste("Error:", e$message), col = "red")
      })
    })
    
    
    # Display values
    output$b_left_display <- renderText({
      sprintf("%.2f", b_left())
    })
    
    output$b_right_display <- renderText({
      sprintf("%.2f", b_right())
    })
    
    output$high_threshold_display <- renderText({
      sprintf("%.2f", thresholds_reactive()$high_load_threshold)
    })
    
    output$lapse_threshold_display <- renderText({
      sprintf("%.2f", thresholds_reactive()$lapse_threshold)
    })
    
    # Return reactive interface
    list(
      zone_bounds = reactive({ c(b_left(), b_right()) }),
      thresholds = thresholds_reactive
    )
  })
}

