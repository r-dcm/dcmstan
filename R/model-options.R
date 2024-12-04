print_choices <- function(x, last = ", or ") {
  vec <- cli::cli_vec(x, style = list("vec-last" = last))
  txt <- cli::cli_fmt(cli::cli_text("{.val {vec}}"))
  txt
}

meas_choices <- function() {
  c("Loglinear cognitive diagnostic model (LCDM)" = "lcdm",
    "Deterministic input, noisy \"and\" gate (DINA)" = "dina",
    "Deterministic input, noisy \"or\" gate (DINO)" = "dino",
    "Compensatory reparameterized unified model (C-RUM)" = "crum",
    "Hierarchical diagnostic classification model" = "hdcm")
}

strc_choices <- function() {
  c("unconstrained", "independent", "hierarchical")
}
