# measurement model parameters -------------------------------------------------
test_that("lcdm parameters work", {
  test_qmatrix <- tibble::tibble(
    att1 = c(1, 0, 1, 1),
    att2 = c(0, 1, 0, 1),
    att3 = c(0, 1, 1, 1),
    att4 = c(0, 0, 1, 1)
  )

  params <- get_parameters(lcdm(), qmatrix = test_qmatrix)

  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("item_id", "type", "attributes",
                                   "coefficient"))

  expect_equal(
    params,
    tibble::tribble(
      ~item_id,         ~type,              ~attributes, ~coefficient,
           "1",   "intercept",                       NA,       "l1_0",
           "1",  "maineffect",                   "att1",      "l1_11",
           "2",   "intercept",                       NA,       "l2_0",
           "2",  "maineffect",                   "att2",      "l2_12",
           "2",  "maineffect",                   "att3",      "l2_13",
           "2", "interaction",             "att2__att3",     "l2_223",
           "3",   "intercept",                       NA,       "l3_0",
           "3",  "maineffect",                   "att1",      "l3_11",
           "3",  "maineffect",                   "att3",      "l3_13",
           "3",  "maineffect",                   "att4",      "l3_14",
           "3", "interaction",             "att1__att3",     "l3_213",
           "3", "interaction",             "att1__att4",     "l3_214",
           "3", "interaction",             "att3__att4",     "l3_234",
           "3", "interaction",       "att1__att3__att4",    "l3_3134",
           "4",   "intercept",                       NA,       "l4_0",
           "4",  "maineffect",                   "att1",      "l4_11",
           "4",  "maineffect",                   "att2",      "l4_12",
           "4",  "maineffect",                   "att3",      "l4_13",
           "4",  "maineffect",                   "att4",      "l4_14",
           "4", "interaction",             "att1__att2",     "l4_212",
           "4", "interaction",             "att1__att3",     "l4_213",
           "4", "interaction",             "att1__att4",     "l4_214",
           "4", "interaction",             "att2__att3",     "l4_223",
           "4", "interaction",             "att2__att4",     "l4_224",
           "4", "interaction",             "att3__att4",     "l4_234",
           "4", "interaction",       "att1__att2__att3",    "l4_3123",
           "4", "interaction",       "att1__att2__att4",    "l4_3124",
           "4", "interaction",       "att1__att3__att4",    "l4_3134",
           "4", "interaction",       "att2__att3__att4",    "l4_3234",
           "4", "interaction", "att1__att2__att3__att4",   "l4_41234"
    )
  )

  expect_equal(
    lcdm_parameters(test_qmatrix, max_interaction = 2),
    tibble::tribble(
      ~item_id,         ~type,              ~attributes, ~coefficient,
           "1",   "intercept",                       NA,       "l1_0",
           "1",  "maineffect",                   "att1",      "l1_11",
           "2",   "intercept",                       NA,       "l2_0",
           "2",  "maineffect",                   "att2",      "l2_12",
           "2",  "maineffect",                   "att3",      "l2_13",
           "2", "interaction",             "att2__att3",     "l2_223",
           "3",   "intercept",                       NA,       "l3_0",
           "3",  "maineffect",                   "att1",      "l3_11",
           "3",  "maineffect",                   "att3",      "l3_13",
           "3",  "maineffect",                   "att4",      "l3_14",
           "3", "interaction",             "att1__att3",     "l3_213",
           "3", "interaction",             "att1__att4",     "l3_214",
           "3", "interaction",             "att3__att4",     "l3_234",
           "4",   "intercept",                       NA,       "l4_0",
           "4",  "maineffect",                   "att1",      "l4_11",
           "4",  "maineffect",                   "att2",      "l4_12",
           "4",  "maineffect",                   "att3",      "l4_13",
           "4",  "maineffect",                   "att4",      "l4_14",
           "4", "interaction",             "att1__att2",     "l4_212",
           "4", "interaction",             "att1__att3",     "l4_213",
           "4", "interaction",             "att1__att4",     "l4_214",
           "4", "interaction",             "att2__att3",     "l4_223",
           "4", "interaction",             "att2__att4",     "l4_224",
           "4", "interaction",             "att3__att4",     "l4_234"
    )
  )
})

