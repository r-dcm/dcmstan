test_that("dina script works", {
  ecpe_dina_unst <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dina()
  )
  mdm_dina_unst <- dcm_specify(
    qmatrix = dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = dina()
  )
  dtmr_dina_unst <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = dina()
  )
  expect_snapshot(stan_code(ecpe_dina_unst))
  expect_snapshot(stan_code(mdm_dina_unst))
  expect_snapshot(stan_code(dtmr_dina_unst))

  ecpe_dina_indp <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dina(),
    structural_model = independent()
  )
  expect_snapshot(stan_code(ecpe_dina_indp))

  dtmr_dina_logl <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = dina(),
    structural_model = loglinear()
  )
  expect_snapshot(stan_code(dtmr_dina_logl))
})

test_that("dino script works", {
  ecpe_dino_unst <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dino()
  )
  mdm_dino_unst <- dcm_specify(
    qmatrix = dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = dino()
  )
  dtmr_dino_unst <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = dino()
  )
  expect_snapshot(stan_code(ecpe_dino_unst))
  expect_snapshot(stan_code(mdm_dino_unst))
  expect_snapshot(stan_code(dtmr_dino_unst))

  ecpe_dino_indp <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dino(),
    structural_model = independent()
  )
  expect_snapshot(stan_code(ecpe_dino_indp))

  dtmr_dino_logl <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = dino(),
    structural_model = loglinear()
  )
  expect_snapshot(stan_code(dtmr_dino_logl))
})

test_that("dina with hierarchy works", {
  ecpe_dina_hdcm <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dina(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  expect_snapshot(stan_code(ecpe_dina_hdcm))
})

test_that("dino with hierarchy works", {
  ecpe_dino_hdcm <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dino(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  expect_snapshot(stan_code(ecpe_dino_hdcm))
})
