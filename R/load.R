check_model_set <- function() {
  length(ls(envir = .theeuhenv)) == 3
}

#' @importFrom reticulate import
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

  ort <- reticulate::import("onnxruntime")
  assign("ort", ort, envir = .theeuhenv)
  sess <- ort$InferenceSession(model_file)
  assign("sess", sess, envir = .theeuhenv)

}

#' @importFrom reticulate conda_create py_module_available use_condaenv conda_install
set_env <- function() {
  envnm <- 'r-theeuh'
  chk <- try(reticulate::use_condaenv(envnm, required = TRUE), silent = T)
  if (!inherits(chk, "try-error")) {
    reticulate::conda_create(envnm, packages = "numpy")
    reticulate::use_condaenv(envnm, required = TRUE)
  }
  if (!reticulate::py_module_available("onnxruntime")) {
    reticulate::conda_install(envnm, packages = c('onnxruntime==1.12.0'), pip = TRUE)
  }
}
