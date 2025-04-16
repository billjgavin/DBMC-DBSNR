`timescale 1ns / 1ps
//CORDIC Rectangular to polar converter, fully pipelined
//Design inspired by https://zipcpu.com/dsp/2017/09/01/topolar.html

module cordic_rtop #(
    parameter IW = 14,         // Input data width 
    parameter OW = 10,         // Output data width
    parameter NSTAGES = 12,    // Number of CORDIC stages
    parameter WW = IW+1        // Working width (expand by 1 bit)
) (
    input  wire               i_clk,   // System clock
    input  wire               i_ce,    // Clock enable
    input  wire signed [IW-1:0] i_xval,  // Input X value
    input  wire signed [IW-1:0] i_yval,  // Input Y value
    output reg [OW-1:0] o_mag,   // Output magnitude
    output reg [OW-1:0] o_phase  // Output phase 
);

    // Internal working registers
    reg signed [WW-1:0] xv [0:NSTAGES];
    reg signed [WW-1:0] yv [0:NSTAGES];
    reg signed [18:0]   ph [0:NSTAGES];  // Phase accumulator (19 bits)

    // Pre-expanded input values (expand by 1 bit to avoid overflow)
    wire signed [WW-1:0] e_xval = { i_xval[IW-1], i_xval };
    wire signed [WW-1:0] e_yval = { i_yval[IW-1], i_yval };

    // CORDIC gain factor (K ? 0.6073...)
    // For 16 stages, K ? 0.6073 * 2^16 
    localparam signed [19:0] CORDIC_GAIN = 20'd39798;  //was 39797

    // Pre-compute CORDIC angles 
    // cordic_angle[i] = atan(2^-i) * 2^19 / (2)
    wire [18:0] cordic_angle [0:NSTAGES-1];
    

    
    assign cordic_angle[0]  = 19'd27203; // atan(2^-0) = atan(1) = 45° = 0.125 * 2^19
    assign cordic_angle[1]  = 19'd14373; // atan(2^-1) = atan(0.5) ? 26.57°
    assign cordic_angle[2]  = 19'd7296; // atan(2^-2) ? 14.04°
    assign cordic_angle[3]  = 19'd3662; // atan(2^-3) ? 7.13°
    assign cordic_angle[4]  = 19'd1832; // atan(2^-4) ? 3.58°
    assign cordic_angle[5]  = 19'd916; // atan(2^-5) ? 1.79°
    assign cordic_angle[6]  = 19'd458; // atan(2^-6) ? 0.89°
    assign cordic_angle[7]  = 19'd229; // atan(2^-7) ? 0.45°
    assign cordic_angle[8]  = 19'd115; // atan(2^-8) ? 0.22°
    assign cordic_angle[9]  = 19'd57; // atan(2^-9) ? 0.11°
    assign cordic_angle[10] = 19'd29; // atan(2^-10) ? 0.06°
    assign cordic_angle[11] = 19'd14; // atan(2^-11) ? 0.03°
    assign cordic_angle[12] = 19'd7; // atan(2^-12) ? 0.01°
    assign cordic_angle[13] = 19'd4; // atan(2^-13) ? 0.005°
    assign cordic_angle[14] = 19'd2; // atan(2^-14) ? 0.003°
    assign cordic_angle[15] = 19'd1; // atan(2^-15) ? 0.001°


    // First stage: Pre-rotation to map the input vector to within +/- 45 degrees of the x-axis
    always @(posedge i_clk)
    if (i_ce)
        case({i_xval[IW-1], i_yval[IW-1]})
        2'b01: begin // Rotate by -315 degrees
            xv[0] <=  e_xval - e_yval;
            yv[0] <=  e_xval + e_yval;
            ph[0] <= 19'd322560;  
            end
        2'b10: begin // Rotate by -135 degrees 
            xv[0] <= -e_xval + e_yval;
            yv[0] <= -e_xval - e_yval;
            ph[0] <= 19'd138240;  
            end
        2'b11: begin // Rotate by -225 degrees 
            xv[0] <= -e_xval - e_yval;
            yv[0] <=  e_xval - e_yval;
            ph[0] <= 19'd230400;  
            end
        // 2'b00:
        default: begin // Rotate by -45 degrees 
            xv[0] <=  e_xval + e_yval;
            yv[0] <= -e_xval + e_yval;
            ph[0] <= 19'd46080;  
            end
        endcase

    // CORDIC iteration stages
    genvar i;
    generate for(i=0; i<NSTAGES; i=i+1) begin : TOPOLARloop
        always @(posedge i_clk)
        if (i_ce)
        begin
            if (yv[i][WW-1]) begin // If y is negative (below x-axis)
                // Rotate CCW to move toward x-axis
                xv[i+1] <= xv[i] - (yv[i]>>>(i+1));
                yv[i+1] <= yv[i] + (xv[i]>>>(i+1));
                ph[i+1] <= ph[i] - cordic_angle[i];
            end else begin
                // Rotate CW to move toward x-axis
                xv[i+1] <= xv[i] + (yv[i]>>>(i+1));
                yv[i+1] <= yv[i] - (xv[i]>>>(i+1));
                ph[i+1] <= ph[i] + cordic_angle[i];
            end
        end
    end endgenerate


    
   // Final stage: Scale the magnitude and round to output width
    reg signed [2*WW:0] mag_result;
    reg [OW-1:0] phase_result;
// Add pipeline registers
always @(posedge i_clk) begin
    if (i_ce) begin
        // First register stage
        mag_result <= (xv[NSTAGES] * CORDIC_GAIN) >>> 13;
        phase_result <= ph[NSTAGES][18:19-OW];
    end
end

// Second pipeline stage
always @(posedge i_clk) begin
    if (i_ce) begin
        o_mag <= mag_result[WW-1:WW-OW];
        o_phase <= phase_result;
    end
end
    


endmodule


