test_that("nido script works", {
  ecpe_spec <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = nido()
  )
  mdm_spec <- dcm_specify(
    qmatrix = dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = nido()
  )
  dtmr_spec <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = nido()
  )
  expect_snapshot(stan_code(ecpe_spec))
  expect_snapshot(stan_code(mdm_spec))
  expect_snapshot(stan_code(dtmr_spec))

  ecpe_spec2 <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = nido(),
    structural_model = independent()
  )
  expect_snapshot(stan_code(ecpe_spec2))
})

test_that("nido with hierarchy works", {
  ecpe_nido_hdcm <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = nido(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  expect_snapshot(stan_code(ecpe_nido_hdcm))
})
