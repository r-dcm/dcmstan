test_that("lcdm script works", {
  ecpe_spec <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                           identifier = "item_id",
                           measurement_model = lcdm())
  mdm_spec <- dcm_specify(qmatrix = dcmdata::mdm_qmatrix,
                          identifier = "item",
                          measurement_model = lcdm())
  dtmr_spec <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                           identifier = "item",
                           measurement_model = lcdm())
  expect_snapshot(generate_stan(ecpe_spec))
  expect_snapshot(generate_stan(mdm_spec))
  expect_snapshot(generate_stan(dtmr_spec))

  ecpe_spec2 <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                            identifier = "item_id",
                            measurement_model = lcdm(),
                            structural_model = independent())
  expect_snapshot(generate_stan(ecpe_spec2))
  dtmr_spec2 <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix %>%
                              dplyr::filter(!(item %in% c("10b", "10c", "13",
                                                          "14", "15a", "17",
                                                          "18", "22"))),
                            identifier = "item",
                            measurement_model = lcdm())
  expect_snapshot(generate_stan(dtmr_spec2))
})

test_that("crum script works", {
  ecpe_spec <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                           identifier = "item_id",
                           measurement_model = crum())
  mdm_spec <- dcm_specify(qmatrix = dcmdata::mdm_qmatrix,
                          identifier = "item",
                          measurement_model = crum())
  dtmr_spec <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix,
                           identifier = "item",
                           measurement_model = crum())
  expect_snapshot(generate_stan(ecpe_spec))
  expect_snapshot(generate_stan(mdm_spec))
  expect_snapshot(generate_stan(dtmr_spec))

  ecpe_spec2 <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                            identifier = "item_id",
                            measurement_model = crum(),
                            structural_model = independent())
  expect_snapshot(generate_stan(ecpe_spec2))
})
