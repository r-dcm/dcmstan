#' 'Stan' code for the DINA and DINO models
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for the DINA and DINO models. The function also returns the code that defines
#' the prior distributions for each parameter, which is used in the `model`
#' block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @rdname dina-dino
#' @noRd
meas_dina <- function(qmatrix, priors, att_names) {
  # parameters block -----
  parameters_block <- glue::glue(
    "  ////////////////////////////////// item parameters",
    "  array[I] real<lower=0,upper=1> slip;",
    "  array[I] real<lower=0,upper=1> guess;",
    .sep = "\n",
    .trim = FALSE
  )

  # transformed parameters block -----
  transformed_parameters_block <- glue::glue(
    "  matrix[I,C] pi;",
    "",
    "  for (i in 1:I) {{",
    "    for (c in 1:C) {{",
    "      pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));",
    "    }}",
    "  }}",
    .sep = "\n",
    .trim = FALSE
  )

  # priors -----
  item_priors <- dina_parameters(qmatrix = qmatrix, rename_items = TRUE) |>
    dplyr::left_join(prior_tibble(priors), by = c("type", "coefficient")) |>
    dplyr::rename(coef_def = "prior") |>
    dplyr::left_join(
      prior_tibble(priors) |>
        dplyr::filter(is.na(.data$coefficient)) |>
        dplyr::select(-"coefficient"),
      by = c("type")
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
    priors = item_priors
  )
}

#' @rdname dina-dino
#' @noRd
meas_dino <- meas_dina
