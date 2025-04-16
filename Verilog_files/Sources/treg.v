`timescale 1ns / 1ps

(* KEEP = "true" *)
(* DONT_TOUCH = "true" *)

//Basic register, treg = Tree reg

module treg (
    input wire clk,            // Clock input
    input wire rst,            // Active-high synchronous reset
    input wire [9:0] data_in,  // 10-bit input data
    output reg [9:0] data_out  // 10-bit output data
);

    // 10-bit register with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            // Reset the register to 0 when rst is high
            data_out <= 10'h000;
        end else begin
            // Update the register with input data
            data_out <= data_in;
        end
    end

endmodule