test_that("crum parameters work", {
  test_qmatrix <- tibble::tibble(
    question = c("Q1", "Q2", "Q3", "Q4"),
    skill1 = c(1, 0, 1, 1),
    skill2 = c(0, 1, 0, 1),
    skill3 = c(0, 1, 1, 1),
    skill4 = c(0, 0, 1, 1)
  )

  params <- get_parameters(crum(), qmatrix = test_qmatrix,
                           identifier = "question")

  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("question", "type", "attributes",
                                   "coefficient"))

  expect_equal(
    params,
    tibble::tribble(
      ~question,         ~type,              ~attributes, ~coefficient,
           "Q1",   "intercept",                       NA,       "l1_0",
           "Q1",  "maineffect",                 "skill1",      "l1_11",
           "Q2",   "intercept",                       NA,       "l2_0",
           "Q2",  "maineffect",                 "skill2",      "l2_12",
           "Q2",  "maineffect",                 "skill3",      "l2_13",
           "Q3",   "intercept",                       NA,       "l3_0",
           "Q3",  "maineffect",                 "skill1",      "l3_11",
           "Q3",  "maineffect",                 "skill3",      "l3_13",
           "Q3",  "maineffect",                 "skill4",      "l3_14",
           "Q4",   "intercept",                       NA,       "l4_0",
           "Q4",  "maineffect",                 "skill1",      "l4_11",
           "Q4",  "maineffect",                 "skill2",      "l4_12",
           "Q4",  "maineffect",                 "skill3",      "l4_13",
           "Q4",  "maineffect",                 "skill4",      "l4_14"
    )
  )

  expect_equal(
    lcdm_parameters(test_qmatrix, max_interaction = 1, identifier = "question",
                    att_names = paste0("att", 1:4), rename_attributes = TRUE),
    tibble::tribble(
     ~question,         ~type,              ~attributes, ~coefficient,
          "Q1",   "intercept",                       NA,       "l1_0",
          "Q1",  "maineffect",                   "att1",      "l1_11",
          "Q2",   "intercept",                       NA,       "l2_0",
          "Q2",  "maineffect",                   "att2",      "l2_12",
          "Q2",  "maineffect",                   "att3",      "l2_13",
          "Q3",   "intercept",                       NA,       "l3_0",
          "Q3",  "maineffect",                   "att1",      "l3_11",
          "Q3",  "maineffect",                   "att3",      "l3_13",
          "Q3",  "maineffect",                   "att4",      "l3_14",
          "Q4",   "intercept",                       NA,       "l4_0",
          "Q4",  "maineffect",                   "att1",      "l4_11",
          "Q4",  "maineffect",                   "att2",      "l4_12",
          "Q4",  "maineffect",                   "att3",      "l4_13",
          "Q4",  "maineffect",                   "att4",      "l4_14"
    )
  )

  expect_equal(
    lcdm_parameters(test_qmatrix, max_interaction = 1, identifier = "question",
                    rename_items = TRUE),
    tibble::tribble(
       ~item_id,         ~type,              ~attributes, ~coefficient,
             1L,   "intercept",                       NA,       "l1_0",
             1L,  "maineffect",                 "skill1",      "l1_11",
             2L,   "intercept",                       NA,       "l2_0",
             2L,  "maineffect",                 "skill2",      "l2_12",
             2L,  "maineffect",                 "skill3",      "l2_13",
             3L,   "intercept",                       NA,       "l3_0",
             3L,  "maineffect",                 "skill1",      "l3_11",
             3L,  "maineffect",                 "skill3",      "l3_13",
             3L,  "maineffect",                 "skill4",      "l3_14",
             4L,   "intercept",                       NA,       "l4_0",
             4L,  "maineffect",                 "skill1",      "l4_11",
             4L,  "maineffect",                 "skill2",      "l4_12",
             4L,  "maineffect",                 "skill3",      "l4_13",
             4L,  "maineffect",                 "skill4",      "l4_14"
    )
  )

  expect_equal(
    lcdm_parameters(test_qmatrix, max_interaction = 1, identifier = "question",
                    rename_attributes = TRUE, rename_items = TRUE),
    tibble::tribble(
      ~item_id,         ~type,              ~attributes, ~coefficient,
            1L,   "intercept",                       NA,       "l1_0",
            1L,  "maineffect",                   "att1",      "l1_11",
            2L,   "intercept",                       NA,       "l2_0",
            2L,  "maineffect",                   "att2",      "l2_12",
            2L,  "maineffect",                   "att3",      "l2_13",
            3L,   "intercept",                       NA,       "l3_0",
            3L,  "maineffect",                   "att1",      "l3_11",
            3L,  "maineffect",                   "att3",      "l3_13",
            3L,  "maineffect",                   "att4",      "l3_14",
            4L,   "intercept",                       NA,       "l4_0",
            4L,  "maineffect",                   "att1",      "l4_11",
            4L,  "maineffect",                   "att2",      "l4_12",
            4L,  "maineffect",                   "att3",      "l4_13",
            4L,  "maineffect",                   "att4",      "l4_14"
    )
  )
})

