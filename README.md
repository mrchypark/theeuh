# theeuh [<img src="man/figures/logo.png" align="right" height=140/>](https://mrchypark.github.io/theeuh/index.html)

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
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

# [한글문서](https://mrchypark.github.io/theeuh/articles/readme-kr.html)

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

### 2-1. miniconda

```r
reticulate::install_miniconda()
```
After install miniconda, `{reticulate}` create conda env named `r-reticulate`.

### 2-2. onnxruntime package

`{theeuh}` package provide `install_onnxruntime()` that easy install onnxruntime.
`install_onnxruntime()` install `onnruntime` package on active env.
If you don't know mush about env, I strongly recommend use new env name like `r-theeuh`.

```r
library("theeuh")
install_onnxruntime(envname = "r-theeuh")
```

more info about `install_onnxruntime()`, please check help page.

## Usage

Please check <https://mrchypark.github.io/theeuh>

## Special Thanks to

Original package is [KoSpacing](https://github.com/haven-jeon/KoSpacing) by [haven-jeon](https://github.com/haven-jeon).
Most parts of code is from [KoSpacing](https://github.com/haven-jeon/KoSpacing)
Also `{theeuh}` package's model and word index is from [KoSpacing](https://github.com/haven-jeon/KoSpacing).

