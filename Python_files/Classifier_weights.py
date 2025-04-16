import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import pandas as pd
from torch.utils.data import Dataset, DataLoader
import copy


# Define custom dataset class
class CustomDataset(Dataset):
    def __init__(self, input_file, target_file):
        # Load the CSV files
        self.X = pd.read_csv(input_file, header=None).values  # 9000x2
        self.y = pd.read_csv(target_file, header=None).values.flatten()  # 9000x1 -> 9000
        
        # Convert to tensors
        self.X = torch.FloatTensor(self.X)
        self.y = torch.LongTensor(self.y)
        
    def __len__(self):
        return len(self.X)
    
    def __getitem__(self, idx):
        return self.X[idx], self.y[idx]

# Define the MLP model
class MLP(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(MLP, self).__init__()
        self.layer1 = nn.Linear(input_size, hidden_size)
        self.act1 = nn.ReLU()
        self.layer2 = nn.Linear(hidden_size, output_size)
    
    def forward(self, x):
        x = self.layer1(x)
        x = self.act1(x)
        x = self.layer2(x)
        return x

# Define a fixed-point quantisation function
def quantise_to_fixed_point(tensor, bits=16, integer_bits=8):
    """
    Quantise a tensor to fixed-point representation.
    
    Args:
        tensor: Input tensor to quantise
        bits: Total number of bits for representation
        integer_bits: Number of bits for the integer part
    
    Returns:
        Quantised tensor
    """
    fraction_bits = bits - integer_bits - 1  # -1 for sign bit
    scale = 2.0 ** fraction_bits
    
    # Clamp values to representable range
    min_val = -2.0 ** (integer_bits)
    max_val = 2.0 ** (integer_bits) - 2.0 ** (-fraction_bits)
    
    clamped_tensor = torch.clamp(tensor, min_val, max_val)
    
    # Quantise
    quantised = torch.round(clamped_tensor * scale) / scale
    
    return quantised

# Function to quantise an entire model
def quantise_model(model, bits=16, integer_bits=8):
    """
    Create a quantised version of the model with fixed-point weights and biases.
    
    Args:
        model: The PyTorch model to quantise
        bits: Total number of bits for fixed-point representation
        integer_bits: Number of bits for the integer part
    
    Returns:
        Quantised model
    """
    quantised_model = copy.deepcopy(model)
    
    for name, param in quantised_model.named_parameters():
        if 'weight' in name or 'bias' in name:
            with torch.no_grad():
                param.copy_(quantise_to_fixed_point(param, bits, integer_bits))
    
    return quantised_model

# Load the data
dataset = CustomDataset('D:\PyTorchWork/1_inputs_v.csv', 'D:\PyTorchWork/1_targets_v.csv')
dataloader = DataLoader(dataset, batch_size=64, shuffle=True)

# Initialize the model
input_size = 2  # 2 input features
hidden_size = 3  # 3 hidden neurons
output_size = 15  # 15 output classes
model = MLP(input_size, hidden_size, output_size)

# Define loss function and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.005)

# Train the model
num_epochs = 1500
for epoch in range(num_epochs):
    running_loss = 0.0
    for inputs, targets in dataloader:
        # Forward pass
        outputs = model(inputs)
        loss = criterion(outputs, targets)
        
        # Backward pass and optimise
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        running_loss += loss.item()
    
    # Print epoch statistics
    if (epoch + 1) % 100 == 0:
        print(f'Epoch [{epoch+1}/{num_epochs}], Loss: {running_loss/len(dataloader):.4f}')

# Create a quantised version of the model (16-bit fixed point)
quantised_model = quantise_model(model, bits=16, integer_bits=8)

# Function to evaluate model accuracy
def evaluate_model(model, dataloader):
    correct = 0
    total = 0
    with torch.no_grad():
        for inputs, targets in dataloader:
            outputs = model(inputs)
            _, predicted = torch.max(outputs.data, 1)
            total += targets.size(0)
            correct += (predicted == targets).sum().item()
    
    accuracy = 100 * correct / total
    return accuracy

# Evaluate both models
full_precision_accuracy = evaluate_model(model, dataloader)
quantised_accuracy = evaluate_model(quantised_model, dataloader)

print("\n--- Accuracy Comparison ---")
print(f"Full precision model accuracy: {full_precision_accuracy:.2f}%")
print(f"16-bit fixed point model accuracy: {quantised_accuracy:.2f}%")
print(f"Accuracy difference: {abs(full_precision_accuracy - quantised_accuracy):.2f}%")

#Prints quantised weights in the required format for the Verilog implementation
def print_verilog_weights(model):
    print("\n--- Verilog Weight and Bias Values ---")
    
    # Extract parameters
    params = {}
    for name, param in model.named_parameters():
        params[name] = param
    
    # Hidden layer weights
    hidden_weights = params['layer1.weight'].data
    print("// Hidden layer weights (quantised values in Q9.7 format)")
  
    print("initial begin")
    for i in range(hidden_weights.size(0)):
        for j in range(hidden_weights.size(1)):
            val = hidden_weights[i][j].item()
            int_val = int(round(val * 128))
            hex_val = format(int_val & 0xFFFF, '04x')
            print(f"    hidden_weights[{i}][{j}] = 16'h{hex_val.upper()};  // {val:.4f} in Q9.7")
    print("end\n")
    
    # Hidden layer biases
    hidden_biases = params['layer1.bias'].data
    print("// Hidden layer biases (quantised values in Q9.7)")

    print("initial begin")
    for i in range(hidden_biases.size(0)):
        val = hidden_biases[i].item()
        int_val = int(round(val * 128))
        hex_val = format(int_val & 0xFFFF, '04x')
        print(f"    hidden_biases[{i}] = 16'h{hex_val.upper()};  // {val:.4f} in Q9.7")
    print("end\n")
    
    # Output layer weights
    output_weights = params['layer2.weight'].data
    print("// Output layer weights (quantised values in Q9.7)")
  
    print("initial begin")
    for i in range(output_weights.size(0)):
        for j in range(output_weights.size(1)):
            val = output_weights[i][j].item()
            int_val = int(round(val * 128))
            hex_val = format(int_val & 0xFFFF, '04x')
            print(f"    output_weights[{i}][{j}] = 16'h{hex_val.upper()};  // {val:.4f} in Q9.7")
    print("end\n")
    
    # Output layer biases
    output_biases = params['layer2.bias'].data
    print("// Output layer biases (quantised values in Q9.7)")
    
    print("initial begin")
    for i in range(output_biases.size(0)):
        val = output_biases[i].item()
        int_val = int(round(val * 128))
        hex_val = format(int_val & 0xFFFF, '04x')
        print(f"    output_biases[{i}] = 16'h{hex_val.upper()};  // {val:.4f} in Q9.7")
    print("end")


print_verilog_weights(quantised_model)

