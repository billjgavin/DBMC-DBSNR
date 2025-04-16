import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import pandas as pd
from torch.utils.data import Dataset, DataLoader
import copy



# Define custom dataset class for regression
class RegressionDataset(Dataset):
    def __init__(self, input_file, target_file):
        # Load the CSV files
        self.X = pd.read_csv(input_file, header=None).values  # Nx2
        self.y = pd.read_csv(target_file, header=None).values  # Nx1
        
        # Convert to tensors
        self.X = torch.FloatTensor(self.X)
        self.y = torch.FloatTensor(self.y)
        
    def __len__(self):
        return len(self.X)
    
    def __getitem__(self, idx):
        return self.X[idx], self.y[idx]

# Define the MLP model for regression
# Note: We keep 15 outputs to match your Verilog implementation
# but we'll only train the first output for regression
class MLPRegression(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(MLPRegression, self).__init__()
        self.layer1 = nn.Linear(input_size, hidden_size)
        self.act1 = nn.ReLU()
        self.layer2 = nn.Linear(hidden_size, output_size)
    
    def forward(self, x):
        x = self.layer1(x)
        x = self.act1(x)
        x = self.layer2(x)
        return x

# Define a fixed-point quantization function with Q9.7 format to match your Verilog
def quantize_to_fixed_point(tensor, bits=16, integer_bits=9):
    """
    Quantize a tensor to fixed-point representation.
    
    Args:
        tensor: Input tensor to quantize
        bits: Total number of bits for representation
        integer_bits: Number of bits for the integer part
    
    Returns:
        Quantized tensor
    """
    fraction_bits = bits - integer_bits - 1  # -1 for sign bit
    scale = 2.0 ** fraction_bits
    
    # Clamp values to representable range
    min_val = -2.0 ** (integer_bits)
    max_val = 2.0 ** (integer_bits) - 2.0 ** (-fraction_bits)
    
    clamped_tensor = torch.clamp(tensor, min_val, max_val)
    
    # Quantize
    quantized = torch.round(clamped_tensor * scale) / scale
    
    return quantized

# Function to quantize an entire model
def quantize_model(model, bits=16, integer_bits=9):
    """
    Create a quantized version of the model with fixed-point weights and biases.
    
    Args:
        model: The PyTorch model to quantize
        bits: Total number of bits for fixed-point representation
        integer_bits: Number of bits for the integer part
    
    Returns:
        Quantized model
    """
    quantized_model = copy.deepcopy(model)
    
    for name, param in quantized_model.named_parameters():
        if 'weight' in name or 'bias' in name:
            with torch.no_grad():
                param.copy_(quantize_to_fixed_point(param, bits, integer_bits))
    
    return quantized_model

# Function to print weights in Verilog format
def print_verilog_weights(model):
    """Print model weights in Verilog-compatible format."""
    print("\n--- Verilog Weight and Bias Values for Regression Model ---")
    
    # Extract parameters
    params = {}
    for name, param in model.named_parameters():
        params[name] = param
    
    # Hidden layer weights
    hidden_weights = params['layer1.weight'].data
    print("// Hidden layer weights (quantized values in Q9.7 format)")
  
    print("initial begin")
    for i in range(hidden_weights.size(0)):
        for j in range(hidden_weights.size(1)):
            val = hidden_weights[i][j].item()
            int_val = int(round(val * 128))  # 128 = 2^7 for Q9.7
            hex_val = format(int_val & 0xFFFF, '04x')
            print(f"    hidden_weights[{i}][{j}] = 16'h{hex_val.upper()};  // {val:.4f} in Q9.7")
    print("end\n")
    
    # Hidden layer biases
    hidden_biases = params['layer1.bias'].data
    print("// Hidden layer biases (quantized values in Q9.7)")

    print("initial begin")
    for i in range(hidden_biases.size(0)):
        val = hidden_biases[i].item()
        int_val = int(round(val * 128))
        hex_val = format(int_val & 0xFFFF, '04x')
        print(f"    hidden_biases[{i}] = 16'h{hex_val.upper()};  // {val:.4f} in Q9.7")
    print("end\n")
    
    # Output layer weights
    output_weights = params['layer2.weight'].data
    print("// Output layer weights (quantized values in Q9.7)")
  
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
    print("// Output layer biases (quantized values in Q9.7)")
    
    print("initial begin")
    for i in range(output_biases.size(0)):
        val = output_biases[i].item()
        int_val = int(round(val * 128))
        hex_val = format(int_val & 0xFFFF, '04x')
        print(f"    output_biases[{i}] = 16'h{hex_val.upper()};  // {val:.4f} in Q9.7")
    print("end")

# Main execution function
def main():
    # Parameters
    input_size = 2           # 2 input features
    hidden_size = 3          # 3 hidden neurons
    output_size = 15         # 15 outputs (to match Verilog code, but we only use the first one)
    batch_size = 64
    num_epochs = 500
    learning_rate = 0.005
    
    # Input and target file paths
    input_file = 'D:\PyTorchWork/1_inputs_snr_v.csv'
    target_file = 'D:\PyTorchWork/1_targets_snr_v.csv'
    
    print(f"Loading data from {input_file} and {target_file}")
    
    # Create dataset and dataloader
    dataset = RegressionDataset(input_file, target_file)
    dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=True)
    
    # Print first 10 inputs and targets
    print("\n--- First 10 inputs and targets ---")
    for i in range(min(10, len(dataset))):
        input_data, target_data = dataset[i]
        print(f"Input {i}: {input_data.tolist()}, Target: {target_data.item()}")
    
    # Initialize the model
    model = MLPRegression(input_size, hidden_size, output_size)
    
    # Define loss function (MSE for regression) and optimizer
    criterion = nn.MSELoss()
    optimizer = optim.Adam(model.parameters(), lr=learning_rate)
    
    # Train the model
    print("Training regression model...")
    for epoch in range(num_epochs):
        running_loss = 0.0
        for inputs, targets in dataloader:
            # Forward pass - only use the first output for regression
            outputs = model(inputs)
            loss = criterion(outputs[:, 0].unsqueeze(1), targets)
            
            # Backward pass and optimize
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            
            running_loss += loss.item()
        if (epoch + 1) == 2:
            print(f'Epoch [{epoch+1}/{num_epochs}], Loss: {running_loss/len(dataloader):.6f}')
        # Print epoch statistics
        if (epoch + 1) % 100 == 0:
            print(f'Epoch [{epoch+1}/{num_epochs}], Loss: {running_loss/len(dataloader):.6f}')
    
    # Zero out weights and biases for all outputs except the first one (index 0)
    print("\nZeroing out weights and biases for unused outputs (1-14)...")
    with torch.no_grad():
        for i in range(1, output_size):  # Outputs 1 to 14
            model.layer2.weight[i,:].zero_()
            model.layer2.bias[i].zero_()
            
    # Create a quantized version of the model (16-bit fixed point with Q9.7 format)
    quantized_model = quantize_model(model, bits=16, integer_bits=9)
    
    # Evaluate both models (using MSE)
    def evaluate_model(model, dataset):
        with torch.no_grad():
            outputs = model(dataset.X)[:, 0].unsqueeze(1)
            mse = nn.MSELoss()(outputs, dataset.y)
        return mse.item()
    
    full_precision_mse = evaluate_model(model, dataset)
    quantized_mse = evaluate_model(quantized_model, dataset)
    
    print("\n--- MSE Comparison ---")
    print(f"Full precision model MSE: {full_precision_mse:.6f}")
    print(f"16-bit fixed point model MSE: {quantized_mse:.6f}")
    print(f"MSE difference: {abs(full_precision_mse - quantized_mse):.6f}")
    
    # Print Verilog weights
    print_verilog_weights(quantized_model)

if __name__ == "__main__":
    main()