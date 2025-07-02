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
      param = paste0("att", .data$child_id),
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~ sapply(gregexpr(pattern = "__", text = .data$parameter),
                      function(.x) length(attr(.x, "match.length"))) + 1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      comp_atts = mapply(one_down_params, x = .data$atts, item = .data$child_id),
      comp_atts = stringr::str_replace_all(.data$comp_atts, "l", "g"),
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
  parents <- all_params %>%
    dplyr::mutate(param = paste0("att", .data$child_id)) %>%
    tidyr::separate_longer_delim(attributes, delim = "__") %>%
    dplyr::rename(parent = attributes) %>%
    dplyr::group_by(.data$param) %>%
    dplyr::filter(dplyr::n() == 1 | !is.na(.data$parent)) %>%
    dplyr::ungroup() %>%
    dplyr::distinct("param", "parent")

  all_profiles <- create_profiles(dplyr::n_distinct(dplyr::select(parents, "param")))

  profile_params <- all_profiles |>
    tibble::rowid_to_column("profile_id") |>
    tidyr::pivot_longer(cols = -c("profile_id"),
                        names_to = "param", values_to = "master")

  profile_attributes <- tibble::tibble(profile_id = 1:nrow(all_profiles)) |>
    dplyr::left_join(
      all_profiles |>
        tibble::rowid_to_column("profile_id") |>
        tidyr::pivot_longer(cols = -c("profile_id"),
                            names_to = "param", values_to = "valid_for_profile") |>
        dplyr::filter(.data$valid_for_profile == 1) |>
        dplyr::mutate(param_id = stringr::str_remove(.data$param, "att")) |>
        dplyr::summarize(profile_atts = paste(.data$param_id, collapse = "__"),
                         profile_attributes = paste(.data$param, collapse = "__"),
                         .by = "profile_id"),
      by = c("profile_id")
    ) |>
    dplyr::mutate(profile_atts = dplyr::case_when(profile_id == 1L ~ "",
                                                  TRUE ~ profile_atts),
                  profile_attributes = dplyr::case_when(profile_id == 1L ~ "",
                                                        TRUE ~ profile_attributes))

  # create Vc terms based on parent configurations
  Vc_terms <- parents %>%
    dplyr::distinct("param") %>%
    dplyr::pull(.data$param) %>%
    purrr::map_dfr(function(.x) {
      param <- .x

      # identify parents of a parameter
      parents_jj <- parents %>%
        dplyr::filter(param == !!param) %>%
        dplyr::filter(!is.na(.data$parent)) %>%
        dplyr::pull(.data$parent)

      # create a child parameter identifier
      param_id <- as.integer(stringr::str_remove(.data$param, "att"))

      # return output for intercept-only case (endogenous variable)
      if (length(parents_jj) == 0) {
        param_names <- strc_params %>%
          dplyr::filter(param == !!param) %>%
          dplyr::pull(.data$param_name)

        output <- tibble::tibble(
          param_id = param_id,
          profile_id = 1L,
          parent_profile_id = 1L,
          strc_params = param_names,
          parent_attributes = ""
        )

        return(output)
      }

      # generate all profile configurations for parent attribute mastery
      parent_profiles <- create_profiles(length(parents_jj)) %>%
        stats::setNames(parents_jj)

      # generate all possible terms for the model: parent(s) -> child
      parents_jj_terms <- stats::model.matrix(~ .^2, data = parent_profiles) %>%
        tibble::as_tibble(.name_repair = model_matrix_name_repair) %>%
        tibble::rowid_to_column("profile_id") %>%
        tidyr::pivot_longer(cols = -c(.data$profile_id),
                            names_to = "parameter",
                            values_to = "valid_for_profile") %>%
        dplyr::filter(.data$valid_for_profile == 1)

      # generate the kernel expression of the logit function
      param_lookup <- strc_params %>%
        dplyr::filter(param == !!param) %>%
        dplyr::select("parameter", "param_name", "child_id")
      parents_jj_terms <- parents_jj_terms %>%
        dplyr::left_join(param_lookup,
                         by = "parameter") %>%
        dplyr::filter(!is.na(.data$param_name)) %>%
        dplyr::summarize(strc_params = paste(.data$param_name, collapse = "+"),
                         .by = "profile_id")

      # generate attribute information to assist mapping between parent_jj_terms
      # and each Vc class index.
      parent_attr_info <- parent_profiles %>%
        tibble::rowid_to_column("profile_id") %>%
        tidyr::pivot_longer(cols = -c(.data$profile_id),
                            names_to = "param",
                            values_to = "valid_for_profile") %>%
        dplyr::filter(.data$valid_for_profile == 1) %>%
        dplyr::mutate(param_id = stringr::str_remove(.data$param, "att")) %>%
        dplyr::summarise(parent_atts = paste(.data$param_id, collapse = "__"),
                         parent_attributes = paste(.data$param, collapse = "__"),
                         .by = "profile_id") %>%
        dplyr::rename(parent_profile_id = profile_id) %>%
        dplyr::left_join(profile_attributes,
                         by = c("parent_atts" = "profile_atts",
                                "parent_attributes" = "profile_attributes")) %>%
        dplyr::add_row(profile_id = 1L, parent_profile_id = 1L,
                       parent_atts = "", parent_attributes = "") %>%
        dplyr::mutate(param_id = param_id) %>%
        dplyr::arrange(.data$profile_id)

      # map each strc node kernel to the correct Vc class
      output <- parents_jj_terms %>%
        dplyr::rename(parent_profile_id = profile_id) %>%
        dplyr::inner_join(parent_attr_info,
                          by = "parent_profile_id") %>%
        dplyr::select("param_id", "profile_id", "parent_profile_id",
                      "strc_params", "parent_attributes")

      return(output)
    })

  Vc_def <- tidyr::expand_grid(Vc_profile_id = seq_len(nrow(all_profiles)),
                               param = parents |> dplyr::arrange(.data$param) |>
                                 dplyr::distinct("param") |>
                                 dplyr::pull(.data$param)) |>
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
    dplyr::rename(parent_master = master) |>
    dplyr::mutate(parent_master = tidyr::replace_na(.data$parent_master, 0)) %>%
    dplyr::mutate(att = dplyr::case_when(parent_master == 0L ~ "",
                                         TRUE ~ parent)) |>
    dplyr::distinct("Vc_profile_id", "param", "param_master", "att") |>
    dplyr::mutate(n_atts = dplyr::n(), .by = c("Vc_profile_id", "param")) |>
    dplyr::mutate(remove = (.data$n_atts > 1) & (.data$att == "")) |>
    dplyr::filter(!.data$remove) |>
    dplyr::select(-"n_atts", -"remove") |>
    dplyr::arrange(.data$Vc_profile_id, .data$param, .data$att) |>
    dplyr::mutate(parent_attributes = paste(.data$att, collapse = "__"),
                  .by = c("Vc_profile_id", "param")) |>
    dplyr::mutate(param_id = as.integer(stringr::str_remove(.data$param, "att"))) |>
    dplyr::select("Vc_profile_id", "param_id",
                  "param_master", "parent_attributes") |>
    dplyr::distinct() %>%
    dplyr::left_join(Vc_terms |>
                       dplyr::select("param_id", "parent_attributes",
                                     "strc_params"),
                     by = c("param_id", "parent_attributes")) |>
    dplyr::select(-"parent_attributes") |>
    dplyr::mutate(rhs = glue::glue("inv_logit({strc_params})")) |>
    dplyr::mutate(rhs = dplyr::case_when(param_master == 0L ~
                                           glue::glue("(1-{rhs})"),
                                         TRUE ~ rhs)) |>
    dplyr::summarize(rhs = paste(.data$rhs, collapse = "*"),
                     .by = c("Vc_profile_id")) |>
    glue::glue_data("Vc[{Vc_profile_id}] = {rhs};")

  transformed_parameters_block <- glue::glue(
    "  simplex[C] Vc;",
    "  vector[C] log_Vc;",
    "",
    "  ////////////////////////////////// class membership probabilities",
    "  {glue::glue_collapse(Vc_def, sep = \"\n  \")}",
    "",
    "  log_Vc = log(Vc);",
    .sep = "\n", .trim = FALSE
  )

  strc_priors <- strc_params |>
    dplyr::select(-"child_id") |>
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
