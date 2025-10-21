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
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#' @param item_names Vector of item names, as in the
#'   `qmatrix_meta$item_names` of a [DCM specification][dcm_specify()].
#' @param hierarchy Optional. If present, the quoted attribute hierarchy. See
#'   \code{vignette("dagitty4semusers", package = "dagitty")} for a tutorial on
#'   how to draw the attribute hierarchy.
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
lcdm_parameters <- function(
  qmatrix,
  identifier = NULL,
  max_interaction = Inf,
  att_names = NULL,
  item_names = NULL,
  hierarchy = NULL,
  rename_attributes = FALSE,
  rename_items = FALSE,
  allowable_params = FALSE
) {
  if (is.null(identifier)) {
    if (is.null(item_names)) {
      item_names <- rlang::set_names(
        seq_len(nrow(qmatrix)),
        as.character(seq_len(nrow(qmatrix)))
      )
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
    att_names <- paste0("att", seq_len(ncol(qmatrix) - 1)) |>
      rlang::set_names(att_names)
  }

  qmatrix <- qmatrix |>
    dplyr::select(-{{ identifier }}) |>
    dplyr::rename_with(
      ~ glue::glue("att{1:(ncol(qmatrix) - 1)}"),
      .cols = dplyr::everything()
    )

  all_params <- stats::model.matrix(
    stats::as.formula(paste0("~ .^", max(ncol(qmatrix), 2L))),
    qmatrix
  ) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    dplyr::select(dplyr::where(~ sum(.x) > 0)) |>
    tibble::rowid_to_column(var = "item_id") |>
    tidyr::pivot_longer(
      cols = -"item_id",
      names_to = "parameter",
      values_to = "value"
    ) |>
    dplyr::filter(.data$value == 1) |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~
          sapply(
            gregexpr(pattern = "__", text = .data$parameter),
            function(.x) length(attr(.x, "match.length"))
          ) +
          1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      coefficient = glue::glue(
        "l{item_id}_{param_level}",
        "{gsub(\"__\", \"\", atts)}"
      ),
      type = dplyr::case_when(
        .data$param_level == 0 ~ "intercept",
        .data$param_level == 1 ~ "maineffect",
        .data$param_level >= 2 ~ "interaction"
      ),
      attributes = dplyr::case_when(
        .data$param_level == 0 ~ NA_character_,
        .data$param_level >= 1 ~ .data$parameter
      )
    ) |>
    dplyr::filter(.data$param_level <= max_interaction) |>
    dplyr::select("item_id", "type", "attributes", "coefficient") |>
    dplyr::mutate(coefficient = as.character(.data$coefficient))

  if (!is.null(hierarchy) && max_interaction > 1) {
    filtered_hierarchy <- glue::glue("dag {{ {hierarchy} }}") |>
      ggdag::tidy_dagitty() |>
      tibble::as_tibble() |>
      dplyr::filter(!is.na(.data$direction)) |>
      dplyr::select("name", "direction", "to") |>
      dplyr::mutate(name = att_names[.data$name], to = att_names[.data$to])

    all_params <- filter_hierarchy(
      all_params,
      filtered_hierarchy = filtered_hierarchy
    )
  }

  if (!rename_attributes) {
    for (i in seq_along(att_names)) {
      all_params <- dplyr::mutate(
        all_params,
        attributes = gsub(
          paste0("att", i),
          names(att_names)[i],
          .data$attributes
        )
      )
    }
  }

  if (!rename_items) {
    all_params <- all_params |>
      dplyr::left_join(
        item_ids,
        by = dplyr::join_by("item_id" == "item_number")
      ) |>
      dplyr::select(
        {{ identifier }} := "dcmstan_real_item_id",
        dplyr::everything(),
        -"item_id"
      )
  }

  if (!is.null(hierarchy) && !allowable_params) {
    all_params <- rename_parameters(
      all_params,
      qmatrix,
      att_names,
      max_interaction,
      hierarchy,
      rename_attributes,
      rename_items
    )
  }

  all_params
}


