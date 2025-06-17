test_that("dina script works", {
  ecpe_dina_unst <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                                identifier = "item_id",
                                measurement_model = dina())
  mdm_dina_unst <- dcm_specify(qmatrix = dcmdata::mdm_qmatrix,
                               identifier = "item",
                               measurement_model = dina())
  dtmr_dina_unst <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                                identifier = "item",
                                measurement_model = dina())
  expect_snapshot(stan_code(ecpe_dina_unst))
  expect_snapshot(stan_code(mdm_dina_unst))
  expect_snapshot(stan_code(dtmr_dina_unst))

<<<<<<< HEAD
  ecpe_spec2 <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                            identifier = "item_id",
                            measurement_model = dina(),
                            structural_model = independent())
  expect_snapshot(generate_stan(ecpe_spec2))

  ecpe_spec4 <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                            identifier = "item_id",
                            measurement_model = dina(),
                            structural_model = bayesnet())
  expect_snapshot(generate_stan(ecpe_spec4))
=======
  ecpe_dina_indp <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                                identifier = "item_id",
                                measurement_model = dina(),
                                structural_model = independent())
  expect_snapshot(stan_code(ecpe_dina_indp))

  dtmr_dina_logl <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                                identifier = "item",
                                measurement_model = dina(),
                                structural_model = loglinear())
  expect_snapshot(stan_code(dtmr_dina_logl))
>>>>>>> dc6f2a2bfa6f0d0cd09a3c5076b97c649da2aa68
})

test_that("dino script works", {
  ecpe_dino_unst <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                                identifier = "item_id",
                                measurement_model = dino())
  mdm_dino_unst <- dcm_specify(qmatrix = dcmdata::mdm_qmatrix,
                               identifier = "item",
                               measurement_model = dino())
  dtmr_dino_unst <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                                identifier = "item",
                                measurement_model = dino())
  expect_snapshot(stan_code(ecpe_dino_unst))
  expect_snapshot(stan_code(mdm_dino_unst))
  expect_snapshot(stan_code(dtmr_dino_unst))

  ecpe_dino_indp <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                                identifier = "item_id",
                                measurement_model = dino(),
                                structural_model = independent())
  expect_snapshot(stan_code(ecpe_dino_indp))

<<<<<<< HEAD
  ecpe_spec2 <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                            identifier = "item_id",
                            measurement_model = dino(),
                            structural_model = independent())
  expect_snapshot(generate_stan(ecpe_spec2))

  ecpe_spec4 <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                            identifier = "item_id",
                            measurement_model = dino(),
                            structural_model = bayesnet())
  expect_snapshot(generate_stan(ecpe_spec4))
=======
  dtmr_dino_logl <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                                identifier = "item",
                                measurement_model = dino(),
                                structural_model = loglinear())
  expect_snapshot(stan_code(dtmr_dino_logl))
>>>>>>> dc6f2a2bfa6f0d0cd09a3c5076b97c649da2aa68
})
