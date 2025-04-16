# DBMC-DBSNR
Code repository to exhibit the DBMC/DBSNR system in order to assist in demonstrating the work undertaken in the PhD program by William Gavin.

This repository includes:

-A link to the dataset with which training and testing was performed 

-MATLAB scripts which provide functionality to extract and manage the dataset 

-Python scripts which are used to generate weight and bias values for the hardware implementation

-The hardware implementation itself


....................................................................................................................................................................................


Signal dataset hosted at Kaggle. Link -> https://www.kaggle.com/datasets/billgavin1/largesignaldataset-dbmc/


....................................................................................................................................................................................

Steps to test code:

1. Download Verilog files and example datasets
2. Create a Vivado project and add all sources
3. Add example datasets to the xsim folder
4. Run Simulation
5. Classification and regression functionality may be swtiched between by commenting/uncommenting appropriate weights in parallel_MLP_24bit.v and changing .csv file name in the testbench


Steps to test system with datasets other than the provided example

1. Download the full signal dataset from kaggle and place in your MATLAB path
2. Run DatasetExtractor.m
3. Run InputDatasetGen.m, take care to ensure that variables n, num_in_data, and class are set appropriately
4. Copy and paste the created .csv files to the xsim folder of the Verilog project
5. Run a behavioural simulation
6. Copy and paste the created mag.csv and arg.csv files to your MATLAB path
7. Run TrainingDataGen.m take care to set variables option and t to appropriate values
8. Copy and paste created inputs and target .csv files to your Python path
9. Run either the Classifier_weights.py or Regression_weights.py file, it may take a number of runs to obtain weight and bias values with strong accuracy
10. Copy and paste the obtained weight and bias values to the paraellel_MLP_24bit code in the appropriate location, make sure to comment old weight values
11. Run Verilog simulation to see resulting performance

Note: DatasetExtractor.m includes a software simulation of the verilog CORDIC/SORTING/DBSCAN modules, it is possible to use this code in conjunction with the two Quickselect.m files to quickly obtain features and targets for training. However, slight algorithmic differences across this simulation and the hardware implementation result in slightly different outputs. It is therefore recommended to follow the above steps as this leads to superior performance. 

To quickly test the system follow these steps:

1. Download the full signal dataset from kaggle and place in your MATLAB path
2. Run DatasetExtractor.m
3. Run either quickselect.m file depending upon if you desire classification or regression functionality Important: Ensure the variables "set", "nwaves", and "n" are set correctly 
4. Copy and paste saved files to your Python path
5. Run the approriate Python weight generation code
6. Copy and paste the output weight and bias values to the paraellel_MLP_24bit code in the appropriate location, make sure to comment old weight values
7. Run InputDatasetGen.m, take care to ensure that variables n, num_in_data, and class are set appropriately
8. Copy and paste the created .csv files to the xsim folder of the Verilog project
9. Run a simulation






