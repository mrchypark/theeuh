#' @importFrom churon onnx_session onnx_run
NULL

.theeuhenv <- new.env(parent = emptyenv())

check_model_set <- function() {
  all(c("hash", "sess") %in% ls(envir = .theeuhenv))
}

load_models <- function() {
  if (!churon::check_onnx_runtime_available()) {
    stop(
      "ONNX Runtime is not configured. Call ",
      "churon::install_onnx_runtime(destdir = ...) before using space(). ",
      "In later R sessions, set ORT_DYLIB_PATH to the installed library.",
      call. = FALSE
    )
  }

  w2idx <- system.file("model", "w2idx", package = "theeuh", mustWork = TRUE)
  w2idx_tbl <- readRDS(w2idx)
  hash <- structure(as.list(w2idx_tbl$Values), names = w2idx_tbl$Keys)

  model_file <-
    system.file("model", "kospacing.onnx", package = "theeuh", mustWork = TRUE)
  old_telemetry <- Sys.getenv("ORT_DISABLE_TELEMETRY", unset = NA_character_)
  on.exit({
    if (is.na(old_telemetry)) {
      Sys.unsetenv("ORT_DISABLE_TELEMETRY")
    } else {
      Sys.setenv(ORT_DISABLE_TELEMETRY = old_telemetry)
    }
  }, add = TRUE)
  # ONNX Runtime reads this at initialization and keeps the process-wide opt-out.
  if (!Sys.setenv(ORT_DISABLE_TELEMETRY = "1")) {
    stop("Unable to disable ONNX Runtime telemetry.", call. = FALSE)
  }
  sess <- churon::onnx_session(model_path = model_file)

  assign("hash", hash, envir = .theeuhenv)
  assign("sess", sess, envir = .theeuhenv)
}