test_that("dina parameters work", {
  test_qmatrix <- tibble::tibble(
    att1 = sample(0:1, size = 5, replace = TRUE),
    att2 = sample(0:1, size = 5, replace = TRUE),
    att3 = sample(0:1, size = 5, replace = TRUE),
    att4 = sample(0:1, size = 5, replace = TRUE)
  )

  params <- get_parameters(dina(), qmatrix = test_qmatrix)

  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("item_id", "type", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(
      item_id = as.character(rep(1:5, each = 2)),
      type = rep(c("guess", "slip"), 5)
    ) |>
      dplyr::mutate(coefficient = paste0(.data$type, "[", .data$item_id, "]")),
    ignore_attr = TRUE
  )
})

test_that("dino parameters work", {
  test_qmatrix <- tibble::tibble(
    test_item = paste0("B", 1:5),
    att1 = sample(0:1, size = 5, replace = TRUE),
    att2 = sample(0:1, size = 5, replace = TRUE),
    att3 = sample(0:1, size = 5, replace = TRUE),
    att4 = sample(0:1, size = 5, replace = TRUE)
  )

  params <- get_parameters(dino(), qmatrix = test_qmatrix,
                           identifier = "test_item")

  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("test_item", "type", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(
      test_item = rep(paste0("B", 1:5), each = 2),
      type = rep(c("guess", "slip"), 5)
    ) |>
      dplyr::mutate(
        coefficient = paste0(.data$type, "[", rep(1:5, each = 2), "]")
      ),
    ignore_attr = TRUE
  )

  expect_equal(
    dina_parameters(qmatrix = test_qmatrix, identifier = "test_item",
                    rename_items = TRUE),
    tibble::tibble(
      item_id = rep(1:5, each = 2),
      type = rep(c("guess", "slip"), 5)
    ) |>
      dplyr::mutate(
        coefficient = paste0(.data$type, "[", rep(1:5, each = 2), "]")
      ),
    ignore_attr = TRUE
  )
})

# structural model parameters --------------------------------------------------
test_that("unconstrained parameters work", {
  test_qmatrix <- tibble::tibble(
    test_item = paste0("B", 1:5),
    att1 = sample(0:1, size = 5, replace = TRUE),
    att2 = sample(0:1, size = 5, replace = TRUE),
    att3 = sample(0:1, size = 5, replace = TRUE),
    att4 = sample(0:1, size = 5, replace = TRUE)
  )

  params <- get_parameters(unconstrained(), qmatrix = test_qmatrix,
                           identifier = "test_item")
  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("type", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(type = "structural",
                   coefficient = "Vc")
  )

  params2 <- get_parameters(unconstrained(), qmatrix = test_qmatrix[, -1])
  expect_true(tibble::is_tibble(params2))
  expect_equal(colnames(params2), c("type", "coefficient"))

  expect_equal(params, params2)
})

