`timescale 1ns / 1ps



module SR_chain_control(
    input start,
    input clk,
    input reset,
    output reg [N:0] enable,    //Sorting control signal
    output reg MLP_en,          //Enables MLP operation
    output reg final            //Ends a DBSCAN cycle
    
);
    reg [9:0] count;
    reg[3:0] cordic_count;
    reg CHAIN_en;  
    parameter N = 1000;   //Number of chained registers in sorting unit/ cycles for DBSCAN operation
    
    //Begin sorting only after 14 CORDIC iterations (only operates on system startup)
        always@(posedge clk) begin
        if (reset == 1) begin
            CHAIN_en<=0;
            cordic_count<=0;
        end
        else if ((cordic_count<14)&&(start==1)) begin
            cordic_count<=cordic_count+1;
            end
        else if (start==1) begin
            CHAIN_en<=1;
        end
        end            
        
    
    // Initialize enable on reset
    always @(posedge clk) begin
        if (reset == 1) begin
            count <= 1;
            // Initialize enable - all 1's except enable[0]=0
            enable <= {1'b1, {(N-1){1'b1}}, 1'b0};
        end
        else if (count == N && CHAIN_en == 1) begin
            count <= 1;
            // Reset enable pattern
            enable <= {1'b1, {(N-1){1'b1}}, 1'b0};
        end
        else if (count < N && CHAIN_en == 1) begin
            count <= count + 1;
            // Only update the specific bit that needs to change
            enable[count] <= 1'b0;
        end
    end
    //Enable MLP operation on clock cycles 3 to 29 
    always@(posedge clk) begin
        if (reset == 1) begin
            MLP_en<=0;
        end
        else if ((count<30)&&(count>2)) begin
            MLP_en<=1;
            end
        else begin
            MLP_en<=0;
        end
        end        
        
   //Enable DBSCAN output routine (declares N differences have been found and resets signals)    
   always@(posedge clk) begin
        if (reset == 1) begin
            final<=0;
        end
        else if ((count==N)) begin
            final<=1;
            end
        else begin
            final<=0;
        end
        end     
endmodule