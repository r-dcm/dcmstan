# nolint start: indendation_linter
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

true_3_hdcm <- tibble::tribble(
  ~att1, ~att2, ~att3,
     0L,    0L,    0L,
     0L,    0L,    1L,
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

true_4_hdcm <- tibble::tribble(
  ~att1, ~att2, ~att3, ~att4,
     0L,    0L,    0L,    0L,
     1L,    0L,    0L,    0L,
     1L,    1L,    0L,    0L,
     1L,    1L,    1L,    0L,
     1L,    1L,    1L,    1L
)

true_4_mixed <- tibble::tribble(
  ~att1, ~att2, ~att3, ~att4,
     0L,    0L,    0L,    0L,
     1L,    0L,    0L,    0L,
     0L,    1L,    0L,    0L,
     1L,    0L,    0L,    1L,
     1L,    1L,    0L,    0L,
     1L,    1L,    1L,    0L,
     1L,    1L,    0L,    1L,
     1L,    1L,    1L,    1L
)
# nolint end

test_that("numeric method works", {
  err <- rlang::catch_cnd(create_profiles(3.2))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "be a whole number")

  expect_identical(create_profiles(3), true_3)
  expect_identical(create_profiles(4), true_4)
})

test_that("stuctural method works", {
  expect_identical(
    create_profiles(bayesnet(), attributes = c("red", "blue", "green")),
    rlang::set_names(true_3, c("red", "blue", "green"))
  )
  expect_identical(
    create_profiles(
      bayesnet(),
      attributes = c(red1 = "red", red2 = "blue", red3 = "green")
    ),
    rlang::set_names(true_3, c("red1", "red2", "red3"))
  )
  expect_identical(
    create_profiles(
      loglinear(),
      attributes = c("red", "blue", "green"),
      keep_names = FALSE
    ),
    true_3
  )

  expect_identical(
    create_profiles(unconstrained(), attributes = paste0("att", 1:3)),
    true_3
  )
  expect_identical(
    create_profiles(independent(), attributes = paste0("att", 1:4)),
    true_4
  )
})

