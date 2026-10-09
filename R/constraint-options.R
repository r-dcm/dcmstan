#' Choices for constraint specifications
#'
#' @returns A named character vector.
#' @rdname constraint-choices
#' @noRd
cnst_choices <- function() {
  c(
    "no constraints" = "none",
    "posterior-space constraints"  = "posterior"
  )
}
