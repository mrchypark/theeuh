import onnx
import torch

model = onnx.load_model("./inst/model/kospacing2.onnx")
embw = model.graph.initializer[29]
embw = torch.tensor(embw.float_data)

class Spacing(torch.nn.Module):

    def __init__(self, vocab_size, embedding_dim):
        super(Spacing, self).__init__()

        self.word_embeddings = torch.nn.Embedding(vocab_size, embedding_dim)

    def forward(self, sentence_vec):
        x = self.word_embeddings(sentence_vec)
        return x






Spacing <- torch::nn_module(
  "Spacing",
  initialize = function() {
    self$embedding <- nn_embedding(1951, 100, .weight = embd)
    self$conv1 <- nn_sequential(nn_conv_transpose1d(128, 100, 1),
                                nn_relu())
    self$conv2 <- nn_sequential(nn_conv_transpose1d(256, 100, 2),
                                nn_relu())
    self$conv3 <- nn_sequential(nn_conv_transpose1d(128, 100, 3),
                                nn_relu())
    self$conv4 <- nn_sequential(nn_conv_transpose1d(64, 100, 4),
                                nn_relu())
    self$conv5 <- nn_sequential(nn_conv_transpose1d(32, 100, 5),
                                nn_relu())
    self$batchnorm <- nn_batch_norm1d(608, 1e-06, 0.99)
    slef$gru <- nn_gru(150, 50)

  },
  forward = function(x) {
    emb <- self$embedding(x)
    catr <-
      torch_cat(list(
        self$conv1(emb),
        self$conv2(emb),
        self$conv3(emb),
        self$conv4(emb),
        self$conv5(emb)
      ))
    bn <- self$batchnorm(catr)
    td <- torch_transpose(bn, 1, 2)
    td <- torch_reshape(td, list(2))
    td <- torch_matmul(td)

  }
)




torch_transpose()

nn_batch_norm1d()
torch_transpose()
torch_reshape()
torch_matmul()
torch_add()
nn_gru()
torch_sigmoid()
