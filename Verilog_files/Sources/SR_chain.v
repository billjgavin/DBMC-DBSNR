`timescale 1ns / 1ps

(* KEEP_HIERARCHY = "yes" *)
(* DONT_TOUCH = "true" *)

//Shift register chain, performs sorting and generates N registers and comparators

module SR_chain(input [9:0] in0, input clk, input reset, input [N:0] enable, output [9:0] out0);
    parameter N = 1000;  // Sets number of chained SRs
    parameter R = N/10; // Number of tree registers 
    
    wire [N*10+19:0] downwire;  // Wire chain between SRs
    wire [R*10-1:0] regwire;    // Wires from Tree regs
    wire [N-1:0] ctrl;          //enable signal
    
    genvar i, j;
    
    // Initialize the first 10 bits of downwire
    assign downwire[9:0] = 10'b1111111111;   //Required to ensure functionality
    assign ctrl[0] = 0; //Required to ensure functionality
    
    // Generate R registers
    generate
        for(i=0; i<R; i=i+1) begin : reg_gen
            treg tregx(clk, reset, in0, regwire[i*10+9:i*10]);
        end
    endgenerate
    
    // First SR_full uses the initial downwire value
    SR_full sr0(regwire[9:0], downwire[9:0], clk, reset, enable[1:0], ctrl[0], ctrl[1], downwire[19:10]);
    
    // Generate the remaining SR_full modules in groups
    //There is a better way to code this but im scared to touch it
    generate
        for(i=0; i<R; i=i+1) begin : reg_group
            // Skip the first SR since already instantiated
            if(i == 0) begin
                for(j=1; j<N/R; j=j+1) begin : sr_chain_first
                    SR_full srx(regwire[i*10+9:i*10], 
                              downwire[(i*N/R+j)*10+9:(i*N/R+j)*10], 
                              clk, reset, enable[i*N/R+j+1:i*N/R+j], 
                              ctrl[i*N/R+j], 
                              ctrl[i*N/R+j+1], 
                              downwire[(i*N/R+j)*10+19:(i*N/R+j)*10+10]);
                end
            end
            else begin
                for(j=0; j<N/R; j=j+1) begin : sr_chain_others
                    SR_full srx(regwire[i*10+9:i*10], 
                              downwire[(i*N/R+j)*10+9:(i*N/R+j)*10], 
                              clk, reset, enable[i*N/R+j+1:i*N/R+j], 
                              ctrl[i*N/R+j], 
                              ctrl[i*N/R+j+1], 
                              downwire[(i*N/R+j)*10+19:(i*N/R+j)*10+10]);
                end
            end
        end
    endgenerate
    
    // Assign outputs
    assign out0 = downwire[N*10+9:N*10];
    
    
    
endmodule