.theeuhenv <- new.env()

.onLoad <- function(libname, pkgname) {
  if (getOption("theeuh.use_autoconfig", default = TRUE)) {
    message("theeuh.use_autoconfig is TRUE")
    envnm <- getOption("theeuh.conda_envnm", default = "r-theeuh")
    message(paste0("theeuh.conda_envnm is ", envnm))
    if (!check_conda_set(envnm)) {
      message(paste0("conda_env ", envnm, " is not exist. Try create conda env."))
      conda_set(envnm)
    }
    reticulate::use_condaenv(envnm)
  }
}
