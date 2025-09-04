test_that("nida script works", {
  ecpe_spec <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = nida()
  )
  mdm_spec <- dcm_specify(
    qmatrix = dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = nida()
  )
  dtmr_spec <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = nida()
  )
  expect_snapshot(stan_code(ecpe_spec))
  expect_snapshot(stan_code(mdm_spec))
  expect_snapshot(stan_code(dtmr_spec))

  ecpe_spec2 <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = nida(),
    structural_model = independent()
  )
  expect_snapshot(stan_code(ecpe_spec2))

  # edge case where all items are simple structure
  dtmr_spec2 <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix |>
      dplyr::filter(
        !(item %in% c("10b", "10c", "13", "14", "15a", "17", "18", "22"))
      ),
    identifier = "item",
    measurement_model = nida()
  )
  expect_snapshot(stan_code(dtmr_spec2))
})
