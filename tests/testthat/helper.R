skip_if_no_onnxruntime <- function() {
  if (!reticulate::py_module_available("onnxruntime"))
    skip("onnxruntime not available for testing")
}
