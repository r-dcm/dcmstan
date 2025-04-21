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
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @rdname lcdm-crum
#' @noRd
meas_lcdm <- function(qmatrix, max_interaction = Inf, priors,
                      hierarchy = NULL, att_labels) {
  # parameters block -----
  all_params <- lcdm_parameters(qmatrix = qmatrix,
                                max_interaction = max_interaction,
                                rename_attributes = TRUE,
                                rename_items = TRUE)

  if (!is.null(hierarchy)) {
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
        dplyr::filter(.data$value != jj) |>
        dplyr::mutate(param = tmp_jj) |>
        dplyr::rename(ancestors = "value") |>
        dplyr::select("param", "ancestors") |>
        dplyr::left_join(att_labels, by = c("ancestors" = "att_label")) |>
        dplyr::select("param", ancestors = "att")

      ancestors <- dplyr::bind_rows(ancestors, tmp)
    }

    nested_params <- ancestors |>
      dplyr::group_by(.data$param) |>
      dplyr::mutate(base_param = gsub("att", "", .data$param),
                    param_num = dplyr::row_number(),
                    int_level = dplyr::row_number(),
                    int_level = max(.data$int_level) + 1,
                    ancestors = gsub("att", "", .data$ancestors)) |>
      dplyr::ungroup() |>
      tidyr::pivot_wider(names_from = "param_num", values_from = "ancestors") |>
      dplyr::select("param", "int_level", "base_param", dplyr::everything()) |>
      tidyr::unite(col = "param_spec", -c("param"), sep = "", na.rm = TRUE)

    int_labels <- ancestors |>
      dplyr::group_by(.data$param) |>
      dplyr::mutate(param_num = dplyr::row_number()) |>
      dplyr::ungroup() |>
      tidyr::pivot_wider(names_from = "param_num", values_from = "ancestors") |>
      tidyr::unite(col = "int_label", dplyr::everything(), sep = "__",
                   na.rm = TRUE, remove = FALSE) |>
      dplyr::select("param", "int_label")

    all_params <- all_params |>
      dplyr::filter(.data$type != "interaction") |>
      dplyr::left_join(nested_params, by = c("attributes" = "param")) |>
      dplyr::mutate(param_spec = paste0("l", .data$item_id, "_",
                                        .data$param_spec),
                    coefficient = dplyr::case_when(is.na(.data$param_spec) ~
                                                     .data$coefficient,
                                                   !is.na(.data$param_spec) ~
                                                     .data$param_spec),
                    type = dplyr::case_when(is.na(.data$param_spec) ~
                                              .data$type,
                                            !is.na(.data$param_spec) ~
                                              "interaction")) |>
      dplyr::select(-"param_spec") |>
      dplyr::left_join(int_labels, by = c("attributes" = "param")) |>
      dplyr::mutate(attributes = dplyr::case_when(.data$type == "interaction" &
                                                    !is.na(.data$int_label) ~
                                                    .data$int_label,
                                                  TRUE ~ .data$attributes)) |>
      dplyr::select(-"int_label")
  }

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
      comp_atts = one_down_params(.data$atts, item = .data$item_id),
      param_name = glue::glue("l{item_id}_{param_level}",
                              "{gsub(\"__\", \"\", atts)}"),
      constraint = dplyr::case_when(
        .data$param_level == 0 ~ glue::glue(""),
        .data$param_level == 1 ~ glue::glue("<lower=0>"),
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
meas_crum <- function(qmatrix, priors, hierarchy = NULL) {
  meas_lcdm(qmatrix, max_interaction = 1L, priors = priors,
            hierarchy = hierarchy)
}
