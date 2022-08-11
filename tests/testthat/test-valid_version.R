test_that("multiplication works", {
  expect_equal(valid_version("1.12.1"), TRUE)
  expect_equal(valid_version("1.13.1"), FALSE)
  expect_equal(valid_version("1.0.0"), TRUE)
  expect_equal(valid_version("iufdf"), FALSE)
  expect_equal(valid_version("rtfv"), FALSE)
  expect_equal(valid_version("v1.12.1"), FALSE)
})
