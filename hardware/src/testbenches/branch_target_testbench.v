/*branch_target is a simple logic, check all the branch conditions, notice signed and unsigned numbers
*/
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Opcode.vh"
`timescale 1ns/100ps

`define CLK_PERIOD                 10
`define XLEN                       32

module branch_target_testbench();
    // Generate 100 Mhz clock
    reg clk = 0;
    always #(`CLK_PERIOD/2) clk = ~clk;

	reg  [`XLEN-1:0] BImm;
	reg  [`XLEN-1:0] PC;
	reg  [`XLEN-1:0] rs1;
	reg  [`XLEN-1:0] rs2;
	reg  [2:0]       funct3;
	reg              branch;
	wire [`XLEN-1:0] BTarg;
	wire             PCSel_bit1;

    branch_target DUT(
		.BImm(BImm),
		.PC(PC),
		.rs1(rs1),
		.rs2(rs2),
		.funct3(funct3),
		.branch(branch),
		.BTarg(BTarg),
		.PCSel_bit1(PCSel_bit1)
    );

    initial begin
    	clk=0;
    	@(posedge clk);
    	BImm=32'd0;
    	PC=32'd0;
    	branch=1'b0;
        rs1=32'd0;
        rs2=32'd0;
        funct3=3'b0;
        @(posedge clk);
        beq_bne_test;
        blt_bge_test;
        bltu_bgeu_test;
    end

    task beq_bne_test;
    	fork
    		begin
    			BImm=32'd4;
                PC=32'd8;
                branch=1'b1;
    			repeat(8) @(posedge clk);
    			branch=1'b0;
    			repeat(8) @(posedge clk);
    		end
    		begin
    			//check BEQ function
                funct3=`FNC_BEQ;
                rs1=32'd1;
                rs2=32'd1;
                #1;
                if(PCSel_bit1!=1) begin
                    $display("BEQ ture fail %d", $time);
                end
                repeat(2) @(posedge clk);
                rs1=32'd2;
                rs2=32'd3;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("BEQ false fail %d", $time);
                end
                repeat(2) @(posedge clk);
                //check BNE function
                funct3=`FNC_BNE;
                rs1=32'd2;
                rs2=32'd3;
                #1;
                if(PCSel_bit1!=1) begin
                    $display("BNE ture fail %d", $time);
                end                
                repeat(2) @(posedge clk);
                rs1=32'd1;
                rs2=32'd1;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("BNE false fail %d", $time);
                end                                
                repeat(2) @(posedge clk);
                //check branch=0 function
                funct3=`FNC_BEQ;
                rs1=32'd1;
                rs2=32'd1;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end
                repeat(2) @(posedge clk);
                rs1=32'd2;
                rs2=32'd3;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end
                repeat(2) @(posedge clk);
                funct3=`FNC_BNE;
                rs1=32'd2;
                rs2=32'd3;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end                
                repeat(2) @(posedge clk);
                rs1=32'd1;
                rs2=32'd1;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end                                
                repeat(2) @(posedge clk);
            end
            begin
                if(BTarg!= BImm+PC) begin
                    $display("branch target calculate fail %d", $time);
                end
            end
    	join
    endtask

    task blt_bge_test; //signed numbers
        fork
            begin
                BImm=32'd4;
                PC=32'd8;
                branch=1'b1;
                repeat(8) @(posedge clk);
                branch=1'b0;
                repeat(8) @(posedge clk);
            end
            begin
                //check BLT function
                funct3=`FNC_BLT;
                rs1=32'b1000_0000_0000_0000_0000_0000_0000_0001;
                rs2=32'b0000_0000_0000_0000_0000_0000_0000_0001;
                #1;
                if(PCSel_bit1!=1) begin
                    $display("BLT ture fail %d", $time);
                end
                repeat(2) @(posedge clk);
                rs1=32'd2;
                rs2=32'd1;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("BLT false fail %d", $time);
                end
                repeat(2) @(posedge clk);
                //check BGE function
                funct3=`FNC_BGE;
                rs1=32'd2;
                rs2=32'd1;
                #1;
                if(PCSel_bit1!=1) begin
                    $display("BGE ture fail %d", $time);
                end                
                repeat(2) @(posedge clk);
                rs1=32'b1000_0000_0000_0000_0000_0000_0000_0001;
                rs2=32'b0000_0000_0000_0000_0000_0000_0000_0001;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("BGE false fail %d", $time);
                end                                
                repeat(2) @(posedge clk);
                //check branch=0 function
                funct3=`FNC_BLT;
                rs1=32'b1000_0000_0000_0000_0000_0000_0000_0001;
                rs2=32'b0000_0000_0000_0000_0000_0000_0000_0001;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end
                repeat(2) @(posedge clk);
                rs1=32'd2;
                rs2=32'd3;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end
                repeat(2) @(posedge clk);
                funct3=`FNC_BGE;
                rs1=32'd4;
                rs2=32'd3;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end                
                repeat(2) @(posedge clk);
                rs1=32'd1;
                rs2=32'd0;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end                                
                repeat(2) @(posedge clk);
            end
            begin
                if(BTarg!= BImm+PC) begin
                    $display("branch target calculate fail %d", $time);
                end
            end            
        join
    endtask

    task bltu_bgeu_test; //unsigned numbers
        fork
            begin
                BImm=32'd4;
                PC=32'd8;
                branch=1'b1;
                repeat(8) @(posedge clk);
                branch=1'b0;
                repeat(8) @(posedge clk);
            end
            begin
                //check BLT function
                funct3=`FNC_BLTU;
                rs1=32'b0000_0000_0000_0000_0000_0000_0000_0001;
                rs2=32'b1000_0000_0000_0000_0000_0000_0000_0001;
                #1;
                if(PCSel_bit1!=1) begin
                    $display("BLTU ture fail %d", $time);
                end
                repeat(2) @(posedge clk);
                rs1=32'd2;
                rs2=32'd1;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("BLTU false fail %d", $time);
                end
                repeat(2) @(posedge clk);
                //check BGE function
                funct3=`FNC_BGEU;
                rs1=32'b1000_0000_0000_0000_0000_0000_0000_0001;
                rs2=32'b0000_0000_0000_0000_0000_0000_0000_0001;
                #1;
                if(PCSel_bit1!=1) begin
                    $display("BGEU ture fail %d", $time);
                end                
                repeat(2) @(posedge clk);
                rs1=32'b0000_0000_0000_0000_0000_0000_0000_0001;
                rs2=32'b1000_0000_0000_0000_0000_0000_0000_0001;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("BGEU false fail %d", $time);
                end                                
                repeat(2) @(posedge clk);
                //check branch=0 function
                funct3=`FNC_BLTU;
                rs1=32'b0000_0000_0000_0000_0000_0000_0000_0001;
                rs2=32'b1000_0000_0000_0000_0000_0000_0000_0001;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end
                repeat(2) @(posedge clk);
                rs1=32'd2;
                rs2=32'd3;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end
                repeat(2) @(posedge clk);
                funct3=`FNC_BGEU;
                rs1=32'd4;
                rs2=32'd3;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end                
                repeat(2) @(posedge clk);
                rs1=32'd1;
                rs2=32'd0;
                #1;
                if(PCSel_bit1!=0) begin
                    $display("branch disable fail %d", $time);
                end                                
                repeat(2) @(posedge clk);
            end
            begin
                repeat(2) @(posedge clk);
                #1;
                if(BTarg!= BImm+PC) begin
                    $display("branch target calculate fail %d", $time);
                end
            end            
        join
    endtask
endmodule