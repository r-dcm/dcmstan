#' 'Stan' code for a Bayesian network structural model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for a bayesian network structural model. The function also returns the code that
#' defines the prior distributions for each parameter, which is used in the
#' `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#' @param hierarchy A character string containing the quoted attribute hierarchy.
#' @param att_labels A named vector of attribute names. Should come from the
#'   model specification (e.g., `spec@qmatrix_meta$attribute_names`).
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @noRd
strc_bayesnet <- function(qmatrix, priors, att_names = NULL, hierarchy = NULL) {
  # parameters block -----
  all_params <- bayesnet_parameters(qmatrix = qmatrix,
                                    att_names = att_names,
                                    hierarchy = hierarchy,
                                    rename_attributes = TRUE)

  strc_params <- all_params |>
    dplyr::mutate(
      parameter = dplyr::case_when(is.na(.data$attributes) ~
                                     "intercept",
                                   TRUE ~ .data$attributes)
    ) |>
    dplyr::mutate(
      param = paste0("att", child_id),
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~ sapply(gregexpr(pattern = "__", text = .data$parameter),
                      function(.x) length(attr(.x, "match.length"))) + 1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      comp_atts = one_down_params(.data$atts, item = .data$child_id),
      comp_atts = stringr::str_replace_all(comp_atts, "l", "g"),
      param_name = glue::glue("g{child_id}_{param_level}",
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
    )

  intercepts <- strc_params |>
    dplyr::filter(.data$param_level == 0) |>
    dplyr::select("param_def") |>
    dplyr::distinct() |>
    dplyr::pull(.data$param_def)
  main_effects <- strc_params |>
    dplyr::filter(.data$param_level == 1) |>
    dplyr::select("param_def") |>
    dplyr::distinct() |>
    dplyr::pull(.data$param_def)
  interactions <- strc_params |>
    dplyr::filter(.data$param_level >= 2) |>
    dplyr::select("param_def") |>
    dplyr::distinct() |>
    dplyr::pull(.data$param_def)

  interaction_stan <- if (length(interactions) > 0) {
    glue::glue(
      "",
      "  ////////////////////////////////// structural interactions",
      "  {glue::glue_collapse(interactions, sep = \"\n  \")}",
      .sep = "\n", .trim = FALSE
    )
  } else {
    ""
  }

  parameters_block <- glue::glue(
    "  ////////////////////////////////// structural intercepts",
    "  {glue::glue_collapse(intercepts, sep = \"\n  \")}",
    "  ////////////////////////////////// structural main effects",
    "  {glue::glue_collapse(main_effects, sep = \"\n  \")}",
    "{interaction_stan}",
    .sep = "\n", .trim = FALSE
  )


  # transformed parameters block -----
  all_profiles <- create_profiles(length(att_names))

  all_profile_attributes <- tibble::tibble(profile_id = 1:nrow(all_profiles)) |>
    dplyr::left_join(
      all_profiles |>
        tibble::rowid_to_column("profile_id") |>
        tidyr::pivot_longer(cols = -c("profile_id"),
                            names_to = "param", values_to = "valid_for_profile") |>
        dplyr::filter(valid_for_profile == 1) |>
        dplyr::mutate(param_id = stringr::str_remove(param, "att")) |>
        dplyr::summarize(profile_atts = paste(param_id, collapse = "__"),
                         profile_attributes = paste(param, collapse = "__"),
                         .by = "profile_id"),
      by = c("profile_id")
    ) |>
    dplyr::mutate(profile_atts = dplyr::case_when(profile_id == 1L ~ "",
                                                  TRUE ~ profile_atts),
                  profile_attributes = dplyr::case_when(profile_id == 1L ~ "",
                                                        TRUE ~ profile_attributes))

  tmp_rho_def <- tibble::tibble()

  for (jj in parents |> dplyr::distinct(param) |> dplyr::pull(.data$param)) {

    parents_jj <- parents |>
      dplyr::filter(.data$param == jj) |>
      dplyr::arrange(parent) |>
      dplyr::select("parent") |>
      dplyr::distinct()

    strc_params_jj <- strc_params |>
      dplyr::filter(.data$param == jj) |>
      dplyr::select("child_id","parameter", "param_name")

    if(nrow(parents_jj) == 1 && is.na(parents_jj$parent)) {
      parents_jj_params <-
        tibble::tibble(profile_id = 1L,
                       parameter = "intercept",
                       valid_for_profile = 1)

      parents_jj_attributes <-
        tibble::tibble(param_id = stringr::str_remove(jj, "att"),
                       profile_id = 1L,
                       parent_profile_id = 1L,
                       parent_atts = "",
                       parent_attributes = "") |>
        dplyr::mutate(param_id = as.integer(param_id))
    } else {
      parent_profiles <- create_profiles(attributes = nrow(parents_jj)) |>
        stats::setNames(parents_jj |> dplyr::pull(.data$parent))

      parents_jj_params <-
        stats::model.matrix(stats::as.formula(paste0("~ .^",
                                                     max(ncol(parent_profiles),
                                                         2L))),
                            parent_profiles) |>
        tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
        tibble::rowid_to_column(var = "profile_id") |>
        tidyr::pivot_longer(-"profile_id", names_to = "parameter",
                            values_to = "valid_for_profile")

      parents_jj_attributes <- parent_profiles |>
        tibble::rowid_to_column("profile_id") |>
        tidyr::pivot_longer(cols = -c("profile_id"),
                            names_to = "param", values_to = "valid_for_profile") |>
        dplyr::filter(valid_for_profile == 1) |>
        dplyr::mutate(param_id = stringr::str_remove(param, "att")) |>
        dplyr::summarize(parent_atts = paste(param_id, collapse = "__"),
                         parent_attributes = paste(param, collapse = "__"),
                         .by = "profile_id") |>
        dplyr::rename(parent_profile_id = profile_id) |>
        dplyr::left_join(all_profile_attributes,
                         by = c("parent_atts" = "profile_atts",
                                "parent_attributes" = "profile_attributes")) |>
        dplyr::add_row(profile_id = 1L, parent_profile_id = 1L,
                       parent_atts = "", parent_attributes = "") |>
        dplyr::arrange(profile_id) |>
        dplyr::mutate(param_id = stringr::str_remove(jj, "att")) |>
        dplyr::mutate(param_id = as.integer(param_id)) |>
        dplyr::select("child_id", "profile_id", dplyr::everything())
    }

    tmp <- parents_jj_attributes |>
      dplyr::left_join(parents_jj_params |>
                         dplyr::left_join(strc_params_jj, by = c("parameter"),
                                          relationship = "many-to-many") |>
                         dplyr::filter(valid_for_profile == 1) |>
                         dplyr::select("param_id", "profile_id" = "profile_id",
                                       "param_name") |>
                         dplyr::distinct() |>
                         dplyr::mutate(strc_params = paste(param_name,
                                                           collapse = "+"),
                                       .by = c("param_id", "profile_id")) |>
                         dplyr::select(-"param_name") |>
                         dplyr::rename(parent_profile_id = profile_id) |>
                         dplyr::distinct(),
                       by = c("param_id", "parent_profile_id"))

    tmp_rho_def <- dplyr::bind_rows(tmp_rho_def, tmp)

  }

  rho_def <- tmp_rho_def |>
    dplyr::arrange(param_id) |>
    glue::glue_data("rho[{param_id},{profile_id}] = inv_logit({strc_params});")

  profile_params <- all_profiles |>
    tibble::rowid_to_column("profile_id") |>
    tidyr::pivot_longer(cols = -c("profile_id"),
                        names_to = "param", values_to = "master")

  Vc_def <- tidyr::expand_grid(Vc_profile_id = seq_len(nrow(all_profiles)),
                               param = att_labels$att) |>
    dplyr::left_join(profile_params,
                     by = c("Vc_profile_id" = "profile_id", "param")) |>
    dplyr::rename(param_master = master) |>
    dplyr::left_join(parents,
                     by = c("param"),
                     relationship = "many-to-many") |>
    dplyr::mutate(parent = dplyr::case_when(is.na(parent) ~ "",
                                            TRUE ~ parent)) |>
    dplyr::left_join(profile_params,
                     by = c("Vc_profile_id" = "profile_id", "parent" = "param")) |>
    dplyr::mutate(master = tidyr::replace_na(master, 0)) |>
    dplyr::mutate(att = dplyr::case_when(master == 0L ~ "",
                                         TRUE ~ parent)) |>
    dplyr::distinct(Vc_profile_id, param, param_master, att) |>
    dplyr::mutate(n_atts = dplyr::n(), .by = c(Vc_profile_id, param)) |>
    dplyr::mutate(remove = (n_atts > 1) & (att == "")) |>
    dplyr::filter(!remove) |>
    dplyr::select(-"n_atts", -"remove") |>
    dplyr::arrange(Vc_profile_id, param, att) |>
    dplyr::mutate(parent_attributes = paste(att, collapse = "__"),
                  .by = c("Vc_profile_id", "param")) |>
    dplyr::mutate(param_id = as.integer(stringr::str_remove(param, "att"))) |>
    dplyr::select("Vc_profile_id", "param_id",
                  "param_master", "parent_attributes") |>
    dplyr::distinct() |>
    dplyr::left_join(tmp_rho_def |>
                       dplyr::rename(rho_profile_id = profile_id) |>
                       dplyr::select(param_id, rho_profile_id, parent_attributes),
                     by = c("param_id", "parent_attributes")) |>
    dplyr::select(-"parent_attributes") |>
    dplyr::mutate(
      rhs = glue::glue("rho[{param_id},{rho_profile_id}]"),
      rhs = dplyr::case_when(param_master == 0L ~ glue::glue("(1-{rhs})"),
                             TRUE ~ rhs)
    ) |>
    dplyr::summarize(rhs = paste(rhs, collapse = "*"), .by = c(Vc_profile_id)) |>
    glue::glue_data("Vc[{Vc_profile_id}] = {rhs};")

  transformed_parameters_block <- glue::glue(
    "  simplex[C] Vc;",
    "  vector[C] log_Vc;",
    "  matrix[I,C] rho;",
    "",
    "  ////////////////////////////////// marginal/conditional attr probabilities",
    "  {glue::glue_collapse(rho_def, sep = \"\n  \")}",
    "",
    "  ////////////////////////////////// class membership probabilities",
    "  {glue::glue_collapse(Vc_def, sep = \"\n  \")}",
    "",
    "  log_Vc = log(Vc);",
    .sep = "\n", .trim = FALSE
  )

  strc_priors <- strc_params |>
    dplyr::select(-"param_id") |>
    dplyr::distinct() |>
    dplyr::left_join(prior_tibble(priors),
                     by = c("type", "param_name" = "coefficient"),
                     relationship = "one-to-one") |>
    dplyr::rename(coef_def = "prior") |>
    dplyr::left_join(prior_tibble(priors) |>
                       dplyr::filter(is.na(.data$coefficient)) |>
                       dplyr::select(-"coefficient"),
                     by = "type", relationship = "many-to-one") |>
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
              priors = strc_priors))
}
