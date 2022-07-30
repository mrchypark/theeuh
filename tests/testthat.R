library(testthat)
library(theeuh)

if (identical(Sys.getenv("NOT_CRAN"), "true"))
  test_check("theeuh")
