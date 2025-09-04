#' 'Stan' code for an unconstrained structural model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for an unconstrained structural model. The function also returns the code
#' that defines the prior distributions for each parameter, which is used in the
#' `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @noRd
strc_unconstrained <- function(qmatrix, priors) {
  parameters_block <-
    glue::glue(
      "  simplex[C] Vc;                  // base rates of class membership",
      .trim = FALSE
    )

  transformed_parameters_block <-
    glue::glue("  vector[C] log_Vc = log(Vc);", .trim = FALSE)

  strc_priors <- get_parameters(unconstrained(), qmatrix = qmatrix) |>
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

  list(
    parameters = parameters_block,
    transformed_parameters = transformed_parameters_block,
    priors = strc_priors
  )
}

#' @rdname lcdm-crum
#' @noRd
strc_hdcm <- function(qmatrix, priors, hierarchy) {
  strc_unconstrained(qmatrix, priors = priors)
}
