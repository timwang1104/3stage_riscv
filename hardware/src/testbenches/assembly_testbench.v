`timescale 1ns/10ps

/* MODIFY THIS LINE WITH THE HIERARCHICAL PATH TO YOUR REGFILE ARRAY INDEXED WITH reg_number */
`define REGFILE_ARRAY_PATH CPU.m_data_path.m_reg_file.reg_array[reg_number]
`define DMEM_ARRAY_PATH CPU.m_dmem_sim.data_mem[mem_number]


module assembly_testbench();
    reg clk, rst;
    parameter CPU_CLOCK_PERIOD = 20;
    parameter CPU_CLOCK_FREQ = 50_000_000;

    initial clk = 0;
    always #(CPU_CLOCK_PERIOD/2) clk <= ~clk;

    Riscv151 # (
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) CPU(
        .clk(clk),
        .rst(rst),
        .FPGA_SERIAL_RX(),
        .FPGA_SERIAL_TX()
    );

    // A task to check if the value contained in a register equals an expected value
    task check_reg;
        input [4:0] reg_number;
        input [31:0] expected_value;
        input [10:0] test_num;
        if (expected_value !== `REGFILE_ARRAY_PATH) begin
            $display("FAIL - test %d, got: %h, expected: %h for reg %d", test_num, `REGFILE_ARRAY_PATH, expected_value, reg_number);
            $finish();
        end
        else begin
            $display("PASS - test %d, got: %h for reg %h", test_num, expected_value, reg_number);
        end
    endtask

    // A task to check if the mem data is successfully loaded into target register
    task check_mem;
    input [10:0] test_num;
    input [13:0] mem_number;
    input [4:0] reg_number;
    input [31:0] bitmask;
    input [5:0] shiftvalue;
    input signed_flag;
    
    reg [31:0] mem_target;
    reg [31:0] exp_data;

    begin
        mem_target=(`DMEM_ARRAY_PATH&bitmask)>>shiftvalue;

        if(signed_flag==0) begin
            exp_data=mem_target;
        end
        else begin
            $display("signed bit %d",mem_target[7]);
            exp_data={{24{mem_target[7]}},mem_target[7:0]};
            // exp_data={{24{mem_target[7]}},mem_target};
        end
        
        if (exp_data !== `REGFILE_ARRAY_PATH) begin
            $display("FAIL - test %d, mem: %h, got: %h, expected: %h for reg %d", test_num,`DMEM_ARRAY_PATH , `REGFILE_ARRAY_PATH, exp_data, reg_number);
            // $finish();
        end
        else begin
            $display("PASS - test %d, mem: %h, got: %h, expected: %h for reg %d", test_num,`DMEM_ARRAY_PATH,  `REGFILE_ARRAY_PATH, exp_data, reg_number);
        end
        
    end
    endtask

    // A task that runs the simulation until a register contains some value
    task wait_for_reg_to_equal;
        input [4:0] reg_number;
        input [31:0] expected_value;
        while (`REGFILE_ARRAY_PATH !== expected_value) @(posedge clk);
    endtask

    task check_lbu_lb;
    input signed_flag;
    begin
        check_mem(2, 0, 10, 32'h0000_00ff, 0, signed_flag);
        check_mem(2, 0, 11, 32'h0000_ff00, 8, signed_flag);
        check_mem(2, 0, 12, 32'h00ff_0000, 16,signed_flag);
        check_mem(2, 0, 13, 32'hff00_0000, 24,signed_flag);
        check_mem(2, 1, 14, 32'h0000_00ff, 0, signed_flag);
        check_mem(2, 1, 15, 32'h0000_ff00, 8, signed_flag);
        check_mem(2, 1, 16, 32'h00ff_0000, 16,signed_flag);
        check_mem(2, 1, 17, 32'hff00_0000, 24,signed_flag);
    end
    endtask

    task check_lhu_lh;
    input signed_flag;
    begin
        check_mem(2, 0, 10, 32'h0000_ffff, 0, signed_flag);
        check_mem(2, 0, 11, 32'h00ff_ff00, 8, signed_flag);
        check_mem(2, 0, 12, 32'hffff_0000, 16,signed_flag);
        check_mem(2, 0, 13, 32'hff00_0000, 24,signed_flag);
        check_mem(2, 1, 14, 32'h0000_ffff, 0, signed_flag);
        check_mem(2, 1, 15, 32'h00ff_ff00, 8, signed_flag);
        check_mem(2, 1, 16, 32'hffff_0000, 16,signed_flag);
        check_mem(2, 1, 17, 32'hff00_0000, 24,signed_flag);
    end
    endtask

    initial begin
        rst = 0;

        // Reset the CPU
        rst = 1;
        repeat (4) @(posedge clk);             // Hold reset for 10 cycles
        rst = 0;

        // Your processor should begin executing the code in /software/assembly_tests/start.s
        wait_for_reg_to_equal(20, 32'd1);


        // Test ADD
        // wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
        // check_reg(1, 32'd300, 1);               // Verify that x1 contains 300
        
        // Test LBU,LB
        // check_lbu_lb(1);

        // Test LHU,LH
        // check_lhu_lh(0);

        // Test SW
        check_reg(11,32'h1234_5678,3); 

        // Test BEQ
        // wait_for_reg_to_equal(20, 32'd2);       // Run the simulation until the flag is set to 2
        // check_reg(1, 32'd500, 2);               // Verify that x1 contains 500
        // check_reg(2, 32'd100, 3);               // Verify that x2 contains 100

        $strobe("ALL ASSEMBLY TESTS PASSED");
        $finish();
    end
endmodule
