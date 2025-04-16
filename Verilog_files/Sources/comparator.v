`timescale 1ns / 1ps

//Comparator
module comparator(
input[9:0] newdata, 
input[9:0] storeddata,
output CMP
    );

//If input data is larger than the stored data output a 1
assign CMP = newdata > storeddata ? 1'b1 : 1'b0;



endmodule