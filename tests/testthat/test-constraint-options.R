test_that("scoring model constraints have functions", {
  c_choice <- cnst_choices()
  for (i in seq_along(c_choice)) {
    expect_true(inherits(eval(rlang::sym(c_choice[i])), "function"))
  }
})

test_that("printing works", {
  expect_snapshot({
    print_choices(cnst_choices(), format = TRUE)
    print_choices(cnst_choices(), last = ", and ", format = TRUE)
  })
})
