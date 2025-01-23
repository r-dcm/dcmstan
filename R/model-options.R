#' Choices for model specifications
#'
#' @returns A named character vector.
#' @rdname model-choices
#' @noRd
meas_choices <- function() {
  c("loglinear cognitive diagnostic model (LCDM)" = "lcdm",
    "deterministic input, noisy \"and\" gate (DINA)" = "dina",
    "deterministic input, noisy \"or\" gate (DINO)" = "dino",
    "compensatory reparameterized unified model (C-RUM)" = "crum")
}

#' @rdname model-choices
#' @noRd
strc_choices <- function() {
  c("unconstrained" = "unconstrained",
    "independent attributes" = "independent",
    "loglinear attribute space" = "loglinear")
}


#' Combine multiple words into a single string
#'
#' @param x A character vector.
#' @param last A string specifying how the last two elements of the vector
#'   should be separated.
#'
#' @returns A string.
#' @noRd
print_choices <- function(x, sep = ", ", last = ", or ", format = FALSE) {
  txt <- if (format) {
    cli::cli_fmt(
      cli::cli_text(
        "{.val {cli::cli_vec(x, style = list('vec-last' = last,
                                             'vec-sep' = sep))}}"
      )
    )
  } else {
    cli::cli_fmt(
      cli::cli_text(
        "{cli::cli_vec(x, style = list('vec-last' = last, 'vec-sep' = sep))}"
      )
    )
  }
  txt
}
