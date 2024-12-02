deparse_no_string <- function(x) {
  if (!is.character(x)) {
    x <- deparse_combine(x)
  }
  x
}

deparse_combine <- function(x, max_char = NULL) {
  out <- paste(deparse(x), sep = "", collapse = "")
  if (isTRUE(max_char > 0)) {
    out <- substr(out, 1L, max_char)
  }
  out
}
