test_that("dcm_specification class errors when expected", {
  test_qmatrix <- tibble::tibble(
    item = paste0("item_", 1:10),
    node1 = sample(0:1, size = 10, replace = TRUE),
    node2 = sample(0:1, size = 10, replace = TRUE),
    node3 = sample(0:1, size = 10, replace = TRUE)
  )

  expect_error(
    dcm_specify(qmatrix = test_qmatrix),
    "only numeric values of 0 or 1"
  )
  expect_error(
    dcm_specify(
      qmatrix = test_qmatrix,
      identifier = "item",
      measurement_model = "lcdm"
    ),
    "must be a <dcmstan::measurement>"
  )
  expect_error(
    dcm_specify(
      qmatrix = test_qmatrix,
      identifier = "item",
      measurement_model = unconstrained()
    ),
    "must be a <dcmstan::measurement>"
  )
  expect_error(
    dcm_specify(
      qmatrix = test_qmatrix,
      identifier = "item",
      structural_model = "unconstrained"
    ),
    "must be a <dcmstan::structural>"
  )
  expect_error(
    dcm_specify(
      qmatrix = test_qmatrix,
      identifier = "item",
      structural_model = lcdm()
    ),
    "must be a <dcmstan::structural>"
  )
  expect_error(
    dcm_specify(
      qmatrix = test_qmatrix,
      identifier = "item",
      measurement_model = lcdm(),
      structural_model = unconstrained(),
      priors = prior("beta(1, 1)", type = "slip")
    ),
    "types not included"
  )
  expect_error(
    dcm_specify(
      qmatrix = test_qmatrix,
      identifier = "item",
      measurement_model = lcdm(),
      structural_model = unconstrained(),
      priors = prior("beta(1, 1)", type = "intercept", coefficient = "l12_0")
    ),
    "coefficients not included"
  )
  expect_error(
    dcm_specify(
      qmatrix = test_qmatrix,
      identifier = "item",
      measurement_model = lcdm(),
      structural_model = loglinear(),
      priors = prior(
        "beta(1, 1)",
        type = "structural_maineffect",
        coefficient = "g_41234"
      )
    ),
    "coefficients not included"
  )
})

test_that("dcm_specification works", {
  test_qmatrix <- tibble::tibble(
    item = paste0("item_", 1:10),
    node1 = sample(0:1, size = 10, replace = TRUE),
    node2 = sample(0:1, size = 10, replace = TRUE),
    node3 = sample(0:1, size = 10, replace = TRUE)
  )

  spec <- dcm_specify(
    qmatrix = test_qmatrix,
    identifier = "item",
    measurement_model = lcdm(max_interaction = 1),
    structural_model = unconstrained()
  )

  S7::check_is_S7(spec, dcm_specification)
  expect_identical(colnames(spec@qmatrix), paste0("att", 1:3))
  expect_identical(
    names(spec@qmatrix_meta),
    c("attribute_names", "item_identifier", "item_names")
  )
  expect_identical(
    spec@qmatrix_meta$attribute_names,
    rlang::set_names(paste0("att", 1:3), paste0("node", 1:3))
  )
  expect_identical(spec@qmatrix_meta$item_identifier, "item")
  expect_identical(
    spec@qmatrix_meta$item_names,
    rlang::set_names(1:10, paste0("item_", 1:10))
  )
  S7::check_is_S7(spec@measurement_model, measurement)
  expect_identical(spec@measurement_model, lcdm(max_interaction = 1))
  S7::check_is_S7(spec@structural_model, structural)
  expect_identical(spec@structural_model, unconstrained())
  S7::check_is_S7(spec@priors, dcmprior)
  expect_identical(
    spec@priors,
    default_dcm_priors(lcdm(max_interaction = 1), unconstrained())
  )
})

test_that("printing works", {
  test_qmatrix <- tibble::tibble(
    item = paste0("item_", 1:10),
    node1 = c(0L, 1L, 0L, 0L, 0L, 1L, 1L, 1L, 0L, 0L),
    node2 = c(0L, 1L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 1L),
    node3 = c(1L, 1L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 1L)
  )

  unst1 <- dcm_specify(
    qmatrix = test_qmatrix,
    identifier = "item",
    measurement_model = lcdm(max_interaction = 1),
    structural_model = unconstrained()
  )

  test_qmatrix2 <- tibble::tibble(
    question = paste0("item_", 1:10),
    skill_1 = c(1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 0L),
    skill_2 = c(1L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 1L, 0L),
    skill_3 = c(0L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 0L)
  )

  indp1 <- dcm_specify(
    qmatrix = test_qmatrix2,
    identifier = "question",
    measurement_model = dina(),
    structural_model = independent()
  )

  test_qmatrix3 <- tibble::tibble(
    item = paste0("item_", 1:10),
    node1 = c(0L, 1L, 0L, 0L, 0L, 1L, 1L, 1L, 0L, 0L),
    node2 = c(0L, 1L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 1L),
    node3 = c(1L, 1L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 1L)
  )

  logl1 <- dcm_specify(
    qmatrix = test_qmatrix3,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = loglinear()
  )

  logl2 <- dcm_specify(
    qmatrix = test_qmatrix3,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = loglinear(max_interaction = 1)
  )

  logl3 <- dcm_specify(
    qmatrix = test_qmatrix3,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = loglinear(max_interaction = 2)
  )

  hdcm1 <- dcm_specify(
    qmatrix = test_qmatrix,
    identifier = "item",
    measurement_model = lcdm(max_interaction = 1),
    structural_model = hdcm("node3 -> node2 -> node1")
  )

  hdcm2 <- dcm_specify(
    qmatrix = test_qmatrix2,
    identifier = "question",
    measurement_model = dina(),
    structural_model = hdcm(
      "skill_1 -> skill_2
       skill_1 -> skill_3"
    )
  )

  bn1 <- dcm_specify(
    qmatrix = test_qmatrix,
    identifier = "item",
    measurement_model = lcdm(),
    structural_model = bayesnet()
  )

  expect_snapshot({
    unst1
    indp1
    logl1
    logl2
    logl3
    hdcm1
    hdcm2
    bn1
  })
})
