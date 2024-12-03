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

  att_names <- colnames(qmatrix[,-which(colnames(qmatrix) == identifier)])
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


# Other utilities --------------------------------------------------------------
model_matrix_name_repair <- function(x) {
  x <- gsub("\\(|\\)", "", x)
  x <- gsub(":", "__", x)
  x <- tolower(x)

  return(x)
}
