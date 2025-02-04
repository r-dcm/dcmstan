strc_loglinear <- function(qmatrix, loglinear_interaction = Inf, priors) {

  all_params <- get_parameters(loglinear(), qmatrix = qmatrix,
                               loglinear_interaction = loglinear_interaction)

  #format parameter labels
  strc_params <- all_params |>
    dplyr::mutate(parameter = dplyr::case_when(is.na(.data$attributes) ~
                                                 "intercept",
                                               TRUE ~ .data$attributes)) |>
    dplyr::select("profile_id", "parameter", param_name = "coefficient", "type") |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~ sapply(gregexpr(pattern = "__", text = .data$parameter),
                      function(.x) length(attr(.x, "match.length"))) + 1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      param_name = glue::glue("g_{param_level}",
                              "{gsub(\"__\", \"\", atts)}"),
      param_def = glue::glue("real {param_name};")
    ) |>
    dplyr::filter(.data$param_level <= loglinear_interaction)

  main_effects <- strc_params |>
    dplyr::filter(.data$param_level == 1) |>
    select("param_def") |>
    distinct() |>
    dplyr::pull(.data$param_def)
  interactions <- strc_params |>
    dplyr::filter(.data$param_level >= 2) |>
    select("param_def") |>
    distinct() |>
    dplyr::pull(.data$param_def)

  interaction_stan <- if (length(interactions) > 0) {
    glue::glue(
      "",
      "  ////////////////////////////////// strc interactions",
      "  {glue::glue_collapse(interactions, sep = \"\n  \")}",
      .sep = "\n", .trim = FALSE
    )
  } else {
    ""
  }

  parameters_block <- glue::glue(
    "  ////////////////////////////////// strc main effects",
    "  {glue::glue_collapse(main_effects, sep = \"\n  \")}",
    "{interaction_stan}",
    .sep = "\n", .trim = FALSE
  )


  # transformed parameters block -----
  pi_def <- strc_params |>
    dplyr::select("profile_id", "parameter", "param_name") |>
    dplyr::group_by(.data$profile_id) |>
    dplyr::summarize(strc_params = paste(unique(.data$param_name),
                                         collapse = "+"),
                     .groups = "drop") |>
    glue::glue_data("mu[{profile_id}] = {strc_params};")

  transformed_parameters_block <-
    glue::glue(
      "  simplex[C] Vc;",
      "  vector[C] log_Vc;",
      "  vector[C] mu;",
      "",
      "  ////////////////////////////////// probability of class membership",
      "  mu[1] = 0;",
      "  {glue::glue_collapse(pi_def, sep = \"\n  \")}",
      .sep = "\n", .trim = FALSE
    )

  strc_priors <- strc_params |>
    dplyr::select(-"profile_id") |>
    dplyr::distinct() |>
    dplyr::left_join(prior_tibble(priors),
                     by = c("type", "coefficient"),
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

  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = strc_priors))

}
