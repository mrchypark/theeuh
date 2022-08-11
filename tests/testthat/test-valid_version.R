test_that("valid_version", {
  expect_equal(is_semver("1.12.1"), TRUE)
  expect_equal(is_semver("1.0.0"), TRUE)
  expect_equal(is_semver("1.13.1"), TRUE)
  expect_equal(is_semver("v1.12.1"), FALSE)
  expect_equal(is_semver("iufdf"), FALSE)
  expect_equal(is_semver(1), FALSE)


  expect_equal(valid_version("1.12.1"), TRUE)
  expect_equal(valid_version("1.13.1"), FALSE)
  expect_equal(valid_version("1.0.0"), TRUE)
})
