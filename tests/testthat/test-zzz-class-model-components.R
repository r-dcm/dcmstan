test_that("measurement class works", {
  expect_true(S7::S7_inherits(measurement))

  expect_true(S7::S7_inherits(measurement(), measurement))
  expect_true(S7::S7_inherits(lcdm(), measurement))
  expect_true(S7::S7_inherits(dina(), measurement))
  expect_true(S7::S7_inherits(dino(), measurement))
  expect_true(S7::S7_inherits(crum(), measurement))
  expect_true(S7::S7_inherits(nida(), measurement))
  expect_true(S7::S7_inherits(nido(), measurement))
  expect_true(S7::S7_inherits(ncrum(), measurement))

  expect_true(S7::S7_inherits(lcdm(), LCDM))
  expect_true(S7::S7_inherits(dina(), DINA))
  expect_true(S7::S7_inherits(dino(), DINO))
  expect_true(S7::S7_inherits(crum(), CRUM))
  expect_true(S7::S7_inherits(nida(), NIDA))
  expect_true(S7::S7_inherits(nido(), NIDO))
  expect_true(S7::S7_inherits(ncrum(), NCRUM))
})

test_that("structural class works", {
  expect_true(S7::S7_inherits(structural))

  expect_true(S7::S7_inherits(structural(), structural))
  expect_true(S7::S7_inherits(unconstrained(), structural))
  expect_true(S7::S7_inherits(independent(), structural))
  expect_true(S7::S7_inherits(loglinear(), structural))
  expect_true(S7::S7_inherits(hdcm(), structural))
  expect_true(S7::S7_inherits(bayesnet(), structural))

  expect_true(S7::S7_inherits(unconstrained(), UNCONSTRAINED))
  expect_true(S7::S7_inherits(independent(), INDEPENDENT))
  expect_true(S7::S7_inherits(loglinear(), LOGLINEAR))
  expect_true(S7::S7_inherits(hdcm(), HDCM))
  expect_true(S7::S7_inherits(bayesnet(), BAYESNET))
})