test_that("HDCM method works", {
  # if attributes NULL, pull from hierarchy -----
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth")
    ),
    rlang::set_names(true_4_hdcm, c("first", "second", "third", "fourth"))
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth"),
      keep_names = FALSE
    ),
    true_4_hdcm
  )

  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow")
    ),
    rlang::set_names(true_4_mixed, c("blue", "yellow", "green", "red"))
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow"),
      keep_names = FALSE
    ),
    true_4_mixed
  )

  # attributes as unnamed vector -----
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "att3 -> att2 -> att1"),
      attributes = paste0("att", 1:3)
    ),
    true_3_hdcm
  )

  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth"),
      attributes = c("first", "second", "third", "fourth")
    ),
    rlang::set_names(true_4_hdcm, c("first", "second", "third", "fourth"))
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth"),
      attributes = c("first", "second", "third", "fourth"),
      keep_names = FALSE
    ),
    true_4_hdcm
  )

  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth"),
      attributes = c("first", "third", "second", "fourth")
    ),
    rlang::set_names(true_4_hdcm, c("first", "second", "third", "fourth")) |>
      dplyr::relocate("third", .before = "second")
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth"),
      attributes = c("first", "third", "second", "fourth"),
      keep_names = FALSE
    ),
    dplyr::relocate(true_4_hdcm, "att3", .before = "att2") |>
      rlang::set_names(paste0("att", 1:4))
  )

  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow"),
      attributes = c("red", "blue", "green", "yellow")
    ),
    rlang::set_names(true_4_mixed, c("blue", "yellow", "green", "red")) |>
      dplyr::select("red", "blue", "green", "yellow")
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow"),
      attributes = c("red", "blue", "green", "yellow"),
      keep_names = FALSE
    ),
    dplyr::select(true_4_mixed, "att4", "att1", "att3", "att2") |>
      rlang::set_names(paste0("att", 1:4))
  )

  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow"),
      attributes = c("blue", "green", "red", "yellow")
    ),
    rlang::set_names(true_4_mixed, c("blue", "yellow", "green", "red")) |>
      dplyr::select("blue", "green", "red", "yellow")
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow"),
      attributes = c("blue", "green", "red", "yellow"),
      keep_names = FALSE
    ),
    dplyr::select(true_4_mixed, "att1", "att3", "att4", "att2") |>
      rlang::set_names(paste0("att", 1:4))
  )

  # attributes as named vector -----
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "att3 -> att2 -> att1"),
      attributes = rlang::set_names(paste0("att", 1:3), paste0("att", 1:3))
    ),
    true_3_hdcm
  )

  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth"),
      attributes = rlang::set_names(
        paste0("att", 1:4),
        c("first", "second", "third", "fourth")
      )
    ),
    rlang::set_names(true_4_hdcm, c("first", "second", "third", "fourth"))
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth"),
      attributes = rlang::set_names(
        paste0("att", 1:4),
        c("first", "second", "third", "fourth")
      ),
      keep_names = FALSE
    ),
    true_4_hdcm
  )

  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth"),
      attributes = rlang::set_names(
        paste0("att", 1:4),
        c("first", "third", "second", "fourth")
      )
    ),
    rlang::set_names(true_4_hdcm, c("first", "second", "third", "fourth")) |>
      dplyr::relocate("third", .before = "second")
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "first -> second -> third -> fourth"),
      attributes = rlang::set_names(
        paste0("att", 1:4),
        c("first", "third", "second", "fourth")
      ),
      keep_names = FALSE
    ),
    dplyr::relocate(true_4_hdcm, "att3", .before = "att2") |>
      rlang::set_names(paste0("att", 1:4))
  )

  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow"),
      attributes = rlang::set_names(
        paste0("att", 1:4),
        c("red", "blue", "green", "yellow")
      )
    ),
    rlang::set_names(true_4_mixed, c("blue", "yellow", "green", "red")) |>
      dplyr::select("red", "blue", "green", "yellow")
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow"),
      attributes = rlang::set_names(
        paste0("att", 1:4),
        c("red", "blue", "green", "yellow")
      ),
      keep_names = FALSE
    ),
    dplyr::select(true_4_mixed, "att4", "att1", "att3", "att2") |>
      rlang::set_names(paste0("att", 1:4))
  )

  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow"),
      attributes = rlang::set_names(
        paste0("att", 1:4),
        c("blue", "green", "red", "yellow")
      )
    ),
    rlang::set_names(true_4_mixed, c("blue", "yellow", "green", "red")) |>
      dplyr::select("blue", "green", "red", "yellow")
  )
  expect_identical(
    create_profiles(
      hdcm(hierarchy = "red <- blue -> green <- yellow"),
      attributes = rlang::set_names(
        paste0("att", 1:4),
        c("blue", "green", "red", "yellow")
      ),
      keep_names = FALSE
    ),
    dplyr::select(true_4_mixed, "att1", "att3", "att4", "att2") |>
      rlang::set_names(paste0("att", 1:4))
  )
})

test_that("dcm_specification method works", {
  mdm_spec <- dcm_specify(
    dcmdata::mdm_qmatrix,
    identifier = "item",
    structural_model = unconstrained()
  )
  ecpe_spec <- dcm_specify(
    dcmdata::ecpe_qmatrix,
    identifier = "item_id",
    structural_model = hdcm(
      hierarchy = "lexical -> cohesive -> morphosyntactic"
    )
  )
  dtmr_spec <- dcm_specify(
    dcmdata::dtmr_qmatrix,
    identifier = "item",
    structural_model = independent()
  )

  expect_identical(
    create_profiles(mdm_spec),
    dplyr::rename(true_1, multiplication = "att1")
  )
  expect_identical(create_profiles(ecpe_spec, keep_names = FALSE), true_3_hdcm)
  expect_identical(
    create_profiles(dtmr_spec),
    dplyr::rename(
      true_4,
      referent_units = "att1",
      partitioning_iterating = "att2",
      appropriateness = "att3",
      multiplicative_comparison = "att4"
    )
  )
})
