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
        input [10:0] test_num;
        input [4:0] reg_number;
        input [31:0] expected_value;
        if (expected_value !== `REGFILE_ARRAY_PATH) begin
            $display("FAIL - test %d, got: %h, expected: %h for reg %d", test_num, `REGFILE_ARRAY_PATH, expected_value, reg_number);
            // $finish();
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
        input [4:0] shiftvalue;
        input signed_flag;
        input [4:0] extend_bits;
        
        reg [31:0] mem_target;
        reg [31:0] exp_data;

        begin
            mem_target=(`DMEM_ARRAY_PATH&bitmask)>>shiftvalue;
    
            if(signed_flag==0) begin
                exp_data=mem_target;
            end
            else begin
                if(extend_bits==24) begin
                    exp_data={{24{mem_target[7]}},mem_target[7:0]};
                end
                else if(extend_bits==16) begin
                    exp_data={{16{mem_target[15]}},mem_target[15:0]};
                end
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

    task check_mem_store;
        input [10:0] test_num;
        input [13:0] mem_number;
        input [4:0] reg_number;
        input [31:0] store_data;
        input [31:0] bitmask;

        reg [31:0] exp_data;
        begin
            exp_data=(`REGFILE_ARRAY_PATH&(~bitmask))|(store_data&bitmask);
            
            if(exp_data!=`DMEM_ARRAY_PATH) begin
                $display("FAIL - test %d, store %h reg:%d mem_pre: %h, mem_pst: %h, expected: %h", test_num, store_data, reg_number,`REGFILE_ARRAY_PATH, `DMEM_ARRAY_PATH, exp_data);
            end
            else begin
                $display("PASS - test %d, reg:%d mem_pre: %h, mem_pst: %h, expected: %h", test_num, reg_number,`REGFILE_ARRAY_PATH, `DMEM_ARRAY_PATH, exp_data);
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
        input [10:0] test_num;
        input signed_flag;
        begin
            check_mem(test_num, 0, 10, 32'h0000_00ff, 0, signed_flag, 24);
            check_mem(test_num, 0, 11, 32'h0000_ff00, 8, signed_flag, 24);
            check_mem(test_num, 0, 12, 32'h00ff_0000, 16,signed_flag, 24);
            check_mem(test_num, 0, 13, 32'hff00_0000, 24,signed_flag, 24);
            check_mem(test_num, 1, 14, 32'h0000_00ff, 0, signed_flag, 24);
            check_mem(test_num, 1, 15, 32'h0000_ff00, 8, signed_flag, 24);
            check_mem(test_num, 1, 16, 32'h00ff_0000, 16,signed_flag, 24);
            check_mem(test_num, 1, 17, 32'hff00_0000, 24,signed_flag, 24);
        end
    endtask

    task check_lhu_lh;
        input [10:0] test_num;
        input signed_flag;
        begin
            check_mem(test_num, 0, 10, 32'h0000_ffff, 0, signed_flag, 16);
            check_mem(test_num, 0, 11, 32'h00ff_ff00, 8, signed_flag, 16);
            check_mem(test_num, 0, 12, 32'hffff_0000, 16,signed_flag, 16);
            check_mem(test_num, 0, 13, 32'h0000_0000, 24,signed_flag, 16);  //unaligned data
            check_mem(test_num, 1, 14, 32'h0000_ffff, 0, signed_flag, 16);
            check_mem(test_num, 1, 15, 32'h00ff_ff00, 8, signed_flag, 16);
            check_mem(test_num, 1, 16, 32'hffff_0000, 16,signed_flag, 16);
            check_mem(test_num, 1, 17, 32'h0000_0000, 24,signed_flag, 16);  //unaligned data
        end
    endtask

    task check_sh;
        input [10:0] test_num;
        begin
            check_mem_store(test_num,1,12, 32'h1122_3344, 32'h0000_ffff);
            check_mem_store(test_num,2,13, 32'h1122_3344, 32'h00ff_ff00);
            check_mem_store(test_num,3,14, 32'h1122_3344, 32'hffff_0000);
            check_mem_store(test_num,4,15, 32'h1122_3344, 32'h0000_0000);
        end
    endtask

    task check_sb;
        input [10:0] test_num;
        begin
            check_mem_store(test_num,6,12, 32'haabb_ccdd, 32'h0000_00ff);
            check_mem_store(test_num,7,13, 32'haabb_ccdd, 32'h0000_ff00);
            check_mem_store(test_num,8,14, 32'haabb_ccdd, 32'h00ff_0000);
            check_mem_store(test_num,9,15, 32'haabb_ccdd, 32'hff00_0000);
        end
    endtask



    initial begin
        rst = 0;

        // Reset the CPU
        rst = 1;
        repeat (4) @(posedge clk);             // Hold reset for 10 cycles
        rst = 0;
        $display("tb %d LBU test", 1);
        wait_for_reg_to_equal(20, 32'd1);
        check_lbu_lb(1,0);

        $display("tb %d LB test", 2);
        wait_for_reg_to_equal(20, 32'd2);
        check_lbu_lb(2,1);

        $display("tb %d LHU test", 3);
        wait_for_reg_to_equal(20, 32'd3);
        check_lhu_lh(3,0);

        $display("tb %d LH test", 4);
        wait_for_reg_to_equal(20, 32'd4);
        check_lhu_lh(4,1);

        $display("tb %d SW test", 5);
        wait_for_reg_to_equal(20, 32'd5);
        check_reg(5,11,32'h1122_3344); 

        $display("tb %d SH test", 6);
        wait_for_reg_to_equal(20, 32'd6);
        check_sh(6);
 
        $display("tb %d SB test", 7);
        wait_for_reg_to_equal(20, 32'd7);
        check_sb(7);


        $display("tb %d AUIPC test", 8);
        wait_for_reg_to_equal(20, 32'd8);
        check_reg(8,10,32'h5000_00f8);

        $display("tb %d ADDI test", 9);
        wait_for_reg_to_equal(20, 32'd9);
        check_reg(9,11,32'h0000_0003);

        $display("tb %d SLTIU test", 10);
        wait_for_reg_to_equal(20, 32'd10);
        check_reg(10,11,32'h0000_0001);

        // Test ADD
        // wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
        // check_reg(1, 32'd300, 1);               // Verify that x1 contains 300
        
        // Test LBU,LB
        // check_lbu_lb(1);

        // Test LHU,LH
        // check_lhu_lh(0);

        // Test SW

        // Test BEQ
        // wait_for_reg_to_equal(20, 32'd2);       // Run the simulation until the flag is set to 2
        // check_reg(1, 32'd500, 2);               // Verify that x1 contains 500
        // check_reg(2, 32'd100, 3);               // Verify that x2 contains 100

        $display("ALL ASSEMBLY TESTS PASSED");
        // $finish();
    end
endmodule
