library(testthat)
library(EnsDb.Gmax.Wm82.v62)

test_that("EnsDb object loads correctly", {
  edb <- EnsDb.Gmax.Wm82.v62
  expect_s4_class(edb, "EnsDb")
  expect_true(length(genes(edb)) > 30000)
})