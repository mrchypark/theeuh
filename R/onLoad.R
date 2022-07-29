.kdenv <- new.env()

#' @importFrom reticulate use_condaenv configure_environment
.onLoad <- function(libname, pkgname) {
  reticulate::use_condaenv("r-reticulate")
  reticulate::configure_environment(pkgname)
  loads()
}
