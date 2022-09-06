.theeuhenv <- new.env()

.onLoad <- function(libname, pkgname) {

  if (getOption("theeuh.use_autoconfig", default = TRUE)) {
    envnm <- getOption("theeuh.conda_envnm", default = "r-theeuh")
    if (!check_conda_set(envnm)) conda_set(envnm)
    reticulate::use_condaenv(envnm)
  }

}
