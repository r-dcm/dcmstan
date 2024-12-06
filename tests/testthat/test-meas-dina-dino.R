test_that("dina script works", {
  ecpe_spec <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                           identifier = "item_id",
                           measurement_model = dina())
  mdm_spec <- dcm_specify(qmatrix = dcmdata::mdm_qmatrix,
                          identifier = "item",
                          measurement_model = dina())
  dtmr_spec <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                           identifier = "item",
                           measurement_model = dina())
  expect_snapshot(generate_stan(ecpe_spec))
  expect_snapshot(generate_stan(mdm_spec))
  expect_snapshot(generate_stan(dtmr_spec))

  ecpe_spec2 <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                            identifier = "item_id",
                            measurement_model = dina(),
                            structural_model = independent())
  expect_snapshot(generate_stan(ecpe_spec2))
})

test_that("dino script works", {
  ecpe_spec <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                           identifier = "item_id",
                           measurement_model = dino())
  mdm_spec <- dcm_specify(qmatrix = dcmdata::mdm_qmatrix,
                          identifier = "item",
                          measurement_model = dino())
  dtmr_spec <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                           identifier = "item",
                           measurement_model = dino())
  expect_snapshot(generate_stan(ecpe_spec))
  expect_snapshot(generate_stan(mdm_spec))
  expect_snapshot(generate_stan(dtmr_spec))

  ecpe_spec2 <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                            identifier = "item_id",
                            measurement_model = dino(),
                            structural_model = independent())
  expect_snapshot(generate_stan(ecpe_spec2))
})
