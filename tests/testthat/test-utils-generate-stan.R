test_that("create_profiles function works - 2 attributes", {
  exp_profiles <- tibble::tibble(att1 = c(0, 1, 0, 1),
                                 att2 = c(0, 0, 1, 1))

  profiles <- create_profiles(2)

  testthat::expect_equal(profiles, exp_profiles)
})

test_that("create_profiles function works - 3 attributes", {
  exp_profiles <- tibble::tibble(att1 = c(0, 1, 0, 0, 1, 1, 0, 1),
                                 att2 = c(0, 0, 1, 0, 1, 0, 1, 1),
                                 att3 = c(0, 0, 0, 1, 0, 1, 1, 1))

  profiles <- create_profiles(3)

  testthat::expect_equal(profiles, exp_profiles)
})

test_that("create_hierarchical_profiles function works", {
  exp_profiles <- tibble::tibble(att1 = c(0, 1, 1, 1),
                                 att2 = c(0, 0, 1, 1),
                                 att3 = c(0, 0, 0, 1))

  att_labels <- tibble::tibble(att = c("att1", "att2", "att3"),
                               att_label = c("x", "y", "z"))

  hierarchy <- ggdag::tidy_dagitty(" dag { x -> y -> z } ")

  profiles <- create_hierarchical_profiles(3, hierarchy, att_labels)

  testthat::expect_equal(profiles, exp_profiles)
})

test_that("one_down_params function works - 1 parameter", {
  exp_outcome <- c("")
  obs_outcome <- one_down_params("1", "3")
  testthat::expect_equal(obs_outcome, exp_outcome)
})

test_that("one_down_params function works - 2 parameters", {
  exp_outcome <- c("l3_11,l3_12")
  obs_outcome <- one_down_params("1__2", "3")
  testthat::expect_equal(obs_outcome, exp_outcome)
})

test_that("one_down_params function works - 3 parameters", {
  exp_outcome <-
    c("l3_11+l3_212+l3_213,l3_12+l3_212+l3_223,l3_13+l3_213+l3_223")
  obs_outcome <- one_down_params("1__2__3", "3")
  testthat::expect_equal(obs_outcome, exp_outcome)
})