#' Determine the possible parameters for a DINA or DINO model
#'
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @param item_names Vector of item names, as in the
#'   `qmatrix_meta$item_names` of a [DCM specification][dcm_specify()].
#' @param rename_items Logical. Should the output rename and number the items to
#'   have consistent and generic names (e.g., `1`, `2`; `TRUE`) or keep the
#'   original item names in the Q-matrix (`FALSE`, the default). If there are no
#'   identifiers in the Q-matrix, generic names are always used.
#'
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
dina_parameters <- function(
  qmatrix,
  identifier = NULL,
  item_names = NULL,
  rename_items = FALSE
) {
  if (is.null(identifier)) {
    if (is.null(item_names)) {
      item_names <- rlang::set_names(
        seq_len(nrow(qmatrix)),
        as.character(seq_len(nrow(qmatrix)))
      )
    }
    qmatrix <- qmatrix |>
      tibble::rowid_to_column(var = "item_id") |>
      dplyr::mutate(item_id = names(item_names)[.data$item_id])
    identifier <- "item_id"
  }
  item_ids <- qmatrix |>
    dplyr::select(dcmstan_real_item_id = {{ identifier }}) |>
    tibble::rowid_to_column(var = "item_number")

  all_params <- tidyr::expand_grid(
    item_id = seq_len(nrow(qmatrix)),
    type = c("slip", "guess")
  ) |>
    tibble::as_tibble() |>
    dplyr::mutate(coefficient = glue::glue("{.data$type}[{.data$item_id}]")) |>
    dplyr::arrange(.data$item_id) |>
    dplyr::mutate(coefficient = as.character(.data$coefficient))

  if (!rename_items) {
    all_params <- all_params |>
      dplyr::left_join(
        item_ids,
        by = dplyr::join_by("item_id" == "item_number")
      ) |>
      dplyr::select(
        {{ identifier }} := "dcmstan_real_item_id",
        dplyr::everything(),
        -"item_id"
      )
  }

  all_params
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
nida_parameters <- function(
  qmatrix,
  identifier = NULL,
  att_names = NULL,
  rename_attributes = FALSE
) {
  if (!is.null(identifier)) {
    qmatrix <- qmatrix |>
      dplyr::select(-{{ identifier }})
  }

  if (is.null(att_names)) {
    att_names <- paste0("att", seq_len(ncol(qmatrix))) |>
      rlang::set_names(colnames(qmatrix))
  } else if (is.null(names(att_names))) {
    att_names <- paste0("att", seq_len(ncol(qmatrix))) |>
      rlang::set_names(att_names)
  }

  all_params <- tibble::enframe(att_names) |>
    tidyr::expand_grid(type = c("slip", "guess")) |>
    dplyr::mutate(
      att_id = gsub("att", "", .data$value),
      coefficient = glue::glue("{.data$type}[{.data$att_id}]"),
      coefficient = as.character(.data$coefficient)
    ) |>
    dplyr::select(attribute = "value", "type", "coefficient")

  if (!rename_attributes) {
    for (i in seq_along(att_names)) {
      all_params <- dplyr::mutate(
        all_params,
        attribute = gsub(paste0("att", i), names(att_names)[i], .data$attribute)
      )
    }
  }

  all_params
}


#' Determine the possible parameters for a NIDO model
#'
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#' @param rename_attributes Logical. Should the output rename the attributes to
#'   have consistent and generic names (e.g., `att1`, `att2`; `TRUE`), or keep
#'   the original attributes names in the Q-matrix (`FALSE`, the default).
#'
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
nido_parameters <- function(
  qmatrix,
  identifier = NULL,
  att_names = NULL,
  rename_attributes = FALSE
) {
  if (!is.null(identifier)) {
    qmatrix <- qmatrix |>
      dplyr::select(-{{ identifier }})
  }

  if (is.null(att_names)) {
    att_names <- paste0("att", seq_len(ncol(qmatrix))) |>
      rlang::set_names(colnames(qmatrix))
  } else if (is.null(names(att_names))) {
    att_names <- paste0("att", seq_len(ncol(qmatrix))) |>
      rlang::set_names(att_names)
  }

  all_params <- tibble::enframe(att_names) |>
    tidyr::expand_grid(type = c("intercept", "maineffect")) |>
    dplyr::mutate(
      att_id = gsub("att", "", .data$value),
      level = dplyr::case_when(
        .data$type == "intercept" ~ 0L,
        .data$type == "maineffect" ~ 1L
      ),
      coefficient = glue::glue("l_{.data$level}{.data$att_id}"),
      coefficient = as.character(.data$coefficient)
    ) |>
    dplyr::select(attribute = "value", "type", "coefficient")

  if (!rename_attributes) {
    for (i in seq_along(att_names)) {
      all_params <- dplyr::mutate(
        all_params,
        attribute = gsub(paste0("att", i), names(att_names)[i], .data$attribute)
      )
    }
  }

  all_params
}


#' Determine the possible parameters for a NC-RUM model
#'
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#' @param item_names Vector of item names, as in the
#'   `qmatrix_meta$item_names` of a [DCM specification][dcm_specify()].
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
ncrum_parameters <- function(
  qmatrix,
  identifier = NULL,
  att_names = NULL,
  item_names = NULL,
  rename_attributes = FALSE,
  rename_items = FALSE
) {
  if (is.null(identifier)) {
    if (is.null(item_names)) {
      item_names <- rlang::set_names(
        seq_len(nrow(qmatrix)),
        as.character(seq_len(nrow(qmatrix)))
      )
    } else if (is.null(names(item_names))) {
      item_names <- rlang::set_names(seq_len(nrow(qmatrix)), item_names)
    }
    qmatrix <- qmatrix |>
      tibble::rowid_to_column(var = "item_id") |>
      dplyr::mutate(item_id = names(item_names)[.data$item_id])
    identifier <- "item_id"
  }
  item_ids <- qmatrix |>
    dplyr::select(dcmstan_real_item_id = {{ identifier }}) |>
    tibble::rowid_to_column(var = "item_number")
  qmatrix <- qmatrix |>
    dplyr::select(-{{ identifier }})

  if (is.null(att_names)) {
    att_names <- paste0("att", seq_len(ncol(qmatrix))) |>
      rlang::set_names(colnames(qmatrix))
  } else if (is.null(names(att_names))) {
    att_names <- paste0("att", seq_len(ncol(qmatrix))) |>
      rlang::set_names(att_names)
  }

  all_params <- qmatrix |>
    dplyr::rename_with(~att_names) |>
    tibble::rowid_to_column(var = "item_id") |>
    dplyr::mutate(baseline = 1L, .before = 2) |>
    tidyr::pivot_longer(
      cols = -"item_id",
      names_to = "attribute",
      values_to = "valid"
    ) |>
    dplyr::filter(.data$valid == 1L) |>
    dplyr::select(-"valid") |>
    dplyr::mutate(
      type = dplyr::case_when(
        .data$attribute == "baseline" ~ "baseline",
        .default = "penalty"
      ),
      attribute = dplyr::na_if(.data$attribute, "baseline"),
      att_id = gsub("att", "", .data$attribute),
      coefficient = dplyr::case_when(
        .data$type == "baseline" ~ glue::glue("pistar_{item_id}"),
        .data$type == "penalty" ~ glue::glue("rstar_{item_id}{att_id}")
      )
    ) |>
    dplyr::select("item_id", "type", "attribute", "coefficient")

  if (!rename_attributes) {
    for (i in seq_along(att_names)) {
      all_params <- dplyr::mutate(
        all_params,
        attribute = gsub(paste0("att", i), names(att_names)[i], .data$attribute)
      )
    }
  }

  if (!rename_items) {
    all_params <- all_params |>
      dplyr::left_join(
        item_ids,
        by = dplyr::join_by("item_id" == "item_number")
      ) |>
      dplyr::select(
        {{ identifier }} := "dcmstan_real_item_id",
        dplyr::everything(),
        -"item_id"
      )
  }

  all_params
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
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#' @param rename_attributes Logical. Should the output rename the attributes to
#'   have consistent and generic names (e.g., `att1`, `att2`; `TRUE`), or keep
#'   the original attributes names in the Q-matrix (`FALSE`, the default).
#'
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
loglinear_parameters <- function(
  qmatrix,
  identifier = NULL,
  max_interaction = Inf,
  att_names = NULL,
  rename_attributes = FALSE
) {
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
    att_names <- paste0("att", seq_len(ncol(qmatrix) - 1)) |>
      rlang::set_names(att_names)
  }

  qmatrix <- qmatrix |>
    dplyr::select(-{{ identifier }}) |>
    dplyr::rename_with(
      ~ glue::glue("att{1:(ncol(qmatrix) - 1)}"),
      .cols = dplyr::everything()
    )

  all_params <- stats::model.matrix(
    stats::as.formula(paste0("~ .^", max(ncol(qmatrix), 2L))),
    create_profiles(ncol(qmatrix))
  ) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    tibble::rowid_to_column(var = "profile_id") |>
    tidyr::pivot_longer(
      cols = -"profile_id",
      names_to = "parameter",
      values_to = "value"
    ) |>
    dplyr::filter(.data$parameter != "intercept") |>
    dplyr::filter(.data$value == 1) |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~
          sapply(
            gregexpr(pattern = "__", text = .data$parameter),
            function(.x) length(attr(.x, "match.length"))
          ) +
          1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      coefficient = glue::glue("g_{param_level}", "{gsub(\"__\", \"\", atts)}"),
      type = "structural",
      attributes = .data$parameter
    ) |>
    dplyr::filter(.data$param_level <= max_interaction) |>
    dplyr::select("profile_id", "type", "attributes", "coefficient") |>
    dplyr::mutate(coefficient = as.character(.data$coefficient))

  if (!rename_attributes) {
    for (i in seq_along(att_names)) {
      all_params <- dplyr::mutate(
        all_params,
        attributes = gsub(
          paste0("att", i),
          names(att_names)[i],
          .data$attributes
        )
      )
    }
  }

  all_params
}