test_that("independent parameters work", {
  test_qmatrix <- tibble::tibble(
    test_item = paste0("B", 1:5),
    att1 = sample(0:1, size = 5, replace = TRUE),
    att2 = sample(0:1, size = 5, replace = TRUE),
    att3 = sample(0:1, size = 5, replace = TRUE),
    att4 = sample(0:1, size = 5, replace = TRUE)
  )

  params <- get_parameters(independent(), qmatrix = test_qmatrix,
                           identifier = "test_item")
  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("type", "attributes", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(type = "structural",
                   attributes = paste0("att", 1:4),
                   coefficient = paste0("eta[", 1:4, "]"))
  )

  params2 <- get_parameters(independent(), qmatrix = test_qmatrix[, -1])
  expect_true(tibble::is_tibble(params2))
  expect_equal(colnames(params2), c("type", "attributes", "coefficient"))

  expect_equal(params, params2)

  test_qmatrix <- tibble::tibble(
    test_item = paste0("M", 1:5),
    add = sample(0:1, size = 5, replace = TRUE),
    subtract = sample(0:1, size = 5, replace = TRUE),
    multiply = sample(0:1, size = 5, replace = TRUE),
    divide = sample(0:1, size = 5, replace = TRUE)
  )

  params <- get_parameters(independent(), qmatrix = test_qmatrix,
                           identifier = "test_item")
  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("type", "attributes", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(type = "structural",
                   attributes = c("add", "subtract", "multiply", "divide"),
                   coefficient = paste0("eta[", 1:4, "]"))
  )

  params2 <- get_parameters(independent(), qmatrix = test_qmatrix[, -1])
  expect_true(tibble::is_tibble(params2))
  expect_equal(colnames(params2), c("type", "attributes", "coefficient"))

  expect_equal(params, params2)
})

