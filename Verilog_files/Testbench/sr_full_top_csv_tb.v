`timescale 1ns/1ps
module SR_full_top_csv_tb();
    // Parameters
    parameter CLK_PERIOD = 7; // 142.86MHz = 7ns period (integer value)
    parameter NUM_TESTS = 9000000;
    parameter N=1000;
    
    // Testbench signals
    reg [13:0] ini, inq;           // 14-bit inputs
    reg clk;
    reg reset;
    reg start;
    
    wire [9:0] out0, out1;
    wire [3:0] classification_result;
    wire [23:0] regression_result;
    wire done,final;
    // File handling
    integer file_nA, file_nP, scan_ret;
    integer file_arg, file_mag,file_class,file_regres; // Output file handles
    integer i, j; // Loop counters
    reg [31:0] temp_value; // Temporary variable to hold scanned value
    reg [13:0] ini_values[0:NUM_TESTS-1];
    reg [13:0] inq_values[0:NUM_TESTS-1];
    
    // Instantiate the Device Under Test (DUT)
    SR_full_top DUT (
        .ini(ini),
        .inq(inq),
        .clk(clk),
        .reset(reset),
        .start(start),
        .out0(out0),
        .out1(out1),
        .regression_result(regression_result),
        .classification_result(classification_result),
        .done(done),
        .final(final)
        
    );
    
    // Clock generation 
    always begin
        clk = 1'b1;
        #(3.5);
        clk = 1'b0;
        #(3.5);
    end
    
    // Load CSV files
    initial begin
        // Open CSV files
        file_nA = $fopen("1_nA_v_class.csv", "r");
        file_nP = $fopen("1_nP_v_class.csv", "r");
        

        
        // Check if files opened successfully
        if (file_nA == 0) begin
            $display("Error: Failed to open 1_nA.csv");
            $finish;
        end
        if (file_nP == 0) begin
            $display("Error: Failed to open 1_nP.csv");
            $finish;
        end
        

        
        #(CLK_PERIOD*100)
        
        // Read values from CSV files
        for (i = 0; i < NUM_TESTS; i = i + 1) begin
            if ($feof(file_nA)) begin
                $display("Warning: Reached end of 1_nA.csv after %d values", i);
                
            end
            if ($feof(file_nP)) begin
                $display("Warning: Reached end of 1_nP.csv after %d values", i);
                
            end
            
            // Read one value from each file
            scan_ret = $fscanf(file_nA, "%d\n", temp_value);
            ini_values[i] = temp_value[13:0]; // Convert to 14-bit value
            
            scan_ret = $fscanf(file_nP, "%d\n", temp_value);
            inq_values[i] = temp_value[13:0]; // Convert to 14-bit value
            
            if (scan_ret != 1) begin
                $display("Error reading CSV at line %d", i);
                $finish;
            end
        end
        
        // Close files
        $fclose(file_nA);
        $fclose(file_nP);
        
        $display("Successfully loaded %d values from CSV files", i);
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        ini = 14'h000; 
        inq = 14'h000;
        reset = 1'b0;
        start = 1'b0;
       
           

        
                // Open output CSV files
        file_arg = $fopen("arg.csv", "w");
        file_mag = $fopen("mag.csv", "w");
        file_class = $fopen("class_results.csv", "w");
        file_regres = $fopen("regres_results.csv", "w");
        
        // Wait for 100 clock cycles before starting
        #(CLK_PERIOD*300);
        
        // Apply reset
        reset = 1'b1;
        #(CLK_PERIOD*5);
        reset = 1'b0;
        
        #(CLK_PERIOD*3);
        #(CLK_PERIOD*500);
        start = 1'b1;
        
        // Apply values from CSV files
        for (j = 2; j < NUM_TESTS; j = j + 1) begin
            // Set final signal at specific test points

            
            #(3.5);
            
            // Apply values from loaded arrays
            ini = ini_values[j];
            inq = inq_values[j];
            
            #(3.5);
            
            if (j % (N+2) == 0) begin
                $fwrite(file_arg, "%d\n", out0);
                $fwrite(file_mag, "%d\n", out1);
                $fwrite(file_class, "%d\n", classification_result);
                $fwrite(file_regres, "%d\n", regression_result);
                $display("Writing to CSV: j=%d, out0=%h, out1=%h, , result=%d , result=%d", j, out0, out1,classification_result,$signed((regression_result/128)-10));
            end
            

        end
        
        // Run for a few more cycles to see final outputs
        #(CLK_PERIOD*1000);

        // End simulation
        $display("Testbench completed");
        $finish;
    end
    
endmodule