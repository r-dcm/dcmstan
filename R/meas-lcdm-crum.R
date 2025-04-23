#' 'Stan' code for the LCDM and C-RUM models
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for the LCDM and C-RUM models. The function also returns the code that
#' defines the prior distributions for each parameter, which is used in the
#' `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#' @param max_interaction The highest item-level interaction to include in the
#'   model.
#' @param hierarchy Optional. If present, the quoted attribute hierarchy. See
#'   \code{vignette("dagitty4semusers", package = "dagitty")} for a tutorial on
#'   how to draw the attribute hierarchy.
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @rdname lcdm-crum
#' @noRd
meas_lcdm <- function(qmatrix, priors, att_names = NULL, max_interaction = Inf,
                      hierarchy = NULL) {
  # parameters block -----
  all_params <- lcdm_parameters(qmatrix = qmatrix,
                                max_interaction = max_interaction,
                                att_names = att_names,
                                hierarchy = hierarchy,
                                rename_attributes = TRUE,
                                rename_items = TRUE)

  meas_params <- all_params |>
    dplyr::mutate(parameter = dplyr::case_when(is.na(.data$attributes) ~
                                                 "intercept",
                                               TRUE ~ .data$attributes)) |>
    dplyr::select("item_id", "parameter", param_name = "coefficient") |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~ sapply(gregexpr(pattern = "__", text = .data$parameter),
                      function(.x) length(attr(.x, "match.length"))) + 1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      comp_atts = mapply(
        one_down_params, .data$atts, .data$item_id,
        MoreArgs = list(possible_params = all_params$coefficient)
      ),
      param_name = glue::glue("l{item_id}_{param_level}",
                              "{gsub(\"__\", \"\", atts)}"),
      constraint = dplyr::case_when(
        .data$param_level == 0 ~ glue::glue(""),
        .data$param_level == 1 ~ glue::glue("<lower=0>"),
        .data$param_level >= 2 & !is.null(hierarchy) ~ glue::glue("<lower=0>"),
        .data$param_level >= 2 ~ glue::glue("<lower=-1 * min([{comp_atts}])>")
      ),
      param_def = dplyr::case_when(
        .data$param_level == 0 ~ glue::glue("real {param_name};"),
        .data$param_level >= 1 ~ glue::glue("real{constraint} {param_name};")
      )
    ) |>
    dplyr::filter(.data$param_level <= max_interaction)

  intercepts <- meas_params |>
    dplyr::filter(.data$param_level == 0) |>
    dplyr::pull(.data$param_def)
  main_effects <- meas_params |>
    dplyr::filter(.data$param_level == 1) |>
    dplyr::pull(.data$param_def)
  interactions <- meas_params |>
    dplyr::filter(.data$param_level >= 2) |>
    dplyr::arrange(.data$item_id, .data$param_name) |>
    dplyr::pull(.data$param_def)

  interaction_stan <- if (length(interactions) > 0) {
    glue::glue(
      "",
      "",
      "  ////////////////////////////////// item interactions",
      "  {glue::glue_collapse(interactions, sep = \"\n  \")}",
      .sep = "\n", .trim = FALSE
    )
  } else {
    ""
  }

  parameters_block <- glue::glue(
    "  ////////////////////////////////// item intercepts",
    "  {glue::glue_collapse(intercepts, sep = \"\n  \")}",
    "",
    "  ////////////////////////////////// item main effects",
    "  {glue::glue_collapse(main_effects, sep = \"\n  \")}{interaction_stan}",
    .sep = "\n", .trim = FALSE
  )

  # transformed parameters block -----
  all_profiles <- create_profiles(ncol(qmatrix))

  profile_params <-
    stats::model.matrix(stats::as.formula(paste0("~ .^",
                                                 max(ncol(all_profiles),
                                                     2L))),
                        all_profiles) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    tibble::rowid_to_column(var = "profile_id") |>
    tidyr::pivot_longer(-"profile_id", names_to = "parameter",
                        values_to = "valid_for_profile")

  pi_def <- tidyr::expand_grid(item_id = unique(meas_params$item_id),
                               profile_id = seq_len(nrow(all_profiles))) |>
    dplyr::left_join(dplyr::select(meas_params, "item_id", "parameter",
                                   "param_name"),
                     by = "item_id",
                     multiple = "all", relationship = "many-to-many") |>
    dplyr::left_join(profile_params, by = c("profile_id", "parameter"),
                     relationship = "many-to-one") |>
    dplyr::filter(.data$valid_for_profile == 1) |>
    dplyr::group_by(.data$item_id, .data$profile_id) |>
    dplyr::arrange(.data$item_id, .data$profile_id, .data$param_name) |>
    dplyr::summarize(meas_params = paste(unique(.data$param_name),
                                         collapse = "+"),
                     .groups = "drop") |>
    glue::glue_data("pi[{item_id},{profile_id}] = inv_logit({meas_params});")

  transformed_parameters_block <- glue::glue(
    "  matrix[I,C] pi;",
    "",
    "  ////////////////////////////////// probability of correct response",
    "  {glue::glue_collapse(pi_def, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # priors -----
  item_priors <- meas_params |>
    dplyr::mutate(
      type = dplyr::case_when(.data$param_level == 0 ~ "intercept",
                              .data$param_level == 1 ~ "maineffect",
                              .data$param_level > 1 ~ "interaction")
    ) |>
    dplyr::arrange(.data$item_id, .data$param_name) |>
    dplyr::left_join(prior_tibble(priors),
                     by = c("type", "param_name" = "coefficient"),
                     relationship = "one-to-one") |>
    dplyr::rename(coef_def = "prior") |>
    dplyr::left_join(prior_tibble(priors) |>
                       dplyr::filter(is.na(.data$coefficient)) |>
                       dplyr::select(-"coefficient"),
                     by = c("type"), relationship = "many-to-one") |>
    dplyr::rename(type_def = "prior") |>
    dplyr::mutate(
      prior = dplyr::case_when(!is.na(.data$coef_def) ~ .data$coef_def,
                               is.na(.data$coef_def) ~ .data$type_def),
      prior_def = glue::glue("{param_name} ~ {prior};")
    ) |>
    dplyr::pull("prior_def")

  # return -----
  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = item_priors))
}

#' @rdname lcdm-crum
#' @noRd
meas_crum <- function(qmatrix, priors, att_names = NULL, hierarchy = NULL) {
  meas_lcdm(qmatrix, max_interaction = 1L, priors = priors,
            hierarchy = hierarchy)
}
