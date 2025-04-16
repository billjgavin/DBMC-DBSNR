`timescale 1ns / 1ps

module SR_full_top(input [13:0] ini, 
                    input[13:0] inq, 
                    input clk, 
                    input reset, 
                    input start, 
                    output [9:0] out0, 
                    output [9:0] out1, 
                    output[3:0] classification_result, 
                    output [23:0] regression_result, 
                    output done,
                    output final

    );
    
    parameter N=1000;   //Sets dataset size (also set in SR_chain_and_control_improved, SR_chain, SR_chain_control, and testbench
    wire [9:0] abs, arg,sortoutarg, sortoutabs;   //Connection Wires
    wire MLP_en,final;  // Control Signals
    wire done;   //Inidicates classification operation complete
    wire [23:0] mlpin0,mlpin1;  //Connection between DBSCAN and MLP
    
cordic_rtop CORDIC0(clk,start,ini,inq,abs,arg);
SR_chain_and_control_improved SRCC0(abs,arg,clk,reset,start,sortoutabs,sortoutarg,MLP_en,final);  //Sorting module
DBSCAN_ARG DBSCANARG(sortoutarg, clk, reset, start, final,out0); //Separate DBSCAN modules to individually set epsilon and minpts
DBSCAN_ABS DBSCANABS(sortoutabs, clk, reset, start, final,out1);

assign mlpin0 = {7'b0000000, out0, 7'b0000000};   //Set MLP input to 24-bits, input always positive
assign mlpin1 = {7'b0000000, out1, 7'b0000000};   //Set MLP input to 24-bits, input always positive  

mlp_24bit_scalable MLP0(clk,reset,MLP_en,mlpin0,mlpin1,classification_result,regression_result,done);



endmodule
