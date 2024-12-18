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
