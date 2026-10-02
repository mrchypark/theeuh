# Changelog

## theeuh 0.1.5

- Use CRAN `churon` (\>= 0.1.13) instead of a pinned GitHub dependency.
- Document explicit ONNX Runtime installation and configure it in CI.
- Disable ONNX Runtime telemetry during initialization to prevent trace
  files.
- Credit the original KoSpacing author and document model provenance.
- Validate character-vector inputs and preserve missing values.
- Preserve literal `|`, `«`, and `»` characters when decoding
  predictions.
- Keep empty inputs independent of the model and runtime.
- Run tests on CRAN, skipping inference only when ONNX Runtime is
  unavailable.
