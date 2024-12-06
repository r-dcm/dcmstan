print_choices <- function(x, last = ", or ") {
  txt <- cli::cli_fmt(
    cli::cli_text("{.val {cli::cli_vec(x, style = list('vec-last' = last))}}")
  )
  txt
}

meas_choices <- function() {
  c("Loglinear cognitive diagnostic model (LCDM)" = "lcdm",
    "Deterministic input, noisy \"and\" gate (DINA)" = "dina",
    "Deterministic input, noisy \"or\" gate (DINO)" = "dino",
    "Compensatory reparameterized unified model (C-RUM)" = "crum")
}

strc_choices <- function() {
  c("Unconstrained" = "unconstrained",
    "Independent attributes" = "independent")
}
