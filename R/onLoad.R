.kdenv <- new.env()

#' @importFrom reticulate use_condaenv configure_environment
.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)
  loads()
}
