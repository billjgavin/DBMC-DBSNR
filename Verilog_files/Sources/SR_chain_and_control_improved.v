`timescale 1ns / 1ps
//Top level module for sorting unit, contains both sorting modules + overall system control unit
//Control unit included in this module for implementation in the same pblock, which minimises delay of the n-bit enable control signal
module SR_chain_and_control_improved(
    input[9:0] ini, inq,           
    input clk, 
    input reset,
    input start,
    output[9:0] out0, out1,          
    output MLP_en, final        
);

parameter N=1000;    //SR_chain size

    
    
   wire[N:0] enable;     //Primary sorting control signal
   
      
    // Instantiate main modules
    SR_chain SRC0(ini, clk, reset, enable, out0);    //2 sorting chains for ABS and ARG data
    SR_chain SRC1(inq, clk, reset, enable, out1);
    SR_chain_control SRCC0(start, clk, reset, enable,MLP_en,final);    //Overall control unit located in this module due to timing requirements of enable signal
    
    
    
endmodule