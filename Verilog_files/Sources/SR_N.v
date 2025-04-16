`timescale 1ns / 1ps

//Register which form the sorting unit SR chain, load logic determined here

module SR_N(input[9:0] new, input[9:0] above, input ctrl, input clk, input reset, input [1:0] load,input abvctrl, output[9:0] down

    );
    reg [9:0] data;
    always@(posedge clk) begin
        if (reset==1) begin
            data <= 10'b0;
        end
    //Shift register logic - N length enable signal, each SR receives 1 bit + 1 bit of the below SR
    //If both load signals are 0 load new data if it is larger than currently held value or above value if not
   case (load) 
   2'b00: begin
         if (abvctrl==0&&ctrl==1) begin
            data<=new;
        end
        else if ((abvctrl==1&&ctrl==1))begin
            data<=above;
        end 
    end
    //If load signal is 1 and below is 0, load new data is above data is larger than input, else load the above data
    2'b10: begin
         if (abvctrl==0) begin
            data<=new;
        end
        else if (abvctrl==1)begin
            data<=above;
        end 
    end
    //If load signal is 1 and below is 1 load above (this is to load data serially from previous sorting operation into DBSCAN)
        2'b11: begin     
            data<=above;    
    end
    // Edge case which should never occur, causes a reset.
    2'b01: begin
        data<=10'b0;
        end
    
    endcase
    end
  //Connect with SR below  
  assign down= data;
  
endmodule
