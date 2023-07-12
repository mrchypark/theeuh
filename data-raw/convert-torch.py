import torch
import torch.nn as nn
import onnx
import onnxruntime as ort
import numpy as np

onnx_model = onnx.load("./inst/model/kospacing2.onnx")
session = ort.InferenceSession("./inst/model/kospacing2.onnx")
weights = {w.name: torch.from_numpy(np.array(w.float_data)) for w in onnx_model.graph.initializer}

name_mapping = {
    "time_distributed_3/kernel:0": "fc3.weight",
    "time_distributed_3/bias:0": "fc3.bias",
    "gru_1_W": "gru.weight_ih_l0",
    "gru_1_R": "gru.weight_hh_l0",
    "gru_1_B": "gru.bias_ih_l0",  
    "time_distributed_2/kernel:0": "fc2.weight",
    "time_distributed_2/bias:0": "fc2.bias",
    "time_distributed_1/kernel:0": "fc1.weight",
    "time_distributed_1/bias:0": "fc1.bias",
    "scale": "batch_norm.weight",
    "bias": "batch_norm.bias",
    "mean": "batch_norm.running_mean",
    "var": "batch_norm.running_var",
    "conv1d_1/kernel:0": "conv1.weight",
    "conv1d_1/bias:0": "conv1.bias",
    "conv1d_2/kernel:0": "conv2.weight",
    "conv1d_2/bias:0": "conv2.bias",
    "conv1d_3/kernel:0": "conv3.weight",
    "conv1d_3/bias:0": "conv3.bias",
    "conv1d_4/kernel:0": "conv4.weight",
    "conv1d_4/bias:0": "conv4.bias",
    "conv1d_5/kernel:0": "conv5.weight",
    "conv1d_5/bias:0": "conv5.bias",
    "embedding_1/embeddings:0": "embedding.weight"
}

weights = {name_mapping[k]: v.clone() for k, v in weights.items() if k in name_mapping}

