test_that("measurement models have functions", {
  m_choice <- meas_choices()
  for (i in seq_along(m_choice)) {
    expect_true(inherits(eval(rlang::sym(m_choice[i])), "function"))
    S7::check_is_S7(do.call(m_choice[i], args = list()), measurement)
  }
})

test_that("structural models have functions", {
  s_choice <- strc_choices()
  for (i in seq_along(s_choice)) {
    expect_true(inherits(eval(rlang::sym(s_choice[i])), "function"))
    if (s_choice[i] == "bayesnet") {
      mod_args <- list(hierarchy = ggdag::tidy_dagitty(" dag { x -> y }"),
                       att_labels = tibble::tibble(att = c("att1",
                                                           "att2"),
                                                   att_labels = c("Test 1",
                                                                  "Test 2")))
    } else {
      mod_args <- list()
    }
    S7::check_is_S7(do.call(s_choice[i], args = list()), structural)
  }
})

test_that("printing works", {
  expect_snapshot({
    print_choices(meas_choices(), format = TRUE)
    print_choices(strc_choices(), format = TRUE)
    print_choices(meas_choices(), last = ", and ", format = TRUE)
  })

  expect_snapshot({
    print_choices(meas_choices())
    print_choices(strc_choices())
    print_choices(meas_choices(), last = ", and ")
  })

  expect_snapshot({
    print_choices(names(meas_choices()), sep = "; ", last = "; ",
                  format = FALSE)
  })
})
