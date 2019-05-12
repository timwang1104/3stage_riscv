`timescale 1ns/10ps

/* MODIFY THIS LINE WITH THE HIERARCHICAL PATH TO YOUR REGFILE ARRAY INDEXED WITH reg_number */
`define REGFILE_ARRAY_PATH CPU.m_riscv_core.m_stage_decode.m_reg_file.reg_array[reg_number]
`define DMEM_ARRAY_PATH CPU.m_dmem_sim.inst.native_mem_module.blk_mem_gen_v8_4_1_inst.memory[mem_number]


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
            $display("%d FAIL - test %d, got: %h, expected: %h for reg %d", $time, test_num, `REGFILE_ARRAY_PATH, expected_value, reg_number);
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
                $display("%d FAIL - test %d, mem: %h, got: %h, expected: %h for reg %d", $time, test_num,`DMEM_ARRAY_PATH , `REGFILE_ARRAY_PATH, exp_data, reg_number);
                $finish();
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
                $display("%d FAIL - test %d, store %h reg:%d mem_pre: %h, mem_pst: %h, expected: %h", $time, test_num, store_data, reg_number,`REGFILE_ARRAY_PATH, `DMEM_ARRAY_PATH, exp_data);
                $finish();
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

    task instr_test;
    begin
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

        // $display("tb %d SW test", 5);
        // wait_for_reg_to_equal(20, 32'd5);
        // check_reg(5,11,32'h1122_3344); 

        // $display("tb %d SH test", 6);
        // wait_for_reg_to_equal(20, 32'd6);
        // check_sh(6);
 
        // $display("tb %d SB test", 7);
        // wait_for_reg_to_equal(20, 32'd7);
        // check_sb(7);


        $display("tb %d AUIPC test", 8);
        wait_for_reg_to_equal(20, 32'd8);
        check_reg(8,10,32'h5000_00f8);

        $display("tb %d ADDI test", 9);
        wait_for_reg_to_equal(20, 32'd9);
        check_reg(9,11,32'h0000_0003);

        $display("tb %d SLTIU test", 10);
        wait_for_reg_to_equal(20, 32'd10);
        check_reg(10,11,32'h0000_0001);

        $display("tb %d SLTIU test", 11);
        wait_for_reg_to_equal(20, 32'd11);
        check_reg(11,11,32'h0000_0000);

        $display("tb %d XORI test", 12);
        wait_for_reg_to_equal(20, 32'd12);
        check_reg(12,11,32'hAABB_CB22);


        $display("tb %d XORI test", 13);
        wait_for_reg_to_equal(20, 32'd13);
        check_reg(13,11,32'h5544_3322);

        $display("tb %d ORI test", 14);
        wait_for_reg_to_equal(20, 32'd14);
        check_reg(14,11,32'hFFFF_FFFF);

        $display("tb %d ORI test", 15);
        wait_for_reg_to_equal(20, 32'd15);
        check_reg(15,11,32'hAABB_CCDD);

        $display("tb %d XORI test", 16);
        wait_for_reg_to_equal(20, 32'd16);
        check_reg(16,11,32'h0000_0000);

        $display("tb %d SLLI test", 17);
        wait_for_reg_to_equal(20, 32'd17);
        check_reg(17,11,32'hABBC_CDD0);

        $display("tb %d SRLI test", 18);
        wait_for_reg_to_equal(20, 32'd18);
        check_reg(18,11,32'h0AAB_BCCD);


        $display("tb %d SRAI test", 19);
        wait_for_reg_to_equal(20, 32'd19);
        check_reg(19,11,32'hFAAB_BCCD);

        $display("tb %d SRAI test", 20);
        wait_for_reg_to_equal(20, 32'd20);
        check_reg(20,11,32'h0123_4567);


        $display("tb %d ADD test", 21);
        wait_for_reg_to_equal(20, 32'd21);
        check_reg(21,11,32'h0000_0003);

        $display("tb %d SLTU test", 22);
        wait_for_reg_to_equal(20, 32'd22);
        check_reg(22,11,32'h0000_0001);

        $display("tb %d SLTU test", 23);
        wait_for_reg_to_equal(20, 32'd23);
        check_reg(23,11,32'h0000_0000);

        $display("tb %d XOR test", 24);
        wait_for_reg_to_equal(20, 32'd24);
        check_reg(24,11,32'hAABB_CB22);


        $display("tb %d XOR test", 25);
        wait_for_reg_to_equal(20, 32'd25);
        check_reg(25,11,32'h5544_3322);

        $display("tb %d OR test", 26);
        wait_for_reg_to_equal(20, 32'd26);
        check_reg(26,11,32'hFFFF_FFFF);

        $display("tb %d OR test", 27);
        wait_for_reg_to_equal(20, 32'd27);
        check_reg(27,11,32'hAABB_CCDD);

        $display("tb %d XOR test", 28);
        wait_for_reg_to_equal(20, 32'd28);
        check_reg(28,11,32'h0000_0000);

        $display("tb %d SLL test", 29);
        wait_for_reg_to_equal(20, 32'd29);
        check_reg(29,11,32'hABBC_CDD0);

        $display("tb %d SRL test", 30);
        wait_for_reg_to_equal(20, 32'd30);
        check_reg(30,11,32'h0AAB_BCCD);


        $display("tb %d SRA test", 31);
        wait_for_reg_to_equal(20, 32'd31);
        check_reg(31,11,32'hFAAB_BCCD);

        $display("tb %d SRA test", 32);
        wait_for_reg_to_equal(20, 32'd32);
        check_reg(32,11,32'h0123_4567);

        $display("tb %d SUB test", 33);
        wait_for_reg_to_equal(20, 32'd33);
        check_reg(33,11,32'h0234_5674);

        // Test BEQ
        $display("tb %d BEQ test", 34);
        wait_for_reg_to_equal(20, 32'd34);       // Run the simulation until the flag is set to 2
        check_reg(34,1, 32'h500);                // Verify that x1 contains 500
        check_reg(34,2, 32'h100);                // Verify that x2 contains 100

        $display("tb %d BNE test", 35);
        wait_for_reg_to_equal(20, 32'd35);       // Run the simulation until the flag is set to 2
        check_reg(35,2, 32'h123);                // Verify that x2 contains 123
        check_reg(35,3, 32'h500);                // Verify that x3 contains 500

        $display("tb %d BLT test", 36);
        wait_for_reg_to_equal(20, 32'd36);       // Run the simulation until the flag is set to 2
        check_reg(36,3, 32'h036);                // Verify that x2 contains 36
        check_reg(36,4, 32'h100);                // Verify that x2 contains 100

        $display("tb %d BGE test", 37);
        wait_for_reg_to_equal(20, 32'd37);       // Run the simulation until the flag is set to 2
        check_reg(37,3, 32'h037);                // Verify that x2 contains 37
        check_reg(37,4, 32'h100);                // Verify that x2 contains 100

        $display("tb %d BLTU test", 38);
        wait_for_reg_to_equal(20, 32'd38);       // Run the simulation until the flag is set to 2
        check_reg(38,3, 32'h038);                // Verify that x2 contains 38
        check_reg(38,4, 32'h038);                // Verify that x2 contains 38

        $display("tb %d BGEU test", 39);
        wait_for_reg_to_equal(20, 32'd39);       // Run the simulation until the flag is set to 2
        check_reg(39,3, 32'h39);                // Verify that x2 contains 39
        check_reg(39,4, 32'h38);                // Verify that x2 contains 38

        $display("tb %d JAL test", 40);
        wait_for_reg_to_equal(20, 32'd40);       // Run the simulation until the flag is set to 2
        check_reg(40,3, 32'h39);                // Verify that x2 contains 39
        check_reg(40,4, 32'h38);                // Verify that x2 contains 38


        $display("tb %d JALR test", 41);
        wait_for_reg_to_equal(20, 32'd41);       // Run the simulation until the flag is set to 2
        check_reg(41,3, 32'h40);                // Verify that x2 contains 39
        check_reg(41,4, 32'h40);                // Verify that x2 contains 38

        $display("tb %d Cycle Counter test", 42);
        wait_for_reg_to_equal(20, 32'd42);       // Run the simulation until the flag is set to 2
        check_reg(42,12, 32'hb2);                // Verify that x2 contains 39

        $display("tb %d Cycle Counter test", 43);
        wait_for_reg_to_equal(20, 32'd43);       // Run the simulation until the flag is set to 2
        check_reg(43,12, 32'hb5);                // Verify that x2 contains 39

    end
    endtask



    initial begin
        rst = 0;

        // Reset the CPU
        rst = 1;
        repeat (4) @(posedge clk);             // Hold reset for 10 cycles
        rst = 0;
        
        instr_test;
        wait_for_reg_to_equal(20, 32'd42);       // Run the simulation until the flag is set to 2

        $display("ALL ASSEMBLY TESTS PASSED");
        $finish();
    end
endmodule
