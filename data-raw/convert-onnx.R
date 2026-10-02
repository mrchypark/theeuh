# Development prerequisites: reticulate 1.22, KoSpacing, and a configured
# r-kospacing Python environment with keras, keras2onnx 1.7.0, and onnx.
# Install prerequisites explicitly before running this conversion script.

library(reticulate) # need to use 1.22

envnm <- 'r-kospacing'
reticulate::use_condaenv(envnm, required = TRUE)

model_file <-
  file.path(system.file(package = "KoSpacing"), "model", 'kospacing')

keras <- reticulate::import("keras")
ko <- reticulate::import("keras2onnx")
onnx <- reticulate::import("onnx")
model <- keras$models$load_model(model_file, compile = FALSE)

onnx_model <- ko$convert_keras(model, "kospacing")
onnx$save_model(onnx_model, "kospacing.onnx")