#' Determine the possible parameters for a Bayesian network structural model
#'
#' @param imatrix An incidence matrix (structural version of a Q-matrix) that
#'   details the conditional dependence relationships between the attributes in
#'   structural model. Rows of the incidence matrix denote the child attributes
#'   and the columns denote the parent attributes.
#' @param identifier A character string identifying the column that contains
#'   item identifiers. If there is no identifier column, this should be `NULL`
#'   (the default).
#' @returns A [tibble][tibble::tibble-package] with all possible parameters.
#' @noRd
bayesnet_parameters <- function(
  qmatrix,
  identifier = NULL,
  hierarchy = NULL,
  att_names = NULL,
  rename_attributes = FALSE
) {
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

  if (is.null(hierarchy)) {
    hierarchy <- saturated_bn(att_names = att_names)
  }
  hierarchy <- replace_hierarchy_names(hierarchy, attribute_names = att_names)

  i_matrix <- calculate_imatrix(hierarchy)

  all_params <-
    stats::model.matrix(
      stats::as.formula(paste0("~ .^", max(ncol(i_matrix), 2L))),
      i_matrix
    ) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    tibble::rowid_to_column(var = "child_id") |>
    tidyr::pivot_longer(
      cols = -"child_id",
      names_to = "parameter",
      values_to = "value"
    ) |>
    dplyr::filter(.data$value == 1) |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~
          sapply(
            gregexpr(pattern = "__", text = .data$parameter),
            function(.x) length(attr(.x, "match.length"))
          ) +
          1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      coefficient = glue::glue(
        "g{child_id}_{param_level}",
        "{gsub(\"__\", \"\", atts)}"
      ),
      type = "structural",
      attributes = dplyr::case_when(
        .data$param_level == 0 ~ NA_character_,
        .data$param_level >= 1 ~ .data$parameter
      )
    ) |>
    dplyr::select("child_id", "type", "attributes", "coefficient") |>
    dplyr::mutate(coefficient = as.character(.data$coefficient))

  all_coef <- all_params |>
    dplyr::mutate(
      valid = dplyr::case_when(
        grepl("_0", .data$coefficient) ~ "0,1",
        .default = "1"
      ),
      all_coef = dplyr::case_when(
        grepl("_0", .data$coefficient) ~
          paste0("att", gsub("g([0-9]+)_0", "\\1", .data$coefficient)),
        .default = .data$attributes
      )
    ) |>
    tidyr::separate_longer_delim(cols = "valid", delim = ",") |>
    dplyr::mutate(valid = as.integer(.data$valid))

  profile_coef <- stats::model.matrix(
    stats::as.formula(paste0("~ .^", max(length(att_names), 2L))),
    create_profiles(length(att_names))
  ) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    tibble::rowid_to_column(var = "profile_id") |>
    dplyr::select(-"intercept") |>
    tidyr::pivot_longer(cols = -"profile_id") |>
    dplyr::left_join(
      all_coef,
      by = c("name" = "all_coef", "value" = "valid"),
      relationship = "many-to-many"
    ) |>
    dplyr::filter(!is.na(.data$coefficient)) |>
    dplyr::distinct(.data$profile_id, .data$coefficient)

  all_params <- all_params |>
    dplyr::left_join(profile_coef, by = "coefficient") |>
    dplyr::arrange(.data$profile_id) |>
    dplyr::select("profile_id", "type", "attributes", "coefficient") |>
    dplyr::mutate(
      type = dplyr::case_when(
        grepl("_0", .data$coefficient) ~ "structural_intercept",
        grepl("_1", .data$coefficient) ~ "structural_maineffect",
        .default = "structural_interaction"
      ),
      attributes = dplyr::case_when(
        grepl("_0", .data$coefficient) ~
          paste0("att", gsub("g([0-9]+)_0", "\\1", .data$coefficient)),
        .default = .data$attributes
      )
    )

  if (!rename_attributes) {
    for (i in seq_along(att_names)) {
      all_params <- dplyr::mutate(
        all_params,
        attributes = gsub(
          paste0("att", i),
          names(att_names)[i],
          .data$attributes
        )
      )
    }
  }

  all_params
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
#' @param all_params Parameters returned by `lcdm_parameters()`.
#' @param filtered_hierarchy A tibble, as returned by [ggdag::tidy_dagitty()].
#'
#' @returns A filtered `all_params` object.
#' @noRd
filter_hierarchy <- function(all_params, filtered_hierarchy) {
  graph_def <- filtered_hierarchy |>
    glue::glue_data("{name} {direction} {to}")
  g <- glue::glue(
    "graph {{ ",
    "{paste(graph_def, collapse = '\n')} ",
    "}}",
    .sep = "\n"
  ) |>
    dagitty::dagitty()

  all_params |>
    tidyr::nest(dat = -"item_id") |>
    dplyr::mutate(
      new_params = lapply(
        .data$dat,
        \(x, g, filtered_hierarchy) {
          if (nrow(x) == 2) {
            return(x)
          }

          item_atts <- x |>
            dplyr::filter(!is.na(attributes), !grepl("__", .data$attributes)) |>
            dplyr::select("attributes") |>
            dplyr::semi_join(
              filtered_hierarchy |>
                dplyr::select(-"direction") |>
                tidyr::pivot_longer(
                  cols = dplyr::everything(),
                  names_to = "type",
                  values_to = "attributes"
                ),
              by = c("attributes")
            ) |>
            dplyr::pull("attributes")

          for (aa in item_atts) {
            ancs <- dagitty::ancestors(g, aa) |>
              tibble::as_tibble() |>
              dplyr::filter(.data$value != aa, .data$value %in% item_atts) |>
              dplyr::pull("value")
            if (!length(ancs)) {
              next
            }

            for (bb in ancs) {
              x <- x |>
                dplyr::filter(
                  !(grepl(aa, .data$attributes) & !grepl(bb, .data$attributes))
                )
            }
          }

          x
        },
        g = g,
        filtered_hierarchy = filtered_hierarchy
      )
    ) |>
    dplyr::select(-"dat") |>
    tidyr::unnest("new_params")
}

