#' Write spaces to Korean sentences.
#'
#' @param ko_sents A character vector of Korean sentences. Missing values are
#'   preserved. Sentences longer than 198 characters are truncated with a warning.
#' @return A character string for one sentence, or an unnamed list of character
#'   strings for multiple sentences. An empty character vector returns `list()`.
#' @details The bundled model is loaded on the first non-empty, non-missing
#'   sentence. ONNX Runtime must be configured first; see
#'   [churon::install_onnx_runtime()]. No runtime is downloaded automatically.
#'   On supported non-Windows runtimes, telemetry is disabled during model
#'   initialization. If another package initializes ONNX Runtime first, set
#'   `ORT_DISABLE_TELEMETRY=1` before starting R to disable telemetry globally.
#' @examples
#' if (churon::check_onnx_runtime_available()) {
#'   space("\uC774\uC81C\uCEE4\uBC0B\uD558\uBA74")
#' }
#'
#' @export
space <- function(ko_sents) {
  if (!is.character(ko_sents) || !is.null(dim(ko_sents))) {
    stop("ko_sents must be a character vector.", call. = FALSE)
  }
  ko_sents <- enc2utf8(ko_sents)

  if (any(!is.na(ko_sents) & nzchar(ko_sents)) && !check_model_set()) {
    load_models()
  }

  sess <- .theeuhenv$sess

  spacing_ <- function(ko_sent) {
    if (is.na(ko_sent) || !nzchar(ko_sent)) return(ko_sent)
    if (nchar(ko_sent) > 198) {
      warning(sprintf(
        "One sentence can not contain more than 198 characters. : %s",
        ko_sent
      ))
    }
    ko_sent_ <- substr(ko_sent, 1, 198)
    mat <- sent_to_matrix(ko_sent_)
    out <- churon::onnx_run(sess, list(input_1 = mat))
    return(trimws(make_pred_sent(ko_sent_, out[[1]])))
  }
  ress <- lapply(unname(ko_sents), spacing_)

  if (length(ress) == 1)
    ress <- ress[[1]]

  return(ress)
}


sent_to_matrix <- function(ko_sent) {
  hash <- get("hash", envir = .theeuhenv)
  ko_sent_ <- paste0('\u00ab', ko_sent, '\u00bb')
  ko_sent_ <- gsub('\\s', '^', ko_sent_)

  #encoding and padding
  encoded <-
    sapply(strsplit(enc2utf8(ko_sent_), split = '')[[1]], function(x) {
      ret <- hash[[x]]
      if (is.null(ret))
        ret <- hash[["__ETC__"]]
      ret
    })

  mat <- matrix(data = hash[['__PAD__']],
                nrow = 1,
                ncol = 200)
  mat[, seq_along(encoded)] <- encoded
  return(mat)
}

make_pred_sent <- function(raw_sent, spacing_mat) {
  raw_chars <- strsplit(enc2utf8(raw_sent), split = "")[[1]]
  spacing_prob <- spacing_mat[seq_along(raw_chars) + 1L]
  ret <- paste0(
    ifelse(spacing_prob > 0.5, paste0(raw_chars, " "), raw_chars),
    collapse = ""
  )
  trimws(gsub("[[:space:]]+", " ", ret))
}
