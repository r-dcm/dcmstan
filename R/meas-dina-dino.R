meas_dina <- function(qmatrix, priors) {
  # parameters block -----
  parameters_block <- glue::glue(
    "  ////////////////////////////////// item parameters",
    "  array[I] real<lower=0,upper=1> slip;",
    "  array[I] real<lower=0,upper=1> guess;",
    .sep = "\n", .trim = FALSE
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
    .sep = "\n", .trim = FALSE
  )

  # priors -----
  item_priors <- dina_parameters(qmatrix = qmatrix,
                                 rename_items = TRUE) %>%
    dplyr::left_join(prior_tibble(priors), by = c("type", "coefficient")) %>%
    dplyr::rename(coef_def = "prior") %>%
    dplyr::left_join(prior_tibble(priors) %>%
                       dplyr::filter(is.na(.data$coefficient)) %>%
                       dplyr::select(-"coefficient"),
                     by = c("type")) %>%
    dplyr::rename(type_def = "prior") %>%
    dplyr::mutate(
      prior = dplyr::case_when(!is.na(.data$coef_def) ~ .data$coef_def,
                               is.na(.data$coef_def) ~ .data$type_def),
      prior_def = glue::glue("{coefficient} ~ {prior};")
    ) %>%
    dplyr::pull("prior_def")

  # return -----
  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = item_priors))
}

meas_dino <- meas_dina
