#' @importFrom semver parse_version
is_semver <- function(ver) {
  chk <- try(semver::parse_version(ver), silent = TRUE)
  !inherits(chk, "try-error")
}

valid_version <- function(ver) {
  ver %in% list(
    "1.0.0", "1.1.0", "1.1.1", "1.1.2", "1.2.0", "1.3.0", "1.3.1", "1.4.0",
    "1.5.1", "1.5.2", "1.5.3", "1.6.0", "1.7.0", "1.7.1", "1.7.2",
    "1.8.0", "1.8.1", "1.8.2", "1.9.0", "1.9.1",
    "1.10.0", "1.11.0", "1.11.1", "1.12.0", "1.12.1"
  )
}
