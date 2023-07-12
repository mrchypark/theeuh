library(torch)

MyModel <- nn_module(
  "MyModel",
  initialize = function(){
    self$embedding <- nn_embedding(num_embeddings=1951, embedding_dim=100)
    self$conv1 <- nn_conv1d(100, 128, 1)
    self$conv2 <- nn_conv1d(100, 256, 2, padding = c(1,0))
    self$conv3 <- nn_conv1d(100, 128, 3, padding = c(1,0))
    self$conv4 <- nn_conv1d(100, 64, 4, padding = c(2,0))
    self$conv5 <- nn_conv1d(100, 32, 5, padding = c(2,0))
    self$batch_norm <- nn_batch_norm1d(608)
    self$fc1 <- nn_linear(608, 300)
    self$fc2 <- nn_linear(300, 150)
    self$gru <- nn_gru(150, 50, batch_first=TRUE)
    self$fc3 <- nn_linear(50, 1)
  },
  forward = function(x){
    x <- self$embedding(x)
    xr <- torch_reshape(x, c(1,100,200))
    x1 <- nnf_relu(self$conv1(xr))
    x2 <- nnf_relu(self$conv2(xr))
    x3 <- nnf_relu(self$conv3(xr))
    x4 <- nnf_relu(self$conv4(xr))
    x5 <- nnf_relu(self$conv5(xr))
    x <- torch_cat(list(x1, x2, x3, x4, x5), dim=2)
    x <- self$batch_norm(x)
    x <- nnf_relu(self$fc1(x))
    x <- nnf_relu(self$fc2(x))
    x <- self$gru(x)
    x <- nnf_sigmoid(self$fc3(x))
    return (x)
  }
)


model <- MyModel()


state_dict <- torch::load_state_dict("inst/model/kospacing2.pth")

state_dict$embedding.weight <- state_dict$embedding.weight$view(c(1951, 100))

state_dict$conv1.weight <- state_dict$conv1.weight$view(c(128, 100, 1))
state_dict$conv2.weight <- state_dict$conv2.weight$view(c(256, 100, 2))
state_dict$conv3.weight <- state_dict$conv3.weight$view(c(128, 100, 3))
state_dict$conv4.weight <- state_dict$conv4.weight$view(c(64, 100, 4))
state_dict$conv5.weight <- state_dict$conv5.weight$view(c(32, 100, 5))

state_dict$fc1.weight <- state_dict$fc1.weight$reshape(c(300, 608))
state_dict$fc2.weight <- state_dict$fc2.weight$reshape(c(150, 300))

state_dict$gru.weight_ih_l1 <- state_dict$gru.weight_ih_l0$view(c(150, 150))
state_dict$gru.weight_hh_l1 <- state_dict$gru.weight_hh_l0$view(c(150, 50))

state_dict$gru.bias_ih_l1 <- state_dict$gru.bias_ih_l0$view(c(150))
state_dict$gru.bias_hh_l1 <- state_dict$gru.bias_hh_l0$view(c(150))

state_dict$fc3.weight <- state_dict$fc3.weight$view(c(1, 50))

model$load_state_dict(state_dict)




torch_tensor(mat,dtype=torch_long()) %>%
  modelp$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  modelp$conv1() %>%
  nnf_relu() -> c1

torch_tensor(mat,dtype=torch_long()) %>%
  modelp$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  modelp$conv2() %>%
  nnf_relu() -> c2

torch_tensor(mat,dtype=torch_long()) %>%
  modelp$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  modelp$conv3() %>%
  nnf_relu() -> c3

torch_tensor(mat,dtype=torch_long()) %>%
  modelp$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  modelp$conv4() %>%
  nnf_relu() -> c4

torch_tensor(mat,dtype=torch_long()) %>%
  modelp$embedding$forward() %>%
  torch_reshape(c(1,100,200)) %>%
  modelp$conv5() %>%
  nnf_relu() -> c5


torch_cat(list(c1,c2,c3,c4,c5), dim = 2L)
