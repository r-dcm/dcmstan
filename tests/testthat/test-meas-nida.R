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

test_that("nida with hierarchy works", {
  ecpe_nida_hdcm <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = nida(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  expect_snapshot(stan_code(ecpe_nida_hdcm))
})

test_that("nida with posterior-space constraints works", {
  mdm_nida_posterior_constrain <- dcm_specify(
    dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = nida(),
    structural_model = unconstrained(),
    scoring_constraint = posterior(
      constraints = tibble::tibble(
        mdm1 = c(1, 0),
        mdm2 = c(1, 0),
        mdm3 = c(1, 0),
        mdm4 = c(1, 0),
        attribute = c("multiplication", "multiplication"),
        classification = c(1L, 0L)
      ),
      thresholds = tibble::tibble(
        classification = c(1L, 0L),
        threshold = c(0.70, 0.30)
      ),
      pattern_identifier = NULL,
      attribute_identifier = "attribute",
      classification_identifier = "classification",
      threshold_identifier = "threshold"
    )
  )
  expect_snapshot(stan_code(mdm_nida_posterior_constrain))
})
