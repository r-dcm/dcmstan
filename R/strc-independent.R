strc_independent <- function() {
  parameters_block <-
    glue::glue("  array[A] real<lower=0,upper=1> eta;", .trim = FALSE)

  transformed_parameters_block <-
    glue::glue(
      "  simplex[C] Vc;",
      "  vector[C] log_Vc;",
      "  for (c in 1:C) {{",
      "    Vc[c] = 1;",
      "    for (a in 1:A) {{",
      "      Vc[c] = Vc[c] * eta[a]^Alpha[c,a] * ",
      "              (1 - eta[a]) ^ (1 - Alpha[c,a]);",
      "    }}",
      "  }}",
      "  log_Vc = log(Vc);", .sep = "\n", .trim = FALSE
    )

  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block))
}
