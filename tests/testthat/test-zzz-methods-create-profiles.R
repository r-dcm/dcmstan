true_1 <- tibble::tribble(
  ~att1,
     0L,
     1L,
)

true_3 <- tibble::tribble(
  ~att1, ~att2, ~att3,
     0L,    0L,    0L,
     1L,    0L,    0L,
     0L,    1L,    0L,
     0L,    0L,    1L,
     1L,    1L,    0L,
     1L,    0L,    1L,
     0L,    1L,    1L,
     1L,    1L,    1L
)

true_4 <- tibble::tribble(
  ~att1, ~att2, ~att3, ~att4,
     0L,    0L,    0L,    0L,
     1L,    0L,    0L,    0L,
     0L,    1L,    0L,    0L,
     0L,    0L,    1L,    0L,
     0L,    0L,    0L,    1L,
     1L,    1L,    0L,    0L,
     1L,    0L,    1L,    0L,
     1L,    0L,    0L,    1L,
     0L,    1L,    1L,    0L,
     0L,    1L,    0L,    1L,
     0L,    0L,    1L,    1L,
     1L,    1L,    1L,    0L,
     1L,    1L,    0L,    1L,
     1L,    0L,    1L,    1L,
     0L,    1L,    1L,    1L,
     1L,    1L,    1L,    1L
)

test_that("numeric method works", {
  err <- rlang::catch_cnd(create_profiles(3.2))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "be a whole number")

  expect_identical(create_profiles(3), true_3)
  expect_identical(create_profiles(4), true_4)
})

test_that("stuctural method works", {
  err <- rlang::catch_cnd(create_profiles(unconstrained(), attribute = 3.2))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "be a whole number")

  expect_identical(create_profiles(unconstrained(), attributes = 3),true_3)
  expect_identical(create_profiles(independent(), attributes = 4), true_4)
})

test_that("dcm_specification method works", {
  mdm_spec <- dcm_specify(dcmdata::mdm_qmatrix, identifier = "item",
                          structural_model = unconstrained())
  ecpe_spec <- dcm_specify(dcmdata::ecpe_qmatrix, identifier = "item_id",
                           structural_model = independent())
  dtmr_spec <- dcm_specify(dcmdata::dtmr_qmatrix, identifier = "item",
                           structural_model = unconstrained())

  expect_identical(create_profiles(mdm_spec),
                   dplyr::rename(true_1, multiplication = "att1"))
  expect_identical(create_profiles(ecpe_spec, keep_names = FALSE), true_3)
  expect_identical(create_profiles(dtmr_spec),
                   dplyr::rename(true_4,
                                 referent_units = "att1",
                                 partitioning_iterating = "att2",
                                 appropriateness = "att3",
                                 multiplicative_comparison = "att4"))
})
