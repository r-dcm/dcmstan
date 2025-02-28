#' Create a dictionary with the attribute names from the Q-matrix and generic
#' attribute names
#'
#' @param qmatrix An item-by-attribute matrix specifying the attributes measured
#' by each item.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#'
#' @returns A tibble.
#' @noRd
get_att_labels <- function(qmatrix, identifier = NULL) {
  if (is.null(identifier)) {
    att_labels <- qmatrix |>
      tidyr::pivot_longer(cols = dplyr::everything(), names_to = "att_label",
                          values_to = "meas") |>
      dplyr::distinct(.data$att_label) |>
      tibble::rowid_to_column("att") |>
      dplyr::mutate(att = stringr::str_c("att", as.character(.data$att)))
  } else {
    att_labels <- qmatrix |>
      dplyr::select(-!!identifier) |>
      tidyr::pivot_longer(cols = dplyr::everything(), names_to = "att_label",
                          values_to = "meas") |>
      dplyr::distinct(.data$att_label) |>
      tibble::rowid_to_column("att") |>
      dplyr::mutate(att = stringr::str_c("att", as.character(.data$att)))
  }

  return(att_labels)
}

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

  if (nrow(bidirectional_flag) > 0 | cycle_flag) {
    rdcmchecks::abort_bad_argument(arg = arg,
                                   must = "not be cyclical",
                                   call = call)
  }

  x
}
