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
  expect_null(check_hierarchy(x = NULL, allow_null = TRUE))
  expect_null(check_hierarchy(x = "a ; b"))
})

test_that("determine_hierarchy_type", {
  expect_null(determine_hierarchy_type(x = NULL, allow_null = TRUE))
  expect_null(determine_hierarchy_type(x = "a ; b"))

  hier1 <- determine_hierarchy_type(x = "a -> c; b -> c; c -> d; c -> e; f")
  expect_equal(hier1$attribute, c("a", "b", "c", "d", "e"))
  expect_equal(hier1$type, c("origin", "origin", "complex", "end", "end"))
  expect_equal(
    tidyr::unnest(hier1, converging_peers)$converging_peers,
    c("b", "a", NA, NA, NA)
  )
  expect_equal(
    tidyr::unnest(hier1, diverging_peers)$diverging_peers,
    c(NA, NA, NA, "e", "d")
  )
  expect_equal(
    tidyr::unnest(hier1, parents)$parents,
    c(NA, NA, "a", "b", "c", "c")
  )
  expect_equal(
    tidyr::unnest(hier1, children)$children,
    c("c", "c", "d", "e", rep(NA, 2))
  )

  hier2 <- determine_hierarchy_type(x = "a -> b -> c -> d -> e")
  expect_equal(hier2$attribute, c("a", "b", "c", "d", "e"))
  expect_equal(hier2$type, c("origin", "linear", "linear", "linear", "end"))
  expect_equal(
    tidyr::unnest(hier2, converging_peers)$converging_peers,
    rep(NA_character_, 5)
  )
  expect_equal(
    tidyr::unnest(hier2, diverging_peers)$diverging_peers,
    rep(NA_character_, 5)
  )
  expect_equal(tidyr::unnest(hier2, parents)$parents, c(NA, "a", "b", "c", "d"))
  expect_equal(
    tidyr::unnest(hier2, children)$children,
    c("b", "c", "d", "e", NA)
  )

  hier3 <- determine_hierarchy_type(x = "a -> e; b -> e; c -> e; d -> e")
  expect_equal(hier3$attribute, c("a", "b", "c", "d", "e"))
  expect_equal(
    hier3$type,
    c("origin", "origin", "origin", "origin", "converging")
  )
  expect_equal(
    tidyr::unnest(hier3, converging_peers)$converging_peers,
    c("b", "c", "d", "a", "c", "d", "a", "b", "d", "a", "b", "c", NA)
  )
  expect_equal(
    tidyr::unnest(hier3, diverging_peers)$diverging_peers,
    rep(NA_character_, 5)
  )
  expect_equal(
    tidyr::unnest(hier3, parents)$parents,
    c(rep(NA, 4), "a", "b", "c", "d")
  )
  expect_equal(tidyr::unnest(hier3, children)$children, c(rep("e", 4), NA))

  hier4 <- determine_hierarchy_type(x = "a -> b; a -> c; a -> d; a -> e")
  expect_equal(hier4$attribute, c("a", "b", "c", "d", "e"))
  expect_equal(hier4$type, c("diverging", "end", "end", "end", "end"))
  expect_equal(
    tidyr::unnest(hier4, converging_peers)$converging_peers,
    rep(NA_character_, 5)
  )
  expect_equal(
    tidyr::unnest(hier4, diverging_peers)$diverging_peers,
    c(NA, "c", "d", "e", "b", "d", "e", "b", "c", "e", "b", "c", "d")
  )
  expect_equal(tidyr::unnest(hier4, parents)$parents, c(NA, rep("a", 4)))
  expect_equal(
    tidyr::unnest(hier4, children)$children,
    c("b", "c", "d", "e", rep(NA, 4))
  )
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
