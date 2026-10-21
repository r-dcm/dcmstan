default_data_names <- c("I", "R", "N", "C", "ii", "rr", "y", "start", "num")
extra_data_names <- list(
  independent = c("A", "Alpha"),
  dina = c("Xi"),
  dino = c("Xi"),
  nida = c("A")
)

test_that("correct data objects are returned", {
  combos <- expand.grid(
    meas = meas_choices(),
    strc = strc_choices(),
    stringsAsFactors = FALSE
  )
  for (i in seq_len(nrow(combos))) {
    model_spec <- dcm_specify(
      dcmdata::mdm_qmatrix,
      identifier = "item",
      measurement_model = do.call(combos$meas[i], args = list()),
      structural_model = do.call(combos$strc[i], args = list())
    )

    test_data <- stan_data(
      model_spec,
      data = dcmdata::mdm_data,
      identifier = "respondent"
    )
    exp_names <- c(
      default_data_names,
      extra_data_names[[combos$meas[i]]],
      extra_data_names[[combos$strc[i]]]
    )
    expect_identical(names(test_data), exp_names)
  }
})

test_that("correct gqs objects are returned", {
  # dtmr -----------------------------------------------------------------------
  spec <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix, identifier = "item")
  dtmr_dat <- stan_data(
    generated_quantities(),
    dcm_spec = spec,
    data = dcmdata::dtmr_data,
    identifier = "id"
  )

  expect_equal(
    names(dtmr_dat),
    c("I", "R", "N", "C", "A", "ii", "rr", "y", "start", "num", "Alpha")
  )
  expect_equal(dtmr_dat$I, 27)
  expect_equal(dtmr_dat$R, 990)
  expect_equal(dtmr_dat$N, 27 * 990)
  expect_equal(dtmr_dat$C, 16)
  expect_equal(dtmr_dat$A, 4)
  expect_equal(dtmr_dat$ii, rep(1:27, 990))
  expect_equal(dtmr_dat$rr, rep(1:990, each = 27))
  expect_true(all(dtmr_dat$y %in% c(0, 1)))
  expect_equal(dtmr_dat$start, seq(1, 27 * 990, by = 27))
  expect_equal(dtmr_dat$num, rep(27, 990))
  expect_equal(dtmr_dat$Alpha, as.matrix(create_profiles(4)))

  # ecpe -----------------------------------------------------------------------
  spec <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix, identifier = "item_id")
  ecpe_dat <- stan_data(
    generated_quantities(),
    dcm_spec = spec,
    data = dcmdata::ecpe_data,
    identifier = "resp_id"
  )

  expect_equal(ecpe_dat$I, 28)
  expect_equal(ecpe_dat$R, 2922)
  expect_equal(ecpe_dat$N, 28 * 2922)
  expect_equal(ecpe_dat$C, 8)
  expect_equal(ecpe_dat$A, 3)
  expect_equal(ecpe_dat$ii, rep(1:28, 2922))
  expect_equal(ecpe_dat$rr, rep(1:2922, each = 28))
  expect_true(all(ecpe_dat$y %in% c(0, 1)))
  expect_equal(ecpe_dat$start, seq(1, 28 * 2922, by = 28))
  expect_equal(ecpe_dat$num, rep(28, 2922))
  expect_equal(ecpe_dat$Alpha, as.matrix(create_profiles(3)))
})

test_that("independent data objects are correct", {
  model_spec <- dcm_specify(
    dcmdata::dtmr_qmatrix,
    identifier = "item",
    structural_model = independent()
  )
  dat <- stan_data(model_spec, data = dcmdata::dtmr_data, identifier = "id")

  expect_equal(dat$I, 27)
  expect_equal(dat$R, 990)
  expect_equal(dat$N, 27 * 990)
  expect_equal(dat$C, 16)
  expect_equal(dat$ii, rep(1:27, 990))
  expect_equal(dat$rr, rep(1:990, each = 27))
  expect_true(all(dat$y %in% c(0, 1)))
  expect_equal(dat$start, seq(1, 27 * 990, by = 27))
  expect_equal(dat$num, rep(27, 990))
  expect_equal(dat$A, 4)
  expect_equal(dat$Alpha, as.matrix(create_profiles(4)))
})

test_that("dina data objects are correct", {
  model_spec <- dcm_specify(
    dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dina()
  )
  dat <- stan_data(
    model_spec,
    data = dcmdata::ecpe_data,
    identifier = "resp_id"
  )

  expect_equal(dat$I, 28)
  expect_equal(dat$R, 2922)
  expect_equal(dat$N, 28 * 2922)
  expect_equal(dat$C, 8)
  expect_equal(dat$ii, rep(1:28, 2922))
  expect_equal(dat$rr, rep(1:2922, each = 28))
  expect_true(all(dat$y %in% c(0, 1)))
  expect_equal(dat$start, seq(1, 28 * 2922, by = 28))
  expect_equal(dat$num, rep(28, 2922))

  profiles <- create_profiles(3)
  test_xi <- matrix(data = NA, nrow = 28, ncol = 8)
  for (r in seq_len(28)) {
    for (c in seq_len(8)) {
      test_xi[r, c] <- prod(profiles[c, ]^model_spec@qmatrix[r, ])
    }
  }
  expect_equal(dat$Xi, test_xi)
})

