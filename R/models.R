check_model_set <- function() {
  length(ls(envir = .theeuhenv)) == 2
}

#' @importFrom torch torch_load
load_models <- function() {
  w2idx <-
    file.path(system.file(package = "theeuh"), "model", 'w2idx')

  w2idx_tbl <- readRDS(w2idx)

  hash <- sapply(unique(w2idx_tbl$Keys), function(x) {
    w2idx_tbl[w2idx_tbl$Keys == x, 2]
  }, simplify = FALSE)

  assign("hash", hash, envir = .theeuhenv)

  model_file <-
    file.path(system.file(package = "theeuh"), "model", 'kospacing')

  model <- torch::torch_load(model_file)
  assign("model", model, envir = .theeuhenv)
}


