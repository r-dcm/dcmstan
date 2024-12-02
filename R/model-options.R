print_choices <- function(x, last = ", or ") {
  vec <- cli::cli_vec(x, style = list("vec-last" = last))
  txt <- cli::cli_fmt(cli::cli_text("{.val {vec}}"))
  txt
}

meas_choices <- function() {
  c("lcdm", "dina", "dino", "crum")
}

strc_choices <- function() {
  c("unconstrained", "independent")
}
