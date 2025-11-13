test_that("class is defined correctly", {
  expect_true(S7::S7_inherits(dcmprior))

  expect_true(S7::S7_inherits(dcmprior(), dcmprior))
  expect_error(dcmprior("beta"), "complete distribution statement")
  expect_error(
    dcmprior(
      "normal(0, 2)",
      type = "maineffect",
      lower_bound = 5,
      upper_bound = 1
    ),
    "@lower_bound must be less than @upper_bound"
  )
})

test_that("define priors", {
  expect_true(S7::S7_inherits(prior("beta(1, 1)", type = "slip"), dcmprior))
  expect_true(S7::S7_inherits(prior("normal(0, 2)", type = "guess"), dcmprior))

  p <- prior("normal(0, 2)", type = "interaction")
  expect_identical(p@prior, "normal(0, 2)")

  p <- prior("student_t(2.5, 1, 2)", type = "intercept", lower_bound = 0)
  expect_identical(p@prior, "student_t(2.5, 1, 2)T[0,]")

  p <- prior(
    "lognormal(0, 5)",
    type = "maineffect",
    lower_bound = 2,
    upper_bound = 5
  )
  expect_identical(p@prior, "lognormal(0, 5)T[2,5]")

  p <- prior("uniform(0, 20)", type = "intercept", upper_bound = 3)
  expect_identical(p@prior, "uniform(0, 20)T[,3]")
})

test_that("priors from variables works", {
  my_prior <- "normal(0, 2)"
  expect_identical(
    prior("normal(0, 2)", type = "intercept"),
    prior_string(my_prior, type = "intercept")
  )

  my_prior <- "beta(5, 25)"
  expect_identical(
    prior("beta(5, 25)", type = "slip"),
    prior_string(my_prior, type = "slip")
  )

  my_prior <- "lognormal(0, 5)"
  expect_identical(
    prior("lognormal(0, 5)", type = "maineffect"),
    prior_string(my_prior, type = "maineffect")
  )
})

# default priors work selectively ----------------------------------------------
test_that("specify only measurement or structural", {
  expect_equal(
    default_dcm_priors(measurement_model = lcdm()),
    lcdm_priors(max_interaction = Inf)
  )
  expect_equal(default_dcm_priors(measurement_model = ncrum()), ncrum_priors())
  expect_equal(default_dcm_priors(measurement_model = dina()), dina_priors())
  expect_equal(default_dcm_priors(measurement_model = dino()), dino_priors())
  expect_equal(default_dcm_priors(measurement_model = crum()), crum_priors())
  expect_equal(default_dcm_priors(measurement_model = nida()), nida_priors())
  expect_equal(default_dcm_priors(measurement_model = nido()), nido_priors())

  expect_equal(
    default_dcm_priors(structural_model = unconstrained()),
    unconstrained_priors()
  )
  expect_equal(
    default_dcm_priors(structural_model = independent()),
    independent_priors()
  )
  expect_equal(
    default_dcm_priors(structural_model = loglinear()),
    loglinear_priors(max_interaction = Inf)
  )
  expect_equal(
    default_dcm_priors(structural_model = hdcm()),
    hdcm_priors()
  )
  expect_equal(
    default_dcm_priors(structural_model = bayesnet()),
    bayesnet_priors(hierarchy = NULL)
  )

  expect_equal(
    default_dcm_priors(
      measurement_model = crum(),
      structural_model = unconstrained()
    ),
    c(crum_priors(), unconstrained_priors())
  )
})

# measurement model priors -----------------------------------------------------
test_that("lcdm default priors", {
  expect_identical(
    prior_tibble(lcdm_priors(max_interaction = Inf)),
    tibble::tibble(
      type = c("intercept", "maineffect", "interaction"),
      coefficient = NA_character_,
      prior = c("normal(0, 2)", "lognormal(0, 1)", "normal(0, 2)")
    )
  )

  expect_identical(
    prior_tibble(lcdm_priors(max_interaction = 1)),
    tibble::tibble(
      type = c("intercept", "maineffect"),
      coefficient = NA_character_,
      prior = c("normal(0, 2)", "lognormal(0, 1)")
    )
  )
})

test_that("ncrum default priors", {
  expect_identical(
    prior_tibble(ncrum_priors()),
    tibble::tibble(
      type = c("baseline", "penalty"),
      coefficient = NA_character_,
      prior = c("beta(15, 3)", "beta(2, 2)")
    )
  )
})

test_that("dina default priors", {
  expect_identical(
    prior_tibble(dina_priors()),
    tibble::tibble(
      type = c("slip", "guess"),
      coefficient = NA_character_,
      prior = c("beta(5, 25)", "beta(5, 25)")
    )
  )
})

test_that("dino default priors", {
  expect_identical(
    prior_tibble(dino_priors()),
    tibble::tibble(
      type = c("slip", "guess"),
      coefficient = NA_character_,
      prior = c("beta(5, 25)", "beta(5, 25)")
    )
  )
})

