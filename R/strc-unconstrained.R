strc_unconstrained <- function() {
  parameters_block <-
    glue::glue(
      "  simplex[C] Vc;                  // base rates of class membership",
      .trim = FALSE
    )

  transformed_parameters_block <-
    glue::glue("  vector[C] log_Vc = log(Vc);", .trim = FALSE)

  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block))
}
