# remotes::install_version("reticulate", version = "1.22")
# remotes::install_github('forkonlp/KoSpacing', upgrade = "never")
#
# library(reticulate) # need to use 1.22
#
# envnm <- 'r-kospacing'
# reticulate::use_condaenv(envnm, required = TRUE)
#
# if (!reticulate::py_module_available("keras2onnx")) {
#   reticulate::conda_install(envnm, packages = c('keras2onnx==1.7.0'))
# }
# if (!reticulate::py_module_available("onnx")) {
#   reticulate::conda_install(envnm, packages = c('onnx'))
# }
# if (!reticulate::py_module_available("onnxruntime")) {
#   reticulate::conda_install(envnm, packages = c('onnxruntime'), pip = TRUE)
# }
#
#
# model_file <-
#   file.path(system.file(package = "KoSpacing"), "model", 'kospacing')
#
# keras <- reticulate::import("keras")
# ko <- reticulate::import("keras2onnx")
# onnx <- reticulate::import("onnx")
# model <- keras$models$load_model(model_file, compile = FALSE)
#
# onnx_model <- ko$convert_keras(model, "kospacing")
# onnx$save_model(onnx_model, "kospacing.onnx")
#
