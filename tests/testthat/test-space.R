test_that("space works", {
  skip_if_not(churon::check_onnx_runtime_available())
  src <- "이제커밋하면에러가해결됩니다."
  old_telemetry <- Sys.getenv("ORT_DISABLE_TELEMETRY", unset = NA_character_)
  tryCatch({
    Sys.unsetenv("ORT_DISABLE_TELEMETRY")
    before <- list.files(tempdir(), pattern = "^mat-debug", recursive = TRUE)
    expect_equal(space(src), "이제 커밋하면 에러가 해결됩니다.")
    expect_true(is.na(Sys.getenv("ORT_DISABLE_TELEMETRY", unset = NA_character_)))
    expect_identical(
      list.files(tempdir(), pattern = "^mat-debug", recursive = TRUE), before
    )
  }, finally = {
    if (is.na(old_telemetry)) {
      Sys.unsetenv("ORT_DISABLE_TELEMETRY")
    } else {
      Sys.setenv(ORT_DISABLE_TELEMETRY = old_telemetry)
    }
  })
})

test_that("space validates character vectors and preserves missing values", {
  expect_error(space(1), "ko_sents must be a character vector", fixed = TRUE)
  expect_error(space(NULL), "ko_sents must be a character vector", fixed = TRUE)
  expect_error(space(list("가")), "character vector")
  expect_error(space(matrix("가")), "character vector")
  expect_identical(space(character()), list())
  expect_identical(space(""), "")
  expect_identical(space(NA_character_), NA_character_)
  expect_identical(space(c(first = "", second = NA_character_)),
                   list("", NA_character_))
})

test_that("prediction decoding preserves input characters", {
  src <- "안녕|«하세요»🙂"
  expect_identical(make_pred_sent(src, rep(0, 200)), src)
  expect_identical(make_pred_sent("가나", c(1, 0.5, 0.6, 1)), "가나")
  expect_identical(make_pred_sent("가나", c(0, 0.6, 0, 0)), "가 나")
  expect_identical(make_pred_sent(" 가\t\t나\n", rep(0, 200)), "가 나")
  expect_identical(make_pred_sent("", rep(0, 200)), "")
})

test_that("model loading reports missing runtime configuration", {
  old_path <- Sys.getenv("ORT_DYLIB_PATH")
  tryCatch({
    Sys.unsetenv("ORT_DYLIB_PATH")
    expect_error(load_models(), "churon::install_onnx_runtime", fixed = TRUE)
  }, finally = Sys.setenv(ORT_DYLIB_PATH = old_path))
})

test_that("space handles vectors, unknown characters and model limits", {
  skip_if_not(churon::check_onnx_runtime_available())
  src <- "이제커밋하면에러가해결됩니다."
  expected <- "이제 커밋하면 에러가 해결됩니다."
  expect_identical(space(c(first = src, second = NA_character_, third = "")),
                   list(expected, NA_character_, ""))

  symbols <- "안녕|«하세요»🙂"
  expect_identical(gsub("[[:space:]]", "", space(symbols)), symbols)
  expect_identical(space("  안녕하세요\t반갑습니다\n"),
                   "안녕하세요 반갑습니다")

  limit <- strrep("가", 198)
  expect_warning(space(limit), NA)
  expect_warning(result <- space(paste0(limit, "나")), "198 characters")
  expect_identical(result, space(limit))
})

test_that("failed session construction restores telemetry settings", {
  local_mocked_bindings(
    check_onnx_runtime_available = function() TRUE,
    onnx_session = function(...) stop("test session error"),
    .package = "churon"
  )
  old_telemetry <- Sys.getenv("ORT_DISABLE_TELEMETRY", unset = NA_character_)
  tryCatch({
    for (value in c(NA_character_, "", "0", "1")) {
      if (is.na(value)) {
        Sys.unsetenv("ORT_DISABLE_TELEMETRY")
      } else {
        Sys.setenv(ORT_DISABLE_TELEMETRY = value)
      }
      # Windows treats an empty environment variable as unset.
      before <- Sys.getenv("ORT_DISABLE_TELEMETRY", unset = NA_character_)
      expect_error(load_models(), "test session error", fixed = TRUE)
      expect_identical(
        Sys.getenv("ORT_DISABLE_TELEMETRY", unset = NA_character_), before
      )
    }
  }, finally = {
    if (is.na(old_telemetry)) {
      Sys.unsetenv("ORT_DISABLE_TELEMETRY")
    } else {
      Sys.setenv(ORT_DISABLE_TELEMETRY = old_telemetry)
    }
  })
})
