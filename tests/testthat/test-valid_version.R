test_that("multiplication works", {
  expect_equal(valid_version("v1.12.1"), TRUE)
  expect_equal(valid_version("v1.13.1"), FALSE)
})
