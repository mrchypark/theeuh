# theeuh [<img src="man/figures/logo.png" align="right" height=140/>](https://mrchypark.github.io/theeuh/index.html)

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/mrchypark/theeuh/workflows/R-CMD-check/badge.svg)](https://github.com/mrchypark/theeuh/actions)
[![runiverse-name](https://mrchypark.r-universe.dev/badges/:name)](https://mrchypark.r-universe.dev/)
[![runiverse-package](https://mrchypark.r-universe.dev/badges/theeuh)](https://mrchypark.r-universe.dev/theeuh)
[![Codecov test
coverage](https://codecov.io/gh/mrchypark/theeuh/branch/main/graph/badge.svg)](https://app.codecov.io/gh/mrchypark/theeuh?branch=main)
<!-- badges: end -->

# [한글문서](https://mrchypark.github.io/theeuh/articles/readme-kr.html)

The goal of theeuh is to restore spacing in Korean sentences.

## Installation

`{theeuh}` is not on CRAN. Install its CRAN dependency `{churon}`, then install
`{theeuh}` from r-universe.

``` r
install.packages("churon")
install.packages(
  "theeuh",
  repos = c("https://mrchypark.r-universe.dev", "https://cloud.r-project.org")
)
```

`{theeuh}` uses `{churon}` for ONNX inference. Before first use, install ONNX
Runtime in the current R session:

``` r
churon::install_onnx_runtime(destdir = "~/.local/share/churon")
runtime_path <- Sys.getenv("ORT_DYLIB_PATH")
runtime_path
```

Save the printed path in `~/.Renviron` for later R sessions, then restart R
before loading `{theeuh}`:

```
ORT_DYLIB_PATH=/path/printed/above
ORT_DISABLE_TELEMETRY=1
```

ONNX Runtime supports macOS arm64, Linux x64/arm64, and Windows x64; macOS
x86_64 is unsupported for ONNX Runtime 1.28.0 and later.
The telemetry setting also covers sessions initialized by other packages.

## Usage

Please check <https://mrchypark.github.io/theeuh/>.

## Special Thanks to

Original package is [KoSpacing](https://github.com/haven-jeon/KoSpacing) by [haven-jeon](https://github.com/haven-jeon).
Most parts of code is from [KoSpacing](https://github.com/haven-jeon/KoSpacing)
Also `{theeuh}` package's model and word index is from [KoSpacing](https://github.com/haven-jeon/KoSpacing).
