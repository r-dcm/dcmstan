#' 'Stan' code for a Bayesian network structural model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for a bayesian network structural model. The function also returns the code
#' that defines the prior distributions for each parameter, which is used in
#' the `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#' @param hierarchy A character string containing the quoted attribute
#'   hierarchy.
#' @param att_labels A named vector of attribute names. Should come from the
#'   model specification (e.g., `spec@qmatrix_meta$attribute_names`).
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @noRd
strc_bayesnet <- function(qmatrix, priors, att_names = NULL, hierarchy = NULL) {
  # parameters block -----
  all_params <- bayesnet_parameters(
    qmatrix = qmatrix,
    att_names = att_names,
    hierarchy = hierarchy,
    rename_attributes = TRUE
  )

  strc_params <- all_params |>
    dplyr::mutate(
      child_id = gsub("g([0-9]+)_[0-9]+", "\\1", .data$coefficient),
      param_level = dplyr::case_when(
        .data$type == "structural_intercept" ~ 0,
        !grepl("__", .data$attributes) ~ 1,
        TRUE ~
          sapply(
            gregexpr(pattern = "__", text = .data$attributes),
            function(.x) length(attr(.x, "match.length"))
          ) +
          1 # nolint
      ),
      atts = gsub("[^0-9|_]", "", .data$attributes),
      comp_atts = mapply(
        one_down_params,
        x = .data$atts,
        item = .data$child_id
      ),
      comp_atts = gsub("l", "g", .data$comp_atts),
      atts = dplyr::case_when(
        .data$param_level == 0 ~ "",
        .default = .data$atts
      ),
      param_name = glue::glue(
        "g{child_id}_{param_level}",
        "{gsub(\"__\", \"\", atts)}"
      ),
      constraint = dplyr::case_when(
        .data$param_level == 0 ~ glue::glue(""),
        .data$param_level == 1 ~ glue::glue("<lower=0>"),
        .data$param_level >= 2 ~ glue::glue("<lower=-1 * min([{comp_atts}])>")
      ),
      param_def = dplyr::case_when(
        .data$param_level == 0 ~ glue::glue("real {param_name};"),
        .data$param_level >= 1 ~ glue::glue("real{constraint} {param_name};")
      )
    )

  intercepts <- strc_params |> #nolint
    dplyr::filter(.data$param_level == 0) |>
    dplyr::select("param_def") |>
    dplyr::distinct() |>
    dplyr::pull(.data$param_def)
  main_effects <- strc_params |> #nolint
    dplyr::filter(.data$param_level == 1) |>
    dplyr::select("param_def") |>
    dplyr::distinct() |>
    dplyr::pull(.data$param_def)
  interactions <- strc_params |> #nolint
    dplyr::filter(.data$param_level >= 2) |>
    dplyr::select("param_def") |>
    dplyr::distinct() |>
    dplyr::pull(.data$param_def)

  interaction_stan <- if (length(interactions) > 0) {
    glue::glue(
      "",
      "  ////////////////////////////////// structural interactions",
      "  {glue::glue_collapse(interactions, sep = \"\n  \")}",
      .sep = "\n",
      .trim = FALSE
    )
  } else {
    ""
  }

  parameters_block <- glue::glue(
    #nolint
    "  ////////////////////////////////// structural intercepts",
    "  {glue::glue_collapse(intercepts, sep = \"\n  \")}",
    "",
    "  ////////////////////////////////// structural main effects",
    "  {glue::glue_collapse(main_effects, sep = \"\n  \")}",
    "{interaction_stan}",
    .sep = "\n",
    .trim = FALSE
  )

  # transformed parameters block -----
  vc_def <- strc_params |>
    dplyr::summarize(
      child_term = paste0(
        "inv_logit(",
        paste(.data$coefficient, collapse = " + "),
        ")"
      ),
      .by = c("profile_id", "child_id")
    ) |>
    dplyr::left_join(
      create_profiles(length(att_names)) |>
        tibble::rowid_to_column(var = "profile_id") |>
        tidyr::pivot_longer(cols = -"profile_id") |>
        dplyr::mutate(name = gsub("att", "", .data$name)),
      by = c("profile_id", "child_id" = "name"),
      relationship = "one-to-one"
    ) |>
    dplyr::mutate(
      comp_term = dplyr::case_when(
        .data$value == 0 ~ paste0("(1 - ", .data$child_term, ")"),
        .data$value == 1 ~ .data$child_term
      )
    ) |>
    dplyr::summarize(
      vc_def = paste(.data$comp_term, collapse = " * "),
      .by = "profile_id"
    ) |>
    glue::glue_data("Vc[{profile_id}] = {vc_def};")

  transformed_parameters_block <- glue::glue(
    "  simplex[C] Vc;",
    "  vector[C] log_Vc;",
    "",
    "  ////////////////////////////////// class membership probabilities",
    "  {glue::glue_collapse(vc_def, sep = \"\n  \")}",
    "",
    "  log_Vc = log(Vc);",
    .sep = "\n",
    .trim = FALSE
  )

  strc_priors <- strc_params |>
    dplyr::distinct(.data$type, .data$coefficient) |>
    dplyr::left_join(
      prior_tibble(priors),
      by = c("type", "coefficient"),
      relationship = "one-to-one"
    ) |>
    dplyr::rename(coef_def = "prior") |>
    dplyr::left_join(
      prior_tibble(priors) |>
        dplyr::filter(is.na(.data$coefficient)) |>
        dplyr::select(-"coefficient"),
      by = "type",
      relationship = "many-to-one"
    ) |>
    dplyr::rename(type_def = "prior") |>
    dplyr::mutate(
      prior = dplyr::case_when(
        !is.na(.data$coef_def) ~ .data$coef_def,
        is.na(.data$coef_def) ~ .data$type_def
      ),
      prior_def = glue::glue("{coefficient} ~ {prior};")
    ) |>
    dplyr::pull("prior_def")

  # return -----
  list(
    parameters = parameters_block,
    transformed_parameters = transformed_parameters_block,
    priors = strc_priors
  )
}
