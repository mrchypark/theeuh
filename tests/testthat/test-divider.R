test_that("divider works", {
  src <- "안녕하세요저는박박사입니다."

  expect_equal(divider(src),
               "안녕하세요 저는 박박사입니다.")
})