test_that("dino data objects are correct", {
  model_spec <- dcm_specify(
    dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = dino(),
    structural_model = independent()
  )
  dat <- stan_data(
    model_spec,
    data = dcmdata::ecpe_data,
    identifier = "resp_id"
  )

  expect_equal(
    names(dat),
    c(default_data_names, extra_data_names$dino, extra_data_names$independent)
  )
  expect_equal(dat$I, 28)
  expect_equal(dat$R, 2922)
  expect_equal(dat$N, 28 * 2922)
  expect_equal(dat$C, 8)
  expect_equal(dat$ii, rep(1:28, 2922))
  expect_equal(dat$rr, rep(1:2922, each = 28))
  expect_true(all(dat$y %in% c(0, 1)))
  expect_equal(dat$start, seq(1, 28 * 2922, by = 28))
  expect_equal(dat$num, rep(28, 2922))

  profiles <- create_profiles(3)
  test_xi <- matrix(data = NA, nrow = 28, ncol = 8)
  for (r in seq_len(28)) {
    for (c in seq_len(8)) {
      test_xi[r, c] <- 1 - prod((1 - profiles[c, ])^model_spec@qmatrix[r, ])
    }
  }
  expect_equal(dat$Xi, test_xi)

  expect_equal(dat$A, 3)
  expect_equal(dat$Alpha, as.matrix(profiles))
})

test_that("hdcm data objects are correct", {
  model_spec <- dcm_specify(
    dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    measurement_model = lcdm(),
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  dat <- stan_data(
    model_spec,
    data = dcmdata::ecpe_data,
    identifier = "resp_id"
  )

  expect_equal(names(dat), c(default_data_names))
  expect_equal(dat$I, 28)
  expect_equal(dat$R, 2922)
  expect_equal(dat$N, 28 * 2922)
  expect_equal(dat$C, 4)
  expect_equal(dat$ii, rep(1:28, 2922))
  expect_equal(dat$rr, rep(1:2922, each = 28))
  expect_true(all(dat$y %in% c(0, 1)))
  expect_equal(dat$start, seq(1, 28 * 2922, by = 28))
  expect_equal(dat$num, rep(28, 2922))
})

test_that("constraint data objects are correct", {
  model_spec <- dcm_specify(
    dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = lcdm(),
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
      missing = NA,
      thresholds = tibble::tibble(
        classification = c(1L, 0L),
        threshold = c(0.80, 0.35)
      ),
      pattern_identifier = NULL,
      attribute_identifier = "attribute",
      classification_identifier = "classification",
      threshold_identifier = "threshold"
    )
  )
  dat <- stan_data(
    model_spec,
    data = dcmdata::mdm_data,
    identifier = "respondent"
  )

  extra_cnst_names <-
    c("R_patt", "N_patt", "ii_patt", "rr_patt", "y_patt", "start_patt",
      "num_patt",
      "R_0", "N_0", "aa_0", "rr_0", "start_0", "num_0", "tau_0",
      "R_1", "N_1", "aa_1", "rr_1", "start_1", "num_1", "tau_1")

  expect_equal(names(dat), c(default_data_names, extra_cnst_names))
  expect_equal(dat$R_patt, 2)
  expect_equal(dat$N_patt, 2 * 4)
  expect_equal(dat$ii_patt, rep(1:4, 2))
  expect_equal(dat$rr_patt, rep(1:2, each = 4))
  expect_true(all(dat$y_patt %in% c(0, 1)))
  expect_equal(dat$start_patt, seq(1, 2 * 4, by = 4))
  expect_equal(dat$num_patt, rep(4, 2))
  expect_equal(dat$R_0, 1)
  expect_equal(dat$N_0, 1)
  expect_equal(dat$aa_0, 1)
  expect_equal(dat$rr_0, 1)
  expect_equal(dat$start_0, c(1,0))
  expect_equal(dat$num_0, c(1,0))
  expect_equal(dat$R_1, 1)
  expect_equal(dat$N_1, 1)
  expect_equal(dat$aa_1, 1)
  expect_equal(dat$rr_1, 2)
  expect_equal(dat$start_1, c(0,1))
  expect_equal(dat$num_1, c(0,1))

  model_spec <- dcm_specify(
    dcmdata::mdm_qmatrix,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = unconstrained(),
    scoring_constraint = posterior(
      constraints = tibble::tibble(
        mdm1 = c(1),
        mdm2 = c(1),
        mdm3 = c(1),
        mdm4 = c(1),
        attribute = c("multiplication"),
        classification = c(1L)
      ),
      missing = NA,
      thresholds = tibble::tibble(
        classification = c(1L),
        threshold = c(0.80)
      ),
      pattern_identifier = NULL,
      attribute_identifier = "attribute",
      classification_identifier = "classification",
      threshold_identifier = "threshold"
    )
  )
  dat <- stan_data(
    model_spec,
    data = dcmdata::mdm_data,
    identifier = "respondent"
  )

  extra_cnst_names <-
    c("R_patt", "N_patt", "ii_patt", "rr_patt", "y_patt", "start_patt",
      "num_patt",
      "R_1", "N_1", "aa_1", "rr_1", "start_1", "num_1", "tau_1")

  expect_equal(names(dat), c(default_data_names, extra_cnst_names))
})