#' Rename parameters to be consistent with the attribute hierarchy
#'
#' @param all_params Parameters returned by `lcdm_parameters()`.
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#' @param max_interaction For the LCDM, the highest level interaction that
#'   should be included in the model. For the C-RUM, this is always 1 (i.e.,
#'   main effects only).
#' @param hierarchy If present, the quoted attribute hierarchy. See
#'   \code{vignette("dagitty4semusers", package = "dagitty")} for a tutorial on
#'   how to draw the attribute hierarchy.
#' @param rename_attributes Logical. Should the output rename the attributes to
#'   have consistent and generic names (e.g., `att1`, `att2`; `TRUE`), or keep
#'   the original attributes names in the Q-matrix (`FALSE`, the default).
#' @param rename_items Logical. Should the output rename and number the items to
#'   have consistent and generic names (e.g., `1`, `2`; `TRUE`) or keep the
#'   original item names in the Q-matrix (`FALSE`, the default). If there are no
#'   identifiers in the Q-matrix, generic names are always used.
#'
#' @returns An `all_params` object where parameters are renamed according to
#' the attribute hierarhcy.
#' @noRd
rename_parameters <- function(
  all_params,
  qmatrix,
  att_names,
  max_interaction,
  hierarchy,
  rename_attributes,
  rename_items
) {
  meas_all <- create_profiles(ncol(qmatrix))[2^ncol(qmatrix), ]
  all_poss_params <- lcdm_parameters(
    qmatrix = meas_all,
    max_interaction = max_interaction,
    att_names = att_names,
    hierarchy = NULL,
    rename_attributes = rename_attributes,
    rename_items = rename_items
  ) |>
    dplyr::select("attributes", "coefficient")
  all_allowable_params <- lcdm_parameters(
    qmatrix = meas_all,
    max_interaction = max_interaction,
    att_names = att_names,
    hierarchy = hierarchy,
    rename_attributes = rename_attributes,
    rename_items = rename_items,
    allowable_params = TRUE
  ) |>
    dplyr::select("attributes", "coefficient")
  params_to_update <- all_poss_params |>
    dplyr::left_join(
      all_allowable_params |>
        dplyr::mutate(allowable = TRUE),
      by = c("attributes", "coefficient")
    ) |>
    dplyr::filter(is.na(.data$allowable)) |>
    dplyr::mutate(new_att = NA)
  good_params <- all_poss_params |>
    dplyr::left_join(
      all_allowable_params |>
        dplyr::mutate(allowable = TRUE),
      by = c("attributes", "coefficient")
    ) |>
    dplyr::filter(!is.na(.data$allowable))

  for (ii in seq_len(nrow(params_to_update))) {
    tmp_att <- params_to_update$attributes[ii]
    tmp_att <- strsplit(tmp_att, "__")[[1]]
    tmp_att <- paste0(tmp_att, collapse = ".*")

    tmp_replacement <- good_params |>
      dplyr::filter(grepl(tmp_att, .data$attributes)) |>
      tidyr::separate(
        col = "coefficient",
        into = c("item_param", "coefficient"),
        sep = "_"
      )

    params_to_update$coefficient[ii] <- tmp_replacement$coefficient[1]
    params_to_update$allowable[ii] <- TRUE
    params_to_update$new_att[ii] <- tmp_replacement$attributes[1]
  }

  stan_att_dict <- all_poss_params |>
    dplyr::left_join(
      params_to_update |>
        dplyr::rename("new_coef" = "coefficient") |>
        dplyr::select(-"allowable"),
      by = c("attributes")
    ) |>
    tidyr::separate(
      col = "coefficient",
      into = c("item_param", "coefficient"),
      sep = "_"
    ) |>
    dplyr::select(-"item_param") |>
    dplyr::mutate(
      coefficient = dplyr::case_when(
        is.na(.data$new_coef) ~ .data$coefficient,
        !is.na(.data$new_coef) ~ .data$new_coef
      )
    ) |>
    dplyr::select(-"new_coef")

  all_params |>
    tidyr::separate(
      col = "coefficient",
      into = c("item_param", "old_coef"),
      sep = "_"
    ) |>
    dplyr::left_join(stan_att_dict, by = c("attributes")) |>
    dplyr::mutate(
      coefficient = paste0("l", .data$item_id, "_", .data$coefficient),
      attributes = dplyr::case_when(
        !is.na(.data$new_att) ~ .data$new_att,
        TRUE ~ .data$attributes
      )
    ) |>
    dplyr::select("item_id", "type", "attributes", "coefficient") |>
    dplyr::mutate(
      type = dplyr::case_when(
        grepl("_0", .data$coefficient) ~ "intercept",
        grepl("_1", .data$coefficient) ~ "maineffect",
        TRUE ~ "interaction"
      )
    )
}