test_that("crum default priors", {
  expect_identical(
    prior_tibble(crum_priors()),
    tibble::tibble(
      type = c("intercept", "maineffect"),
      coefficient = NA_character_,
      prior = c("normal(0, 2)", "lognormal(0, 1)")
    )
  )
})

test_that("nida default priors", {
  expect_identical(
    prior_tibble(nida_priors()),
    tibble::tibble(
      type = c("slip", "guess"),
      coefficient = NA_character_,
      prior = c("beta(5, 25)", "beta(5, 25)")
    )
  )
})

test_that("nido default priors", {
  expect_identical(
    prior_tibble(nido_priors()),
    tibble::tibble(
      type = c("intercept", "maineffect"),
      coefficient = NA_character_,
      prior = c("normal(0, 2)", "lognormal(0, 1)")
    )
  )
})

# structural model priors ------------------------------------------------------
test_that("unconstrained default priors", {
  expect_identical(
    prior_tibble(unconstrained_priors()),
    tibble::tibble(
      type = c("structural"),
      coefficient = "Vc",
      prior = c("dirichlet(rep_vector(1, C))")
    )
  )
})

test_that("independent default priors", {
  expect_identical(
    prior_tibble(independent_priors()),
    tibble::tibble(
      type = c("structural"),
      coefficient = NA_character_,
      prior = c("beta(1, 1)")
    )
  )
})

test_that("loglinear default priors", {
  expect_identical(
    prior_tibble(loglinear_priors(max_interaction = Inf)),
    tibble::tibble(
      type = c("structural_maineffect", "structural_interaction"),
      coefficient = NA_character_,
      prior = c("normal(0, 10)", "normal(0, 10)")
    )
  )

  expect_identical(
    prior_tibble(loglinear_priors(max_interaction = 1)),
    tibble::tibble(
      type = c("structural_maineffect"),
      coefficient = NA_character_,
      prior = c("normal(0, 10)")
    )
  )
})

test_that("hdcm default priors", {
  expect_identical(
    prior_tibble(hdcm_priors()),
    tibble::tibble(
      type = c("structural"),
      coefficient = "Vc",
      prior = c("dirichlet(rep_vector(1, C))")
    )
  )
})

test_that("bayesnet default priors", {
  expect_identical(
    prior_tibble(bayesnet_priors(hierarchy = NULL)),
    tibble::tibble(
      type = c(
        "structural_intercept",
        "structural_maineffect",
        "structural_interaction"
      ),
      coefficient = NA_character_,
      prior = c("normal(0, 2)", "lognormal(0, 1)", "normal(0, 2)")
    )
  )
})

# prior methods ----------------------------------------------------------------
test_that("prior_tibble works", {
  my_prior <- prior("normal(0, 1)", type = "intercept")
  prior_tib <- prior_tibble(my_prior)

  expect_true(tibble::is_tibble(prior_tib))
  expect_equal(colnames(prior_tib), c("type", "coefficient", "prior"))
  expect_equal(
    colnames(prior_tibble(my_prior, .keep_all = TRUE)),
    c(
      "distribution",
      "type",
      "coefficient",
      "lower_bound",
      "upper_bound",
      "prior"
    )
  )
})

test_that("printing works", {
  expect_snapshot({
    my_prior <- prior("normal(0, 1)", type = "intercept")
    my_prior
    print(my_prior)

    bigger_prior <- c(
      prior("normal(0, 5)", type = "intercept"),
      prior("lognormal(0, 1)", type = "maineffect")
    )
    bigger_prior
    print(bigger_prior)
  })
})

test_that("c works", {
  prior1 <- prior(
    "cauchy(0, 1)",
    type = "slip",
    lower_bound = 0,
    upper_bound = 1
  )

  err <- rlang::catch_cnd(c(prior1, mtcars))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "must be .*dcmprior.* objects")

  prior2 <- prior("beta(5, 17)", type = "guess")
  prior3 <- prior("beta(5, 17)", type = "slip")

  full_prior <- c(prior1, prior2, prior3)
  dstc_prior <- c(prior1, prior2, prior3, replace = TRUE)

  expect_equal(length(full_prior@distribution), 3)
  expect_equal(full_prior@prior, prior_tibble(full_prior)$prior)

  expect_equal(length(dstc_prior@distribution), 2)
  expect_equal(dstc_prior@prior, prior_tibble(dstc_prior)$prior)

  expect_equal(
    dplyr::bind_rows(
      prior_tibble(prior1),
      prior_tibble(prior2),
      prior_tibble(prior3)
    ),
    prior_tibble(full_prior)
  )
  expect_equal(
    dplyr::bind_rows(prior_tibble(prior1), prior_tibble(prior2)),
    prior_tibble(dstc_prior)
  )
})
