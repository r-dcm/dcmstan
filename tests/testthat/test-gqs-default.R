test_that("gqs script works", {
  expect_snapshot(stan_code(generated_quantities(loglik = TRUE,
                                                 probabilities = TRUE,
                                                 ppmc = TRUE)))
  expect_snapshot(stan_code(generated_quantities(loglik = FALSE,
                                                 probabilities = TRUE,
                                                 ppmc = TRUE)))
  expect_snapshot(stan_code(generated_quantities(loglik = TRUE,
                                                 probabilities = FALSE,
                                                 ppmc = TRUE)))
  expect_snapshot(stan_code(generated_quantities(loglik = FALSE,
                                                 probabilities = FALSE,
                                                 ppmc = TRUE)))
  expect_snapshot(stan_code(generated_quantities(loglik = TRUE,
                                                 probabilities = TRUE,
                                                 ppmc = FALSE)))
  expect_snapshot(stan_code(generated_quantities(loglik = FALSE,
                                                 probabilities = TRUE,
                                                 ppmc = FALSE)))
  expect_snapshot(stan_code(generated_quantities(loglik = TRUE,
                                                 probabilities = FALSE,
                                                 ppmc = FALSE)))
  expect_snapshot(stan_code(generated_quantities(loglik = FALSE,
                                                 probabilities = FALSE,
                                                 ppmc = FALSE)))
})
