#
#
# MyModel <- nn_module(
#   "MyModel",
#   initialize = function(){
#     self$embedding <- nn_embedding(num_embeddings=1951, embedding_dim=100)
#     self$conv1 <- nn_conv1d(100, 128, 1)
#     self$conv2 <- nn_conv1d(100, 256, 2)
#     self$conv3 <- nn_conv1d(100, 128, 3)
#     self$conv4 <- nn_conv1d(100, 64, 4)
#     self$conv5 <- nn_conv1d(100, 32, 5)
#     self$batch_norm <- nn_batch_norm1d(608)
#     self$fc1 <- nn_linear(608, 300)
#     self$fc2 <- nn_linear(300, 150)
#     self$gru <- nn_gru(150, 50, batch_first=TRUE)
#     self$fc3 <- nn_linear(50, 1)
#   },
#   forward = function(x){
#     x <- self$embedding(x)
#     x1 <- nnf_relu(self$conv1(x))
#     x2 <- nnf_relu(self$conv2(x))
#     x3 <- nnf_relu(self$conv3(x))
#     x4 <- nnf_relu(self$conv4(x))
#     x5 <- nnf_relu(self$conv5(x))
#     x <- torch_cat(list(x1, x2, x3, x4, x5), dim=2)
#     x <- self$batch_norm(x)
#     x <- nnf_relu(self$fc1(x))
#     x <- nnf_relu(self$fc2(x))
#     x <- self$gru(x)
#     x <- nnf_sigmoid(self$fc3(x))
#     return (x)
#   }
# )
