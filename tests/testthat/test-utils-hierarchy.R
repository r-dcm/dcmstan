test_that("get_att_labels function works - identifier", {
  exp_labels <- tibble::tibble(att = c("att1", "att2", "att3"),
                               att_label = c("morphosyntactic", "cohesive",
                                             "lexical"))

  labels <- get_att_labels(dcmdata::ecpe_qmatrix,
                           identifier = "item_id")

  testthat::expect_equal(labels, exp_labels)
})

test_that("get_att_labels function works - no identifier", {
  exp_labels <- tibble::tibble(att = c("att1", "att2", "att3"),
                               att_label = c("morphosyntactic", "cohesive",
                                             "lexical"))

  labels <- get_att_labels(dcmdata::ecpe_qmatrix %>%
                             dplyr::select(-"item_id"))

  testthat::expect_equal(labels, exp_labels)
})

test_that("check_hierarchy", {
  err <- rlang::catch_cnd(check_hierarchy(2))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "a single string")

  err <- rlang::catch_cnd(check_hierarchy("x <-> y -> z"))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "be a hierarchical structure with a clear starting attribute")

  err <- rlang::catch_cnd(check_hierarchy("x -> y <-> z"))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "be a hierarchical structure with a clear ending attribute")
})
