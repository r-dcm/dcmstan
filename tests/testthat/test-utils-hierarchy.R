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
