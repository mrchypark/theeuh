#' @importFrom reticulate use_condaenv
check_conda_set <- function(envnm) {
  chk <- try(reticulate::use_condaenv(envnm, required = TRUE), silent = T)
  return(!inherits(chk, "try-error"))
}

#' @importFrom reticulate conda_create
conda_set <- function(envnm) {
  reticulate::conda_create(
    envname = envnm,
    environment = file.path(system.file(package = "theeuh"), 'environment.yml')
  )
}
