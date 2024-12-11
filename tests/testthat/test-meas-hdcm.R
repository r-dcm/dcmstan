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

  hierarchy <-
    ggdag::tidy_dagitty(" dag { referent_units -> partitioning_iterating -> appropriateness -> multiplicative_comparison } ")

  att_labels <- dcmdata::dtmr_qmatrix |>
    dplyr::select(-"item") |>
    tidyr::pivot_longer(cols = dplyr::everything(), names_to = "att_label",
                        values_to = "drop") |>
    dplyr::select(-"drop") |>
    dplyr::distinct() |>
    tibble::rowid_to_column(var = "att") |>
    dplyr::mutate(att = stringr::str_c("att", as.character(.data$att)))

  dtmr_spec <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix %>%
                             dplyr::filter(!(item %in% c("10b", "10c", "13",
                                                         "14", "15a", "17",
                                                         "18", "22"))),
                           identifier = "item",
                           measurement_model = hdcm(hierarchy = hierarchy,
                                                    att_labels = att_labels))
  expect_snapshot(generate_stan(dtmr_spec))
})
