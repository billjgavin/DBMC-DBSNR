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
3. Run Quickselect.m or Quickselect_snr.m, choosing an appropriate value of n.
4. There are now 2 options -> Use






