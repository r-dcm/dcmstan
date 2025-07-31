#' 'Stan' code for the NIDO model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for the NIDO model. The function also returns the code that defines the
#' prior distributions for each parameter, which is used in the `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#' @param hierarchy Optional. If present, the quoted attribute hierarchy. See
#'   \code{vignette("dagitty4semusers", package = "dagitty")} for a tutorial on
#'   how to draw the attribute hierarchy.
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @rdname nido
#' @noRd
meas_nido <- function(qmatrix, priors, att_names = NULL, hierarchy = NULL) {
  # parameters block -----
  all_params <- nido_parameters(qmatrix = qmatrix,
                                rename_attributes = TRUE)

  meas_params <- all_params |>
    dplyr::mutate(
      param_def = dplyr::case_when(
        .data$type == "intercept" ~ glue::glue("real {coefficient};"),
        .data$type >= "maineffect" ~ glue::glue("real<lower=0> {coefficient};")
      )
    ) |>
    dplyr::pull("param_def")

  parameters_block <- glue::glue(
    "  ////////////////////////////////// measurement parameters",
    "  {glue::glue_collapse(meas_params, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # transformed parameters block -----
  all_profiles <- if (is.null(hierarchy)) {
    create_profiles(ncol(qmatrix))
  } else {
    create_profiles(hdcm(hierarchy = hierarchy),
                    attributes = att_names)
  }

  profile_params <- all_profiles |>
    tibble::rowid_to_column("profile_id") |>
    tidyr::pivot_longer(cols = -"profile_id", names_to = "att",
                        values_to = "meas") |>
    dplyr::left_join(all_params, by = c("att" = "attribute"),
                     relationship = "many-to-many") |>
    dplyr::filter(!(meas == 0 & type == "maineffect")) |>
    dplyr::summarize(param = paste(.data$coefficient, collapse = "+"),
                     .by = c("profile_id", "att")) |>
    dplyr::select("profile_id", "att", "param")

  pi_def <- qmatrix |>
    tibble::rowid_to_column("item_id") |>
    tidyr::pivot_longer(cols = -c("item_id"),
                        names_to = "att_id",
                        values_to = "valid") |>
    dplyr::filter(.data$valid == 1L) |>
    dplyr::select(-"valid") |>
    tidyr::expand_grid(profile_id = seq_len(nrow(all_profiles))) |>
    dplyr::left_join(profile_params, by = c("profile_id", "att_id" = "att"),
                     relationship = "many-to-one") |>
    dplyr::summarize(param = paste(.data$param, collapse = "+"),
                     .by = c("item_id", "profile_id")) |>
    glue::glue_data("pi[{item_id},{profile_id}] = inv_logit({param});")

  transformed_parameters_block <- glue::glue(
    "  matrix[I,C] pi;",
    "",
    "  ////////////////////////////////// probability of correct response",
    "  {glue::glue_collapse(pi_def, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # priors -----
  att_priors <- all_params |>
    dplyr::left_join(prior_tibble(priors),
                     by = c("type", "coefficient"),
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
      prior_def = glue::glue("{coefficient} ~ {prior};")
    ) |>
    dplyr::pull("prior_def")

  # return -----
  list(parameters = parameters_block,
       transformed_parameters = transformed_parameters_block,
       priors = att_priors)
}
