# theeuh

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/mrchypark/theeuh/workflows/R-CMD-check/badge.svg)](https://github.com/mrchypark/theeuh/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/theeuh)](https://CRAN.R-project.org/package=theeuh)
[![runiverse-name](https://mrchypark.r-universe.dev/badges/:name)](https://mrchypark.r-universe.dev/)
[![runiverse-package](https://mrchypark.r-universe.dev/badges/theeuh)](https://mrchypark.r-universe.dev/ui#packages)
[![metacran
downloads](https://cranlogs.r-pkg.org/badges/theeuh)](https://cran.r-project.org/package=theeuh)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/theeuh)](https://cran.rstudio.com/package=theeuh)
[![Codecov test
coverage](https://codecov.io/gh/mrchypark/theeuh/branch/main/graph/badge.svg)](https://app.codecov.io/gh/mrchypark/theeuh?branch=main)
<!-- badges: end -->

The goal of theeuh is to write space on korean sentense corractly.

## Installation

`{theeuh}` has 2 step installation

### 1. Package

``` r
# CRAN NOT YET!!!!
install.packages("theeuh")

# dev version r-universe
install.packages('theeuh', repos = "https://mrchypark.r-universe.dev")
```

### 2. Python dependency

`{theeuh}` use `onnxruntime`. So, you need to install `python` and `onnxruntime` package.

If you don't have any knowledge of python environment, miniconda is good choice.

```r
reticulate::install_miniconda()
```

After install miniconda, `{reticulate}` create conda env named `r-reticulate`.
`{theeuh}` package provide `install_onnxruntime()` that easy install onnxruntime.

```r
library("theeuh")
install_onnxruntime()
```

if you want to use conda env for `{theeuh}` only, add env name to create.

```r
install_onnxruntime(envname = "r-theeuh")
```

more info about `install_onnxruntime()`, please check help page.

## Usage

Please check <https://mrchypark.github.io/theeuh>

## Special Thanks to

Original package is [KoSpacing](https://github.com/haven-jeon/KoSpacing) by [haven-jeon](https://github.com/haven-jeon).
Most parts of code is from [KoSpacing](https://github.com/haven-jeon/KoSpacing)
Also `{theeuh}` package's model and word index is from [KoSpacing](https://github.com/haven-jeon/KoSpacing).

