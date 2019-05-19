/*
Control_Path is a simple combinational logic with limited inputs, go through every posibility and check the output
*/

`include "Opcode.vh"

`timescale 1ns/100ps

`define CLK_PERIOD                 10
`define XLEN                       32
`define REG_FILE_ADDR_WIDTH        5

module Control_Path_testbench();
    // Generate 100 Mhz clock
    reg clk = 0;
    always #(`CLK_PERIOD/2) clk = ~clk;

    wire [6:0] Opcode;
    wire [2:0] funct3;
    wire Inst_bit30;
    wire Reg_Write;
    wire Inst_or_rs2;
    wire [1:0] Extend_Sel;
    wire [1:0] OpA_Sel;
    wire [4:0] shamt;
    wire WB_Sel;
    wire PCSel_bit0;
    wire branch;
    wire [4:0] ALU_Ctl;

    reg[10:0] combined_input;
    wire[18:0] combined_output;

    Control_Path DUT(
        .Opcode(Opcode),
        .funct3(funct3),
        .Inst_bit30(Inst_bit30),
        .Reg_Write(Reg_Write),
        .Inst_or_rs2(Inst_or_rs2),
        .Extend_Sel(Extend_Sel),
        .OpA_Sel(OpA_Sel),
        .shamt(shamt),
        .WB_Sel(WB_Sel),
        .PCSel_bit0(PCSel_bit0),
        .branch(branch),
        .ALU_Ctl(ALU_Ctl)
    );
    initial begin
    	clk=0;
    	combined_input=0;
    end

    always @(posedge clk) begin
    	combined_input<=combined_input+1;
    end
    always @(*) begin
    	if (combined_input<=11'b 1111_1111_111) begin
    		case(combined_input)
    			{`OPC_LUI,3'bx,1'bx}: begin
    				if (combined_output!=19'b01000_1_0_10_10_01100_00_0_0_0) begin
    					$display("LUI fail");
    				end
    			end
				{`OPC_AUIPC, 3'bxxx, 1'bx}: begin
					if(combined_output!=19'b01000_1_0_10_01_01100_00_0_0_0) begin
						$display("AUIPC fail");
					end
				end
				{`OPC_JAL, 3'bxxx, 1'bx}: begin
					if(combined_output!=19'b00000_1_0_11_01_00000_10_1_0_0) begin
						$display("JAL fail");
					end
				end
				{`OPC_JALR, 3'b000, 1'bx}: begin
					if(combined_output!=19'b00000_1_0_00_00_00000_10_1_0_0) begin
						$display("JALR fail");
					end
				end
				{`OPC_BEQ, 3'b000, 1'bx}: begin
					if(combined_output!=19'b00000_0_1_xx_00_00000_xx_0_0_1) begin
						$display("BEQ fail");
					end
				end
				{`OPC_BNE, 3'b001, 1'bx}: begin
					if(combined_output!=19'b00000_0_1_xx_00_00000_xx_0_0_1) begin
						$display("BNE fail");
					end
				end
				{`OPC_BLT, 3'b100, 1'bx}: begin
					if(combined_output!=19'b00000_0_1_xx_00_00000_xx_0_0_1) begin
						$display("BLT fail");
					end
				end
				{`OPC_BGE, 3'b101, 1'bx}: begin
					if(combined_output!=19'b00000_0_1_xx_00_00000_xx_0_0_1) begin
						$display("BGE fail");
					end
				end
				{`OPC_BLTU, 3'b110, 1'bx}: begin
					if(combined_output!=19'b00000_0_1_xx_00_00000_xx_0_0_1) begin
						$display("BLTU fail");
					end
				end
				{`OPC_BGEU, 3'b111, 1'bx}: begin
					if(combined_output!=19'b00000_0_1_xx_00_00000_xx_0_0_1) begin
						$display("BGEU fail");
					end
				end
				{`OPC_LB, 3'b000, 1'bx}: begin
					if(combined_output!=19'b01000_1_0_00_00_00010_01_0_0_0) begin
						$display("LB fail");
					end
				end
				{`OPC_LH, 3'b001, 1'bx}: begin
					if(combined_output!=19'b01000_1_0_00_00_00010_01_0_0_0) begin
						$display("LH fail");
					end
				end
				{`OPC_LW, 3'b010, 1'bx}: begin
					if(combined_output!=19'b01000_1_0_00_00_00010_01_0_0_0) begin
						$display("LW fail");
					end
				end
				{`OPC_LBU, 3'b100, 1'bx}: begin
					if(combined_output!=19'b01000_1_0_00_00_00010_01_0_0_0) begin
						$display("LBU fail");
					end
				end
				{`OPC_LHU, 3'b101, 1'bx}: begin
					if(combined_output!=19'b01000_1_0_00_00_00010_01_0_0_0) begin
						$display("LHU fail");
					end
				end
				{`OPC_SB, 3'b000, 1'bx}: begin
					if(combined_output!=19'b01000_0_0_01_00_00010_xx_0_0_0) begin
						$display("SB fail");
					end
				end
				{`OPC_SH, 3'b001, 1'bx}: begin
					if(combined_output!=19'b01000_0_0_01_00_00010_xx_0_0_0) begin
						$display("SH fail");
					end
				end
				{`OPC_SW, 3'b010, 1'bx}: begin
					if(combined_output!=19'b01000_0_0_01_00_00010_xx_0_0_0) begin
						$display("SW fail");
					end
				end
				{`OPC_ADDI, 3'b000, 1'bx}: begin
					if(combined_output!=19'b00000_1_0_00_00_00000_00_0_1_0) begin
						$display("ADDI fail");
					end
				end
				{`OPC_SLTI, 3'b010, 1'bx}: begin
					if(combined_output!=19'b11001_1_0_00_00_00000_00_0_1_0) begin
						$display("SLTI fail");
					end
				end
				{`OPC_SLTIU, 3'b011, 1'bx}: begin
					if(combined_output!=19'b00001_1_0_00_00_00000_00_0_1_0) begin
						$display("SLTIU fail");
					end
				end
				{`OPC_XORI, 3'b100, 1'bx}: begin
					if(combined_output!=19'b00100_1_0_00_00_00000_00_0_1_0) begin
						$display("XORI fail");
					end
				end
				{`OPC_ORI, 3'b110, 1'bx}: begin
					if(combined_output!=19'b00011_1_0_00_00_00000_00_0_1_0) begin
						$display("ORI fail");
					end
				end
				{`OPC_ANDI, 3'b111, 1'bx}: begin
					if(combined_output!=19'b00010_1_0_00_00_00000_00_0_1_0) begin
						$display("ANDI fail");
					end
				end
				{`OPC_SLLI, 3'b001, 1'bx}: begin
					if(combined_output!=19'b00101_1_0_00_00_00000_00_0_1_0) begin
						$display("OPC_SLLI fail");
					end
				end
				{`OPC_SRLI, 3'b101, 1'b0}: begin
					if(combined_output!=19'b00110_1_0_00_00_00000_00_0_1_0) begin
						$display("OPC_SRLI fail");
					end
				end
				{`OPC_SRAI, 3'b101, 1'b1}: begin
					if(combined_output!=19'b00110_1_0_00_00_00000_00_0_1_0) begin
						$display("OPC_SRAI fail");
					end
				end
				{`OPC_ADD, 3'b000, 1'b0}: begin
					if(combined_output!=19'b00000_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_ADD fail");
					end
				end
				{`OPC_SUB, 3'b000, 1'b1}: begin
					if(combined_output!=19'b11000_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_SUB fail");
					end
				end
				{`OPC_SLL, 3'b001, 1'bx}: begin
					if(combined_output!=19'b00101_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_SLL fail");
					end
				end
				{`OPC_SLT, 3'b010, 1'bx}: begin
					if(combined_output!=19'b11001_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_SLT fail");
					end
				end
				{`OPC_SLTU, 3'b011, 1'bx}: begin
					if(combined_output!=19'b00001_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_SLTU fail");
					end
				end
				{`OPC_XOR, 3'b100, 1'bx}: begin
					if(combined_output!=19'b00100_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_XOR fail");
					end
				end
				{`OPC_SRL, 3'b101, 1'b0}: begin
					if(combined_output!=19'b00110_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_SRL fail");
					end
				end
				{`OPC_SRA, 3'b101, 1'b1}: begin
					if(combined_output!=19'b00110_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_SRA fail");
					end
				end
				{`OPC_OR, 3'b110, 1'bx}: begin
					if(combined_output!=19'b00011_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_OR fail");
					end
				end
				{`OPC_AND, 3'b111, 1'bx}: begin
					if(combined_output!=19'b00010_1_1_xx_00_00000_00_0_1_0) begin
						$display("OPC_AND fail");
					end
				end
				default: begin
					#1;
				end
			endcase
    	end
    	else begin
    		$finish();
    	end
    end

    assign {Oppcode,funct3,Inst_bit30}=combined_input;
    assign {ALU_Ctl,Reg_Write,Inst_or_rs2,Extend_Sel,OpA_Sel,shamt,WB_Sel,PCSel_bit0,branch}=combined_output;
endmodule