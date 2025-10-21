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
  expect_equal(
    colnames(params),
    c("item_id", "type", "attributes", "coefficient")
  )

  expect_equal(
    params,
    # nolint start: indentation_linter
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
    # nolint end
  )

  expect_equal(
    lcdm_parameters(test_qmatrix, max_interaction = 2),
    # nolint start: indentation_linter
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
    # nolint end
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
      type = rep(c("slip", "guess"), 5)
    ) |>
      dplyr::mutate(coefficient = paste0(.data$type, "[", .data$item_id, "]"))
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

  params <- get_parameters(
    dino(),
    qmatrix = test_qmatrix,
    identifier = "test_item"
  )

  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("test_item", "type", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(
      test_item = rep(paste0("B", 1:5), each = 2),
      type = rep(c("slip", "guess"), 5)
    ) |>
      dplyr::mutate(
        coefficient = paste0(.data$type, "[", rep(1:5, each = 2), "]")
      )
  )

  expect_equal(
    dina_parameters(
      qmatrix = test_qmatrix,
      identifier = "test_item",
      rename_items = TRUE
    ),
    tibble::tibble(
      item_id = rep(1:5, each = 2),
      type = rep(c("slip", "guess"), 5)
    ) |>
      dplyr::mutate(
        coefficient = paste0(.data$type, "[", rep(1:5, each = 2), "]")
      )
  )
})

test_that("nida parameters work", {
  set.seed(123)
  test_qmatrix <- tibble::tibble(
    question = c("Q1", "Q2", "Q3", "Q4"),
    node1 = c(1, 0, 1, 0),
    node2 = c(0, 1, 0, 1),
    node3 = c(0, 1, 1, 1),
    node4 = c(0, 0, 1, 1)
  )

  params <- get_parameters(
    nida(),
    qmatrix = test_qmatrix,
    identifier = "question"
  )

  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("attribute", "type", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(
      attribute = rep(c("node1", "node2", "node3", "node4"), each = 2),
      type = rep(c("slip", "guess"), 4),
      coefficient = c(
        "slip[1]",
        "guess[1]",
        "slip[2]",
        "guess[2]",
        "slip[3]",
        "guess[3]",
        "slip[4]",
        "guess[4]"
      )
    )
  )

  expect_equal(
    nida_parameters(
      test_qmatrix,
      identifier = "question",
      att_names = paste0("skill", 1:4)
    ),
    tibble::tibble(
      attribute = rep(c("skill1", "skill2", "skill3", "skill4"), each = 2),
      type = rep(c("slip", "guess"), 4),
      coefficient = c(
        "slip[1]",
        "guess[1]",
        "slip[2]",
        "guess[2]",
        "slip[3]",
        "guess[3]",
        "slip[4]",
        "guess[4]"
      )
    )
  )

  expect_equal(
    nida_parameters(
      test_qmatrix,
      identifier = "question",
      att_names = paste0("skill", 1:4),
      rename_attributes = TRUE
    ),
    tibble::tibble(
      attribute = rep(c("att1", "att2", "att3", "att4"), each = 2),
      type = rep(c("slip", "guess"), 4),
      coefficient = c(
        "slip[1]",
        "guess[1]",
        "slip[2]",
        "guess[2]",
        "slip[3]",
        "guess[3]",
        "slip[4]",
        "guess[4]"
      )
    )
  )
})

test_that("nido parameters work", {
  test_qmatrix <- tibble::tibble(
    question = c("Q1", "Q2", "Q3", "Q4"),
    skill1 = c(1, 0, 1, 1),
    skill2 = c(0, 1, 0, 1),
    skill3 = c(0, 1, 1, 1),
    skill4 = c(0, 0, 1, 1)
  )

  params <- get_parameters(
    nido(),
    qmatrix = test_qmatrix,
    identifier = "question"
  )

  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("attribute", "type", "coefficient"))

  expect_equal(
    params,
    tibble::tribble(
      ~attribute,     ~type,              ~coefficient,
      "skill1",       "intercept",        "l_01",
      "skill1",       "maineffect",       "l_11",
      "skill2",       "intercept",        "l_02",
      "skill2",       "maineffect",       "l_12",
      "skill3",       "intercept",        "l_03",
      "skill3",       "maineffect",       "l_13",
      "skill4",       "intercept",        "l_04",
      "skill4",       "maineffect",       "l_14"
    )
  )

  expect_equal(
    nido_parameters(
      test_qmatrix,
      identifier = "question",
      att_names = c("larry", "peggy", "broccoli", "henry")
    ),
    tibble::tribble(
      ~attribute,     ~type,              ~coefficient,
      "larry",        "intercept",        "l_01",
      "larry",        "maineffect",       "l_11",
      "peggy",        "intercept",        "l_02",
      "peggy",        "maineffect",       "l_12",
      "broccoli",     "intercept",        "l_03",
      "broccoli",     "maineffect",       "l_13",
      "henry",        "intercept",        "l_04",
      "henry",        "maineffect",       "l_14"
    )
  )

  expect_equal(
    nido_parameters(
      test_qmatrix,
      identifier = "question",
      att_names = c("larry", "peggy", "broccoli", "henry"),
      rename_attributes = TRUE
    ),
    tibble::tribble(
      ~attribute,     ~type,              ~coefficient,
      "att1",         "intercept",        "l_01",
      "att1",         "maineffect",       "l_11",
      "att2",         "intercept",        "l_02",
      "att2",         "maineffect",       "l_12",
      "att3",         "intercept",        "l_03",
      "att3",         "maineffect",       "l_13",
      "att4",         "intercept",        "l_04",
      "att4",         "maineffect",       "l_14"
    )
  )
})

