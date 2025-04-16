`timescale 1ns / 1ps

// Top-level module for MLP with argmax classifier output

module mlp_24bit_scalable #(
    parameter NUM_HIDDEN = 3,
    parameter NUM_OUTPUTS = 15
)(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [23:0] input_1,
    input wire [23:0] input_2,
    output wire [3:0] classification_result,
    output wire [23:0] regression_result,
    output wire done
);
    // States for main controller
    localparam IDLE = 3'd0;
    localparam COMPUTE_HIDDEN_MUL = 3'd1;
    localparam COMPUTE_HIDDEN_SUM = 3'd2;
    localparam COMPUTE_OUTPUT_MUL = 3'd3;
    localparam COMPUTE_OUTPUT_SUM = 3'd4;
    localparam ARGMAX = 3'd5;
    localparam DONE_STATE = 3'd6;
    
    reg [23:0] current_value;
    
    // State register
    reg [2:0] state;
    
    // Fixed number of inputs
    localparam NUM_INPUTS = 2;
    
    // Hidden layer outputs 
    reg [23:0] hidden_outputs [0:NUM_HIDDEN-1];
    
    // Multiplication results for hidden layer
    reg [47:0] hidden_mul_results [0:NUM_HIDDEN-1][0:NUM_INPUTS-1];
    reg [23:0] hidden_sums [0:NUM_HIDDEN-1];
    
    // Multiplication results for output layer
    reg [47:0] output_mul_results [0:NUM_OUTPUTS-1][0:NUM_HIDDEN-1];
    
    // Output layer results
    reg [23:0] output_values [0:NUM_OUTPUTS-1];
    reg [23:0] temp_sum;
    
    // Counter for computations
    reg [4:0] counter;
    
    // Argmax registers
    reg [23:0] max_value;
    reg [3:0] max_index;
    
    // Variable for initialization loops
    integer i, j;
    
    
    
    // Hidden layer weights (quantised values in Q9.7 format)
    reg [15:0] hidden_weights [0:NUM_HIDDEN-1][0:NUM_INPUTS-1];
    
    // Hidden layer biases (quantised values in Q9.7)
    reg [15:0] hidden_biases [0:NUM_HIDDEN-1];
    
    // Output layer weights (quantised values in Q9.7)
    reg [15:0] output_weights [0:NUM_OUTPUTS-1][0:NUM_HIDDEN-1];
    
    // Output layer biases (quantised values in Q9.7)
    reg [15:0] output_biases [0:NUM_OUTPUTS-1];
    
//Use provided Python files to train MLP and copy and paste the output for the weights

initial begin
    hidden_weights[0][0] = 16'h0032;  // 0.3906 in Q9.7
    hidden_weights[0][1] = 16'hFFEA;  // -0.1719 in Q9.7
    hidden_weights[1][0] = 16'hFFF6;  // -0.0781 in Q9.7
    hidden_weights[1][1] = 16'h005F;  // 0.7422 in Q9.7
    hidden_weights[2][0] = 16'hFFB8;  // -0.5625 in Q9.7
    hidden_weights[2][1] = 16'h0062;  // 0.7656 in Q9.7
end

// Hidden layer biases (quantised values in Q9.7)

initial begin
    hidden_biases[0] = 16'hFBAA;  // -8.6719 in Q9.7
    hidden_biases[1] = 16'hFE84;  // -2.9688 in Q9.7
    hidden_biases[2] = 16'h07DA;  // 15.7031 in Q9.7
end

// Output layer weights (quantised values in Q9.7)

initial begin
    output_weights[0][0] = 16'h0040;  // 0.5000 in Q9.7
    output_weights[0][1] = 16'hFFE3;  // -0.2266 in Q9.7
    output_weights[0][2] = 16'h00CE;  // 1.6094 in Q9.7
    output_weights[1][0] = 16'hF89B;  // -14.7891 in Q9.7
    output_weights[1][1] = 16'h0209;  // 4.0703 in Q9.7
    output_weights[1][2] = 16'hFEC1;  // -2.4922 in Q9.7
    output_weights[2][0] = 16'hFEB1;  // -2.6172 in Q9.7
    output_weights[2][1] = 16'h0082;  // 1.0156 in Q9.7
    output_weights[2][2] = 16'hFFB1;  // -0.6172 in Q9.7
    output_weights[3][0] = 16'hFF75;  // -1.0859 in Q9.7
    output_weights[3][1] = 16'h006C;  // 0.8438 in Q9.7
    output_weights[3][2] = 16'hFFAA;  // -0.6719 in Q9.7
    output_weights[4][0] = 16'hFFDC;  // -0.2812 in Q9.7
    output_weights[4][1] = 16'h0011;  // 0.1328 in Q9.7
    output_weights[4][2] = 16'hEAEE;  // -42.1406 in Q9.7
    output_weights[5][0] = 16'h0034;  // 0.4062 in Q9.7
    output_weights[5][1] = 16'h0000;  // -0.0000 in Q9.7
    output_weights[5][2] = 16'hF52C;  // -21.6562 in Q9.7
    output_weights[6][0] = 16'h005A;  // 0.7031 in Q9.7
    output_weights[6][1] = 16'h0014;  // 0.1562 in Q9.7
    output_weights[6][2] = 16'h0029;  // 0.3203 in Q9.7
    output_weights[7][0] = 16'hFF9E;  // -0.7656 in Q9.7
    output_weights[7][1] = 16'h0066;  // 0.7969 in Q9.7
    output_weights[7][2] = 16'hFFCD;  // -0.3984 in Q9.7
    output_weights[8][0] = 16'hFFD3;  // -0.3516 in Q9.7
    output_weights[8][1] = 16'hFF1D;  // -1.7734 in Q9.7
    output_weights[8][2] = 16'hFFD3;  // -0.3516 in Q9.7
    output_weights[9][0] = 16'hFFCE;  // -0.3906 in Q9.7
    output_weights[9][1] = 16'hFEB4;  // -2.5938 in Q9.7
    output_weights[9][2] = 16'hE351;  // -57.3672 in Q9.7
    output_weights[10][0] = 16'h001F;  // 0.2422 in Q9.7
    output_weights[10][1] = 16'hFF21;  // -1.7422 in Q9.7
    output_weights[10][2] = 16'hF64E;  // -19.3906 in Q9.7
    output_weights[11][0] = 16'hFFF2;  // -0.1094 in Q9.7
    output_weights[11][1] = 16'hFFA0;  // -0.7500 in Q9.7
    output_weights[11][2] = 16'hD835;  // -79.5859 in Q9.7
    output_weights[12][0] = 16'h003D;  // 0.4766 in Q9.7
    output_weights[12][1] = 16'hFFBD;  // -0.5234 in Q9.7
    output_weights[12][2] = 16'hF083;  // -30.9766 in Q9.7
    output_weights[13][0] = 16'h0070;  // 0.8750 in Q9.7
    output_weights[13][1] = 16'hFF91;  // -0.8672 in Q9.7
    output_weights[13][2] = 16'hFF6D;  // -1.1484 in Q9.7
    output_weights[14][0] = 16'h009C;  // 1.2188 in Q9.7
    output_weights[14][1] = 16'hFFDE;  // -0.2656 in Q9.7
    output_weights[14][2] = 16'hFE3A;  // -3.5469 in Q9.7
end

// Output layer biases (quantised values in Q9.7)

initial begin
    output_biases[0] = 16'hFB48;  // -9.4375 in Q9.7
    output_biases[1] = 16'h1174;  // 34.9062 in Q9.7
    output_biases[2] = 16'h0802;  // 16.0156 in Q9.7
    output_biases[3] = 16'h03A5;  // 7.2891 in Q9.7
    output_biases[4] = 16'h053B;  // 10.4609 in Q9.7
    output_biases[5] = 16'hFAAF;  // -10.6328 in Q9.7
    output_biases[6] = 16'hEED2;  // -34.3594 in Q9.7
    output_biases[7] = 16'hFF66;  // -1.2031 in Q9.7
    output_biases[8] = 16'h0B76;  // 22.9219 in Q9.7
    output_biases[9] = 16'h0EA9;  // 29.3203 in Q9.7
    output_biases[10] = 16'h063F;  // 12.4922 in Q9.7
    output_biases[11] = 16'h08A5;  // 17.2891 in Q9.7
    output_biases[12] = 16'hFF7B;  // -1.0391 in Q9.7
    output_biases[13] = 16'hF731;  // -17.6172 in Q9.7
    output_biases[14] = 16'hE796;  // -48.8281 in Q9.7
end

//These are weights optimised for regression (to test uncomment and comment above weights (make sure to use correct dataset.)
    // Hidden layer weights (quantised values in Q9.7 format)
//initial begin
//    hidden_weights[0][0] = 16'h0002;  // 0.0156 in Q9.7
//    hidden_weights[0][1] = 16'hFFDA;  // -0.2969 in Q9.7
//    hidden_weights[1][0] = 16'h0008;  // 0.0625 in Q9.7
//    hidden_weights[1][1] = 16'h0020;  // 0.2500 in Q9.7
//    hidden_weights[2][0] = 16'hFFB0;  // -0.6250 in Q9.7
//    hidden_weights[2][1] = 16'hFFC2;  // -0.4844 in Q9.7
//end

//// Hidden layer biases (quantised values in Q9.7)
//initial begin
//    hidden_biases[0] = 16'h0756;  // 14.6719 in Q9.7
//    hidden_biases[1] = 16'h072A;  // 14.3281 in Q9.7
//    hidden_biases[2] = 16'hFFDC;  // -0.2812 in Q9.7
//end

//// Output layer weights (quantised values in Q9.7)
//initial begin
//    output_weights[0][0] = 16'hFF54;  // -1.3438 in Q9.7
//    output_weights[0][1] = 16'h0042;  // 0.5156 in Q9.7
//    output_weights[0][2] = 16'hFFB8;  // -0.5625 in Q9.7
//    output_weights[1][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[1][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[1][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[2][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[2][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[2][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[3][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[3][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[3][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[4][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[4][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[4][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[5][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[5][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[5][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[6][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[6][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[6][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[7][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[7][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[7][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[8][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[8][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[8][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[9][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[9][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[9][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[10][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[10][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[10][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[11][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[11][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[11][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[12][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[12][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[12][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[13][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[13][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[13][2] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[14][0] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[14][1] = 16'h0000;  // 0.0000 in Q9.7
//    output_weights[14][2] = 16'h0000;  // 0.0000 in Q9.7
//end

//// Output layer biases (quantised values in Q9.7)
//initial begin
//    output_biases[0] = 16'h0680;  // 13.0000 in Q9.7
//    output_biases[1] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[2] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[3] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[4] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[5] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[6] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[7] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[8] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[9] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[10] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[11] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[12] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[13] = 16'h0000;  // 0.0000 in Q9.7
//    output_biases[14] = 16'h0000;  // 0.0000 in Q9.7
//end
    // Initialize output array
    initial begin
        for (i = 0; i < NUM_OUTPUTS; i = i + 1) begin
            output_values[i] = 24'h800000; // Smallest possible 24-bit signed value
        end
    end
    
    // ReLU activation function 
    function [23:0] relu;
        input [23:0] value;
        begin
            relu = (value[23]) ? 24'h000000 : value; // If MSB is 1 (negative), return 0
        end
    endfunction
    
    // Main state machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            counter <= 5'd0;
            max_value <= 24'h800000; // Smallest possible 24-bit signed value
            max_index <= 4'd0;
            
            // Initialize output values
            for (i = 0; i < NUM_OUTPUTS; i = i + 1) begin
                output_values[i] <= 24'h800000;
            end
            
            // Initialize hidden values
            for (i = 0; i < NUM_HIDDEN; i = i + 1) begin
                hidden_outputs[i] <= 24'h000000;
            end
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= COMPUTE_HIDDEN_MUL;
                    end
                end
                
                COMPUTE_HIDDEN_MUL: begin
                    // Perform all hidden layer multiplications in parallel
                    for (i = 0; i < NUM_HIDDEN; i = i + 1) begin
                        hidden_mul_results[i][0] <= $signed(input_1) * $signed(hidden_weights[i][0]);
                        hidden_mul_results[i][1] <= $signed(input_2) * $signed(hidden_weights[i][1]);
                    end
                    
                    // Move to next state to compute sums and apply ReLU
                    state <= COMPUTE_HIDDEN_SUM;
                end
                
                COMPUTE_HIDDEN_SUM: begin
                    // Sum multiplications and add bias for each hidden neuron
                    for (i = 0; i < NUM_HIDDEN; i = i + 1) begin
                        hidden_sums[i] = $signed(hidden_biases[i]);
                        for (j = 0; j < NUM_INPUTS; j = j + 1) begin
                            hidden_sums[i] = hidden_sums[i] + $signed(hidden_mul_results[i][j][30:7]);
                        end
                        
                        // Apply ReLU activation
                        hidden_outputs[i] <= relu(hidden_sums[i]);
                    end
                    
                    // Move to output layer computation
                    state <= COMPUTE_OUTPUT_MUL;
                end
                
                COMPUTE_OUTPUT_MUL: begin
                    // Perform all output layer multiplications in parallel
                    for (i = 0; i < NUM_OUTPUTS; i = i + 1) begin
                        for (j = 0; j < NUM_HIDDEN; j = j + 1) begin
                            output_mul_results[i][j] <= $signed(hidden_outputs[j]) * $signed(output_weights[i][j]);
                        end
                    end
                    
                    // Move to next state to compute sums
                    state <= COMPUTE_OUTPUT_SUM;
                end
                
                COMPUTE_OUTPUT_SUM: begin
                    // Sum multiplications and add bias for each output neuron
                    for (i = 0; i < NUM_OUTPUTS; i = i + 1) begin
                        temp_sum = $signed(output_biases[i]);
                        for (j = 0; j < NUM_HIDDEN; j = j + 1) begin
                            temp_sum = temp_sum + $signed(output_mul_results[i][j][30:7]);
                        end
                        output_values[i] <= temp_sum;
                    end
                    
                    // Move to argmax computation
                    counter <= 5'd0;
                    state <= ARGMAX;
                end
                
                ARGMAX: begin
                    if (counter < NUM_OUTPUTS) begin
                        if (counter == 0) begin
                            // First cycle: initialize max to the first output
                            max_value <= output_values[0];
                            max_index <= 4'd0;
                            current_value <= output_values[counter+1];
                            counter <= counter + 1;
                        end else begin
                            // Compare current output with max value
                            if ($signed(current_value) > $signed(max_value)) begin
                                max_value <= current_value;
                                max_index <= counter[3:0];
                            end
                            
                            if (counter < NUM_OUTPUTS - 1) begin
                                current_value <= output_values[counter+1];
                            end
                            
                            counter <= counter + 1;
                            
                            // Move to DONE state after processing last output
                            if (counter == (NUM_OUTPUTS - 1)) begin
                                state <= DONE_STATE;
                            end
                        end
                    end else begin
                        // Fallback transition
                        state <= DONE_STATE;
                    end
                end
                
                DONE_STATE: begin
                    if (start == 0) begin
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
    
    // Output assignments
    assign classification_result = max_index;
    assign regression_result = output_values[0];
    assign done = (state == DONE_STATE);
    
endmodule
