# ============================================================================
# SURGICAL TRAINING LAB - WORKING VERSION
# ============================================================================

# Load only essential packages to avoid conflicts
library(shiny)
library(bslib)
library(ggplot2)
library(plotly)
library(DT)
library(shinyjs)
library(htmltools)
library(jsonlite)

# Source theme and policy functions
source("R/theme.R")
source("R/policies.R")

# ============================================================================
# UI
# ============================================================================

ui <- fluidPage(
  theme = lab_theme(),
  
  # Initialize shinyjs
  shinyjs::useShinyjs(),
  
  # Initialize Bootstrap 5 tooltips
  tags$script(HTML("
    $(document).ready(function(){
      var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle=\"tooltip\"]'));
      var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
      });
    });
  ")),
  
  # Header
  div(style = "text-align: center; margin-top: 20px; margin-bottom: 30px;",
    h1("🧪 Surgical Training Lab — Threshold Policies", 
       style = "color: #0b1526; margin-bottom: 10px;"),
    p("Interactive Theory Explorer for Case Study Alignment", 
      style = "color: #6b7280; font-size: 1.1em;")
  ),
  
  # Main tabset for three policies
  tabsetPanel(
    id = "tabs",
    type = "tabs",
    
    # ========================================================================
    # TAB 1: Adaptive Gain (Inverted-U)
    # ========================================================================
    tabPanel(
      "Adaptive Gain (Inverted-U)",
      value = "tab_gain",
      br(),
      fluidRow(
        column(4,
          wellPanel(
            h4(
              "🎯 Inverted-U Parameters ",
              tags$span(
                class = "help-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Targets mid-arousal zone; extremes impair performance.",
                "?"
              )
            ),
            sliderInput("gain_k", "Curve sharpness (k)", 
                        min = 0.1, max = 1.0, value = 0.4, step = 0.05),
            sliderInput("gain_scale", "Scale", 
                        min = 0.5, max = 2.0, value = 1.0, step = 0.1),
            hr(),
            helpText("🔬 Adaptive Gain Theory: Targets the mid-arousal zone. ",
                     "This is an intuition plot showing optimal performance at intermediate arousal levels.")
          )
        ),
        column(8,
          div(style = "margin-bottom: 10px; color: #6b7280; font-size: 0.95em;",
            "Targets mid-arousal zone; extremes impair performance."
          ),
          plotOutput("plot_gain", height = 400)
        )
      )
    ),
    
    # ========================================================================
    # TAB 2: Dual-Criterion (SDT)
    # ========================================================================
    tabPanel(
      "Dual-Criterion (SDT)",
      value = "tab_sdt",
      br(),
      fluidRow(
        column(4,
          wellPanel(
            h4(
              "🎯 SDT Parameters ",
              tags$span(
                class = "help-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "One knob moves both criteria; tuning bias, not d′; hysteresis prevents edge chatter.",
                "?"
              )
            ),
            sliderInput("criterion_tightness", "criterion_tightness", 
                        min = 0, max = 1, value = 0.60, step = 0.01),
            sliderInput("coupling", "coupling", 
                        min = 0, max = 1, value = 0.70, step = 0.01),
            sliderInput("hys_margin", "hys_margin", 
                        min = 0.00, max = 0.50, value = 0.15, step = 0.01),
            sliderInput("base_hl", "base_hl", 
                        min = 0.5, max = 3, value = 1.60, step = 0.05),
            sliderInput("base_lapse", "base_lapse", 
                        min = -3, max = -0.5, value = -1.60, step = 0.05),
            sliderInput("move_range", "move_range", 
                        min = 0.2, max = 2.0, value = 1.00, step = 0.05),
            hr(),
            helpText("🔬 Signal Detection Theory: Two decision criteria with enter/exit thresholds ",
                     "to reduce edge chatter via hysteresis.")
          )
        ),
        column(8,
          div(style = "margin-bottom: 10px; color: #6b7280; font-size: 0.95em;",
            "One knob moves both criteria; tuning bias, not d′; hysteresis prevents edge chatter."
          ),
          plotOutput("plot_sdt_density", height = 380),
          br(),
          plotOutput("plot_sdt_timeseries", height = 360)
        )
      )
    ),
    
    # ========================================================================
    # TAB 3: Time-on-Task (Fatigue)
    # ========================================================================
    tabPanel(
      "Time-on-Task (Fatigue)",
      value = "tab_fatigue",
      br(),
      fluidRow(
        column(4,
          wellPanel(
            h4(
              "⏰ Fatigue Parameters ",
              tags$span(
                class = "help-icon",
                `data-bs-toggle` = "tooltip",
                `data-bs-placement` = "top",
                title = "Hold steady until onset; relax with half-life; microbreak briefly tightens threshold.",
                "?"
              )
            ),
            sliderInput("c_start", "c_start", 
                        min = 0.50, max = 0.90, value = 0.70, step = 0.01),
            sliderInput("c_floor", "c_floor", 
                        min = 0.40, max = 0.70, value = 0.50, step = 0.01),
            sliderInput("onset_min", "onset_min (min)", 
                        min = 5, max = 60, value = 30, step = 1),
            sliderInput("fatigue_half_life_min", "fatigue_half_life_min (min)", 
                        min = 5, max = 60, value = 21, step = 1),
            sliderInput("microbreak_min", "microbreak_min (min)", 
                        min = 0, max = 90, value = 60, step = 1),
            sliderInput("microbreak_reset_fixed", "microbreak_reset_fixed", 
                        min = 0.00, max = 0.20, value = 0.08, step = 0.01),
            sliderInput("microbreak_decay_min", "microbreak_decay_min (min)", 
                        min = 0.5, max = 5, value = 2, step = 0.1),
            fileInput("phys_csv", 
                      "Optional: Upload microbreak pre/post physiology CSV", 
                      accept = c(".csv")),
            hr(),
            helpText("🔬 Vigilance Decrement: Policy on the decision threshold with exponential decay. ",
                     "Optional physiology-proportional reset (preferred) after microbreak.")
          )
        ),
        column(8,
          div(style = "margin-bottom: 10px; color: #6b7280; font-size: 0.95em;",
            "Hold steady until onset; relax with half-life; microbreak briefly tightens threshold."
          ),
          plotOutput("plot_fatigue", height = 500)
        )
      )
    )
  ),
  
  # ========================================================================
  # Export Policy Section
  # ========================================================================
  hr(),
  div(style = "background: #f0f9ff; padding: 20px; border-radius: 8px; margin: 20px 0;",
    h4("📦 Export Policy Configuration"),
    fluidRow(
      column(4,
        radioButtons("policy_kind", "Export which policy?", inline = TRUE,
                     choices = c("adaptive_gain", "dual_criterion", "time_on_task"), 
                     selected = "dual_criterion")
      ),
      column(4, 
        textInput("export_path", "Export path", value = "export/policy.json")
      ),
      column(4, 
        br(),
        downloadButton("download_policy", "Export policy JSON", class = "btn-primary")
      )
    )
  )
)

