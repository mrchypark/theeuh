# Write spaces to Korean sentences.

Write spaces to Korean sentences.

## Usage

``` r
space(ko_sents)
```

## Arguments

- ko_sents:

  A character vector of Korean sentences. Missing values are preserved.
  Sentences longer than 198 characters are truncated with a warning.

## Value

A character string for one sentence, or an unnamed list of character
strings for multiple sentences. An empty character vector returns
[`list()`](https://rdrr.io/r/base/list.html).

## Details

The bundled model is loaded on the first non-empty, non-missing
sentence. ONNX Runtime must be configured first; see
[`churon::install_onnx_runtime()`](https://rdrr.io/pkg/churon/man/install_onnx_runtime.html).
No runtime is downloaded automatically. On supported non-Windows
runtimes, telemetry is disabled during model initialization. If another
package initializes ONNX Runtime first, set `ORT_DISABLE_TELEMETRY=1`
before starting R to disable telemetry globally.

## Examples

``` r
if (churon::check_onnx_runtime_available()) {
  space("\uC774\uC81C\uCEE4\uBC0B\uD558\uBA74")
}
#> [1] "이제 커밋하면"
```
