test_that("nido script works", {
  ecpe_spec <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                           identifier = "item_id",
                           measurement_model = nido())
  mdm_spec <- dcm_specify(qmatrix = dcmdata::mdm_qmatrix,
                          identifier = "item",
                          measurement_model = nido())
  dtmr_spec <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                           identifier = "item",
                           measurement_model = nido())
  expect_snapshot(generate_stan(ecpe_spec))
  expect_snapshot(generate_stan(mdm_spec))
  expect_snapshot(generate_stan(dtmr_spec))

  ecpe_spec2 <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                            identifier = "item_id",
                            measurement_model = nido(),
                            structural_model = independent())
  expect_snapshot(generate_stan(ecpe_spec2))
})