# ============================================================================
# SERVER
# ============================================================================

server <- function(input, output, session) {
  
  # ========================================================================
  # TAB 1: Adaptive Gain (Inverted-U) Plot
  # ========================================================================
  output$plot_gain <- renderPlot({
    x <- seq(0, 10, length.out = 200)
    perf <- adaptive_gain_perf(x, k = input$gain_k, scale = input$gain_scale)
    ggplot(data.frame(arousal = x, performance = perf),
           aes(arousal, performance)) +
      geom_line(linewidth = 1, color = "#1f9bb6") +
      labs(title = "Inverted-U intuition", 
           x = "Arousal", 
           y = "Performance (arb.)") +
      theme_minimal(base_size = 14)
  })
  
  # ========================================================================
  # TAB 2: Dual-Criterion (SDT) - Reactive Thresholds
  # ========================================================================
  thresholds <- reactive({
    sdt_dual_criterion(
      criterion_tightness = input$criterion_tightness,
      coupling            = input$coupling,
      hys_margin          = input$hys_margin,
      base_hl             = input$base_hl,
      base_lapse          = input$base_lapse,
      move_range          = input$move_range
    )
  })
  
  # SDT density plot
  output$plot_sdt_density <- renderPlot({
    th <- thresholds()
    df <- evidence_demo_distributions()
    ggplot(df, aes(x, fill = class, color = class)) +
      annotate("rect", xmin = th$lo_enter, xmax = th$hi_enter, ymin = -Inf, ymax = Inf,
               alpha = 0.06, fill = "#1f9bb6") +
      annotate("rect", xmin = th$lo_enter, xmax = th$lo_exit, ymin = -Inf, ymax = Inf,
               alpha = 0.06, fill = "#9ca3af") +
      annotate("rect", xmin = th$hi_exit,  xmax = th$hi_enter, ymin = -Inf, ymax = Inf,
               alpha = 0.06, fill = "#9ca3af") +
      geom_density(alpha = 0.18, linewidth = 0.6) +
      geom_vline(xintercept = c(th$lo_enter, th$hi_enter), linetype = 2, linewidth = 0.55) +
      geom_vline(xintercept = c(th$lo_exit,  th$hi_exit),  linetype = 3, linewidth = 0.55) +
      annotate("label", x = (th$lo_enter + th$hi_enter)/2, y = 0.10, label = "Decision: Normal",
               fill = "white", label.size = 0.2, size = 3.5) +
      annotate("text", x = th$hi_enter + 0.08, y = 0.06, hjust = 0, label = "→ HL enter",  size = 3.3) +
      annotate("text", x = th$hi_exit  + 0.08, y = 0.05, hjust = 0, label = "→ HL exit",   size = 3.3) +
      annotate("text", x = th$lo_enter - 0.08, y = 0.06, hjust = 1, label = "Lapse enter ←", size = 3.3) +
      annotate("text", x = th$lo_exit  - 0.08, y = 0.05, hjust = 1, label = "Lapse exit ←",  size = 3.3) +
      scale_color_manual(values = c("Lapse"="#6b7280", "Optimal/Normal"="#0ea5b7", "High-Load"="#bc3c29")) +
      scale_fill_manual(values  = c("Lapse"="#6b7280", "Optimal/Normal"="#0ea5b7", "High-Load"="#bc3c29")) +
      coord_cartesian(xlim = c(-4,4)) +
      labs(title = "Dual-Criterion (SDT) with Hysteresis",
           subtitle = sprintf("tightness=%.2f · coupling=%.2f · hysteresis=%.2f  |  enter:[%.2f, %.2f]  exit:[%.2f, %.2f]",
                              input$criterion_tightness, input$coupling, input$hys_margin,
                              th$lo_enter, th$hi_enter, th$lo_exit, th$hi_exit),
           x = "Evidence (signed index: Lapse ←   0   → High-Load)",
           y = "Density") +
      guides(color = "none", fill = "none") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none")
  })
  
  # SDT time-series plot
  output$plot_sdt_timeseries <- renderPlot({
    th <- thresholds()
    e  <- evidence_demo_timeseries()
    
    # Make sure we see at least one crossing; nudge slightly if needed
    hi_enter2 <- th$hi_enter; hi_exit2 <- th$hi_exit
    lo_enter2 <- th$lo_enter; lo_exit2 <- th$lo_exit
    need_nudge <- !(any(e > hi_enter2) || any(e < lo_enter2))
    if (need_nudge) {
      maxE <- max(e); minE <- min(e)
      if (!any(e > hi_enter2) && maxE > (hi_enter2 - 0.02)) {
        hi_enter2 <- max(hi_enter2 - 0.02, maxE - 0.03)
        hi_exit2  <- hi_enter2 - max(0.05, abs(th$hi_enter - th$hi_exit))
      }
      if (!any(e < lo_enter2) && minE < (lo_enter2 + 0.02)) {
        lo_enter2 <- min(lo_enter2 + 0.02, minE + 0.03)
        lo_exit2  <- lo_enter2 + max(0.05, abs(th$lo_exit - th$lo_enter))
      }
    }
    
    naive <- ifelse(e > hi_enter2, "HL", ifelse(e < lo_enter2, "Lapse", "Normal"))
    hys   <- sdt_classify_hysteresis(e, lo_enter2, lo_exit2, hi_enter2, hi_exit2)
    
    df_long <- rbind(
      data.frame(t = seq_along(e), evidence = e, state = naive, method = "Naive (top)",         y = e),
      data.frame(t = seq_along(e), evidence = e, state = hys,   method = "Hysteresis (bottom)", y = e - 0.06)
    )
    hlines <- data.frame(
      y = c(hi_enter2, hi_exit2, lo_enter2, lo_exit2),
      type = factor(c("Enter","Exit","Enter","Exit"), levels = c("Enter","Exit"))
    )
    
    ggplot(df_long, aes(t, y)) +
      geom_line(aes(y = evidence), linewidth = 0.45, color = "grey35", alpha = 0.7) +
      geom_hline(data = hlines, aes(yintercept = y, linetype = type),
                 linewidth = 0.45, color = "black", alpha = 0.75) +
      geom_point(aes(color = state, shape = method), size = 0.9, alpha = 0.95) +
      scale_color_manual(values = c("HL"="#bc3c29","Lapse"="#6b7280","Normal"="#0ea5b7")) +
      scale_shape_manual(values = c("Naive (top)" = 16, "Hysteresis (bottom)" = 17)) +
      scale_linetype_manual(values = c("Enter"=2, "Exit"=3)) +
      labs(title = "Hysteresis reduces edge-chatter",
           subtitle = if (need_nudge)
             "Shapes = method; dashed = enter, dotted = exit • Note: thresholds nudged slightly for visibility"
           else
             "Shapes = method; dashed = enter, dotted = exit thresholds",
           x = "Time", y = "Evidence",
           color = "State", shape = "Method", linetype = "Threshold") +
      theme_minimal(base_size = 14) +
      theme(
        legend.position   = "bottom",
        legend.box        = "horizontal",
        legend.key.size   = grid::unit(6, "pt"),
        legend.spacing.x  = grid::unit(4, "pt"),
        legend.spacing.y  = grid::unit(2, "pt"),
        legend.box.spacing= grid::unit(2, "pt"),
        legend.title      = element_text(size = 9),
        legend.text       = element_text(size = 8),
        plot.subtitle     = element_text(size = 10)
      ) +
      guides(
        color    = guide_legend(nrow = 1, byrow = TRUE, order = 1),
        shape    = guide_legend(nrow = 1, byrow = TRUE, order = 2),
        linetype = guide_legend(nrow = 1, byrow = TRUE, order = 3)
      )
  })
  
  # ========================================================================
  # TAB 3: Time-on-Task (Fatigue) Plot
  # ========================================================================
  output$plot_fatigue <- renderPlot({
    # optional physiology: CSV with columns RMSSD_pre, RMSSD_post, TEPR_pre, TEPR_post, Tremor_pre, Tremor_post
    phys <- NULL
    if (!is.null(input$phys_csv)) {
      dat <- tryCatch(read.csv(input$phys_csv$datapath), error = function(e) NULL)
      if (!is.null(dat)) {
        ok <- all(c("RMSSD_pre","RMSSD_post","TEPR_pre","TEPR_post","Tremor_pre","Tremor_post") %in% names(dat))
        if (ok) phys <- as.list(dat)
      }
    }
    
    t <- seq(0, 90, by = 0.25)
    thr <- time_on_task_threshold(
      t,
      c_start               = input$c_start,
      c_floor               = input$c_floor,
      onset_min             = input$onset_min,
      fatigue_half_life_min = input$fatigue_half_life_min,
      microbreak_min        = input$microbreak_min,
      microbreak_reset_fixed= input$microbreak_reset_fixed,
      microbreak_decay_min  = input$microbreak_decay_min,
      phys_opt              = phys
    )
    c_start <- input$c_start; c_floor <- input$c_floor
    onset_min <- input$onset_min; t_half <- onset_min + input$fatigue_half_life_min
    y_half <- (c_start + c_floor)/2
    
    df <- data.frame(mins = t, threshold = thr)
    ggplot(df, aes(mins, threshold)) +
      annotate("rect", xmin = -Inf, xmax = onset_min, ymin = -Inf, ymax = Inf,
               alpha = 0.05, fill = "grey60") +
      geom_hline(yintercept = c_start, linetype = "solid",  linewidth = 0.3) +
      geom_hline(yintercept = c_floor, linetype = "dotted", linewidth = 0.3) +
      geom_vline(xintercept = onset_min, linetype = 2, linewidth = 0.3) +
      { if (!is.na(input$microbreak_min)) geom_vline(xintercept = input$microbreak_min, linetype = 2, linewidth = 0.3) } +
      geom_line(linewidth = 0.85, color = "#1f9bb6") +
      geom_point(aes(x = t_half, y = y_half), size = 2, color = "red") +
      geom_segment(aes(x = t_half, xend = t_half, y = c_start, yend = y_half),
                   arrow = arrow(length = grid::unit(0.15, "cm")), linewidth = 0.3) +
      annotate("text", x = onset_min - 2, y = c_start + 0.006, hjust = 1,
               label = "Onset", size = 4) +
      { if (!is.na(input$microbreak_min))
          annotate("text", x = input$microbreak_min + 2, y = c_start - 0.01, hjust = 0,
                   label = "Microbreak", size = 4) } +
      annotate("text", x = t_half - 21, y = y_half - 0.025, hjust = 0,
               label = "Half-life → halfway to floor", size = 4) +
      annotate("text", x = max(t) - 5, y = c_floor + 0.005, hjust = 1,
               label = "Floor", size = 4) +
      annotate("text", x = 5, y = c_start + 0.005, hjust = 0,
               label = "Start", size = 4) +
      labs(
        title = "Time-on-Task (Fatigue-Adaptive): steady → relax → brief reset",
        subtitle = sprintf("Onset=%d min · Half-life=%d min · Microbreak=%s",
                           input$onset_min, input$fatigue_half_life_min,
                           ifelse(is.na(input$microbreak_min), "none", paste0(input$microbreak_min, " min"))),
        x = "Time on task (min)", y = "High-Load decision threshold"
      ) +
      theme_minimal(base_size = 14) + 
      theme(legend.position = "none")
  })
  
  # ========================================================================
  # Export Policy JSON (Downloadable)
  # ========================================================================
  output$download_policy <- downloadHandler(
    filename = function() basename(input$export_path),
    content = function(file) {
      policy <- switch(input$policy_kind,
        "adaptive_gain" = list(kind="adaptive_gain",
                               params=list(k=input$gain_k, scale=input$gain_scale)),
        "dual_criterion" = {
          th <- thresholds()
          list(kind="dual_criterion",
               params=list(
                 criterion_tightness=input$criterion_tightness,
                 coupling=input$coupling,
                 hys_margin=input$hys_margin,
                 base_hl=input$base_hl, base_lapse=input$base_lapse, move_range=input$move_range),
               thresholds=th)
        },
        "time_on_task" = list(kind="time_on_task",
               params=list(
                 c_start=input$c_start, c_floor=input$c_floor, onset_min=input$onset_min,
                 fatigue_half_life_min=input$fatigue_half_life_min,
                 microbreak_min=input$microbreak_min,
                 microbreak_reset_fixed=input$microbreak_reset_fixed,
                 microbreak_decay_min=input$microbreak_decay_min))
      )
      jsonlite::write_json(policy, file, auto_unbox = TRUE, pretty = TRUE)
    }
  )
}

# ============================================================================
# RUN APP
# ============================================================================

shinyApp(ui, server)