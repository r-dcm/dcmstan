#' Determine the possible parameters for an LCDM or C-RUM model
#'
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @param max_interaction For the LCDM, the highest level interaction that
#'   should be included in the model. For the C-RUM, this is always 1 (i.e.,
#'   main effects only).
#' @param rename_attributes Logical. Should the output rename the attributes to
#'   have consistent and generic names (e.g., `att1`, `att2`; `TRUE`), or keep
#'   the original attributes names in the Q-matrix (`FALSE`, the default).
#' @param rename_items Logical. Should the output rename and number the items to
#'   have consistent and generic names (e.g., `1`, `2`; `TRUE`) or keep the
#'   original item names in the Q-matrix (`FALSE`, the default). If there are no
#'   identifiers in the Q-matrix, generic names are always used.
#'
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
lcdm_parameters <- function(qmatrix, identifier = NULL, max_interaction = Inf,
                            rename_attributes = FALSE, rename_items = FALSE) {
  if (is.null(identifier)) {
    qmatrix <- qmatrix |>
      tibble::rowid_to_column(var = "item_id")
    identifier <- "item_id"

    item_ids <- qmatrix |>
      dplyr::select(dcmstan_real_item_id = {{ identifier }}) |>
      tibble::rowid_to_column(var = "item_number")
  } else {
    item_ids <- qmatrix |>
      dplyr::select(dcmstan_real_item_id = {{ identifier }}) |>
      tibble::rowid_to_column(var = "item_number")
  }

  att_names <- colnames(qmatrix[, -which(colnames(qmatrix) == identifier)])
  qmatrix <- qmatrix |>
    dplyr::select(-{{ identifier }}) |>
    dplyr::rename_with(~glue::glue("att{1:(ncol(qmatrix) - 1)}"),
                       .cols = dplyr::everything())

  all_params <- stats::model.matrix(
    stats::as.formula(paste0("~ .^", max(ncol(qmatrix), 2L))),
    qmatrix
  ) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    dplyr::select(dplyr::where(~ sum(.x) > 0)) |>
    tibble::rowid_to_column(var = "item_id") |>
    tidyr::pivot_longer(cols = -"item_id", names_to = "parameter",
                        values_to = "value") |>
    dplyr::filter(.data$value == 1) |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~ sapply(gregexpr(pattern = "__", text = .data$parameter),
                      function(.x) length(attr(.x, "match.length"))) + 1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      coefficient = glue::glue("l{item_id}_{param_level}",
                               "{gsub(\"__\", \"\", atts)}"),
      type = dplyr::case_when(.data$param_level == 0 ~ "intercept",
                              .data$param_level == 1 ~ "maineffect",
                              .data$param_level >= 2 ~ "interaction"),
      attributes = dplyr::case_when(.data$param_level == 0 ~ NA_character_,
                                    .data$param_level >= 1 ~ .data$parameter)
    ) |>
    dplyr::filter(.data$param_level <= max_interaction) |>
    dplyr::select("item_id", "type", "attributes", "coefficient") |>
    dplyr::mutate(coefficient = as.character(.data$coefficient))

  if (!rename_attributes) {
    for (i in seq_along(att_names)) {
      all_params <- dplyr::mutate(all_params,
                                  attributes = gsub(paste0("att", i),
                                                    att_names[i],
                                                    .data$attributes))
    }
  }

  if (!rename_items) {
    all_params <- all_params |>
      dplyr::left_join(item_ids,
                       by = dplyr::join_by("item_id" == "item_number")) |>
      dplyr::select({{ identifier }} := "dcmstan_real_item_id",
                    dplyr::everything(),
                    -"item_id")
  }

  return(all_params)
}


#' Determine the possible parameters for a DINA or DINO model
#'
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @param rename_items Logical. Should the output rename and number the items to
#'   have consistent and generic names (e.g., `1`, `2`; `TRUE`) or keep the
#'   original item names in the Q-matrix (`FALSE`, the default). If there are no
#'   identifiers in the Q-matrix, generic names are always used.
#'
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
dina_parameters <- function(qmatrix, identifier = NULL, rename_items = FALSE) {
  if (is.null(identifier)) {
    qmatrix <- qmatrix |>
      tibble::rowid_to_column(var = "item_id")
    identifier <- "item_id"

    item_ids <- qmatrix |>
      dplyr::select(dcmstan_real_item_id = {{ identifier }}) |>
      tibble::rowid_to_column(var = "item_number")
  } else {
    item_ids <- qmatrix |>
      dplyr::select(dcmstan_real_item_id = {{ identifier }}) |>
      tibble::rowid_to_column(var = "item_number")
  }

  all_params <- expand.grid(item_id = seq_len(nrow(qmatrix)),
                            type = c("slip", "guess"),
                            stringsAsFactors = FALSE) |>
    tibble::as_tibble() |>
    dplyr::mutate(coefficient = glue::glue("{.data$type}[{.data$item_id}]")) |>
    dplyr::arrange(.data$item_id, .data$type) |>
    dplyr::mutate(coefficient = as.character(.data$coefficient))

  if (!rename_items) {
    all_params <- all_params |>
      dplyr::left_join(item_ids,
                       by = dplyr::join_by("item_id" == "item_number")) |>
      dplyr::select({{ identifier }} := "dcmstan_real_item_id",
                    dplyr::everything(),
                    -"item_id")
  }

  return(all_params)
}


#' Determine the possible parameters for a Bayesian network structural model
#'
#' @param imatrix An incidence matrix (structural version of a Q-matrix) that
#'  details the conditional dependence relationships between the attributes in
#'  structural model. Rows of the incidence matrix denote the child attributes
#'  and the columns denote the parent attributes.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
bayesnet_parameters <- function(imatrix, identifier = NULL) {
  if (is.null(identifier)) {
    imatrix <- imatrix |>
      tibble::rowid_to_column(var = "param_id")
    identifier <- "param_id"

    child_ids <- imatrix |>
      dplyr::select(dcmstan_real_param_id = {{ identifier }}) |>
      tibble::rowid_to_column(var = "param_number")
  } else {
    child_ids <- imatrix |>
      dplyr::select(dcmstan_real_child_id = {{ identifier }}) |>
      tibble::rowid_to_column(var = "param_number")
  }

  imatrix <- imatrix |>
    dplyr::select(-{{ identifier }})

  all_params <- stats::model.matrix(
    stats::as.formula(paste0("~ .^",
                             max(ncol(imatrix), 2L))),
    imatrix) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    tibble::rowid_to_column(var = "param_id") |>
    dplyr::select("param_id", dplyr::everything()) |>
    tidyr::pivot_longer(cols = -"param_id", names_to = "parameter",
                        values_to = "value") |>
    dplyr::filter(.data$value == 1) |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~ sapply(gregexpr(pattern = "__", text = .data$parameter),
                      function(.x) length(attr(.x, "match.length"))) + 1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      coefficient = glue::glue("g{param_id}_{param_level}",
                               "{gsub(\"__\", \"\", atts)}"),
      type = "structural",
      attributes = .data$parameter
    ) |>
    dplyr::select("param_id", "type", "attributes", "coefficient") |>
    dplyr::mutate(coefficient = as.character(.data$coefficient))

  return(all_params)

}


# Other utilities --------------------------------------------------------------
#' Consistent naming for model matrix output
#'
#' @param x A character vector of column names.
#'
#' @returns A cleaned vector of column names.
#' @noRd
model_matrix_name_repair <- function(x) {
  x <- gsub("\\(|\\)", "", x)
  x <- gsub(":", "__", x)
  x <- tolower(x)

  x
}
