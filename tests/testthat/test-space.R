test_that("space works", {
  src <- "이제커밋하면에러가해결됩니다."

  expect_equal(space(src),
               "이제 커밋하면 에러가 해결됩니다.")
})
