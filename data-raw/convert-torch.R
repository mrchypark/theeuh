## onnx_pytorch fail
## 이게 그래도 gpu만 구현하면 되는 것인가 싶네.
## 기본값 문제가 있는데, 이건 실행해보고 문제인지 확인해야 함.
## library(reticulate)
py_install("onnx_pytorch", pip = T)
op <- import("onnx_pytorch")

model_file <-
  file.path(system.file(package = "theeuh"), "model", 'kospacing.onnx')

op$code_gen$gen(model_file, "./inst")
# > op$code_gen$gen(model_file, "./inst")
# WARNING:root:Cannot get default value for to of Cast.
# WARNING:root:Cannot get default value for perm of Transpose.
# WARNING:root:Cannot get default value for dilations of Conv.
# WARNING:root:Cannot get default value for kernel_shape of Conv.
# WARNING:root:Cannot get default value for pads of Conv.
# WARNING:root:Cannot get default value for strides of Conv.
# WARNING:root:Cannot get default value for axis of Concat.
# Error in py_call_impl(callable, dots$args, dots$keywords) :
#   NotImplementedError: OpCodeGenerator is unimplemented for GRU.


# onnx2torch fail!
# gru 도 있어야 함
library(reticulate)
py_install("onnx2torch", pip = T)
ot <- import("onnx2torch")
md <- ot$convert(model_file)
# Error in py_call_impl(callable, dots$args, dots$keywords) :
#   NotImplementedError: Only symmetric padding is implemented ([0, 1])

# https://gist.github.com/qinjian623/6aa777037534c1c1dccbb66f832e93b8
# cast가 없어서 실패. 코드를 보면  gru도 없음



## 백터 크기를 모델에 저장
## https://gaussian37.github.io/dl-pytorch-deploy/
library(reticulate)
model_file <-
  file.path(system.file(package = "theeuh"), "model", 'kospacing.onnx')
onnx <- import("onnx")

onnx$save_model(
  onnx$shape_inference$infer_shapes(onnx$load_model(model_file)),
  "./inst/model/kospacing2.onnx"
)



library(reticulate)
model_file <-
  file.path(system.file(package = "theeuh"), "model", 'kospacing.onnx')
onnx <- import("onnx")
mdl <- onnx$load_model(model_file)

install.packages("torch")
library(torch)
library(reticulate)

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


