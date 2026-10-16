test_that("check_constraint_data", {

  test_constraints <- tibble::tribble(
    ~attribute , ~classification, ~item_1 , ~item_2 , ~item_3 , ~item_4 ,
    "att1"     , 1L             , 1L      , 1L      , 0L      , 0L      ,
    "att1"     , 0L             , 0L      , 0L      , 0L      , 0L      ,
    "att2"     , 1L             , 0L      , 0L      , 1L      , 1L      ,
    "att2"     , 0L             , 0L      , 0L      , 0L      , 0L
  )

  expect_error(
    check_constraint_data(
      constraints = test_constraints,
      pattern_identifier = "pattern"
    ),
    "`pattern_identifier` must be included in `constraints`"
  )
  expect_error(
    check_constraint_data(
      constraints = test_constraints,
      pattern_identifier = NULL,
      attribute_identifier = "attribute_id"
    ),
    "`attribute_identifier` must be included in `constraints`"
  )
  expect_error(
    check_constraint_data(
      constraints = test_constraints,
      pattern_identifier = NULL,
      attribute_identifier = "attribute",
      classification_identifier = "status"
    ),
    "`classification_identifier` must be included in `constraints`"
  )
  expect_error(
    check_constraint_data(
      constraints = tibble::tibble()
    ),
    "`constraints` must be a non-empty data frame; not list"
  )

  error_constraints <- tibble::tribble(
    ~attribute , ~classification, ~item_1 , ~item_2 , ~item_3 , ~item_4 ,
    NA         , 1L             , 1L      , 1L      , 0L      , 0L      ,
    "att1"     , 0L             , 0L      , 0L      , 0L      , 0L      ,
    "att2"     , 1L             , 0L      , 0L      , 1L      , 1L      ,
    "att2"     , 0L             , 0L      , 0L      , 0L      , 0L
  )

  expect_error(
    check_constraint_data(
      constraints = error_constraints,
      attribute_identifier = "attribute"
    ),
    "`attribute_identifier` must contain only character strings"
  )

  error_constraints2 <- tibble::tribble(
    ~attribute , ~classification, ~item_1 , ~item_2 , ~item_3 , ~item_4 ,
    "att1"     , NA             , 1L      , 1L      , 0L      , 0L      ,
    "att1"     , 0L             , 0L      , 0L      , 0L      , 0L      ,
    "att2"     , 1L             , 0L      , 0L      , 1L      , 1L      ,
    "att2"     , 0L             , 0L      , 0L      , 0L      , 0L
  )

  expect_error(
    check_constraint_data(
      constraints = error_constraints2,
      classification_identifier = "classification"
    ),
    "`classification_identifier` must contain only numeric values of 0 or 1"
  )

})

test_that("check_threshold_data", {

  test_thresholds <- tibble::tribble(
    ~classification , ~threshold ,
    1L              , 0.70       ,
    0L              , 0.30
  )

  expect_error(
    check_threshold_data(
      thresholds = test_thresholds,
      classification_identifier = "status"
    ),
    "`classification_identifier` must be included in `thresholds`"
  )
  expect_error(
    check_threshold_data(
      thresholds = test_thresholds,
      classification_identifier = "classification",
      threshold_identifier = "tau"
    ),
    "`threshold_identifier` must be included in `thresholds`"
  )

  error_thresholds <- tibble::tribble(
    ~classification , ~threshold ,
    NA              , 0.70       ,
    0L              , 0.30
  )

  expect_error(
    check_threshold_data(
      thresholds = error_thresholds,
      classification_identifier = "classification"
    ),
    "`classification_identifier` must contain only numeric values of 0 or 1"
  )

  error_thresholds2 <- tibble::tribble(
    ~classification , ~threshold ,
    1L              , 1.10       ,
    0L              , 0.30
  )

  expect_error(
    check_threshold_data(
      thresholds = error_thresholds2,
      threshold_identifier = "threshold"
    ),
    "`threshold_identifier` must contain only numeric values between 0 and 1"
  )

  error_thresholds3 <- tibble::tribble(
    ~classification , ~threshold ,
    1L              , 0.70       ,
    1L              , 0.60       ,
    0L              , 0.30
  )

  expect_error(
    check_threshold_data(
      thresholds = error_thresholds3,
      classification_identifier = "classification"
    ),
    "`thresholds` must contain only one threshold value per classification"
  )

  error_thresholds4 <- tibble::tribble(
    ~classification , ~threshold ,
    1L              , 0.30       ,
    0L              , 0.70
  )

  expect_error(
    check_threshold_data(
      thresholds = error_thresholds4,
      classification_identifier = "classification"
    ),
    paste(
      "`thresholds` must contain threshold values that are non-decreasing",
      "with increasing classification values"
    )
  )

})

test_that("check_constraints", {

  test_constraints0 <- tibble::tribble(
    ~pattern , ~attribute , ~classification, ~item_1 , ~item_2 , ~item_3 , ~item_4 ,
    "001"    , "att1"     , 1L             , 1L      , 1L      , 0L      , 0L      ,
    "002"    , "att1"     , 0L             , 0L      , 0L      , 0L      , 0L      ,
    "003"    , "att2"     , 1L             , 0L      , 0L      , 1L      , 1L      ,
    "002"    , "att2"     , 0L             , 0L      , 0L      , 0L      , 0L
  )
  test_constraints <- tibble::tribble(
    ~attribute , ~classification, ~item_1 , ~item_2 , ~item_3 , ~item_4 ,
    "att1"     , 1L             , 1L      , 1L      , 0L      , 0L      ,
    "att1"     , 0L             , 0L      , 0L      , 0L      , 0L      ,
    "att2"     , 1L             , 0L      , 0L      , 1L      , 1L      ,
    "att2"     , 0L             , 0L      , 0L      , 0L      , 0L
  )
  test_thresholds0 <- tibble::tribble(
    ~classification , ~threshold ,
    1L              , 0.70       ,
    0L              , 0.30
  )
  test_thresholds <- tibble::tribble(
    ~classification , ~threshold ,
    1L              , 0.70
  )
  test_thresholds2 <- tibble::tribble(
    ~classification , ~threshold ,
    2L              , 0.90       ,
    1L              , 0.70       ,
    0L              , 0.30
  )

  expect_error(
    clean_constraints(
      constraints = test_constraints,
      missing = NA,
      thresholds = test_thresholds,
      pattern_identifier = NULL,
      attribute_identifier = "attribute",
      classification_identifier = "classification",
      threshold_identifier = "threshold"
    ),
    "`thresholds` must include all classifications present in `constraints`"
  )

  expect_error(
    clean_constraints(
      constraints = test_constraints,
      missing = NA,
      thresholds = test_thresholds2,
      pattern_identifier = NULL,
      attribute_identifier = "attribute",
      classification_identifier = "classification",
      threshold_identifier = "threshold"
    ),
    "`thresholds` must only include classifications present in `constraints`"
  )

  cleaned_constraints <- clean_constraints(
    constraints = test_constraints0,
    missing = NA,
    thresholds = test_thresholds0,
    pattern_identifier = NULL,
    attribute_identifier = "attribute",
    classification_identifier = "classification",
    threshold_identifier = "threshold"
  )
  expect_equal(names(cleaned_constraints), c("patterns", "constraints"))
  expect_equal(names(cleaned_constraints$patterns),
               c("pattern", "item", "score"))
  expect_equal(names(cleaned_constraints$constraints),
               c("pattern", "att", "class", "tau"))

})
