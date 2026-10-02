# CRAN submission review: theeuh 0.1.5

Reviewed against the official sources below and the applicable requirements
from churon's previous CRAN review. Private correspondence is not reproduced.

| Requirement | Candidate evidence |
| --- | --- |
| Concise title, correct software quoting, informative description | DESCRIPTION |
| Software link in angle brackets; accurate dependency requirements | DESCRIPTION |
| All contributors and bundled asset provenance | Authors@R; inst/COPYRIGHTS |
| Source package and compatible license | R-only code; GPL; ONNX/RDS model data |
| CRAN dependencies; no remote-only dependency | churon >= 0.1.13; no Remotes |
| Document arguments, return class and meaning | R/space.R; generated man/space.Rd |
| Run short examples; do not hide them in dontrun | Conditional executable example |
| No automatic installation or downloads | R/, examples, tests; explicit setup docs |
| No default home, package-directory or working-directory writes | Read-only model loading |
| No unconsented non-Windows runtime telemetry | Scoped initialization opt-out |
| No temporary telemetry trace leftovers | Runtime regression test and package check |
| Restore modified process state | on.exit restores telemetry environment variable |
| No global workspace, working-directory, RNG or option changes | R/ and tests reviewed |
| Use TRUE/FALSE, portable paths and UTF-8 | R/; system.file; enc2utf8 |
| At most two computation threads | churon session uses one intra-op thread |
| Meaningful tests on CRAN; optional software handled gracefully | tests/testthat |
| Network-free examples/tests | Bundled local model; no installation calls |
| Portable installation including macOS | churon 0.1.13 fixes earlier Rust PATH failure |
| Package size limits | Source archive approximately 2.2 MB |
| Canonical URLs and accurate CRAN status | DESCRIPTION; README; Korean documentation |
| Current R and PDF manual | Official macOS R 4.6.1 builder: OK |
| Development R and Windows | Win-builder R-devel and GitHub checks pending |
| No duplicate pending submission; maintainer email confirmation | Gmail checked; no theeuh submission |

The earlier churon macOS Rust build failure is resolved in its CRAN version
0.1.13. All current CRAN checks for that version are OK as reviewed on
2026-10-02. theeuh itself contains no configure script or compiled code.

Native-code, Rust vendoring, compiled executable, C/C++ registration and
compiled-code portability rules do not apply to theeuh's own source.
Runtime inference is optional on platforms without supported ONNX binaries.

## Verification

* Local macOS arm64, R 4.5.2: 31 expectations pass with ONNX Runtime 1.29.0,
  including restoration after failed session construction. Coverage: 98.59%.
* Built archive: R CMD check --as-cran --no-manual has no errors or warnings;
  the only NOTE is New submission. Package-managed telemetry opt-out leaves
  no temporary diagnostic files. External clock probe disabled; timestamps
  still checked. All 14 checked package URLs are valid.
* [Official macOS R 4.6.1 builder](https://mac.R-project.org/macbuilder/results/1790948418-19d2219072629121/):
  no errors, warnings or notes; PDF manual check passes.
* Windows setup uses a checksum-verified official archive because churon 0.1.13
  currently passes an unsupported quiet argument to base R's unzip function.
  This dependency installer issue does not affect loading or running theeuh
  with a configured runtime. Both setup guides include an explicit workaround.

## Official sources

* [Repository Policy](https://cran.r-project.org/web/packages/policies.html)
* [Submission Checklist](https://cran.r-project.org/web/packages/submission_checklist.html)
* [Writing R Extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html)
* [URL checks](https://cran.r-project.org/web/packages/URL_checks.html)
* [CRAN Cookbook](https://contributor.r-project.org/cran-cookbook/)
* [Description issues](https://contributor.r-project.org/cran-cookbook/description_issues.html)
* [Documentation issues](https://contributor.r-project.org/cran-cookbook/docs_issues.html)
* [Code issues](https://contributor.r-project.org/cran-cookbook/code_issues.html)
* [Examples and general issues](https://contributor.r-project.org/cran-cookbook/general_issues.html)
* [ONNX Runtime telemetry](https://github.com/microsoft/onnxruntime/blob/v1.29.0/docs/Privacy.md)
* [churon CRAN checks](https://cran.r-project.org/web/checks/check_results_churon.html)