class MyModel(nn.Module):
    def __init__(self):
        super(MyModel, self).__init__()
        self.embedding = nn.Embedding(num_embeddings=1951, embedding_dim=100)
        self.conv1 = nn.Conv1d(in_channels=100, out_channels=128, kernel_size=1)
        self.conv2 = nn.Conv1d(in_channels=100, out_channels=256, kernel_size=2, padding=1)
        self.conv3 = nn.Conv1d(in_channels=100, out_channels=128, kernel_size=3, padding=1)
        self.conv4 = nn.Conv1d(in_channels=100, out_channels=64, kernel_size=4, padding=2)
        self.conv5 = nn.Conv1d(in_channels=100, out_channels=32, kernel_size=5, padding=2)
        self.batch_norm = nn.BatchNorm1d(num_features=608)
        self.fc1 = nn.Linear(in_features=608, out_features=300)
        self.fc2 = nn.Linear(in_features=300, out_features=150)
        self.gru = nn.GRU(input_size=150, hidden_size=50, batch_first=True)
        self.fc3 = nn.Linear(in_features=50, out_features=1)
        self.sigmoid = nn.Sigmoid()

        self.embedding.weight.data = weights["embedding.weight"]
        self.conv1.weight.data = weights["conv1.weight"].reshape(self.conv1.weight.data.shape)
        self.conv1.bias.data = weights["conv1.bias"]
        self.conv2.weight.data = weights["conv2.weight"].reshape(self.conv2.weight.data.shape)
        self.conv2.bias.data = weights["conv2.bias"]
        self.conv3.weight.data = weights["conv3.weight"].reshape(self.conv3.weight.data.shape)
        self.conv3.bias.data = weights["conv3.bias"]
        self.conv4.weight.data = weights["conv4.weight"].reshape(self.conv4.weight.data.shape)
        self.conv4.bias.data = weights["conv4.bias"]
        self.conv5.weight.data = weights["conv5.weight"].reshape(self.conv5.weight.data.shape)
        self.conv5.bias.data = weights["conv5.bias"]
        self.batch_norm.weight.data = weights["batch_norm.weight"]
        self.batch_norm.bias.data = weights["batch_norm.bias"]
        self.batch_norm.running_mean = weights["batch_norm.running_mean"]
        self.batch_norm.running_var = weights["batch_norm.running_var"]
        self.fc1.weight.data = weights["fc1.weight"].reshape(self.fc1.weight.data.shape).T
        self.fc1.bias.data = weights["fc1.bias"]
        self.fc2.weight.data = weights["fc2.weight"].reshape(self.fc2.weight.data.shape).T
        self.fc2.bias.data = weights["fc2.bias"]
        self.gru.weight_ih_l0.data = weights["gru.weight_ih_l0"].reshape(self.gru.weight_ih_l0.data.shape)
        self.gru.weight_hh_l0.data = weights["gru.weight_hh_l0"].reshape(self.gru.weight_hh_l0.data.shape)
        self.gru.bias_ih_l0.data = weights["gru.bias_ih_l0"][:150]
        self.gru.bias_hh_l0.data = weights["gru.bias_ih_l0"][150:]
        self.fc3.weight.data = weights["fc3.weight"].reshape(self.fc3.weight.data.shape).T
        self.fc3.bias.data = weights["fc3.bias"]

    def forward(self, x):
        x = x.float()
        x = self.embedding(x)
        x = x.transpose(1, 2)
        conv_out1 = self.conv1(x)
        conv_out1 = nn.functional.relu(conv_out1)
        conv_out2 = self.conv2(x)
        conv_out2 = nn.functional.relu(conv_out2)
        conv_out3 = self.conv3(x)
        conv_out3 = nn.functional.relu(conv_out3)
        conv_out4 = self.conv4(x)
        conv_out4 = nn.functional.relu(conv_out4)
        conv_out5 = self.conv5(x)
        conv_out5 = nn.functional.relu(conv_out5)
        out = torch.cat([conv_out1, conv_out2, conv_out3, conv_out4, conv_out5], dim=1)
        out = self.batch_norm(out)
        out = out.transpose(1, 2)
        out = out.reshape(out.size(0), -1, 608)
        out = self.fc1(out)
        out = nn.functional.relu(out)
        out = self.fc2(out)
        out = nn.functional.relu(out)
        out = out.transpose(0, 1)
        out, _ = self.gru(out)
        out = out.transpose(0, 1)
        out = out.reshape(out.size(0), -1, 50)
        out = self.fc3(out)
        out = self.sigmoid(out)
        out = out.reshape(out.size(0), -1, 2)

        return out

model = MyModel()


# Check the shape of each weight in the model
for name, param in model.named_parameters():
    print(f"Name: {name}, Shape: {param.shape}")

# Check the shape of each weight in the state_dict
for name, param in weights.items():
    print(f"Name: {name}, Shape: {param.shape}")


weights['embedding.weight'] = weights['embedding.weight'].clone()
weights['conv1.weight'] = weights['conv1.weight'].reshape(128, 100, 1)

weights['conv1.weight'] = weights['conv1.weight'].reshape(128, 100, 1).clone()
weights['conv2.weight'] = weights['conv2.weight'].reshape(256, 100, 2).clone()
weights['conv3.weight'] = weights['conv3.weight'].reshape(128, 100, 3).clone()
weights['conv4.weight'] = weights['conv4.weight'].reshape(64, 100, 4).clone()
weights['conv5.weight'] = weights['conv5.weight'].reshape(32, 100, 5).clone()

weights['fc1.weight'] = weights['fc1.weight'].reshape(608, 300).clone()
weights['fc2.weight'] = weights['fc2.weight'].reshape(300, 150).clone()

weights['gru.weight_ih_l0'] = weights['gru.weight_ih_l0'].reshape(150, 150).clone()
weights['gru.weight_hh_l0'] = weights['gru.weight_hh_l0'].reshape(150, 50).clone()

# Since the bias of GRU in PyTorch is split into bias_ih and bias_hh, we need to split the bias loaded from ONNX model
weights['gru.bias_hh_l0'] = weights['gru.bias_ih_l0'][150:].clone()
weights['gru.bias_ih_l0'] = weights['gru.bias_ih_l0'][:150].clone()

weights['fc3.weight'] = weights['fc3.weight'].reshape(50, 1).clone()


# Load the weights into the model
model.load_state_dict(weights)

# Save the PyTorch model
torch.save(model.state_dict(), "inst/model/kospacing2.pth")
