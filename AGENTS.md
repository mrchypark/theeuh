# AGENTS.md

**Generated:** 2026-01-21 \| **Branch:** main \| **Commit:** HEAD

## OVERVIEW

**theeuh** is an R package for Korean text spacing using ONNX inference
via `churon`. Single public API
([`space()`](https://mrchypark.github.io/theeuh/reference/space.md)),
lazy-loaded models in `.theeuhenv`.

## STRUCTURE

    theeuh/
    ├── R/              # Source: space() + model loading
    ├── tests/testthat/ # test-space.R
    ├── inst/model/     # ONNX + w2idx (binary)
    ├── data-raw/       # Model conversion scripts
    └── .github/workflows/ # CI (R-CMD-check, pkgdown)

## WHERE TO LOOK

| Task          | File                                    |
|---------------|-----------------------------------------|
| Main API      | `R/space.R:space()`                     |
| Model loading | `R/models.R:load_models()`              |
| Tests         | `tests/testthat/test-space.R`           |
| CI config     | `.github/workflows/check-standard.yaml` |

## PUBLIC API

| Function          | Args             | Returns                                |
|-------------------|------------------|----------------------------------------|
| `space(ko_sents)` | character vector | Spaced Korean text (character or list) |

## CONVENTIONS

- **Naming**: `snake_case` for functions, `.prefix` for private
  (`.theeuhenv`)
- **Assignment**: `<-` only, never `=`
- **Indent**: 2 spaces
- **Line length**: 80 chars max
- **Docs**: roxygen2 with `@param`, `@return`, `@export`, `@examples`
- **Encoding**: [`enc2utf8()`](https://rdrr.io/r/base/Encoding.html) for
  Korean text
- **Paths**:
  [`system.file()`](https://rdrr.io/r/base/system.file.html) +
  [`file.path()`](https://rdrr.io/r/base/file.path.html) for package
  files
- **State**: [`new.env()`](https://rdrr.io/r/base/environment.html) for
  package-scoped lazy state

## ANTI-PATTERNS (THIS PROJECT)

- **NEVER** use `F`/`T` — write `FALSE`/`TRUE` explicitly
- **NEVER** edit `NAMESPACE` or `man/` — run `devtools::document()`
- **NEVER** export internal helpers (`sent_to_matrix`, `make_pred_sent`,
  `check_model_set`, `load_models`)
- Avoid type instability:
  [`space()`](https://mrchypark.github.io/theeuh/reference/space.md)
  returns `list` when length \> 1, `character` when length = 1

## CONSTRAINTS

- **Max sentence length**: 198 characters (enforced with warning,
  truncated)
- **Model files**: Lazy-loaded on first
  [`space()`](https://mrchypark.github.io/theeuh/reference/space.md)
  call
- **Auto-generated**: `NAMESPACE`, `man/*` are roxygen2 outputs

## COMMANDS

``` bash
# Package check
R CMD check .

# Tests (all, file, or single)
devtools::test()
devtools::test(filter = "test-space")

# Docs
devtools::document()
pkgdown::build_site()

# Coverage
covr::package_coverage()
```

## GOTCHAS

- `install_onnxruntime()` mentioned in README but not in source — verify
  availability
- `R/.logo.R` is dev-only (hex sticker generation), not runtime
- `inst/model/w2idx` lacks `.rds` extension
