#' 'Stan' code for a Bayesian network structural model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for a log-linear structural model. The function also returns the code that
#' defines the prior distributions for each parameter, which is used in the
#' `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param hierarchy
#' @param att_labels
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @noRd
strc_bayesnet <- function(qmatrix, priors, hierarchy = NULL, att_labels) {

  if(is.null(hierarchy)) {

    ## saturated hierarchy
    temp_hierarchy <- expand.grid(param = att_labels$att,
                                  parent = att_labels$att,
                                  stringsAsFactors = FALSE) |>
      tibble::as_tibble() |>
      dplyr::mutate(param_id = stringr::str_remove(.data$param, "att"),
                    param_id = as.integer(param_id),
                    parent_id = stringr::str_remove(.data$parent, "att"),
                    parent_id = as.integer(parent_id)) |>
      dplyr::filter(parent_id > param_id) |>
      dplyr::select("param", "parent") |>
      left_join(att_labels, by = c("parent" = "att")) |>
      dplyr::select(-"parent") |>
      dplyr::rename(parent = att_label) |>
      left_join(att_labels, by = c("param" = "att")) |>
      dplyr::select(-"param") |>
      dplyr::rename(param = att_label) |>
      dplyr::select("param", "parent")

    hierarchy <- temp_hierarchy |>
      dplyr::mutate(edge = paste(param, "->", parent)) |>
      dplyr::select(edge) |>
      dplyr::summarize(hierarchy = paste(edge, collapse = "  ")) |>
      dplyr::pull(.data$hierarchy)

  }


  g <- glue::glue(" graph { <hierarchy> } ", .open = "<", .close = ">")
  g <- dagitty::dagitty(g)

  hierarchy <- glue::glue(" dag { <hierarchy> } ", .open = "<", .close = ">")
  hierarchy <- ggdag::tidy_dagitty(hierarchy)


  parents <- tibble::tibble()
  ancestors <- tibble::tibble()

  for (jj in hierarchy |> tibble::as_tibble() |> dplyr::pull(.data$name)) {
    tmp_jj <- att_labels |>
      dplyr::filter(.data$att_label == jj) |>
      dplyr::pull(.data$att)

    tmp <- dagitty::ancestors(g, jj) |>
      tibble::as_tibble() |>
      dplyr::mutate(param = tmp_jj) |>
      dplyr::rename(ancestors = "value") |>
      dplyr::select("param", "ancestors") |>
      dplyr::left_join(att_labels, by = c("ancestors" = "att_label")) |>
      dplyr::select("param", ancestors = "att")

    ancestors <- dplyr::bind_rows(ancestors, tmp)

    tmp2 <- dagitty::parents(g, jj) |>
      tibble::as_tibble() |>
      dplyr::mutate(param = tmp_jj) |>
      dplyr::rename(parents = "value") |>
      dplyr::select("param", "parents") |>
      dplyr::left_join(att_labels, by = c("parents" = "att_label")) |>
      dplyr::select("param", parents = "att")

    parents <- dplyr::bind_rows(parents, tmp2)
  }






}
