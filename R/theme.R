lab_theme <- function() {
  bslib::bs_theme(
    version = 5,
    base_font = bslib::font_google("Inter"),
    primary = "#1f9bb6",
    secondary = "#0b1526",
    info = "#1f9bb6",
    bg = "#f7f9fc",
    fg = "#0b1526"
  ) |>
    bslib::bs_add_rules("
      .help-icon{display:inline-flex;align-items:center;justify-content:center;
        width:0.85em;height:0.85em;border-radius:999px;border:1px solid #e5e7eb;
        color:#1f9bb6;font-size:0.65em;margin-left:0.15rem;cursor:help;
        vertical-align:super;position:relative;top:-0.1em}
      .help-icon:hover{background:#e6f6fb;border-color:#b7e1f0}
      .plot-condensed-legend .legend{margin-top:4px}
    ")
}

