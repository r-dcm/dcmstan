test_that("lcdm script works", {
  ecpe_lcdm_unst <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                                identifier = "item_id",
                                measurement_model = lcdm())
  mdm_lcdm_unst <- dcm_specify(qmatrix = dcmdata::mdm_qmatrix,
                               identifier = "item",
                               measurement_model = lcdm())
  dtmr_lcdm_unst <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                                identifier = "item",
                                measurement_model = lcdm())
  expect_snapshot(stan_code(ecpe_lcdm_unst))
  expect_snapshot(stan_code(mdm_lcdm_unst))
  expect_snapshot(stan_code(dtmr_lcdm_unst))

  ecpe_lcdm_indp <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                                identifier = "item_id",
                                measurement_model = lcdm(),
                                structural_model = independent())
  expect_snapshot(stan_code(ecpe_lcdm_indp))

  dtmr_lcdm_logl <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                                identifier = "item",
                                measurement_model = lcdm(),
                                structural_model = loglinear())
  expect_snapshot(stan_code(dtmr_lcdm_logl))

  ecpe_lcdm_bn <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                              identifier = "item_id",
                              measurement_model = lcdm(),
                              structural_model = bayesnet())
  expect_snapshot(stan_code(ecpe_lcdm_bn))

  # edge case where all items are simple structure
  dtmr_edge <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix %>%
                             dplyr::filter(!(item %in% c("10b", "10c", "13",
                                                         "14", "15a", "17",
                                                         "18", "22"))),
                           identifier = "item",
                           measurement_model = lcdm())
  expect_snapshot(stan_code(dtmr_edge))
})

test_that("crum script works", {
  ecpe_crum_unst <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                                identifier = "item_id",
                                measurement_model = crum())
  mdm_crum_unst <- dcm_specify(qmatrix = dcmdata::mdm_qmatrix,
                               identifier = "item",
                               measurement_model = crum())
  dtmr_crum_unst <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                                identifier = "item",
                                measurement_model = crum())
  expect_snapshot(stan_code(ecpe_crum_unst))
  expect_snapshot(stan_code(mdm_crum_unst))
  expect_snapshot(stan_code(dtmr_crum_unst))

  ecpe_crum_indp <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                                identifier = "item_id",
                                measurement_model = crum(),
                                structural_model = independent())
  expect_snapshot(stan_code(ecpe_crum_indp))

  dtmr_crum_logl <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                                identifier = "item",
                                measurement_model = crum(),
                                structural_model = loglinear())
  expect_snapshot(stan_code(dtmr_crum_logl))

  ecpe_crum_bn <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                              identifier = "item_id",
                              measurement_model = crum(),
                              structural_model = bayesnet())
  expect_snapshot(stan_code(ecpe_crum_bn))
})

test_that("lcdm with hierarchy works", {
  ecpe_lcdm_hdcm <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = lcdm(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  expect_snapshot(stan_code(ecpe_lcdm_hdcm))
})
