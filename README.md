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

`{theeuh}` uses `{churon}` for ONNX inference. On macOS arm64 and Linux
x64/arm64, install ONNX Runtime in the current R session before first use:

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

### Windows x64

The CRAN release of `{churon}` 0.1.13 cannot install ONNX Runtime on Windows:
its installer calls `utils::unzip(..., quiet = TRUE)`, but Windows base R does
not accept that argument. Until `{churon}` fixes this, download the official
[ONNX Runtime 1.29.0 Windows x64 archive](https://github.com/microsoft/onnxruntime/releases/download/v1.29.0/onnxruntime-win-x64-1.29.0.zip)
and install it with base R. Choose a persistent directory for `destdir`.

``` r
destdir <- "C:/Users/your-name/AppData/Local/churon"
dir.create(destdir, recursive = TRUE, showWarnings = FALSE)

zip_url <- paste0(
  "https://github.com/microsoft/onnxruntime/releases/download/v1.29.0/",
  "onnxruntime-win-x64-1.29.0.zip"
)
zip_file <- file.path(tempdir(), "onnxruntime-win-x64-1.29.0.zip")
utils::download.file(zip_url, zip_file, mode = "wb")
utils::unzip(zip_file, exdir = destdir)
unlink(zip_file)

runtime_path <- normalizePath(
  file.path(
    destdir, "onnxruntime-win-x64-1.29.0", "lib", "onnxruntime.dll"
  ),
  winslash = "/",
  mustWork = TRUE
)
Sys.setenv(ORT_DYLIB_PATH = runtime_path, ORT_DISABLE_TELEMETRY = "1")
runtime_path
```

For later R sessions, save the printed absolute path in `~/.Renviron`, restart
R, then load `{theeuh}`:

```
ORT_DYLIB_PATH=C:/Users/your-name/AppData/Local/churon/onnxruntime-win-x64-1.29.0/lib/onnxruntime.dll
ORT_DISABLE_TELEMETRY=1
```

## Usage

Please check <https://mrchypark.github.io/theeuh/>.

## Special Thanks to

Original package is [KoSpacing](https://github.com/haven-jeon/KoSpacing) by [haven-jeon](https://github.com/haven-jeon).
Most parts of code is from [KoSpacing](https://github.com/haven-jeon/KoSpacing)
Also `{theeuh}` package's model and word index is from [KoSpacing](https://github.com/haven-jeon/KoSpacing).
