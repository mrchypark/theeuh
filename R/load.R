#' @importFrom reticulate import
loads <- function() {
  w2idx <-
    file.path(system.file(package = "theeuh"), "model", 'w2idx')

  w2idx_tbl <- readRDS(w2idx)

  hash <- sapply(unique(w2idx_tbl$Keys), function(x) {
    w2idx_tbl[w2idx_tbl$Keys == x, 2]
  }, simplify = FALSE)

  assign("hash", hash, envir = .kdenv)

  model_file <-
    file.path(system.file(package = "theeuh"), "model", 'kospacing.onnx')

  ort <- reticulate::import("onnxruntime")
  sess <- ort$InferenceSession(model_file)
  assign("sess", sess, envir = .kdenv)

  ort <- reticulate::import("onnxruntime")
  assign("ort", ort, envir = .kdenv)
}
