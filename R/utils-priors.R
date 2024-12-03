deparse_no_string <- function(x) {
  if (!is.character(x)) {
    x <- paste(deparse(x), sep = "", collapse = "")
  }
  x
}
