#' 'Stan' code for a log-linear structural model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for a log-linear structural model. The function also returns the code that
#' defines the prior distributions for each parameter, which is used in the
#' `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param max_interaction The highest structural-level interaction to include in
#'   the model.
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @noRd
strc_loglinear <- function(qmatrix, max_interaction = Inf, priors) {
  # parameters block -----
  all_params <- loglinear_parameters(
    qmatrix = qmatrix,
    max_interaction = max_interaction
  )

  parameters_block <- glue::glue(
    "  ////////////////////////////////// structural parameters",
    "  {glue::glue_collapse(
          glue::glue(\"real {unique(all_params$coefficient)};\"),
          sep = \"\n  \"
        )}",
    .sep = "\n",
    .trim = FALSE
  )

  # transformed parameters block -----
  class_def <- all_params |>
    dplyr::select("profile_id", "attributes", "coefficient") |>
    dplyr::summarize(
      strc_params = paste(unique(.data$coefficient), collapse = "+"),
      .by = "profile_id"
    ) |>
    glue::glue_data("mu[{profile_id}] = {strc_params};")

  transformed_parameters_block <-
    glue::glue(
      "  simplex[C] Vc;",
      "  vector[C] log_Vc;",
      "  vector[C] mu;",
      "",
      "  ////////////////////////////////// probability of class membership",
      "  mu[1] = 0;",
      "  {glue::glue_collapse(class_def, sep = \"\n  \")}",
      "",
      "  log_Vc = mu - log_sum_exp(mu);",
      "  Vc = exp(log_Vc);",
      .sep = "\n",
      .trim = FALSE
    )

  # priors -----
  strc_priors <- all_params |>
    dplyr::select(-"profile_id") |>
    dplyr::distinct() |>
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
