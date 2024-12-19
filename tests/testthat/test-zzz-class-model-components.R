test_that("measurement class works", {
  expect_true(S7::S7_inherits(measurement))

  expect_true(S7::S7_inherits(measurement(), measurement))
  expect_true(S7::S7_inherits(lcdm(), measurement))
  expect_true(S7::S7_inherits(dina(), measurement))
  expect_true(S7::S7_inherits(dino(), measurement))
  expect_true(S7::S7_inherits(crum(), measurement))

  expect_true(S7::S7_inherits(lcdm(), LCDM))
  expect_true(S7::S7_inherits(dina(), DINA))
  expect_true(S7::S7_inherits(dino(), DINO))
  expect_true(S7::S7_inherits(crum(), CRUM))
})

test_that("structural class works", {
  expect_true(S7::S7_inherits(structural))

  expect_true(S7::S7_inherits(structural(), structural))
  expect_true(S7::S7_inherits(unconstrained(), structural))
  expect_true(S7::S7_inherits(independent(), structural))
  expect_true(S7::S7_inherits(hierarchical(), structural))

  expect_true(S7::S7_inherits(unconstrained(), UNCONSTRAINED))
  expect_true(S7::S7_inherits(independent(), INDEPENDENT))
  expect_true(S7::S7_inherits(hierarchical(), HIERARCHICAL))
})
