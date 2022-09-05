.theeuhenv <- new.env()

.onLoad <- function(libname, pkgname) {

  if (as.logical(Sys.getenv("USE_THEEUH_PYTHON_ENV", unset = "TRUE"))) {
    envnm <- Sys.getenv("THEEUH_PYTHON_ENV_NAME", unset = "r-theeuh")
    if (!check_conda_set(envnm)) conda_set(envnm)
    reticulate::use_condaenv(envnm)
  }

}
