## Submission

This is the first CRAN submission of theeuh. Version 0.1.5 is an update to
previous GitHub releases. The package restores spacing in Korean text using
a bundled model through the CRAN package churon (>= 0.1.13).

ONNX Runtime is optional at runtime. Loading the package does not initialize
the model. No functions, examples, or tests download or install software.
Inference examples and tests run only when a runtime is configured; other
tests run without it. The dependency uses one intra-operation thread.

Model initialization disables non-Windows ONNX Runtime telemetry and restores
the original environment variable afterwards. Model and vocabulary provenance
and the original author's credit are included in inst/COPYRIGHTS and Authors@R.

## Local checks

macOS arm64, R 4.5.2, churon 0.1.13, ONNX Runtime 1.29.0:
23 test expectations passed, including real inference and telemetry opt-out.
R CMD check --as-cran --no-manual: 0 errors, 0 warnings, 1 NOTE (New submission).
The external clock probe was disabled after confirming the local clock;
future-file timestamp checks were retained. Telemetry was disabled by the
package itself, without a pre-set telemetry environment variable.

Official macOS builder, arm64, R 4.6.1 Patched:
0 errors, 0 warnings, 0 notes, including PDF manual checks.
https://mac.R-project.org/macbuilder/results/1790948116-a032d2ed9617f2fe/
