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
                            att_names = NULL, item_names = NULL,
                            hierarchy = NULL,
                            rename_attributes = FALSE, rename_items = FALSE) {
  if (is.null(identifier)) {
    if (is.null(item_names)) {
      item_names <- rlang::set_names(seq_len(nrow(qmatrix)),
                                     as.character(seq_len(nrow(qmatrix))))
    }
    qmatrix <- qmatrix |>
      tibble::rowid_to_column(var = "item_id") |>
      dplyr::mutate(item_id = names(item_names)[.data$item_id])
    identifier <- "item_id"
  }
  item_ids <- qmatrix |>
    dplyr::select(dcmstan_real_item_id = {{ identifier }}) |>
    tibble::rowid_to_column(var = "item_number")

  if (is.null(att_names)) {
    att_names <- paste0("att", seq_len(ncol(qmatrix) - 1)) |>
      rlang::set_names(
        colnames(qmatrix[, -which(colnames(qmatrix) == identifier)])
      )
  } else if (is.null(names(att_names))) {
    att_names <- rlang::set_names(att_names, att_names)
  }

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

  if (!is.null(hierarchy)) {
    filtered_hierarchy <- glue::glue("dag {{ {hierarchy} }}") |>
      ggdag::tidy_dagitty() |>
      tibble::as_tibble() |>
      dplyr::filter(!is.na(.data$direction)) |>
      dplyr::select("name", "direction", "to") |>
      dplyr::mutate(name = att_names[.data$name],
                    to = att_names[.data$to])

    all_params <- filter_hierarchy(all_params,
                                   filtered_hierarchy = filtered_hierarchy)
  }

  if (!rename_attributes) {
    for (i in seq_along(att_names)) {
      all_params <- dplyr::mutate(all_params,
                                  attributes = gsub(paste0("att", i),
                                                    names(att_names)[i],
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
dina_parameters <- function(qmatrix, identifier = NULL, item_names = NULL,
                            rename_items = FALSE) {
  if (is.null(identifier)) {
    if (is.null(item_names)) {
      item_names <- rlang::set_names(seq_len(nrow(qmatrix)),
                                     as.character(seq_len(nrow(qmatrix))))
    }
    qmatrix <- qmatrix |>
      tibble::rowid_to_column(var = "item_id") |>
      dplyr::mutate(item_id = names(item_names)[.data$item_id])
    identifier <- "item_id"
  }
  item_ids <- qmatrix |>
    dplyr::select(dcmstan_real_item_id = {{ identifier }}) |>
    tibble::rowid_to_column(var = "item_number")

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


#' Determine the possible parameters for a NIDA model
#'
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @param rename_attributes Logical. Should the output rename the attributes to
#'   have consistent and generic names (e.g., `att1`, `att2`; `TRUE`), or keep
#'   the original attributes names in the Q-matrix (`FALSE`, the default).
#'
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
nida_parameters <- function(qmatrix, identifier = NULL,
                            rename_attributes = FALSE) {
  if (!is.null(identifier)) {
    qmatrix <- qmatrix |>
      dplyr::select(-{{ identifier }})
  }

  attribute_ids <- tibble::tibble(dcmstan_real_att_id = colnames(qmatrix)) |>
    tibble::rowid_to_column(var = "att_number")

  all_params <- expand.grid(att_id = seq_len(ncol(qmatrix)),
                            type = c("slip", "guess"),
                            stringsAsFactors = FALSE) |>
    tibble::as_tibble() |>
    dplyr::mutate(coefficient = glue::glue("{.data$type}[{.data$att_id}]")) |>
    dplyr::arrange(.data$att_id, .data$type) |>
    dplyr::mutate(coefficient = as.character(.data$coefficient))

  if (!rename_attributes) {
    all_params <- all_params |>
      dplyr::left_join(attribute_ids,
                       by = dplyr::join_by("att_id" == "att_number")) |>
      dplyr::mutate(att_id = .data$dcmstan_real_att_id) |>
      dplyr::select(-"dcmstan_real_att_id")
  }

  return(all_params)
}


#' Determine the possible parameters for a NIDO model
#'
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @param rename_attributes Logical. Should the output rename the attributes to
#'   have consistent and generic names (e.g., `att1`, `att2`; `TRUE`), or keep
#'   the original attributes names in the Q-matrix (`FALSE`, the default).
#'
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
nido_parameters <- function(qmatrix, identifier = NULL,
                            rename_attributes = FALSE) {
  if (!is.null(identifier)) {
    qmatrix <- qmatrix |>
      dplyr::select(-{{ identifier }})
  }

  att_id <- seq_len(ncol(qmatrix))

  attribute_ids <- tibble::tibble(dcmstan_real_att_id = colnames(qmatrix)) |>
    tibble::rowid_to_column(var = "att_number")

  all_params <- tidyr::crossing(att_id = att_id,
                                type = c("beta", "gamma")) |>
    dplyr::mutate(coefficient = dplyr::case_when(.data$type == "beta" ~
                                                   glue::glue("beta{att_id}"),
                                                 .data$type == "gamma" ~
                                                   glue::glue("gamma{att_id}")))

  if (!rename_attributes) {
    all_params <- all_params |>
      dplyr::left_join(attribute_ids,
                       by = dplyr::join_by("att_id" == "att_number")) |>
      dplyr::mutate(att_id = .data$dcmstan_real_att_id) |>
      dplyr::select(-"dcmstan_real_att_id")
  }

  return(all_params)
}

#' Determine the possible parameters for a Log-linear structural model
#'
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @param max_interaction Positive integer. For the Log-linear structural
#' model, the highest structural-level interaction to include in the model.
#' @param rename_attributes Logical. Should the output rename the attributes to
#'   have consistent and generic names (e.g., `att1`, `att2`; `TRUE`), or keep
#'   the original attributes names in the Q-matrix (`FALSE`, the default).
#'
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
loglinear_parameters <- function(qmatrix, identifier = NULL,
                                 max_interaction = Inf,
                                 att_names = NULL,
                                 rename_attributes = FALSE) {
  if (is.null(identifier)) {
    qmatrix <- qmatrix |>
      tibble::rowid_to_column(var = "item_id")
    identifier <- "item_id"
  }

  if (is.null(att_names)) {
    att_names <- paste0("att", seq_len(ncol(qmatrix) - 1)) |>
      rlang::set_names(
        colnames(qmatrix[, -which(colnames(qmatrix) == identifier)])
      )
  } else if (is.null(names(att_names))) {
    att_names <- rlang::set_names(att_names, att_names)
  }

  qmatrix <- qmatrix |>
    dplyr::select(-{{ identifier }}) |>
    dplyr::rename_with(~glue::glue("att{1:(ncol(qmatrix) - 1)}"),
                       .cols = dplyr::everything())

  all_params <- stats::model.matrix(
    stats::as.formula(paste0("~ .^", max(ncol(qmatrix), 2L))),
    create_profiles(ncol(qmatrix))
  ) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    tibble::rowid_to_column(var = "profile_id") |>
    tidyr::pivot_longer(cols = -"profile_id", names_to = "parameter",
                        values_to = "value") |>
    dplyr::filter(.data$parameter != "intercept") |>
    dplyr::filter(.data$value == 1) |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~ sapply(gregexpr(pattern = "__", text = .data$parameter),
                      function(.x) length(attr(.x, "match.length"))) + 1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      coefficient = glue::glue("g_{param_level}",
                               "{gsub(\"__\", \"\", atts)}"),
      type = "structural",
      attributes = .data$parameter
    ) |>
    dplyr::filter(.data$param_level <= max_interaction) |>
    dplyr::select("profile_id", "type", "attributes", "coefficient") |>
    dplyr::mutate(coefficient = as.character(.data$coefficient))

  if (!rename_attributes) {
    for (i in seq_along(att_names)) {
      all_params <- dplyr::mutate(all_params,
                                  attributes = gsub(paste0("att", i),
                                                    names(att_names)[i],
                                                    .data$attributes))
    }
  }

  return(all_params)
}

#' Determine the possible parameters for a NC-RUM model
#'
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
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
ncrum_parameters <- function(qmatrix, identifier = NULL,
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

  qmatrix <- qmatrix |>
    dplyr::select(-{{ identifier }})

  attribute_ids <- tibble::tibble(dcmstan_real_att_id = colnames(qmatrix)) |>
    tibble::rowid_to_column(var = "att_number") |>
    dplyr::mutate(att_name = paste0("att", .data$att_number))

  colnames(qmatrix) <- attribute_ids$att_name

  attribute_ids <- attribute_ids |>
    dplyr::select(-"att_name")

  measured_att <- qmatrix |>
    tibble::rowid_to_column("item_id") |>
    tidyr::pivot_longer(cols = -c("item_id"), names_to = "att_id",
                        values_to = "meas") |>
    dplyr::mutate(att_id = as.numeric(sub("att", "", .data$att_id)))

  all_params <- expand.grid(item_id = seq_len(nrow(qmatrix)),
                            att_id = seq_len(ncol(qmatrix)),
                            type = c("slip", "penalty"),
                            stringsAsFactors = FALSE) |>
    tibble::as_tibble() |>
    dplyr::mutate(coefficient = glue::glue(
      "{.data$type}_{.data$item_id}_{.data$att_id}"
    )) |>
    dplyr::arrange(.data$item_id, .data$att_id, .data$type) |>
    dplyr::mutate(coefficient = as.character(.data$coefficient)) |>
    dplyr::left_join(measured_att, by = c("item_id", "att_id")) |>
    dplyr::filter(.data$meas == 1) |>
    dplyr::select(-"meas")

  if (!rename_attributes) {
    all_params <- all_params |>
      dplyr::left_join(attribute_ids,
                       by = dplyr::join_by("att_id" == "att_number")) |>
      dplyr::mutate(att_id = .data$dcmstan_real_att_id) |>
      dplyr::select(-"dcmstan_real_att_id")
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


#' Filter out nested parameters from the LCDM
#'
#' @param all_params Parameters returned by [lcdm_parameters()].
#' @param filtered_hierarchy A tibble, as returned by [ggdag::tidy_dagitty()].
#'
#' @returns A filtered `all_params` object.
#' @noRd
filter_hierarchy <- function(all_params, filtered_hierarchy) {
  graph_def <- filtered_hierarchy |>
    glue::glue_data("{name} {direction} {to}", )
  g <- glue::glue("graph {{ ",
                  "{paste(graph_def, collapse = '\n')} ",
                  "}}", .sep = "\n") |>
    dagitty::dagitty()

  all_params |>
    tidyr::nest(dat = -"item_id") |>
    dplyr::mutate(
      new_params = lapply(
        .data$dat,
        \(x, g) {
          if (nrow(x) == 2) return(x)

          item_atts <- x |>
            dplyr::filter(!is.na(attributes),
                          !grepl("__", .data$attributes)) |>
            dplyr::pull("attributes")

          for (aa in item_atts) {
            ancs <- dagitty::ancestors(g, aa) |>
              tibble::as_tibble() |>
              dplyr::filter(.data$value != aa,
                            .data$value %in% item_atts) |>
              dplyr::pull("value")
            if (!length(ancs)) next

            for (bb in ancs) {
              x <- x |>
                dplyr::filter(!(grepl(aa, .data$attributes) &
                                  !grepl(bb, .data$attributes)))
            }
          }

          x
        },
        g = g
      )
    ) |>
    dplyr::select(-"dat") |>
    tidyr::unnest("new_params")
}
