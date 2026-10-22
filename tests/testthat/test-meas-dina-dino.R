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

  ecpe_dina_hdcm <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dina(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  expect_equal(stan_code(ecpe_dina_hdcm), stan_code(ecpe_dina_unst))

  ecpe_dina_bn <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dina(),
    structural_model = bayesnet()
  )
  expect_snapshot(stan_code(ecpe_dina_bn))

  ecpe_dina_bn_hier <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dina(),
    structural_model = bayesnet(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  expect_snapshot(stan_code(ecpe_dina_bn_hier))
})

test_that("dina with posterior-space constraints works", {
  mdm_dina_posterior_constrain <- dcm_specify(
    dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = dina(),
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
  expect_snapshot(stan_code(mdm_dina_posterior_constrain))
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

  ecpe_dino_bn <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dino(),
    structural_model = bayesnet()
  )
  expect_snapshot(stan_code(ecpe_dino_bn))

  ecpe_dino_hdcm <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dino(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  expect_equal(stan_code(ecpe_dino_hdcm), stan_code(ecpe_dino_unst))
})

test_that("dina with posterior-space constraints works", {
  mdm_dino_posterior_constrain <- dcm_specify(
    dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = dino(),
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
  expect_snapshot(stan_code(mdm_dino_posterior_constrain))
})
