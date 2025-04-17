default_data_names <- c("I", "R", "N", "C", "ii", "rr", "y", "start", "num")
extra_data_names <- list(
  independent = c("A", "Alpha"),
  dina = c("Xi"),
  dino = c("Xi")
)

test_that("correct data objects are returned", {
  combos <- expand.grid(meas = meas_choices(), strc = strc_choices(),
                        stringsAsFactors = FALSE)
  for (i in seq_len(nrow(combos))) {
    if (combos$strc[i] != "hdcm") {
      model_spec <- dcm_specify(
        dcmdata::ecpe_qmatrix, identifier = "item_id",
        measurement_model = do.call(combos$meas[i], args = list()),
        structural_model = do.call(combos$strc[i], args = list())
      )
    } else if (combos$meas[i] == "lcdm") {
      model_spec <- dcm_specify(
        dcmdata::ecpe_qmatrix, identifier = "item_id",
        measurement_model =
          do.call(combos$meas[i],
                  args = list(max_interaction = Inf,
                              hierarchy =
                                "lexical -> cohesive -> morphosyntactic")),
        structural_model = do.call(combos$strc[i], args = list())
      )
    } else {
      model_spec <- dcm_specify(
        dcmdata::ecpe_qmatrix, identifier = "item_id",
        measurement_model = do.call(combos$meas[i], args = list(hierarchy = "lexical -> cohesive -> morphosyntactic")),
        structural_model = do.call(combos$strc[i], args = list())
      )
    }

    test_data <- stan_data(model_spec, data = dcmdata::ecpe_data,
                           identifier = "resp_id")
    exp_names <- c(default_data_names,
                   extra_data_names[[combos$meas[i]]],
                   extra_data_names[[combos$strc[i]]])
    expect_identical(names(test_data), exp_names)
  }
})

test_that("correct gqs objects are returned", {
  # dtmr -----------------------------------------------------------------------
  spec <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix, identifier = "item")
  dtmr_dat <- stan_data(generated_quantities(), dcm_spec = spec,
                        data = dcmdata::dtmr_data, identifier = "id")

  expect_equal(names(dtmr_dat),
               c("I", "R", "N", "C", "A", "ii", "rr", "y", "start", "num",
                 "Alpha"))
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
  ecpe_dat <- stan_data(generated_quantities(), dcm_spec = spec,
                        data = dcmdata::ecpe_data, identifier = "resp_id")

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
  model_spec <- dcm_specify(dcmdata::dtmr_qmatrix, identifier = "item",
                            structural_model = independent())
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
  model_spec <- dcm_specify(dcmdata::ecpe_qmatrix, identifier = "item_id",
                            measurement_model = dina())
  dat <- stan_data(model_spec, data = dcmdata::ecpe_data,
                   identifier = "resp_id")

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
      test_xi[r, c] <- prod(profiles[c, ] ^ model_spec@qmatrix[r, ])
    }
  }
  expect_equal(dat$Xi, test_xi)
})

test_that("dino data objects are correct", {
  model_spec <- dcm_specify(dcmdata::ecpe_qmatrix, identifier = "item_id",
                            measurement_model = dino(),
                            structural_model = independent())
  dat <- stan_data(model_spec, data = dcmdata::ecpe_data,
                   identifier = "resp_id")

  expect_equal(names(dat),
               c(default_data_names, extra_data_names$dino,
                 extra_data_names$independent))
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
      test_xi[r, c] <- 1 - prod((1 - profiles[c, ]) ^ model_spec@qmatrix[r, ])
    }
  }
  expect_equal(dat$Xi, test_xi)

  expect_equal(dat$A, 3)
  expect_equal(dat$Alpha, as.matrix(profiles))
})
