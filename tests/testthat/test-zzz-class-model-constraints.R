test_that("scoring class works", {
  expect_true(S7::S7_inherits(scoring))

  expect_true(S7::S7_inherits(scoring(), scoring))
  expect_true(S7::S7_inherits(none(), scoring))
  # expect_true(S7::S7_inherits(posterior(), scoring))

  expect_true(S7::S7_inherits(none(), NONE))
  # expect_true(S7::S7_inherits(posterior(), POSTERIOR))
})

test_that("scoring class errors", {
  expect_error(
    scoring(
      constraint = "taylor"
    ),
    "@constraint must be one of"
  )
  expect_error(
    scoring(
      constraint = "none",
      constraint_args = list(taylor = 13)
    ),
    "@constraint_args contains unknown arguments"
  )
})

test_that("constraint_property cannot be overwritten", {
  score_cnst <- none()
  expect_error(
    score_cnst@constraint <- "posterior",
    "@constraint is read-only"
  )
})
