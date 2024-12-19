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
  # make sure hierarchy is a string
  check_string(x)

  g <- glue::glue(" graph { <x> } ", .open = "<", .close = ">")
  g <- dagitty::dagitty(g)

  hierarchy <- glue::glue(" dag { <x> } ", .open = "<", .close = ">")
  hierarchy <- ggdag::tidy_dagitty(hierarchy)

  # make sure there is a clear starting point in the hierarchy
  ancestors <- tibble::tibble()

  for (jj in hierarchy |>
       tibble::as_tibble() |>
       dplyr::distinct(.data$name) |>
       dplyr::pull(.data$name)) {
    tmp <- dagitty::ancestors(g, jj) |>
      tibble::as_tibble() |>
      dplyr::filter(.data$value != jj) |>
      dplyr::mutate(param = jj) |>
      dplyr::rename(ancestors = "value") |>
      dplyr::select("param", "ancestors")

    tmp2 <- dagitty::spouses(g, jj) |>
      tibble::as_tibble() |>
      dplyr::filter(.data$value != jj) |>
      dplyr::mutate(param = jj) |>
      dplyr::rename(ancestors = "value") |>
      dplyr::select("param", "ancestors")

    ancestors <- dplyr::bind_rows(ancestors, tmp, tmp2)
  }

  no_ancestors <- hierarchy |>
    tibble::as_tibble() |>
    dplyr::select("name") |>
    dplyr::anti_join(ancestors, by = c("name" = "param")) |>
    dplyr::distinct(.data$name)

  if (nrow(no_ancestors) == 0) {
    rdcmchecks::abort_bad_argument(arg = arg,
                                   must = "be a hierarchical structure with a clear starting attribute",
                                   call = call)
  }

  # make sure there is a clear ending point in the hierarchy
  children <- tibble::tibble()

  for (jj in hierarchy |> tibble::as_tibble() |> dplyr::pull(.data$name)) {
    tmp <- dagitty::children(g, jj) |>
      tibble::as_tibble() |>
      dplyr::filter(.data$value != jj) |>
      dplyr::mutate(param = jj) |>
      dplyr::rename(children = "value") |>
      dplyr::select("param", "children")

    tmp2 <- dagitty::spouses(g, jj) |>
      tibble::as_tibble() |>
      dplyr::filter(.data$value != jj) |>
      dplyr::mutate(param = jj) |>
      dplyr::rename(children = "value") |>
      dplyr::select("param", "children")

    children <- dplyr::bind_rows(children, tmp, tmp2)
  }

  no_children <- hierarchy |>
    tibble::as_tibble() |>
    dplyr::select("name") |>
    dplyr::anti_join(children, by = c("name" = "param"))

  if (nrow(no_children) == 0) {
    rdcmchecks::abort_bad_argument(arg = arg,
                                   must = "be a hierarchical structure with a clear ending attribute",
                                   call = call)
  }

  x
}
