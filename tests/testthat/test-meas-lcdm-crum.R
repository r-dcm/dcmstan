test_that("lcdm script works", {
  ecpe_lcdm_unst <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = lcdm()
  )
  mdm_lcdm_unst <- dcm_specify(
    qmatrix = dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = lcdm()
  )
  dtmr_lcdm_unst <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = lcdm()
  )
  expect_snapshot(stan_code(ecpe_lcdm_unst))
  expect_snapshot(stan_code(mdm_lcdm_unst))
  expect_snapshot(stan_code(dtmr_lcdm_unst))

  ecpe_lcdm_indp <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = lcdm(),
    structural_model = independent()
  )
  expect_snapshot(stan_code(ecpe_lcdm_indp))

  dtmr_lcdm_logl <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = loglinear()
  )
  expect_snapshot(stan_code(dtmr_lcdm_logl))

  # edge case where all items are simple structure
  dtmr_edge <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix |>
      dplyr::filter(
        !(item %in% c("10b", "10c", "13", "14", "15a", "17", "18", "22"))
      ),
    identifier = "item",
    measurement_model = lcdm()
  )
  expect_snapshot(stan_code(dtmr_edge))
})

test_that("crum script works", {
  ecpe_crum_unst <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = crum()
  )
  mdm_crum_unst <- dcm_specify(
    qmatrix = dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = crum()
  )
  dtmr_crum_unst <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = crum()
  )
  expect_snapshot(stan_code(ecpe_crum_unst))
  expect_snapshot(stan_code(mdm_crum_unst))
  expect_snapshot(stan_code(dtmr_crum_unst))

  ecpe_crum_indp <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = crum(),
    structural_model = independent()
  )
  expect_snapshot(stan_code(ecpe_crum_indp))

  dtmr_crum_logl <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = crum(),
    structural_model = loglinear()
  )
  expect_snapshot(stan_code(dtmr_crum_logl))
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

  ecpe_ldcm_hdcm_conv <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = lcdm(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive lexical -> morphosyntactic"
    )
  )
  expect_snapshot(stan_code(ecpe_ldcm_hdcm_conv))

  ecpe_ldcm_hdcm_div <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = lcdm(),
    structural_model = hdcm(
      hierarchy = "lexical -> morphosyntactic cohesive -> morphosyntactic"
    )
  )
  expect_snapshot(stan_code(ecpe_ldcm_hdcm_div))

  ecpe_ldcm_hdcm_sep <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = lcdm(),
    structural_model = hdcm(
      hierarchy = "lexical -> morphosyntactic
                   cohesive"
    )
  )
  expect_snapshot(stan_code(ecpe_ldcm_hdcm_sep))

  dtmr_lcdm_comp <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = hdcm(
      hierarchy =
        "referent_units -> appropriateness -> multiplicative_comparison
         partitioning_iterating -> appropriateness"
    )
  )
  expect_snapshot(stan_code(dtmr_lcdm_comp))

  dtmr_lcdm_4att_div <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = hdcm(
      hierarchy =
        "referent_units -> appropriateness
         referent_units -> multiplicative_comparison
         referent_units -> partitioning_iterating"
    )
  )
  expect_snapshot(stan_code(dtmr_lcdm_4att_div))

  dtmr_lcdm_4att_conv <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = hdcm(
      hierarchy =
        "referent_units -> appropriateness
         multiplicative_comparison -> appropriateness
         partitioning_iterating -> appropriateness"
    )
  )
  expect_snapshot(stan_code(dtmr_lcdm_4att_conv))

  dtmr_lcdm_partial_linear <- dcm_specify(
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = hdcm(
      hierarchy =
        "referent_units -> appropriateness -> multiplicative_comparison
         partitioning_iterating"
    )
  )
  expect_snapshot(stan_code(dtmr_lcdm_partial_linear))
})

test_that("crum with hierarchy works", {
  ecpe_crum_hdcm <- dcm_specify(
    qmatrix = dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = crum(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  expect_snapshot(stan_code(ecpe_crum_hdcm))
})