test_that("ncrum parameters work", {
  test_qmatrix <- tibble::tibble(
    question = c("Q1", "Q2", "Q3", "Q4"),
    addition = c(1, 0, 1, 0),
    subtraction = c(0, 1, 0, 1),
    multiplication = c(0, 1, 1, 1),
    division = c(0, 0, 1, 1)
  )

  params <- get_parameters(
    ncrum(),
    qmatrix = test_qmatrix,
    identifier = "question"
  )

  expect_true(tibble::is_tibble(params))
  expect_equal(
    colnames(params),
    c("question", "type", "attribute", "coefficient")
  )

  expect_equal(
    params,
    tibble::tibble(
      question = c(
        "Q1",
        "Q1",
        "Q2",
        "Q2",
        "Q2",
        "Q3",
        "Q3",
        "Q3",
        "Q3",
        "Q4",
        "Q4",
        "Q4",
        "Q4"
      ),
      type = c(
        "baseline",
        "penalty",
        "baseline",
        rep("penalty", 2),
        "baseline",
        rep("penalty", 3),
        "baseline",
        rep("penalty", 3)
      ),
      attribute = c(
        NA,
        "addition",
        NA,
        "subtraction",
        "multiplication",
        NA,
        "addition",
        "multiplication",
        "division",
        NA,
        "subtraction",
        "multiplication",
        "division"
      ),
      coefficient = c(
        "pistar_1",
        "rstar_11",
        "pistar_2",
        "rstar_22",
        "rstar_23",
        "pistar_3",
        "rstar_31",
        "rstar_33",
        "rstar_34",
        "pistar_4",
        "rstar_42",
        "rstar_43",
        "rstar_44"
      )
    )
  )

  expect_equal(
    ncrum_parameters(
      test_qmatrix,
      identifier = "question",
      att_names = paste0("skill", 1:4)
    ),
    tibble::tibble(
      question = c(
        "Q1",
        "Q1",
        "Q2",
        "Q2",
        "Q2",
        "Q3",
        "Q3",
        "Q3",
        "Q3",
        "Q4",
        "Q4",
        "Q4",
        "Q4"
      ),
      type = c(
        "baseline",
        "penalty",
        "baseline",
        rep("penalty", 2),
        "baseline",
        rep("penalty", 3),
        "baseline",
        rep("penalty", 3)
      ),
      attribute = c(
        NA,
        "skill1",
        NA,
        "skill2",
        "skill3",
        NA,
        "skill1",
        "skill3",
        "skill4",
        NA,
        "skill2",
        "skill3",
        "skill4"
      ),
      coefficient = c(
        "pistar_1",
        "rstar_11",
        "pistar_2",
        "rstar_22",
        "rstar_23",
        "pistar_3",
        "rstar_31",
        "rstar_33",
        "rstar_34",
        "pistar_4",
        "rstar_42",
        "rstar_43",
        "rstar_44"
      )
    )
  )

  expect_equal(
    ncrum_parameters(
      test_qmatrix[, -1],
      identifier = NULL,
      item_names = paste0("item", 1:4)
    ),
    tibble::tibble(
      item_id = c(
        "item1",
        "item1",
        "item2",
        "item2",
        "item2",
        "item3",
        "item3",
        "item3",
        "item3",
        "item4",
        "item4",
        "item4",
        "item4"
      ),
      type = c(
        "baseline",
        "penalty",
        "baseline",
        rep("penalty", 2),
        "baseline",
        rep("penalty", 3),
        "baseline",
        rep("penalty", 3)
      ),
      attribute = c(
        NA,
        "addition",
        NA,
        "subtraction",
        "multiplication",
        NA,
        "addition",
        "multiplication",
        "division",
        NA,
        "subtraction",
        "multiplication",
        "division"
      ),
      coefficient = c(
        "pistar_1",
        "rstar_11",
        "pistar_2",
        "rstar_22",
        "rstar_23",
        "pistar_3",
        "rstar_31",
        "rstar_33",
        "rstar_34",
        "pistar_4",
        "rstar_42",
        "rstar_43",
        "rstar_44"
      )
    )
  )

  expect_equal(
    ncrum_parameters(
      test_qmatrix[, -1],
      identifier = NULL,
      att_names = paste0("skill", 1:4),
      item_names = rlang::set_names(1:4, paste0("q_", 1:4)),
      rename_attributes = TRUE,
      rename_items = TRUE
    ),
    tibble::tibble(
      item_id = c(1L, 1L, 2L, 2L, 2L, 3L, 3L, 3L, 3L, 4L, 4L, 4L, 4L),
      type = c(
        "baseline",
        "penalty",
        "baseline",
        rep("penalty", 2),
        "baseline",
        rep("penalty", 3),
        "baseline",
        rep("penalty", 3)
      ),
      attribute = c(
        NA,
        "att1",
        NA,
        "att2",
        "att3",
        NA,
        "att1",
        "att3",
        "att4",
        NA,
        "att2",
        "att3",
        "att4"
      ),
      coefficient = c(
        "pistar_1",
        "rstar_11",
        "pistar_2",
        "rstar_22",
        "rstar_23",
        "pistar_3",
        "rstar_31",
        "rstar_33",
        "rstar_34",
        "pistar_4",
        "rstar_42",
        "rstar_43",
        "rstar_44"
      )
    )
  )

  expect_equal(
    ncrum_parameters(
      test_qmatrix[, -1],
      identifier = NULL,
      item_names = rlang::set_names(1:4, paste0("q_", 1:4))
    ),
    tibble::tibble(
      item_id = c(
        "q_1",
        "q_1",
        "q_2",
        "q_2",
        "q_2",
        "q_3",
        "q_3",
        "q_3",
        "q_3",
        "q_4",
        "q_4",
        "q_4",
        "q_4"
      ),
      type = c(
        "baseline",
        "penalty",
        "baseline",
        rep("penalty", 2),
        "baseline",
        rep("penalty", 3),
        "baseline",
        rep("penalty", 3)
      ),
      attribute = c(
        NA,
        "addition",
        NA,
        "subtraction",
        "multiplication",
        NA,
        "addition",
        "multiplication",
        "division",
        NA,
        "subtraction",
        "multiplication",
        "division"
      ),
      coefficient = c(
        "pistar_1",
        "rstar_11",
        "pistar_2",
        "rstar_22",
        "rstar_23",
        "pistar_3",
        "rstar_31",
        "rstar_33",
        "rstar_34",
        "pistar_4",
        "rstar_42",
        "rstar_43",
        "rstar_44"
      )
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

  params <- get_parameters(
    crum(),
    qmatrix = test_qmatrix,
    identifier = "question"
  )

  expect_true(tibble::is_tibble(params))
  expect_equal(
    colnames(params),
    c("question", "type", "attributes", "coefficient")
  )

  expect_equal(
    params,
    # nolint start: indentation_linter
    tibble::tribble(
      ~question, ~type,        ~attributes, ~coefficient,
      "Q1",      "intercept",        NA,    "l1_0",
      "Q1",      "maineffect", "skill1",    "l1_11",
      "Q2",      "intercept",        NA,    "l2_0",
      "Q2",      "maineffect", "skill2",    "l2_12",
      "Q2",      "maineffect", "skill3",    "l2_13",
      "Q3",      "intercept",        NA,    "l3_0",
      "Q3",      "maineffect", "skill1",    "l3_11",
      "Q3",      "maineffect", "skill3",    "l3_13",
      "Q3",      "maineffect", "skill4",    "l3_14",
      "Q4",      "intercept",        NA,    "l4_0",
      "Q4",      "maineffect", "skill1",    "l4_11",
      "Q4",      "maineffect", "skill2",    "l4_12",
      "Q4",      "maineffect", "skill3",    "l4_13",
      "Q4",      "maineffect", "skill4",    "l4_14"
    )
    # nolint end
  )

  expect_equal(
    lcdm_parameters(
      test_qmatrix,
      max_interaction = 1,
      identifier = "question",
      att_names = paste0("att", 1:4),
      rename_attributes = TRUE
    ),
    # nolint start: indentation_linter
    tibble::tribble(
      ~question, ~type,        ~attributes, ~coefficient,
      "Q1",      "intercept",      NA,      "l1_0",
      "Q1",      "maineffect", "att1",      "l1_11",
      "Q2",      "intercept",      NA,      "l2_0",
      "Q2",      "maineffect", "att2",      "l2_12",
      "Q2",      "maineffect", "att3",      "l2_13",
      "Q3",      "intercept",      NA,      "l3_0",
      "Q3",      "maineffect", "att1",      "l3_11",
      "Q3",      "maineffect", "att3",      "l3_13",
      "Q3",      "maineffect", "att4",      "l3_14",
      "Q4",      "intercept",      NA,      "l4_0",
      "Q4",      "maineffect", "att1",      "l4_11",
      "Q4",      "maineffect", "att2",      "l4_12",
      "Q4",      "maineffect", "att3",      "l4_13",
      "Q4",      "maineffect", "att4",      "l4_14"
    )
    # nolint end
  )

  expect_equal(
    lcdm_parameters(
      test_qmatrix,
      max_interaction = 1,
      identifier = "question",
      rename_items = TRUE
    ),
    # nolint start: indentation_linter
    tibble::tribble(
      ~item_id, ~type,        ~attributes, ~coefficient,
            1L, "intercept",        NA,    "l1_0",
            1L, "maineffect", "skill1",    "l1_11",
            2L, "intercept",        NA,    "l2_0",
            2L, "maineffect", "skill2",    "l2_12",
            2L, "maineffect", "skill3",    "l2_13",
            3L, "intercept",        NA,    "l3_0",
            3L, "maineffect", "skill1",    "l3_11",
            3L, "maineffect", "skill3",    "l3_13",
            3L, "maineffect", "skill4",    "l3_14",
            4L, "intercept",        NA,    "l4_0",
            4L, "maineffect", "skill1",    "l4_11",
            4L, "maineffect", "skill2",    "l4_12",
            4L, "maineffect", "skill3",    "l4_13",
            4L, "maineffect", "skill4",    "l4_14"
    )
    # nolint end
  )

  expect_equal(
    lcdm_parameters(
      test_qmatrix,
      max_interaction = 1,
      identifier = "question",
      rename_attributes = TRUE,
      rename_items = TRUE
    ),
    # nolint start: indentation_linter
    tibble::tribble(
      ~item_id, ~type,        ~attributes, ~coefficient,
            1L, "intercept",      NA,      "l1_0",
            1L, "maineffect", "att1",      "l1_11",
            2L, "intercept",      NA,      "l2_0",
            2L, "maineffect", "att2",      "l2_12",
            2L, "maineffect", "att3",      "l2_13",
            3L, "intercept",      NA,      "l3_0",
            3L, "maineffect", "att1",      "l3_11",
            3L, "maineffect", "att3",      "l3_13",
            3L, "maineffect", "att4",      "l3_14",
            4L, "intercept",      NA,      "l4_0",
            4L, "maineffect", "att1",      "l4_11",
            4L, "maineffect", "att2",      "l4_12",
            4L, "maineffect", "att3",      "l4_13",
            4L, "maineffect", "att4",      "l4_14"
    )
    # nolint end
  )
})

# duplicate Rupp et al. parameters ---------------------------------------------
test_that("dina parameters (table 6.5)", {
  params <- dcm_specify(
    qmatrix = rupp_math,
    identifier = "items",
    measurement_model = dina()
  ) |>
    get_parameters() |>
    dplyr::filter(type != "structural")

  expect_equal(
    params,
    tibble::tibble(
      items = rep(paste("Item", 1:4), each = 2),
      type = rep(c("slip", "guess"), 4),
      coefficient = c(
        "slip[1]",
        "guess[1]",
        "slip[2]",
        "guess[2]",
        "slip[3]",
        "guess[3]",
        "slip[4]",
        "guess[4]"
      )
    )
  )

  dina_code <- meas_dina(
    qmatrix = rupp_math[, -1],
    priors = default_dcm_priors(dina()),
    att_names = NULL
  )
  dina_code$priors <- NULL
  expect_snapshot(dina_code)
})

test_that("nida parameters (table 6.6)", {
  params <- dcm_specify(
    qmatrix = rupp_math,
    identifier = "items",
    measurement_model = nida()
  ) |>
    get_parameters() |>
    dplyr::filter(type != "structural")

  expect_equal(
    params,
    tibble::tibble(
      attribute = rep(
        c("addition", "subtraction", "multiplication", "division"),
        each = 2
      ),
      type = rep(c("slip", "guess"), 4),
      coefficient = c(
        "slip[1]",
        "guess[1]",
        "slip[2]",
        "guess[2]",
        "slip[3]",
        "guess[3]",
        "slip[4]",
        "guess[4]"
      )
    )
  )

  nida_code <- meas_nida(
    qmatrix = rlang::set_names(rupp_math[, -1], paste0("att", 1:4)),
    priors = default_dcm_priors(nida()),
    att_names = NULL,
    hierarchy = NULL
  )

  pi_code <- nida_code$transformed_parameters |>
    tibble::as_tibble() |>
    tidyr::separate_longer_delim("value", delim = "\n") |>
    dplyr::filter(grepl("^  pi", .data$value)) |>
    tidyr::separate_wider_regex(
      "value",
      patterns = c(
        ".*\\[",
        i = "[0-9]*",
        ",",
        c = "[0-9]*",
        "\\] = ",
        value = ".*",
        ";$"
      )
    ) |>
    dplyr::mutate(i = paste0("Item ", i), c = as.integer(.data$c)) |>
    dplyr::left_join(
      dplyr::select(rupp_profiles, "id", "rupp_id"),
      by = c("c" = "id"),
      relationship = "many-to-one"
    ) |>
    dplyr::select(-"c") |>
    tidyr::pivot_wider(names_from = "i", values_from = "value") |>
    dplyr::arrange(.data$rupp_id)

  expect_identical(
    pi_code,
    # nolint start: line_length_linter
    tibble::tribble(
      ~rupp_id, ~`Item 1`,                     ~`Item 2`,       ~`Item 3`,                     ~`Item 4`,
            1L, "guess[1]*guess[2]",           "guess[4]",      "guess[2]*guess[3]",           "guess[1]",
            2L, "guess[1]*guess[2]",           "(1 - slip[4])", "guess[2]*guess[3]",           "guess[1]",
            3L, "guess[1]*guess[2]",           "guess[4]",      "guess[2]*(1 - slip[3])",      "guess[1]",
            4L, "guess[1]*guess[2]",           "(1 - slip[4])", "guess[2]*(1 - slip[3])",      "guess[1]",
            5L, "guess[1]*(1 - slip[2])",      "guess[4]",      "(1 - slip[2])*guess[3]",      "guess[1]",
            6L, "guess[1]*(1 - slip[2])",      "(1 - slip[4])", "(1 - slip[2])*guess[3]",      "guess[1]",
            7L, "guess[1]*(1 - slip[2])",      "guess[4]",      "(1 - slip[2])*(1 - slip[3])", "guess[1]",
            8L, "guess[1]*(1 - slip[2])",      "(1 - slip[4])", "(1 - slip[2])*(1 - slip[3])", "guess[1]",
            9L, "(1 - slip[1])*guess[2]",      "guess[4]",      "guess[2]*guess[3]",           "(1 - slip[1])",
           10L, "(1 - slip[1])*guess[2]",      "(1 - slip[4])", "guess[2]*guess[3]",           "(1 - slip[1])",
           11L, "(1 - slip[1])*guess[2]",      "guess[4]",      "guess[2]*(1 - slip[3])",      "(1 - slip[1])",
           12L, "(1 - slip[1])*guess[2]",      "(1 - slip[4])", "guess[2]*(1 - slip[3])",      "(1 - slip[1])",
           13L, "(1 - slip[1])*(1 - slip[2])", "guess[4]",      "(1 - slip[2])*guess[3]",      "(1 - slip[1])",
           14L, "(1 - slip[1])*(1 - slip[2])", "(1 - slip[4])", "(1 - slip[2])*guess[3]",      "(1 - slip[1])",
           15L, "(1 - slip[1])*(1 - slip[2])", "guess[4]",      "(1 - slip[2])*(1 - slip[3])", "(1 - slip[1])",
           16L, "(1 - slip[1])*(1 - slip[2])", "(1 - slip[4])", "(1 - slip[2])*(1 - slip[3])", "(1 - slip[1])"
    )
    # nolint end
  )
})

test_that("ncrum parameters (table 6.8)", {
  params <- dcm_specify(
    qmatrix = rupp_math,
    identifier = "items",
    measurement_model = ncrum()
  ) |>
    get_parameters() |>
    dplyr::filter(type != "structural")

  expect_equal(
    params,
    tibble::tibble(
      items = c(
        rep("Item 1", 3),
        rep("Item 2", 2),
        rep("Item 3", 3),
        rep("Item 4", 2)
      ),
      type = c(
        "baseline",
        rep("penalty", 2),
        "baseline",
        rep("penalty", 1),
        "baseline",
        rep("penalty", 2),
        "baseline",
        rep("penalty", 1)
      ),
      attribute = c(
        NA,
        "addition",
        "subtraction",
        NA,
        "division",
        NA,
        "subtraction",
        "multiplication",
        NA,
        "addition"
      ),
      coefficient = c(
        "pistar_1",
        "rstar_11",
        "rstar_12",
        "pistar_2",
        "rstar_24",
        "pistar_3",
        "rstar_32",
        "rstar_33",
        "pistar_4",
        "rstar_41"
      )
    )
  )

  ncrum_code <- meas_ncrum(
    qmatrix = rlang::set_names(rupp_math[, -1], paste0("att", 1:4)),
    priors = default_dcm_priors(ncrum()),
    att_names = NULL,
    hierarchy = NULL
  )

  pi_code <- ncrum_code$transformed_parameters |>
    tibble::as_tibble() |>
    tidyr::separate_longer_delim("value", delim = "\n") |>
    dplyr::filter(grepl("^  pi", .data$value)) |>
    tidyr::separate_wider_regex(
      "value",
      patterns = c(
        ".*\\[",
        i = "[0-9]*",
        ",",
        c = "[0-9]*",
        "\\] = ",
        value = ".*",
        ";$"
      )
    ) |>
    dplyr::mutate(i = paste0("Item ", i), c = as.integer(.data$c)) |>
    dplyr::left_join(
      dplyr::select(rupp_profiles, "id", "rupp_id"),
      by = c("c" = "id"),
      relationship = "many-to-one"
    ) |>
    dplyr::select(-"c") |>
    tidyr::pivot_wider(names_from = "i", values_from = "value") |>
    dplyr::arrange(.data$rupp_id)

  expect_identical(
    pi_code,
    # nolint start: line_length_linter
    tibble::tribble(
      ~rupp_id, ~`Item 1`,                    ~`Item 2`,           ~`Item 3`,                    ~`Item 4`,
            1L, "pistar_1*rstar_11*rstar_12", "pistar_2*rstar_24", "pistar_3*rstar_32*rstar_33", "pistar_4*rstar_41",
            2L, "pistar_1*rstar_11*rstar_12", "pistar_2",          "pistar_3*rstar_32*rstar_33", "pistar_4*rstar_41",
            3L, "pistar_1*rstar_11*rstar_12", "pistar_2*rstar_24", "pistar_3*rstar_32",          "pistar_4*rstar_41",
            4L, "pistar_1*rstar_11*rstar_12", "pistar_2",          "pistar_3*rstar_32",          "pistar_4*rstar_41",
            5L, "pistar_1*rstar_11",          "pistar_2*rstar_24", "pistar_3*rstar_33",          "pistar_4*rstar_41",
            6L, "pistar_1*rstar_11",          "pistar_2",          "pistar_3*rstar_33",          "pistar_4*rstar_41",
            7L, "pistar_1*rstar_11",          "pistar_2*rstar_24", "pistar_3",                   "pistar_4*rstar_41",
            8L, "pistar_1*rstar_11",          "pistar_2",          "pistar_3",                   "pistar_4*rstar_41",
            9L, "pistar_1*rstar_12",          "pistar_2*rstar_24", "pistar_3*rstar_32*rstar_33", "pistar_4",
           10L, "pistar_1*rstar_12",          "pistar_2",          "pistar_3*rstar_32*rstar_33", "pistar_4",
           11L, "pistar_1*rstar_12",          "pistar_2*rstar_24", "pistar_3*rstar_32",          "pistar_4",
           12L, "pistar_1*rstar_12",          "pistar_2",          "pistar_3*rstar_32",          "pistar_4",
           13L, "pistar_1",                   "pistar_2*rstar_24", "pistar_3*rstar_33",          "pistar_4",
           14L, "pistar_1",                   "pistar_2",          "pistar_3*rstar_33",          "pistar_4",
           15L, "pistar_1",                   "pistar_2*rstar_24", "pistar_3",                   "pistar_4",
           16L, "pistar_1",                   "pistar_2",          "pistar_3",                   "pistar_4"
    )
    # nolint end
  )
})

test_that("dino parameters (table 6.13)", {
  params <- dcm_specify(
    qmatrix = rupp_gri,
    identifier = "item",
    measurement_model = dino()
  ) |>
    get_parameters() |>
    dplyr::filter(type != "structural")

  expect_equal(
    params,
    tibble::tibble(
      item = rep(paste0("GRI", 1:4), each = 2),
      type = rep(c("slip", "guess"), 4),
      coefficient = c(
        "slip[1]",
        "guess[1]",
        "slip[2]",
        "guess[2]",
        "slip[3]",
        "guess[3]",
        "slip[4]",
        "guess[4]"
      )
    )
  )

  dino_code <- meas_dino(
    qmatrix = rupp_gri[, -1],
    priors = default_dcm_priors(dino()),
    att_names = NULL
  )
  dino_code$priors <- NULL
  expect_snapshot(dino_code)
})

test_that("nido parameters (table 6.15)", {
  params <- dcm_specify(
    qmatrix = rupp_gri,
    identifier = "item",
    measurement_model = nido()
  ) |>
    get_parameters() |>
    dplyr::filter(type != "structural")

  expect_equal(
    params,
    tibble::tibble(
      attribute = rep(paste0("attribute", 1:4), each = 2),
      type = rep(c("intercept", "maineffect"), 4),
      coefficient = c(
        "l_01",
        "l_11",
        "l_02",
        "l_12",
        "l_03",
        "l_13",
        "l_04",
        "l_14"
      )
    )
  )

  nido_code <- meas_nido(
    qmatrix = rlang::set_names(rupp_gri[, -1], paste0("att", 1:4)),
    priors = default_dcm_priors(nido()),
    att_names = NULL,
    hierarchy = NULL
  )

  pi_code <- nido_code$transformed_parameters |>
    tibble::as_tibble() |>
    tidyr::separate_longer_delim("value", delim = "\n") |>
    dplyr::filter(grepl("^  pi", .data$value)) |>
    tidyr::separate_wider_regex(
      "value",
      patterns = c(
        ".*\\[",
        i = "[0-9]*",
        ",",
        c = "[0-9]*",
        "\\] = inv_logit\\(",
        value = ".*",
        "\\);$"
      )
    ) |>
    dplyr::mutate(i = paste0("Item ", i), c = as.integer(.data$c)) |>
    dplyr::left_join(
      dplyr::select(rupp_profiles, "id", "rupp_id"),
      by = c("c" = "id"),
      relationship = "many-to-one"
    ) |>
    dplyr::select(-"c") |>
    tidyr::pivot_wider(names_from = "i", values_from = "value") |>
    dplyr::arrange(.data$rupp_id)

  expect_identical(
    pi_code,
    # nolint start: line_length_linter
    tibble::tribble(
      ~rupp_id, ~`Item 1`,   ~`Item 2`,             ~`Item 3`,   ~`Item 4`,
            1L, "l_01",      "l_02+l_03",           "l_04",      "l_02+l_03+l_04",
            2L, "l_01",      "l_02+l_03",           "l_04+l_14", "l_02+l_03+l_04+l_14",
            3L, "l_01",      "l_02+l_03+l_13",      "l_04",      "l_02+l_03+l_13+l_04",
            4L, "l_01",      "l_02+l_03+l_13",      "l_04+l_14", "l_02+l_03+l_13+l_04+l_14",
            5L, "l_01",      "l_02+l_12+l_03",      "l_04",      "l_02+l_12+l_03+l_04",
            6L, "l_01",      "l_02+l_12+l_03",      "l_04+l_14", "l_02+l_12+l_03+l_04+l_14",
            7L, "l_01",      "l_02+l_12+l_03+l_13", "l_04",      "l_02+l_12+l_03+l_13+l_04",
            8L, "l_01",      "l_02+l_12+l_03+l_13", "l_04+l_14", "l_02+l_12+l_03+l_13+l_04+l_14",
            9L, "l_01+l_11", "l_02+l_03",           "l_04",      "l_02+l_03+l_04",
           10L, "l_01+l_11", "l_02+l_03",           "l_04+l_14", "l_02+l_03+l_04+l_14",
           11L, "l_01+l_11", "l_02+l_03+l_13",      "l_04",      "l_02+l_03+l_13+l_04",
           12L, "l_01+l_11", "l_02+l_03+l_13",      "l_04+l_14", "l_02+l_03+l_13+l_04+l_14",
           13L, "l_01+l_11", "l_02+l_12+l_03",      "l_04",      "l_02+l_12+l_03+l_04",
           14L, "l_01+l_11", "l_02+l_12+l_03",      "l_04+l_14", "l_02+l_12+l_03+l_04+l_14",
           15L, "l_01+l_11", "l_02+l_12+l_03+l_13", "l_04",      "l_02+l_12+l_03+l_13+l_04",
           16L, "l_01+l_11", "l_02+l_12+l_03+l_13", "l_04+l_14", "l_02+l_12+l_03+l_13+l_04+l_14"
    )
    # nolint end
  )
})

test_that("crum parameters (table 6.17)", {
  params <- dcm_specify(
    qmatrix = rupp_gri,
    identifier = "item",
    measurement_model = crum()
  ) |>
    get_parameters() |>
    dplyr::filter(type != "structural")

  expect_equal(
    params,
    tibble::tibble(
      item = c(rep("GRI1", 2), rep("GRI2", 3), rep("GRI3", 2), rep("GRI4", 4)),
      type = c(
        "intercept",
        rep("maineffect", 1),
        "intercept",
        rep("maineffect", 2),
        "intercept",
        rep("maineffect", 1),
        "intercept",
        rep("maineffect", 3)
      ),
      attributes = c(
        NA,
        "attribute1",
        NA,
        "attribute2",
        "attribute3",
        NA,
        "attribute4",
        NA,
        "attribute2",
        "attribute3",
        "attribute4"
      ),
      coefficient = c(
        "l1_0",
        "l1_11",
        "l2_0",
        "l2_12",
        "l2_13",
        "l3_0",
        "l3_14",
        "l4_0",
        "l4_12",
        "l4_13",
        "l4_14"
      )
    )
  )

  crum_code <- meas_crum(
    qmatrix = rlang::set_names(rupp_gri[, -1], paste0("att", 1:4)),
    priors = default_dcm_priors(crum()),
    att_names = NULL,
    hierarchy = NULL
  )

  pi_code <- crum_code$transformed_parameters |>
    tibble::as_tibble() |>
    tidyr::separate_longer_delim("value", delim = "\n") |>
    dplyr::filter(grepl("^  pi", .data$value)) |>
    tidyr::separate_wider_regex(
      "value",
      patterns = c(
        ".*\\[",
        i = "[0-9]*",
        ",",
        c = "[0-9]*",
        "\\] = inv_logit\\(",
        value = ".*",
        "\\);$"
      )
    ) |>
    dplyr::mutate(i = paste0("Item ", i), c = as.integer(.data$c)) |>
    dplyr::left_join(
      dplyr::select(rupp_profiles, "id", "rupp_id"),
      by = c("c" = "id"),
      relationship = "many-to-one"
    ) |>
    dplyr::select(-"c") |>
    tidyr::pivot_wider(names_from = "i", values_from = "value") |>
    dplyr::arrange(.data$rupp_id)

  expect_identical(
    pi_code,
    # nolint start: line_length_linter
    tibble::tribble(
      ~rupp_id, ~`Item 1`,    ~`Item 2`,          ~`Item 3`,    ~`Item 4`,
            1L, "l1_0",       "l2_0",             "l3_0",       "l4_0",
            2L, "l1_0",       "l2_0",             "l3_0+l3_14", "l4_0+l4_14",
            3L, "l1_0",       "l2_0+l2_13",       "l3_0",       "l4_0+l4_13",
            4L, "l1_0",       "l2_0+l2_13",       "l3_0+l3_14", "l4_0+l4_13+l4_14",
            5L, "l1_0",       "l2_0+l2_12",       "l3_0",       "l4_0+l4_12",
            6L, "l1_0",       "l2_0+l2_12",       "l3_0+l3_14", "l4_0+l4_12+l4_14",
            7L, "l1_0",       "l2_0+l2_12+l2_13", "l3_0",       "l4_0+l4_12+l4_13",
            8L, "l1_0",       "l2_0+l2_12+l2_13", "l3_0+l3_14", "l4_0+l4_12+l4_13+l4_14",
            9L, "l1_0+l1_11", "l2_0",             "l3_0",       "l4_0",
           10L, "l1_0+l1_11", "l2_0",             "l3_0+l3_14", "l4_0+l4_14",
           11L, "l1_0+l1_11", "l2_0+l2_13",       "l3_0",       "l4_0+l4_13",
           12L, "l1_0+l1_11", "l2_0+l2_13",       "l3_0+l3_14", "l4_0+l4_13+l4_14",
           13L, "l1_0+l1_11", "l2_0+l2_12",       "l3_0",       "l4_0+l4_12",
           14L, "l1_0+l1_11", "l2_0+l2_12",       "l3_0+l3_14", "l4_0+l4_12+l4_14",
           15L, "l1_0+l1_11", "l2_0+l2_12+l2_13", "l3_0",       "l4_0+l4_12+l4_13",
           16L, "l1_0+l1_11", "l2_0+l2_12+l2_13", "l3_0+l3_14", "l4_0+l4_12+l4_13+l4_14"
    )
    # nolint end
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

  params <- get_parameters(
    unconstrained(),
    qmatrix = test_qmatrix,
    identifier = "test_item"
  )
  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("type", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(type = "structural", coefficient = "Vc")
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

  params <- get_parameters(
    independent(),
    qmatrix = test_qmatrix,
    identifier = "test_item"
  )
  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("type", "attributes", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(
      type = "structural",
      attributes = paste0("att", 1:4),
      coefficient = paste0("eta[", 1:4, "]")
    )
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

  params <- get_parameters(
    independent(),
    qmatrix = test_qmatrix,
    identifier = "test_item"
  )
  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("type", "attributes", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(
      type = "structural",
      attributes = c("add", "subtract", "multiply", "divide"),
      coefficient = paste0("eta[", 1:4, "]")
    )
  )

  params2 <- get_parameters(independent(), qmatrix = test_qmatrix[, -1])
  expect_true(tibble::is_tibble(params2))
  expect_equal(colnames(params2), c("type", "attributes", "coefficient"))

  expect_equal(params, params2)
})

test_that("loglinear parameters work", {
  test_qmatrix <- tibble::tibble(
    att1 = c(1, 0, 1, 1),
    att2 = c(0, 1, 0, 1),
    att3 = c(0, 1, 1, 1)
  )

  params <- get_parameters(loglinear(), qmatrix = test_qmatrix)

  expect_true(tibble::is_tibble(params))
  expect_equal(
    colnames(params),
    c("profile_id", "type", "attributes", "coefficient")
  )

  expect_equal(
    params,
    # nolint start: indentation_linter
    tibble::tribble(
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
    # nolint end
  )

  expect_equal(
    loglinear_parameters(
      test_qmatrix,
      max_interaction = 1,
      att_names = paste0("node", 1:3)
    ),
    # nolint start: indentation_linter
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
    )
    # nolint end
  )
})

test_that("hdcm parameters work", {
  test_qmatrix <- tibble::tibble(
    test_item = paste0("B", 1:5),
    att1 = sample(0:1, size = 5, replace = TRUE),
    att2 = sample(0:1, size = 5, replace = TRUE),
    att3 = sample(0:1, size = 5, replace = TRUE),
    att4 = sample(0:1, size = 5, replace = TRUE)
  )

  params <- get_parameters(
    hdcm(),
    qmatrix = test_qmatrix,
    identifier = "test_item"
  )
  expect_true(tibble::is_tibble(params))
  expect_equal(colnames(params), c("type", "coefficient"))

  expect_equal(
    params,
    tibble::tibble(type = "structural", coefficient = "Vc")
  )

  params2 <- get_parameters(hdcm(), qmatrix = test_qmatrix[, -1])
  expect_true(tibble::is_tibble(params2))
  expect_equal(colnames(params2), c("type", "coefficient"))

  expect_equal(params, params2)
})

test_that("bayesian network parameters work", {
  params <- get_parameters(
    bayesnet(
      "appropriateness -> multiplicative_comparison
       appropriateness -> partitioning_iterating
       multiplicative_comparison -> referent_units
       partitioning_iterating -> referent_units"
    ),
    qmatrix = dcmdata::dtmr_qmatrix,
    identifier = "item"
  )

  expect_true(tibble::is_tibble(params))
  expect_equal(
    colnames(params),
    c("profile_id", "type", "attributes", "coefficient")
  )

  expect_equal(
    params,
    # nolint start: indentation_linter, line_length_linter
    tibble::tribble(
      ~profile_id,                    ~type,                                         ~attributes, ~coefficient,
               1L,   "structural_intercept",                                    "referent_units",       "g1_0",
               1L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
               1L,   "structural_intercept",                                   "appropriateness",       "g3_0",
               1L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
               2L,   "structural_intercept",                                    "referent_units",       "g1_0",
               2L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
               2L,   "structural_intercept",                                   "appropriateness",       "g3_0",
               2L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
               3L,   "structural_intercept",                                    "referent_units",       "g1_0",
               3L,  "structural_maineffect",                            "partitioning_iterating",      "g1_12",
               3L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
               3L,   "structural_intercept",                                   "appropriateness",       "g3_0",
               3L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
               4L,   "structural_intercept",                                    "referent_units",       "g1_0",
               4L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
               4L,  "structural_maineffect",                                   "appropriateness",      "g2_13",
               4L,   "structural_intercept",                                   "appropriateness",       "g3_0",
               4L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
               4L,  "structural_maineffect",                                   "appropriateness",      "g4_13",
               5L,   "structural_intercept",                                    "referent_units",       "g1_0",
               5L,  "structural_maineffect",                         "multiplicative_comparison",      "g1_14",
               5L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
               5L,   "structural_intercept",                                   "appropriateness",       "g3_0",
               5L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
               6L,   "structural_intercept",                                    "referent_units",       "g1_0",
               6L,  "structural_maineffect",                            "partitioning_iterating",      "g1_12",
               6L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
               6L,   "structural_intercept",                                   "appropriateness",       "g3_0",
               6L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
               7L,   "structural_intercept",                                    "referent_units",       "g1_0",
               7L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
               7L,  "structural_maineffect",                                   "appropriateness",      "g2_13",
               7L,   "structural_intercept",                                   "appropriateness",       "g3_0",
               7L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
               7L,  "structural_maineffect",                                   "appropriateness",      "g4_13",
               8L,   "structural_intercept",                                    "referent_units",       "g1_0",
               8L,  "structural_maineffect",                         "multiplicative_comparison",      "g1_14",
               8L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
               8L,   "structural_intercept",                                   "appropriateness",       "g3_0",
               8L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
               9L,   "structural_intercept",                                    "referent_units",       "g1_0",
               9L,  "structural_maineffect",                            "partitioning_iterating",      "g1_12",
               9L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
               9L,  "structural_maineffect",                                   "appropriateness",      "g2_13",
               9L,   "structural_intercept",                                   "appropriateness",       "g3_0",
               9L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
               9L,  "structural_maineffect",                                   "appropriateness",      "g4_13",
              10L,   "structural_intercept",                                    "referent_units",       "g1_0",
              10L,  "structural_maineffect",                            "partitioning_iterating",      "g1_12",
              10L,  "structural_maineffect",                         "multiplicative_comparison",      "g1_14",
              10L, "structural_interaction", "partitioning_iterating__multiplicative_comparison",     "g1_224",
              10L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
              10L,   "structural_intercept",                                   "appropriateness",       "g3_0",
              10L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
              11L,   "structural_intercept",                                    "referent_units",       "g1_0",
              11L,  "structural_maineffect",                         "multiplicative_comparison",      "g1_14",
              11L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
              11L,  "structural_maineffect",                                   "appropriateness",      "g2_13",
              11L,   "structural_intercept",                                   "appropriateness",       "g3_0",
              11L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
              11L,  "structural_maineffect",                                   "appropriateness",      "g4_13",
              12L,   "structural_intercept",                                    "referent_units",       "g1_0",
              12L,  "structural_maineffect",                            "partitioning_iterating",      "g1_12",
              12L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
              12L,  "structural_maineffect",                                   "appropriateness",      "g2_13",
              12L,   "structural_intercept",                                   "appropriateness",       "g3_0",
              12L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
              12L,  "structural_maineffect",                                   "appropriateness",      "g4_13",
              13L,   "structural_intercept",                                    "referent_units",       "g1_0",
              13L,  "structural_maineffect",                            "partitioning_iterating",      "g1_12",
              13L,  "structural_maineffect",                         "multiplicative_comparison",      "g1_14",
              13L, "structural_interaction", "partitioning_iterating__multiplicative_comparison",     "g1_224",
              13L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
              13L,   "structural_intercept",                                   "appropriateness",       "g3_0",
              13L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
              14L,   "structural_intercept",                                    "referent_units",       "g1_0",
              14L,  "structural_maineffect",                         "multiplicative_comparison",      "g1_14",
              14L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
              14L,  "structural_maineffect",                                   "appropriateness",      "g2_13",
              14L,   "structural_intercept",                                   "appropriateness",       "g3_0",
              14L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
              14L,  "structural_maineffect",                                   "appropriateness",      "g4_13",
              15L,   "structural_intercept",                                    "referent_units",       "g1_0",
              15L,  "structural_maineffect",                            "partitioning_iterating",      "g1_12",
              15L,  "structural_maineffect",                         "multiplicative_comparison",      "g1_14",
              15L, "structural_interaction", "partitioning_iterating__multiplicative_comparison",     "g1_224",
              15L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
              15L,  "structural_maineffect",                                   "appropriateness",      "g2_13",
              15L,   "structural_intercept",                                   "appropriateness",       "g3_0",
              15L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
              15L,  "structural_maineffect",                                   "appropriateness",      "g4_13",
              16L,   "structural_intercept",                                    "referent_units",       "g1_0",
              16L,  "structural_maineffect",                            "partitioning_iterating",      "g1_12",
              16L,  "structural_maineffect",                         "multiplicative_comparison",      "g1_14",
              16L, "structural_interaction", "partitioning_iterating__multiplicative_comparison",     "g1_224",
              16L,   "structural_intercept",                            "partitioning_iterating",       "g2_0",
              16L,  "structural_maineffect",                                   "appropriateness",      "g2_13",
              16L,   "structural_intercept",                                   "appropriateness",       "g3_0",
              16L,   "structural_intercept",                         "multiplicative_comparison",       "g4_0",
              16L,  "structural_maineffect",                                   "appropriateness",      "g4_13"
    )
    # nolint end
  )

  test_qmatrix <- tibble::tibble(
    att1 = c(1, 0, 1, 1),
    att2 = c(0, 1, 0, 1),
    att3 = c(0, 1, 1, 1)
  )

  params <- get_parameters(
    bayesnet(),
    qmatrix = test_qmatrix,
    attributes = paste0("att", 1:3)
  )

  expect_equal(
    params,
    # nolint start: indentation_linter
    tibble::tribble(
      ~profile_id,                    ~type,  ~attributes, ~coefficient,
               1L,   "structural_intercept",       "att1",       "g1_0",
               1L,   "structural_intercept",       "att2",       "g2_0",
               1L,   "structural_intercept",       "att3",       "g3_0",
               2L,   "structural_intercept",       "att1",       "g1_0",
               2L,   "structural_intercept",       "att2",       "g2_0",
               2L,  "structural_maineffect",       "att1",      "g2_11",
               2L,   "structural_intercept",       "att3",       "g3_0",
               2L,  "structural_maineffect",       "att1",      "g3_11",
               3L,   "structural_intercept",       "att1",       "g1_0",
               3L,   "structural_intercept",       "att2",       "g2_0",
               3L,   "structural_intercept",       "att3",       "g3_0",
               3L,  "structural_maineffect",       "att2",      "g3_12",
               4L,   "structural_intercept",       "att1",       "g1_0",
               4L,   "structural_intercept",       "att2",       "g2_0",
               4L,   "structural_intercept",       "att3",       "g3_0",
               5L,   "structural_intercept",       "att1",       "g1_0",
               5L,   "structural_intercept",       "att2",       "g2_0",
               5L,  "structural_maineffect",       "att1",      "g2_11",
               5L,   "structural_intercept",       "att3",       "g3_0",
               5L,  "structural_maineffect",       "att1",      "g3_11",
               5L,  "structural_maineffect",       "att2",      "g3_12",
               5L, "structural_interaction", "att1__att2",     "g3_212",
               6L,   "structural_intercept",       "att1",       "g1_0",
               6L,   "structural_intercept",       "att2",       "g2_0",
               6L,  "structural_maineffect",       "att1",      "g2_11",
               6L,   "structural_intercept",       "att3",       "g3_0",
               6L,  "structural_maineffect",       "att1",      "g3_11",
               7L,   "structural_intercept",       "att1",       "g1_0",
               7L,   "structural_intercept",       "att2",       "g2_0",
               7L,   "structural_intercept",       "att3",       "g3_0",
               7L,  "structural_maineffect",       "att2",      "g3_12",
               8L,   "structural_intercept",       "att1",       "g1_0",
               8L,   "structural_intercept",       "att2",       "g2_0",
               8L,  "structural_maineffect",       "att1",      "g2_11",
               8L,   "structural_intercept",       "att3",       "g3_0",
               8L,  "structural_maineffect",       "att1",      "g3_11",
               8L,  "structural_maineffect",       "att2",      "g3_12",
               8L, "structural_interaction", "att1__att2",     "g3_212"
    )
    # nolint end
  )
})


# dcm specification parameters -------------------------------------------------
test_that("warnings are produced for unnecessary arguments", {
  test_qmatrix <- tibble::tibble(
    att1 = c(1, 0, 1, 1),
    att2 = c(0, 1, 0, 1),
    att3 = c(0, 1, 1, 1),
    att4 = c(0, 0, 1, 1)
  )

  spec1 <- dcm_specify(qmatrix = test_qmatrix)
  expect_warning(
    get_parameters(spec1, qmatrix = test_qmatrix),
    "should not be specified"
  )
  expect_warning(
    get_parameters(spec1, qmatrix = test_qmatrix, identifier = "item"),
    "should not be specified"
  )
  expect_warning(
    get_parameters(spec1, identifier = "item"),
    "should not be specified"
  )
})

test_that("combining parameters in a specification works", {
  test_qmatrix <- tibble::tibble(
    skill1 = c(1, 0, 1, 1),
    skill2 = c(0, 1, 0, 1),
    skill3 = c(0, 1, 1, 1),
    skill4 = c(0, 0, 1, 1)
  )

  spec1 <- dcm_specify(qmatrix = test_qmatrix)
  expect_equal(
    get_parameters(spec1),
    dplyr::bind_rows(
      get_parameters(lcdm(), qmatrix = test_qmatrix),
      get_parameters(unconstrained(), qmatrix = test_qmatrix)
    )
  )

  spec2 <- dcm_specify(
    qmatrix = test_qmatrix,
    measurement_model = lcdm(max_interaction = 2)
  )
  expect_equal(
    get_parameters(spec2),
    dplyr::bind_rows(
      get_parameters(lcdm(max_interaction = 2), qmatrix = test_qmatrix),
      get_parameters(unconstrained(), qmatrix = test_qmatrix)
    )
  )

  spec3 <- dcm_specify(
    qmatrix = test_qmatrix,
    measurement_model = crum(),
    structural_model = independent()
  )
  expect_equal(
    get_parameters(spec3),
    dplyr::bind_rows(
      get_parameters(crum(), qmatrix = test_qmatrix),
      get_parameters(independent(), qmatrix = test_qmatrix)
    )
  )

  spec4 <- dcm_specify(
    qmatrix = test_qmatrix,
    measurement_model = lcdm(),
    structural_model = loglinear()
  )
  expect_equal(
    get_parameters(spec4),
    dplyr::bind_rows(
      get_parameters(lcdm(), qmatrix = test_qmatrix),
      get_parameters(loglinear(), qmatrix = test_qmatrix)
    ) |>
      dplyr::select(
        dplyr::any_of(c("item_id", "profile_id")),
        dplyr::everything()
      )
  )

  spec4 <- dcm_specify(
    qmatrix = test_qmatrix,
    measurement_model = lcdm(),
    structural_model = loglinear(max_interaction = 1)
  )
  expect_equal(
    get_parameters(spec4),
    dplyr::bind_rows(
      get_parameters(lcdm(), qmatrix = test_qmatrix),
      get_parameters(loglinear(max_interaction = 1), qmatrix = test_qmatrix)
    ) |>
      dplyr::select(
        dplyr::any_of(c("item_id", "profile_id")),
        dplyr::everything()
      )
  )
})
