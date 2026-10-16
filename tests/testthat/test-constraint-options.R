test_that("scoring model constraints have functions", {
  c_choice <- cnst_choices()
  for (i in seq_along(c_choice)) {
    expect_true(inherits(eval(rlang::sym(c_choice[i])), "function"))
    S7::check_is_S7(do.call(c_choice[i], args = list()), scoring)
  }
})
