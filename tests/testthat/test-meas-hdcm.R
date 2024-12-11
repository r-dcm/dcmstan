test_that("hdcm script works with unconstrained structural model", {
  hierarchy <-
    ggdag::tidy_dagitty(" dag { lexical -> cohesive -> morphosyntactic } ")

  att_labels <- dcmdata::ecpe_qmatrix |>
    dplyr::select(-"item_id") |>
    tidyr::pivot_longer(cols = dplyr::everything(), names_to = "att_label",
                        values_to = "drop") |>
    dplyr::select(-"drop") |>
    dplyr::distinct() |>
    tibble::rowid_to_column(var = "att") |>
    dplyr::mutate(att = stringr::str_c("att", as.character(.data$att)))

  ecpe_spec <- dcm_specify(qmatrix = dcmdata::ecpe_qmatrix,
                           identifier = "item_id",
                           measurement_model = hdcm(hierarchy = hierarchy,
                                                    att_labels = att_labels),
                           structural_model = unconstrained())
  expect_snapshot(generate_stan(ecpe_spec))
})
