#' Checks the validity of the hierarchy
#'
#' @param x A character string containing the quoted attribute hierarchy.
#'
#' @returns A string.
#' @noRd
check_hierarchy <- function(x, arg = rlang::caller_arg(x),
                            call = rlang::caller_env()) {
  check_string(x)

  g <- glue::glue(" graph { <x> } ", .open = "<", .close = ">")
  g <- dagitty::dagitty(g)

  hierarchy <- glue::glue(" dag { <x> } ", .open = "<", .close = ">")
  hierarchy <- ggdag::tidy_dagitty(hierarchy)

  cycle_flag <- !dagitty::isAcyclic(g)

  bidirectional_flag <- hierarchy |>
    tibble::as_tibble() |>
    dplyr::filter(.data$direction == "<->")

  if (nrow(bidirectional_flag) > 0 || cycle_flag) {
    rdcmchecks::abort_bad_argument(arg = arg,
                                   must = "not be cyclical",
                                   call = call)
  }

  invisible(NULL)
}
