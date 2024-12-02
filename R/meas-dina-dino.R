meas_dina <- function(qmatrix) {
  # parameters block -----
  parameters_block <- glue::glue(
    "  ////////////////////////////////// item parameters",
    "  array[I] real<lower=0,upper=1> slip;",
    "  array[I] real<lower=0,upper=1> guess;",
    .sep = "\n"
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
    .sep = "\n"
  )

  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block))
}

meas_dino <- meas_dina
