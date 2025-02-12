#' Generate 'Stan' code for a diagnostic classification models
#'
#' Given a specification for a diagnostic classification model, automatically
#' generate the 'Stan' code necessary to estimate the model. For details on how
#' the code blocks relate to diagnostic models, see da Silva et al. (2017),
#' Jiang and Carter (2019), and Thompson (2019).
#'
#' @param x A model specification (e.g., [dcm_specify()]) object.
#' @param ... Additional arguments passed to methods.
#'
#' @return A [glue][glue::as_glue] object containing the 'Stan' code for the
#'   specified model.
#' @export
#'
#' @references da Silva, M. A., de Oliveira, E. S. B., von Davier, A. A., and
#'   Bazán, J. L. (2017). Estimating the DINA model parameters using the
#'   No-U-Turn sampler. *Biometrical Journal, 60*(2), 352-368.
#'   \doi{10.1002/bimj.201600225}
#' @references Jiang, Z., & Carter, R. (2019). Using Hamiltonian Monte Carlo to
#'   estimate the log-linear cognitive diagnosis model via Stan. *Behavior
#'   Research Methods, 51*, 651-662. \doi{10.3758/s13428-018-1069-9}
#' @references Thompson, W. J. (2019). *Bayesian psychometrics for diagnostic
#'   assessments: A proof of concept* (Research Report No. 19-01). University of
#'   Kansas; Accessible Teaching, Learning, and Assessment Systems.
#'   \doi{10.35542/osf.io/jzqs8}
#'
#' @examples
#' qmatrix <- data.frame(
#'   att1 = sample(0:1, size = 5, replace = TRUE),
#'   att2 = sample(0:1, size = 5, replace = TRUE)
#' )
#'
#' model_spec <- dcm_specify(qmatrix = qmatrix,
#'                           measurement_model = lcdm(),
#'                           structural_model = unconstrained())
#'
#' generate_stan(model_spec)
generate_stan <- S7::new_generic("generate_stan", "x")

# Method for dcm_specification -------------------------------------------------
S7::method(generate_stan, dcm_specification) <- function(x) {
  meas_args <- c(list(qmatrix = x@qmatrix, priors = x@priors),
                 x@measurement_model@model_args)
  meas_code <- do.call(paste0("meas_", x@measurement_model@model), meas_args)

  strc_args <- c(list(qmatrix = x@qmatrix, priors = x@priors),
                 x@structural_model@model_args)
  strc_code <- do.call(paste0("strc_", x@structural_model@model), strc_args)

  # data block -----
  data_block <- glue::glue(
    "data {{
      int<lower=1> I;                      // number of items
      int<lower=1> R;                      // number of respondents
      int<lower=1> N;                      // number of observations
      int<lower=1> C;                      // number of classes
      int<lower=1> A;                      // number of attributes
      array[N] int<lower=1,upper=I> ii;    // item for observation n
      array[N] int<lower=1,upper=R> rr;    // respondent for observation n
      array[N] int<lower=0,upper=1> y;     // score for observation n
      array[R] int<lower=1,upper=N> start; // starting row for respondent R
      array[R] int<lower=1,upper=I> num;   // number of items for respondent R
      matrix[C,A] Alpha;                   // attribute pattern for each class
      matrix[I,C] Xi;                      // class attribute mastery indicator
    }}"
  )

  # parameters block -----
  parameters_block <- glue::glue(
    "parameters {{",
    "{strc_code$parameters}",
    "",
    "{meas_code$parameters}",
    "}}", .sep = "\n"
  )

  # transformed parameters block -----
  transformed_parameters_block <- glue::glue(
    "transformed parameters {{",
    "{strc_code$transformed_parameters}",
    "{meas_code$transformed_parameters}",
    "}}", .sep = "\n"
  )

  # model block -----
  all_priors <- glue::as_glue(c(strc_code$priors, meas_code$priors))
  model_block <- glue::glue(
    "model {{",
    "",
    "  ////////////////////////////////// priors",
    "  {glue::glue_collapse(all_priors, sep = \"\n  \")}",
    "",
    "  ////////////////////////////////// likelihood",
    "  for (r in 1:R) {{",
    "    row_vector[C] ps;",
    "    for (c in 1:C) {{",
    "      array[num[r]] real log_items;",
    "      for (m in 1:num[r]) {{",
    "        int i = ii[start[r] + m - 1];",
    "        log_items[m] = y[start[r] + m - 1] * log(pi[i,c]) +",
    "                       (1 - y[start[r] + m - 1]) * log(1 - pi[i,c]);",
    "      }}",
    "      ps[c] = log_Vc[c] + sum(log_items);",
    "    }}",
    "    target += log_sum_exp(ps);",
    "  }}",
    "}}", .sep = "\n"
  )

  full_script <- glue::glue(
    "{data_block}",
    "{parameters_block}",
    "{transformed_parameters_block}",
    "{model_block}",
    .sep = "\n"
  )

  full_script
}
