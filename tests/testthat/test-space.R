test_that("space works", {
  skip_if_no_onnxruntime()
  src <- "안녕하세요저는박박사입니다."

  expect_equal(space(src),
               "안녕하세 요저는 박 박사입니다.")
})
