#' 'Stan' code for the NC-RUM model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for the NC-RUM model. The function also returns the code that defines the
#' prior distributions for each parameter, which is used in the `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @rdname ncrum
#' @noRd
meas_ncrum <- function(qmatrix, priors, att_names = NULL, hierarchy = NULL) {
  # parameters block -----
  all_params <- ncrum_parameters(qmatrix = qmatrix,
                                 rename_attributes = TRUE,
                                 rename_items = TRUE)

  params <- all_params |>
    glue::glue_data("real<lower=0,upper=1> {coefficient};")

  parameters_block <- glue::glue(
    "  ////////////////////////////////// measurement parameters",
    "  {glue::glue_collapse(params, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # transformed parameters block -----
  all_profiles <- if (is.null(hierarchy)) {
    create_profiles(ncol(qmatrix))
  } else {
    create_profiles(hdcm(hierarchy = hierarchy),
                    attributes = att_names)
  }

  pi_def <- all_params |>
    tidyr::expand_grid(profile_id = seq_len(nrow(all_profiles))) |>
    dplyr::left_join(all_profiles |>
                       tibble::rowid_to_column(var = "profile_id") |>
                       tidyr::pivot_longer(cols = -"profile_id",
                                           names_to = "attribute",
                                           values_to = "valid"),
                     by = c("profile_id", "attribute"),
                     relationship = "many-to-one") |>
    dplyr::filter(is.na(valid) | valid == 0) |>
    dplyr::summarize(pi = paste(coefficient, collapse = "*"),
                     .by = c("item_id", "profile_id")) |>
    dplyr::mutate(
      full_param = glue::glue("pi[{item_id},{profile_id}] = {pi};")
    ) |>
    dplyr::pull("full_param")

  transformed_parameters_block <- glue::glue(
    "  matrix[I,C] pi;",
    "",
    "  ////////////////////////////////// probability of correct response",
    "  {glue::glue_collapse(pi_def, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # priors -----
  prior_def <- all_params |>
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
  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = prior_def))
}
