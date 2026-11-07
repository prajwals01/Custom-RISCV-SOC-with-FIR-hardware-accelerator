module tb_top;

    reg clk, reset;
    integer file, i, start_idx, num_samples;

    // Instantiate DUT
    top uut(.clk(clk), .reset(reset));

    // Clock generation (10 time units period)
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // 1. Initialize variables and start waveform dump
        clk = 0;
        reset = 1;
        $dumpfile("top.vcd");
        $dumpvars(0, uut);

        // 2. Apply reset
        #10;
        reset = 0;

        // 3. Wait for the processor to finish 500 loops 
        // (100,000 time units should be plenty!)
        #2000000;

        // 4. Extract the Clean Data to a Text File
        $display("--- ATTEMPTING TO EXTRACT DATA ---");
        file = $fopen("clean_filtered_ppg.txt", "w");
        
        if (file == 0) begin
            $display("ERROR: Simulator failed to create the text file!");
        end else begin
            start_idx = uut.reg_file.registers[12] / 4;
            num_samples = start_idx;
            $display("Extracting %0d samples starting at word index %0d (x12 = %0d)...", num_samples, start_idx, uut.reg_file.registers[12]);
            for (i = start_idx; i < start_idx + num_samples; i = i + 1) begin
                $fdisplay(file, "%h", uut.data_mem.D_memory[i]); 
            end
            $fclose(file);
            $display("SUCCESS: Hex data successfully saved to clean_filtered_ppg.txt!");
        end

        // 5. Stop the simulation
        $finish;
    end

endmodule