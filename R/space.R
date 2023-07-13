#' Write spaces to Korean sentences.
#'
#' @param ko_sents target korean sentences.
#'
#' @export
space <- function(ko_sents) {

  if (!check_model_set()) load_models()

  model <- get("model", envir = .theeuhenv)

  spacing_ <- function(ko_sent) {
    if (nchar(ko_sent) > 198) {
      warning(sprintf(
        "One sentence can not contain more than 198 characters. : %s",
        ko_sent
      ))
    }
    ko_sent_ <- substr(ko_sent, 1, 198)
    mat <- sent_to_matrix(ko_sent_)

    out <- model(torch_tensor(mat,dtype=torch_long()))
    return(trimws(make_pred_sent(ko_sent_, array(as_array(out), 200))))
  }
  ress <- sapply(ko_sents,
                 spacing_,
                 simplify = F,
                 USE.NAMES = F)

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
  mat[, 1:length(encoded)] <-  encoded
  return(mat)
}

make_pred_sent <- function(raw_sent, spacing_mat) {
  raw_sent <- paste0('\u00ab', raw_sent, '\u00bb')
  spacing_prob <- spacing_mat[1:nchar(raw_sent)]
  raw_chars <- strsplit(raw_sent, split = '')[[1]]

  ret_v <- c()
  for (i in 1:length(raw_chars)) {
    if (spacing_prob[i] > 0.5) {
      ret_v <- c(ret_v, raw_chars[i], " ")
    } else{
      ret_v <- c(ret_v, raw_chars[i])
    }
  }
  ret <- paste0(ret_v, collapse = '')
  ret <- gsub('[\u00ab|\u00bb]', '', ret)
  ret <-
    paste(strsplit(ret, split = "[[:space:]]+")[[1]], collapse = ' ')
  return(ret)
}
