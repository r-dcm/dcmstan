#' Deparse a function call as a character string
#'
#' @param x A character string or call to be converted to a character string.
#'
#' @returns A string.
#' @noRd
deparse_no_string <- function(x) {
  if (!is.character(x)) {
    x <- paste(deparse(x), sep = "", collapse = "")
  }
  x
}