<<<<<<< HEAD
test_that("bayesian network parameters work", {
=======
test_that("loglinear parameters work", {
>>>>>>> dc6f2a2bfa6f0d0cd09a3c5076b97c649da2aa68
  test_qmatrix <- tibble::tibble(
    att1 = c(1, 0, 1, 1),
    att2 = c(0, 1, 0, 1),
    att3 = c(0, 1, 1, 1)
  )

<<<<<<< HEAD
  structural = bayesnet()
  att_labels <- get_att_labels(qmatrix = test_qmatrix, identifier = NULL)
  structural@model_args$att_labels <- att_labels
  params <- get_parameters(structural, qmatrix = test_qmatrix)

  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("param_id", "type", "attributes",
=======
  params <- get_parameters(loglinear(), qmatrix = test_qmatrix)

  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("profile_id", "type", "attributes",
>>>>>>> dc6f2a2bfa6f0d0cd09a3c5076b97c649da2aa68
                                   "coefficient"))

  expect_equal(
    params,
    tibble::tribble(
<<<<<<< HEAD
      ~param_id,         ~type,              ~attributes, ~coefficient,
      1L,   "structural_intercept",        "intercept",  "g1_0",
      2L,   "structural_intercept",        "intercept",  "g2_0",
      2L,   "structural_maineffect",       "att1",       "g2_11",
      3L,   "structural_intercept",        "intercept",  "g3_0",
      3L,   "structural_maineffect",       "att1",       "g3_11",
      3L,   "structural_maineffect",       "att2",       "g3_12",
      3L,   "structural_interaction",      "att1__att2",  "g3_212"
    )
  )

  structural = bayesnet()
  structural@model_args$att_labels <- att_labels
  hierarchy <- "att3 -> att2 -> att1"
  structural@model_args$hierarchy <- hierarchy
  g <- glue::glue(" graph { <hierarchy> } ", .open = "<", .close = ">")
  g <- dagitty::dagitty(g)
  hierarchy <- glue::glue(" dag { <hierarchy> } ", .open = "<", .close = ">")
  hierarchy <- ggdag::tidy_dagitty(hierarchy)

  parents <- tibble::tibble()
  ancestors <- tibble::tibble()
  roots <- dagitty::exogenousVariables(g)

  for (jj in hierarchy |> tibble::as_tibble() |> dplyr::pull(.data$name)) {
    tmp_jj <- att_labels |>
      dplyr::filter(.data$att_label == jj) |>
      dplyr::pull(.data$att)

    tmp <- dagitty::ancestors(g, jj) |>
      tibble::as_tibble() |>
      dplyr::mutate(param = tmp_jj) |>
      dplyr::rename(ancestor = "value") |>
      dplyr::select("param", "ancestor") |>
      dplyr::left_join(att_labels, by = c("ancestor" = "att_label")) |>
      dplyr::select("param", ancestor = "att")

    ancestors <- dplyr::bind_rows(ancestors, tmp) |>
      dplyr::distinct()

    tmp2 <- dagitty::parents(g, jj) |>
      tibble::as_tibble() |>
      dplyr::mutate(param = tmp_jj) |>
      dplyr::rename(parent = "value") |>
      dplyr::select("param", "parent") |>
      dplyr::left_join(att_labels, by = c("parent" = "att_label")) |>
      dplyr::select("param", parent = "att")

    parents <- dplyr::bind_rows(parents, tmp2) |>
      dplyr::distinct()

    if(jj %in% roots) {
      parents <- dplyr::bind_rows(
        parents,
        jj |>
          tibble::as_tibble() |>
          dplyr::left_join(att_labels, by = c("value" = "att_label")) |>
          dplyr::rename(param = att) |>
          dplyr::select("param") |>
          dplyr::mutate(parent = NA_character_)
      ) |>
        dplyr::arrange(param)
    }
  }

  test_imatrix <- ancestors |>
    dplyr::rename(parent = ancestor) |>
    dplyr::left_join(parents |>
                       dplyr::filter(!is.na(parent)) |>
                       dplyr::mutate(meas = 1L),
                     by = c("param", "parent")) |>
    dplyr::arrange(param) |>
    tidyr::pivot_wider(names_from = "parent", values_from = "meas") |>
    dplyr::mutate(dplyr::across(dplyr::starts_with("att"),
                                ~tidyr::replace_na(., 0L)))
  expect_equal(
    bayesnet_parameters(test_imatrix, identifier = "param"),
    tibble::tribble(
      ~param_id,         ~type,              ~attributes, ~coefficient,
      1L,   "structural_intercept",        "intercept",  "g1_0",
      1L,   "structural_maineffect",       "att2",       "g1_12",
      2L,   "structural_intercept",        "intercept",  "g2_0",
      2L,   "structural_maineffect",       "att3",       "g2_13",
      3L,   "structural_intercept",        "intercept",  "g3_0"
=======
      ~profile_id,         ~type,             ~attributes, ~coefficient,
               2L,  "structural",                  "att1",       "g_11",
               3L,  "structural",                  "att2",       "g_12",
               4L,  "structural",                  "att3",       "g_13",
               5L,  "structural",                  "att1",       "g_11",
               5L,  "structural",                  "att2",       "g_12",
               5L,  "structural",            "att1__att2",      "g_212",
               6L,  "structural",                  "att1",       "g_11",
               6L,  "structural",                  "att3",       "g_13",
               6L,  "structural",            "att1__att3",      "g_213",
               7L,  "structural",                  "att2",       "g_12",
               7L,  "structural",                  "att3",       "g_13",
               7L,  "structural",            "att2__att3",      "g_223",
               8L,  "structural",                  "att1",       "g_11",
               8L,  "structural",                  "att2",       "g_12",
               8L,  "structural",                  "att3",       "g_13",
               8L,  "structural",            "att1__att2",      "g_212",
               8L,  "structural",            "att1__att3",      "g_213",
               8L,  "structural",            "att2__att3",      "g_223",
               8L,  "structural",      "att1__att2__att3",     "g_3123"
    )
  )

  expect_equal(
    loglinear_parameters(test_qmatrix, max_interaction = 1,
                         att_names = paste0("node", 1:3)),
    tibble::tribble(
      ~profile_id,         ~type,             ~attributes, ~coefficient,
               2L,  "structural",                 "node1",       "g_11",
               3L,  "structural",                 "node2",       "g_12",
               4L,  "structural",                 "node3",       "g_13",
               5L,  "structural",                 "node1",       "g_11",
               5L,  "structural",                 "node2",       "g_12",
               6L,  "structural",                 "node1",       "g_11",
               6L,  "structural",                 "node3",       "g_13",
               7L,  "structural",                 "node2",       "g_12",
               7L,  "structural",                 "node3",       "g_13",
               8L,  "structural",                 "node1",       "g_11",
               8L,  "structural",                 "node2",       "g_12",
               8L,  "structural",                 "node3",       "g_13"
>>>>>>> dc6f2a2bfa6f0d0cd09a3c5076b97c649da2aa68
    )
  )
})

<<<<<<< HEAD
=======
test_that("hdcm parameters work", {
  test_qmatrix <- tibble::tibble(
    test_item = paste0("B", 1:5),
    att1 = sample(0:1, size = 5, replace = TRUE),
    att2 = sample(0:1, size = 5, replace = TRUE),
    att3 = sample(0:1, size = 5, replace = TRUE),
    att4 = sample(0:1, size = 5, replace = TRUE)
  )

  params <- get_parameters(hdcm(), qmatrix = test_qmatrix,
                           identifier = "test_item")
  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("type", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(type = "structural",
                   coefficient = "Vc")
  )

  params2 <- get_parameters(hdcm(), qmatrix = test_qmatrix[, -1])
  expect_true(tibble::is_tibble(params2))
  expect_equal(colnames(params2), c("type", "coefficient"))

  expect_equal(params, params2)
})
>>>>>>> dc6f2a2bfa6f0d0cd09a3c5076b97c649da2aa68

# dcm specification parameters -------------------------------------------------
test_that("warnings are produced for unnecessary arguments", {
  test_qmatrix <- tibble::tibble(
    att1 = c(1, 0, 1, 1),
    att2 = c(0, 1, 0, 1),
    att3 = c(0, 1, 1, 1),
    att4 = c(0, 0, 1, 1)
  )

  spec1 <- dcm_specify(qmatrix = test_qmatrix)
  expect_warning(get_parameters(spec1, qmatrix = test_qmatrix),
                 "should not be specified")
  expect_warning(get_parameters(spec1, qmatrix = test_qmatrix,
                                identifier = "item"),
                 "should not be specified")
  expect_warning(get_parameters(spec1, identifier = "item"),
                 "should not be specified")
})

test_that("combining parameters in a specification works", {
  test_qmatrix <- tibble::tibble(
    skill1 = c(1, 0, 1, 1),
    skill2 = c(0, 1, 0, 1),
    skill3 = c(0, 1, 1, 1),
    skill4 = c(0, 0, 1, 1)
  )

  spec1 <- dcm_specify(qmatrix = test_qmatrix)
  expect_equal(get_parameters(spec1),
               dplyr::bind_rows(
                 get_parameters(lcdm(), qmatrix = test_qmatrix),
                 get_parameters(unconstrained(), qmatrix = test_qmatrix)
               ))

  spec2 <- dcm_specify(qmatrix = test_qmatrix,
                       measurement_model = lcdm(max_interaction = 2))
  expect_equal(get_parameters(spec2),
               dplyr::bind_rows(
                 get_parameters(lcdm(max_interaction = 2),
                                qmatrix = test_qmatrix),
                 get_parameters(unconstrained(), qmatrix = test_qmatrix)
               ))

  spec3 <- dcm_specify(qmatrix = test_qmatrix,
                       measurement_model = crum(),
                       structural_model = independent())
  expect_equal(get_parameters(spec3),
               dplyr::bind_rows(
                 get_parameters(crum(), qmatrix = test_qmatrix),
                 get_parameters(independent(), qmatrix = test_qmatrix)
               ))

  spec4 <- dcm_specify(qmatrix = test_qmatrix,
                       measurement_model = lcdm(),
                       structural_model = loglinear())
  expect_equal(get_parameters(spec4),
               dplyr::bind_rows(
                 get_parameters(lcdm(), qmatrix = test_qmatrix),
                 get_parameters(loglinear(), qmatrix = test_qmatrix)
               ))

  spec4 <- dcm_specify(qmatrix = test_qmatrix,
                       measurement_model = lcdm(),
                       structural_model = loglinear(max_interaction = 1))
  expect_equal(get_parameters(spec4),
               dplyr::bind_rows(
                 get_parameters(lcdm(), qmatrix = test_qmatrix),
                 get_parameters(loglinear(max_interaction = 1),
                                qmatrix = test_qmatrix)
               ))
})
