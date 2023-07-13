library(torch)

sent_to_matrix <- function(ko_sent) {
  w2idx_tbl <- readRDS("inst/model/w2idx")

  hash <- sapply(unique(w2idx_tbl$Keys), function(x) {
    w2idx_tbl[w2idx_tbl$Keys == x, 2]
  }, simplify = FALSE)
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

MyModel <- nn_module(
  "MyModel",
  initialize = function(){
    self$embedding <- nn_embedding(num_embeddings=1951, embedding_dim=100)
    self$conv1 <- nn_conv1d(100, 128, 1)
    self$conv2 <- nn_conv1d(100, 256, 2, padding=1)
    self$conv3 <- nn_conv1d(100, 128, 3, padding=1)
    self$conv4 <- nn_conv1d(100, 64, 4, padding=2)
    self$conv5 <- nn_conv1d(100, 32, 5, padding=2)
    self$batch_norm <- nn_batch_norm1d(608)
    self$fc1 <- nn_linear(608, 300)
    self$fc2 <- nn_linear(300, 150)
    self$gru <- nn_gru(150, 50, batch_first=TRUE)
    self$fc3 <- nn_linear(50, 1)
  },
  forward = function(x){
    x <- self$embedding(x)
    xr <- torch_reshape(x, c(1,100,200))
    x1 <- nnf_relu(self$conv1(xr)[,,1:200])
    x2 <- nnf_relu(self$conv2(xr)[,,1:200])
    x3 <- nnf_relu(self$conv3(xr)[,,1:200])
    x4 <- nnf_relu(self$conv4(xr)[,,1:200])
    x5 <- nnf_relu(self$conv5(xr)[,,1:200])
    x <- torch_cat(list(x1, x2, x3, x4, x5), dim=2)
    x <- self$batch_norm(x)
    x <- torch_reshape(x, c(1, 200, 608))
    x <- nnf_relu(self$fc1(x))
    x <- nnf_relu(self$fc2(x))
    x <- self$gru(x)
    x <- nnf_sigmoid(self$fc3(x[[1]]))
    return (x)
  }
)


model <- MyModel()


state_dict <- torch::load_state_dict("inst/model/kospacing2.pth")

state_dict$embedding.weight <- state_dict$embedding.weight$view(c(1951, 100))

state_dict$fc1.weight <- state_dict$fc1.weight$reshape(c(300, 608))
state_dict$fc2.weight <- state_dict$fc2.weight$reshape(c(150, 300))

state_dict$gru.weight_ih_l1 <- state_dict$gru.weight_ih_l0$view(c(150, 150))
state_dict$gru.weight_hh_l1 <- state_dict$gru.weight_hh_l0$view(c(150, 50))

state_dict$gru.bias_ih_l1 <- state_dict$gru.bias_ih_l0$view(c(150))
state_dict$gru.bias_hh_l1 <- state_dict$gru.bias_hh_l0$view(c(150))

state_dict$fc3.weight <- state_dict$fc3.weight$view(c(1, 50))

model$load_state_dict(state_dict)

torch_save(model, "inst/model/kospacing")
model <- torch_load("inst/model/kospacing")

ko_sent_ <- substr("안녕하세요저는박찬엽입니다", 1, 198)
mat <- sent_to_matrix(ko_sent_)

out <- model(torch_tensor(mat,dtype=torch_long()))
trimws(make_pred_sent(ko_sent_, array(as_array(out), 200)))

## for test

torch_tensor(mat,dtype=torch_long()) %>%
  model$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  model$conv1() %>%
  .[,,1:200] %>%
  nnf_relu() -> c1

torch_tensor(mat,dtype=torch_long()) %>%
  model$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  model$conv2() %>%
  .[,,1:200] %>%
  nnf_relu() -> c2

torch_tensor(mat,dtype=torch_long()) %>%
  model$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  model$conv3() %>%
  .[,,1:200] %>%
  nnf_relu() -> c3

torch_tensor(mat,dtype=torch_long()) %>%
  model$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  model$conv4() %>%
  .[,,1:200] %>%
  nnf_relu() -> c4

torch_tensor(mat,dtype=torch_long()) %>%
  model$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  model$conv5() %>%
  .[,,1:200] %>%
  nnf_relu() -> c5

torch_cat(list(c1,c2,c3,c4,c5), dim = 2L) %>%
  # torch_reshape(c(1,200,608)) %>%
  model$batch_norm$forward() %>%
  torch_reshape(c(1, 200, 608)) %>%
  model$fc1$forward() %>%
  nnf_relu() %>%
  model$fc2$forward() %>%
  nnf_relu() %>%
  model$gru$forward() %>%
  .[[1]] %>%
  model$fc3$forward() %>%
  nnf_sigmoid() %>%
  as_array() -> res


