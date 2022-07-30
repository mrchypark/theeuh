.theeuhenv <- new.env()

#' @importFrom reticulate py_config
.onLoad <- function(libname, pkgname) {
  reticulate::py_config()
}
