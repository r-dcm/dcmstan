strc_unconstrained <- function(qmatrix, priors) {
  parameters_block <-
    glue::glue(
      "  simplex[C] Vc;                  // base rates of class membership",
      .trim = FALSE
    )

  transformed_parameters_block <-
    glue::glue("  vector[C] log_Vc = log(Vc);", .trim = FALSE)

  strc_priors <- get_parameters(unconstrained(), qmatrix = qmatrix) |>
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
      prior_def = glue::glue("{coefficient} ~ {prior};")
    ) |>
    dplyr::pull("prior_def")

  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = strc_priors))
}
