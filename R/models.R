.theeuhenv <- new.env()

check_model_set <- function() {
  length(ls(envir = .theeuhenv)) == 2
}

load_models <- function() {
  w2idx <-
    file.path(system.file(package = "theeuh"), "model", 'w2idx')

  w2idx_tbl <- readRDS(w2idx)

  hash <- sapply(unique(w2idx_tbl$Keys), function(x) {
    w2idx_tbl[w2idx_tbl$Keys == x, 2]
  }, simplify = FALSE)

  assign("hash", hash, envir = .theeuhenv)

  model_file <-
    file.path(system.file(package = "theeuh"), "model", 'kospacing.onnx')

  sess <- churon::onnx_session(model_path = model_file)
  assign("sess", sess, envir = .theeuhenv)
}
