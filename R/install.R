# allmost follow https://github.com/rstudio/tensorflow/blob/v2.9.0/R/install.R

#' Install onnxruntime python package
#'
#' `install_onnxruntime()` installs just the onnxruntime python package and it's
#' direct dependencies to inference model.
#'
#' @inheritParams reticulate::py_install
#' @param version onnxruntime version to install.
#' @param restart_session Restart R session after installing (note this will
#'   only occur within RStudio)
#' @param pip_ignore_installed Whether pip should ignore installed python
#'   packages and reinstall all already installed python packages. This defaults
#'   to `TRUE`, to ensure that onnxruntime dependencies like NumPy are compatible
#'   with the prebuilt onnxruntime binaries.
#' @param ... other arguments passed to [`reticulate::conda_install()`] or
#'   [`reticulate::virtualenv_install()`], depending on the `method` used.
#'
#' @importFrom reticulate py_available py_install
#' @importFrom rstudioapi hasFun restartSession
#' @export
install_onnxruntime <- function(method = c("auto", "virtualenv", "conda"),
                                conda = "auto",
                                version = "1.12.0",
                                envname = NULL,
                                restart_session = TRUE,
                                conda_python_version = NULL,
                                ...,
                                pip_ignore_installed = TRUE,
                                python_version = conda_python_version) {

  method <- match.arg(method)

  # verify 64-bit
  if (.Machine$sizeof.pointer != 8) {
    stop("Unable to install onnxruntime on this platform.",
         "Binary installation is only available for 64-bit platforms.")
  }

  # some special handling for windows
  if (is_windows()) {

    # avoid DLL in use errors
    if (reticulate::py_available()) {
      stop("You should call install_onnxruntime() only in a fresh ",
           "R session that has not yet initialized onnxruntime (this is ",
           "to avoid DLL in use errors during installation)")
    }
  }

  packages <- c(paste0("onnxruntime==", version))

  reticulate::py_install(
    packages       = packages,
    envname        = envname,
    method         = method,
    conda          = conda,
    python_version = python_version,
    pip            = TRUE,
    pip_ignore_installed = pip_ignore_installed,
    ...
  )

  cat("\nInstallation complete.\n\n")

  if (restart_session &&
      requireNamespace("rstudioapi", quietly = TRUE) &&
      rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()

  invisible(NULL)
}

is_windows <- function() {
  identical(.Platform$OS.type, "windows")
}
