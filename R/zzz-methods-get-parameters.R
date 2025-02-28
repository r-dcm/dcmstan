#' Identify parameters included in a diagnostic classification model
#'
#' When specifying prior distributions, it is often useful to see which
#' parameters are included in a given model. Using the Q-matrix and type of
#' diagnostic model to estimated, we can create a list of all included
#' parameters for which a prior can be specified.
#'
#' @inheritParams dcm_specify
#' @param x A model specification (e.g., [dcm_specify()], measurement model
#'   (e.g., [lcdm()]), or structural model (e.g., [unconstrained()]) object.
#' @param ... Additional arguments passed to methods.
#'
#' @return A [tibble][tibble::tibble-package] showing the available parameter
#'   types and coefficients for a specified model.
#' @export
#'
#' @examples
#' qmatrix <- tibble::tibble(item = paste0("item_", 1:10),
#'                           att1 = sample(0:1, size = 10, replace = TRUE),
#'                           att2 = sample(0:1, size = 10, replace = TRUE),
#'                           att3 = sample(0:1, size = 10, replace = TRUE),
#'                           att4 = sample(0:1, size = 10, replace = TRUE))
#' get_parameters(dina(), qmatrix = qmatrix, identifier = "item")
get_parameters <- S7::new_generic("get_parameters", "x",
                                  function(x, qmatrix, ..., identifier = NULL) {
                                    check_string(identifier, allow_null = TRUE)
                                    S7::S7_dispatch()
                                  })

# Method for DCM specification -------------------------------------------------
S7::method(get_parameters, dcm_specification) <- function(x, qmatrix,
                                                          identifier = NULL) {
  if (lifecycle::is_present(qmatrix) || !is.null(identifier)) {
    arg <- rlang::caller_arg(x)
    cli::cli_warn(
      glue::glue("{{.arg qmatrix}} and {{.arg identifier}} should not be
                 specified for {{.cls dcm_specification}} objects. Using",
                 "{{.code {arg}@qmatrix}} instead.",
                 .sep = " ")
    )
  }

  dplyr::bind_rows(
    get_parameters(x@measurement_model, qmatrix = x@qmatrix),
    get_parameters(x@structural_model, qmatrix = x@qmatrix)
  )
}

# Methods for measurement models -----------------------------------------------
S7::method(get_parameters, LCDM) <- function(x, qmatrix, identifier = NULL) {
  check_number_whole(x@model_args$max_interaction, min = 1,
                     allow_infinite = TRUE)
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

  lcdm_parameters(qmatrix = qmatrix, identifier = identifier,
                  max_interaction = x@model_args$max_interaction)
}

S7::method(get_parameters, DINA) <- function(x, qmatrix, identifier = NULL) {
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

  dina_parameters(qmatrix = qmatrix, identifier = identifier)
}

S7::method(get_parameters, DINO) <- function(x, qmatrix, identifier = NULL) {
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

  dina_parameters(qmatrix = qmatrix, identifier = identifier)
}

S7::method(get_parameters, CRUM) <- function(x, qmatrix, identifier = NULL) {
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

  lcdm_parameters(qmatrix = qmatrix, identifier = identifier,
                  max_interaction = 1L)
}

# Methods for structural models ------------------------------------------------
S7::method(get_parameters, UNCONSTRAINED) <- function(x, qmatrix,
                                                      identifier = NULL) {
  tibble::tibble(type = "structural", coefficient = "Vc")
}

S7::method(get_parameters, INDEPENDENT) <- function(x, qmatrix,
                                                    identifier = NULL) {
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)
  att_names <- if (is.null(identifier)) {
    colnames(qmatrix)
  } else {
    colnames(qmatrix[, -which(colnames(qmatrix) == identifier)])
  }
  tibble::tibble(type = "structural",
                 attributes = att_names,
                 coefficient = paste0("eta[", seq_along(att_names), "]"))
}

S7::method(get_parameters, BAYESNET) <- function(x, qmatrix,
                                                  identifier = NULL) {
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)
  hierarchy = x@model_args$hierarchy
  att_labels = x@model_args$att_labels
  if(is.null(hierarchy)) {
    temp_hierarchy <- tidyr::expand_grid(param = att_labels$att,
                                         parent = att_labels$att) |>
      tibble::as_tibble() |>
      dplyr::mutate(param_id = stringr::str_remove(.data$param, "att"),
                    param_id = as.integer(param_id),
                    parent_id = stringr::str_remove(.data$parent, "att"),
                    parent_id = as.integer(parent_id)) |>
      dplyr::filter(parent_id > param_id) |>
      dplyr::select("param", "parent") |>
      dplyr::left_join(att_labels, by = c("parent" = "att")) |>
      dplyr::select(-"parent") |>
      dplyr::rename(parent = att_label) |>
      dplyr::left_join(att_labels, by = c("param" = "att")) |>
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

  ancestors <- tibble::tibble()
  for (jj in hierarchy |> tibble::as_tibble() |> dplyr::pull(.data$name)) {
    tmp_jj <- att_labels |>
      dplyr::filter(.data$att_label == jj) |>
      dplyr::pull(.data$att)

    tmp <- dagitty::ancestors(g, jj) |>
      tibble::as_tibble() |>
      dplyr::mutate(param = tmp_jj) |>
      dplyr::rename(ancestor = "value") |>
      dplyr::select("param", "ancestor") |>
      dplyr::left_join(att_labels, by = c("ancestor" = "att_label")) |>
      dplyr::select("param", ancestor = "att")

    ancestors <- dplyr::bind_rows(ancestors, tmp) |>
      dplyr::distinct()
  }

  imatrix <- ancestors |>
    dplyr::mutate(meas = dplyr::case_when(param == ancestor ~ 0L,
                                          TRUE ~ 1L)) |>
    dplyr::arrange(param) |>
    tidyr::pivot_wider(names_from = "ancestor", values_from = "meas") |>
    dplyr::mutate(dplyr::across(dplyr::starts_with("att"),
                                ~tidyr::replace_na(., 0L)))

  bayesnet_parameters(imatrix = imatrix, identifier = "param")

}
