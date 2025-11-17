#' 'Stan' code for generated quantities
#'
#' Create the `generated quantities` block that is needed for different
#' quantities of interest.
#'
#' @param loglik Logical indicating whether log-likelihood should be generated.
#' @param probabilities Logical indicating whether class and attribute
#'   proficiency probabilities should be generated.
#' @param ppmc Logical indicating whether replicated data sets for posterior
#'   predictive model checks should be generated.
#'
#' @returns A [glue::glue()] object containing the `generated quantities` block.
#' @rdname gqs
#' @noRd
gqs_default <- function(loglik = FALSE, probabilities = FALSE, ppmc = FALSE) {
  # identify variables ---------------------------------------------------------
  if (loglik) {
    loglik_vars <- glue::glue(
      "  vector[R] log_lik;",
      .trim = FALSE
    )
  } else {
    loglik_vars <- NULL
  }

  if (probabilities) {
    prob_vars <- glue::glue(
      "  matrix[R,C] prob_resp_class;       // post prob of resp R in class C",
      "  matrix[R,A] prob_resp_attr;        // post prob of resp R master A",
      .sep = "\n",
      .trim = FALSE
    )
  } else {
    prob_vars <- NULL
  }

  if (ppmc) {
    ppmc_vars <- glue::glue(
      "  array[N] int y_rep;",
      "  array[R] int r_class;",
      .sep = "\n",
      .trim = FALSE
    )
  } else {
    ppmc_vars <- NULL
  }

  # identify loops -------------------------------------------------------------
  if (loglik || probabilities) {
    loglik_line <- "    log_lik[r] = log_sum_exp(prob_joint);"
    prob_line <- paste0(
      "    prob_resp_class[r] = exp(prob_joint) / ",
      "exp(log_sum_exp(prob_joint));"
    )

    loop1 <- glue::glue(
      "  for (r in 1:R) {{",
      "    row_vector[C] prob_joint;",
      "    for (c in 1:C) {{",
      "      array[num[r]] real log_items;",
      "      for (m in 1:num[r]) {{",
      "        int i = ii[start[r] + m - 1];",
      "        log_items[m] = y[start[r] + m - 1] * log(pi[i,c]) +",
      "                       (1 - y[start[r] + m - 1]) * log(1 - pi[i,c]);",
      "      }}",
      "      prob_joint[c] = log_Vc[c] + sum(log_items);",
      "    }}",
      if (loglik) glue::glue("{loglik_line}"),
      if (probabilities) glue::glue("{prob_line}"),
      "  }}",
      .sep = "\n",
      .trim = FALSE,
      .null = NULL
    )

    loop2 <- glue::glue(
      "",
      "  for (r in 1:R) {{",
      "    for (a in 1:A) {{",
      "      row_vector[C] prob_attr_class;",
      "      for (c in 1:C) {{",
      "        prob_attr_class[c] = prob_resp_class[r,c] * Alpha[c,a];",
      "      }}",
      "      prob_resp_attr[r,a] = sum(prob_attr_class);",
      "    }}",
      "  }}",
      .sep = "\n",
      .trim = FALSE,
      .null = NULL
    )

    loglik_prob_loop <- glue::glue(
      "{loop1}",
      if (probabilities) "{loop2}",
      .sep = "\n",
      .null = NULL
    )
  } else {
    loglik_prob_loop <- NULL
  }

  if (ppmc) {
    ppmc_loop <- glue::glue(
      if (!is.null(loglik_prob_loop)) "",
      "  for (r in 1:R) {{",
      "    vector[C] r_probs = exp(log_Vc) / exp(log_sum_exp(log_Vc));",
      "    r_class[r] = categorical_rng(r_probs);",
      "    for (m in 1:num[r]) {{",
      "      int i = ii[start[r] + m - 1];",
      "      y_rep[start[r] + m - 1] = bernoulli_rng(pi[i, r_class[r]]);",
      "    }}",
      "  }}",
      .sep = "\n",
      .trim = FALSE,
      .null = NULL
    )
  } else {
    ppmc_loop <- NULL
  }

  # create code ----------------------------------------------------------------
  gqs_block <- glue::glue(
    "generated quantities {{",
    if (!is.null(loglik_vars)) glue::glue("{loglik_vars}"),
    if (!is.null(prob_vars)) glue::glue("{prob_vars}"),
    if (!is.null(ppmc_vars)) glue::glue("{ppmc_vars}"),
    "",
    if (!is.null(loglik_prob_loop)) "{loglik_prob_loop}",
    if (!is.null(ppmc_loop)) "{ppmc_loop}",
    "}}",
    .sep = "\n",
    .null = NULL
  )

  gqs_block
}
