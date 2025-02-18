test_that("stan code is syntactically correct", {
  stan_dir <- withr::local_tempdir()

  combos <- expand.grid(meas = meas_choices(), strc = strc_choices(),
                        stringsAsFactors = FALSE)

  for (i in seq_len(nrow(combos))) {
    mdm_spec <- dcm_specify(
      qmatrix = dcmdata::mdm_qmatrix, identifier = "item",
      measurement_model = do.call(combos$meas[i], args = list()),
      structural_model = do.call(combos$strc[i], args = list())
    )
    ecpe_spec <- dcm_specify(
      qmatrix = dcmdata::ecpe_qmatrix, identifier = "item_id",
      measurement_model = do.call(combos$meas[i], args = list()),
      structural_model = do.call(combos$strc[i], args = list())
    )
    dtmr_spec <- dcm_specify(
      qmatrix = dcmdata::dtmr_qmatrix, identifier = "item",
      measurement_model = do.call(combos$meas[i], args = list()),
      structural_model = do.call(combos$strc[i], args = list())
    )

    mdm_file <- cmdstanr::write_stan_file(stan_code(mdm_spec), dir = stan_dir,
                                          force_overwrite = TRUE)
    ecpe_file <- cmdstanr::write_stan_file(stan_code(ecpe_spec), dir = stan_dir,
                                           force_overwrite = TRUE)
    dtmr_file <- cmdstanr::write_stan_file(stan_code(dtmr_spec), dir = stan_dir,
                                           force_overwrite = TRUE)

    mdm_model <- cmdstanr::cmdstan_model(mdm_file, compile = FALSE)
    ecpe_model <- cmdstanr::cmdstan_model(ecpe_file, compile = FALSE)
    dtmr_model <- cmdstanr::cmdstan_model(dtmr_file, compile = FALSE)

    expect_true(mdm_model$check_syntax(quiet = TRUE))
    expect_true(ecpe_model$check_syntax(quiet = TRUE))
    expect_true(dtmr_model$check_syntax(quiet = TRUE))
  }
})
