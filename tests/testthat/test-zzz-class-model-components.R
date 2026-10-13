test_that("measurement class works", {
  expect_true(S7::S7_inherits(measurement))

  expect_true(S7::S7_inherits(measurement(), measurement))
  expect_true(S7::S7_inherits(lcdm(), measurement))
  expect_true(S7::S7_inherits(dina(), measurement))
  expect_true(S7::S7_inherits(dino(), measurement))
  expect_true(S7::S7_inherits(crum(), measurement))
  expect_true(S7::S7_inherits(nida(), measurement))
  expect_true(S7::S7_inherits(nido(), measurement))
  expect_true(S7::S7_inherits(ncrum(), measurement))

  expect_true(S7::S7_inherits(lcdm(), LCDM))
  expect_true(S7::S7_inherits(dina(), DINA))
  expect_true(S7::S7_inherits(dino(), DINO))
  expect_true(S7::S7_inherits(crum(), CRUM))
  expect_true(S7::S7_inherits(nida(), NIDA))
  expect_true(S7::S7_inherits(nido(), NIDO))
  expect_true(S7::S7_inherits(ncrum(), NCRUM))
})

test_that("measurment class errors", {
  expect_error(
    measurement(
      model = "taylor"
    ),
    "@model must be one of"
  )

  expect_error(
    measurement(
      model = "lcdm",
      model_args = list(taylor = 13)
    ),
    "@model_args contains unknown arguments"
  )
})

test_that("structural class works", {
  expect_true(S7::S7_inherits(structural))

  expect_true(S7::S7_inherits(structural(), structural))
  expect_true(S7::S7_inherits(unconstrained(), structural))
  expect_true(S7::S7_inherits(independent(), structural))
  expect_true(S7::S7_inherits(loglinear(), structural))
  expect_true(S7::S7_inherits(hdcm(), structural))
  expect_true(S7::S7_inherits(bayesnet(), structural))

  expect_true(S7::S7_inherits(unconstrained(), UNCONSTRAINED))
  expect_true(S7::S7_inherits(independent(), INDEPENDENT))
  expect_true(S7::S7_inherits(loglinear(), LOGLINEAR))
  expect_true(S7::S7_inherits(hdcm(), HDCM))
  expect_true(S7::S7_inherits(bayesnet(), BAYESNET))
})

test_that("structural class errors", {
  expect_error(
    structural(
      model = "travis"
    ),
    "@model must be one of"
  )

  expect_error(
    structural(
      model = "hdcm",
      model_args = list(travis = 87)
    ),
    "@model_args contains unknown arguments"
  )
})

test_that("quantities class works", {
  expect_true(S7::S7_inherits(quantities))

  expect_true(S7::S7_inherits(quantities(), quantities))
  expect_true(S7::S7_inherits(generated_quantities(), quantities))

  expect_true(S7::S7_inherits(generated_quantities(), GQS))
})

test_that("quantities class errors", {
  expect_error(
    quantities(model_args = list(taylor = 13)),
    "@model_args contains unknown arguments"
  )
})

test_that("model_property cannot be overwritten", {
  meas_mod <- lcdm()
  expect_error(
    meas_mod@model <- "dina",
    "Can't set read-only property"
  )

  strc_mod <- loglinear()
  expect_error(
    strc_mod@model <- "hdcm",
    "Can't set read-only property"
  )
})

test_that("public model constructors initialize the model once", {
  models <- list(
    lcdm = lcdm,
    dina = dina,
    dino = dino,
    nida = nida,
    nido = nido,
    ncrum = ncrum,
    crum = crum,
    unconstrained = unconstrained,
    independent = independent,
    loglinear = loglinear,
    hdcm = hdcm,
    bayesnet = bayesnet
  )
  for (name in names(models)) {
    x <- models[[name]]()
    expect_identical(x@model, name)
    if (name %in% c("lcdm", "loglinear")) {
      expect_identical(x@model_args, list(max_interaction = Inf))
    } else if (name %in% c("hdcm", "bayesnet")) {
      expect_identical(x@model_args, list(hierarchy = NULL))
    } else {
      expect_identical(x@model_args, list())
    }
    error <- tryCatch(
      {
        x@model <- "changed"
        NULL
      },
      error = identity
    )
    expect_s3_class(error, "error")
    expect_match(
      conditionMessage(error),
      "Can't set read-only property",
      fixed = TRUE
    )
    expect_identical(x@model, name)
  }
  expect_identical(
    lcdm(max_interaction = 2)@model_args,
    list(max_interaction = 2)
  )
  expect_identical(
    loglinear(max_interaction = 1)@model_args,
    list(max_interaction = 1)
  )
  hierarchy <- "att1 -> att2 -> att3"
  expect_identical(
    hdcm(hierarchy = hierarchy)@model_args,
    list(hierarchy = hierarchy)
  )
  expect_identical(
    bayesnet(hierarchy = hierarchy)@model_args,
    list(hierarchy = hierarchy)
  )
})

test_that("public models retain parent validation", {
  error_message <- function(expr) {
    error <- tryCatch(expr, error = identity)
    expect_s3_class(error, "error")
    conditionMessage(error)
  }
  expect_snapshot({
    model <- S7::S7_class(dina())
    cat(error_message(model(model = "unknown")), "\n", sep = "")
    model <- S7::S7_class(loglinear())
    cat(error_message(model(model = "unknown")), "\n", sep = "")
    x <- dina()
    cat(
      error_message(x@model_args <- list(max_interaction = 1)),
      "\n",
      sep = ""
    )
    x <- loglinear()
    cat(
      error_message(x@model_args <- list(hierarchy = "att1 -> att2")),
      "\n",
      sep = ""
    )
  })
})
