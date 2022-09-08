#' @importFrom reticulate use_condaenv
check_conda_set <- function(envnm) {
  chk <- try(reticulate::use_condaenv(envnm, required = TRUE), silent = T)
  return(!inherits(chk, "try-error"))
}

#' @importFrom reticulate conda_create
conda_set <- function(envnm) {
  reticulate::conda_create(
    envname = envnm,
    environment = condaenv_path()
  )
}

condaenv_path <- function() {
  if (is_windows()) {
    return(file.path(system.file(package = "theeuh"), "condaenv", 'windows.yml'))
  }
  file.path(system.file(package = "theeuh"), "condaenv", 'linux.yml')
}

get_os <- function(){
  return(paste0(Sys.info()["sysname"], Sys.info()["machine"]))
}

is_unix <- function() {
  identical(.Platform$OS.type, "unix")
}

is_windows <- function() {
  identical(.Platform$OS.type, "windows")
}

is_linux <- function() {
  identical(tolower(Sys.info()[["sysname"]]), "linux")
}

is_osx <- function() {
  Sys.info()["sysname"] == "Darwin"
}
