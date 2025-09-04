test_that("check_hierarchy", {
  err <- rlang::catch_cnd(check_hierarchy(2))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "a single string")

  err <- rlang::catch_cnd(check_hierarchy(c("x -> y", "y -> z")))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "a single string")

  err <- rlang::catch_cnd(check_hierarchy("x <-> y -> z"))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "not be cyclical")

  err <- rlang::catch_cnd(check_hierarchy("a -> b -> c -> d -> b  d -> e"))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "not be cyclical")

  expect_null(check_hierarchy("x -> y -> z"))
})

test_that("check hierarchy names", {
  err <- rlang::catch_cnd(check_hierarchy_names(3, paste0("att", 1:3)))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "a single string")

  err <- rlang::catch_cnd(check_hierarchy_names("1 -> 2 -> 3", 1:3))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "a character vector")

  err <- rlang::catch_cnd(
    check_hierarchy_names(
      "red -> yellow -> blue",
      attribute_names = c("red", "yellow")
    )
  )
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "only include attributes")
  expect_match(err$footer, "blue")

  err <- rlang::catch_cnd(
    check_hierarchy_names(
      "red -> yellow -> blue",
      attribute_names = c("red", "yellow", "blue", "green")
    )
  )
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "include all attributes")
  expect_match(err$footer, "green")

  expect_null(
    check_hierarchy_names(
      "red -> yellow -> blue",
      attribute_names = c("blue", "red", "yellow")
    )
  )
})

test_that("check hierarchy names in specification", {
  err <- rlang::catch_cnd(
    dcm_specify(
      qmatrix = dcmdata::ecpe_qmatrix,
      identifier = "item_id",
      structural_model = hdcm("lexcial -> cohesive -> morphosyntactic")
    )
  )
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "only include attributes")
  expect_match(err$footer, "lexcial")

  err <- rlang::catch_cnd(
    dcm_specify(
      qmatrix = dcmdata::mdm_qmatrix,
      identifier = "item",
      structural_model = hdcm("division")
    )
  )
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "only include attributes")
  expect_match(err$footer, "division")

  err <- rlang::catch_cnd(
    dcm_specify(
      qmatrix = dcmdata::dtmr_qmatrix,
      identifier = "item",
      structural_model = hdcm(
        "referent_units -> partitioning_iterating <- appropriateness"
      )
    )
  )
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "include all attributes")
  expect_match(err$footer, "multiplicative_comparison")

  expect_true(S7::S7_inherits(
    dcm_specify(
      qmatrix = dcmdata::ecpe_qmatrix,
      identifier = "item_id",
      structural_model = hdcm("lexical -> cohesive -> morphosyntactic")
    ),
    dcm_specification
  ))
})
