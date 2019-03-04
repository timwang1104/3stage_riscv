`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Opcode.vh"
module control_path
(
    input [6:0] Opcode,
    input [2:0] funct3,
    input Inst_bit30,
    output Reg_Write,
    output Inst_or_rs2,
    output [1:0] Extend_Sel,
    output [1:0] OpA_Sel,
    output [4:0] shamt,
    output WB_Sel,
    output PCSel_bit0,
    output branch,
    output [4:0] ALU_Ctl
);

	reg ALU_Op_reg; 
    reg Reg_Write_reg;
    reg Inst_or_rs2_reg;
    reg [1:0] Extend_Sel_reg;
    reg [1:0] OpA_Sel_reg;
    reg [4:0] shamt_reg;
    reg WB_Sel_reg;
    reg PCSel_bit0_reg;
    reg branch_reg;
    reg [4:0] ALU_Ctl_reg;

	assign Reg_Write=Reg_Write_reg;
	assign Inst_or_rs2=Inst_or_rs2_reg;
	assign Extend_Sel=Extend_Sel_reg;
	assign OpA_Sel=OpA_Sel_reg;
	assign shamt=shamt_reg;
	assign WB_Sel=WB_Sel_reg;
	assign PCSel_bit0=PCSel_bit0_reg;
	assign branch=branch_reg;
	assign ALU_Ctl=ALU_Ctl_reg;

	always @(*) begin
		case(Opcode)
			`OPC_LUI: begin
				Reg_Write_reg=1'b1;
				Inst_or_rs2_reg=1'b0;
				Extend_Sel_reg=2'b10;
				OpA_Sel_reg=2'b10;
				shamt_reg=5'b01100;
				WB_Sel_reg=2'b00;
				PCSel_bit0_reg=1'b0;
				branch_reg=1'b0;
				ALU_Ctl_reg=`ALU_ADD_SFT;
				ALU_Op_reg=1'b0;
			end
			`OPC_AUIPC: begin
				Reg_Write_reg=1'b1;
				Inst_or_rs2_reg=1'b0;
				Extend_Sel_reg=2'b10;
				OpA_Sel_reg=2'b01;
				shamt_reg=5'b01100;
				WB_Sel_reg=2'b00;
				PCSel_bit0_reg=1'b0;
				branch_reg=1'b0;
				ALU_Ctl_reg=`ALU_ADD_SFT;
				ALU_Op_reg=1'b0;
			end
			`OPC_JAL: begin
				Reg_Write_reg=1'b1;
				Inst_or_rs2_reg=1'b0;
				Extend_Sel_reg=2'b11;
				OpA_Sel_reg=2'b01;
				shamt_reg=5'b00000;
				WB_Sel_reg=2'b10;
				PCSel_bit0_reg=1'b1;
				branch_reg=1'b0;
				ALU_Ctl_reg=`ALU_ADD;
				ALU_Op_reg=1'b0;
			end
			`OPC_JALR: begin
				Reg_Write_reg=1'b1;
				Inst_or_rs2_reg=1'b0;
				Extend_Sel_reg=2'b00;
				OpA_Sel_reg=2'b00;
				shamt_reg=5'b00000;
				WB_Sel_reg=2'b10;
				PCSel_bit0_reg=1'b1;
				branch_reg=1'b0;
				ALU_Ctl_reg=`ALU_ADD;
				ALU_Op_reg=1'b0;			
			end
			`OPC_BRANCH: begin
				Reg_Write_reg=1'b0;
				Inst_or_rs2_reg=1'b0;
				Extend_Sel_reg=2'b00;
				OpA_Sel_reg=2'b00;
				shamt_reg=5'b00000;
				WB_Sel_reg=2'b00;
				PCSel_bit0_reg=1'b0;
				branch_reg=1'b1;
				ALU_Ctl_reg=`ALU_ADD;
				ALU_Op_reg=1'b0;
			end
			`OPC_STORE: begin
				Reg_Write_reg=1'b0;
				Inst_or_rs2_reg=1'b0;
				Extend_Sel_reg=2'b01;
				OpA_Sel_reg=2'b00;
				shamt_reg=5'b00010;
				WB_Sel_reg=2'b00;
				PCSel_bit0_reg=1'b0;
				branch_reg=1'b0;
				ALU_Ctl_reg=`ALU_ADD_SFT;
				ALU_Op_reg=1'b0;
			end
			`OPC_LOAD: begin
				Reg_Write_reg=1'b1;
				Inst_or_rs2_reg=1'b0;
				Extend_Sel_reg=2'b00;
				OpA_Sel_reg=2'b00;
				shamt_reg=5'b00010;
				WB_Sel_reg=2'b01;
				PCSel_bit0_reg=1'b0;
				branch_reg=1'b0;
				ALU_Ctl_reg=`ALU_ADD_SFT;
				ALU_Op_reg=1'b0;
			end
			`OPC_ARI_RTYPE: begin
				Reg_Write_reg=1'b1;
				Inst_or_rs2_reg=1'b1;
				Extend_Sel_reg=2'b00;
				OpA_Sel_reg=2'b00;
				shamt_reg=5'b00000;
				WB_Sel_reg=2'b00;
				PCSel_bit0_reg=1'b0;
				branch_reg=1'b0;
				ALU_Op_reg=1'b1;
			end
			`OPC_ARI_ITYPE: begin
				Reg_Write_reg=1'b1;
				Inst_or_rs2_reg=1'b0;
				Extend_Sel_reg=2'b00;
				OpA_Sel_reg=2'b00;
				shamt_reg=5'b00000;
				WB_Sel_reg=2'b00;
				PCSel_bit0_reg=1'b0;
				branch_reg=1'b0;
				ALU_Op_reg=1'b1;
			end
			default: begin
				Reg_Write_reg=1'b0;
				Inst_or_rs2_reg=1'b0;
				Extend_Sel_reg=2'b00;
				OpA_Sel_reg=2'b00;
				shamt_reg=5'b00000;
				WB_Sel_reg=2'b00;
				PCSel_bit0_reg=1'b0;
				branch_reg=1'b0;
				ALU_Ctl_reg=`ALU_ADD;
				ALU_Op_reg=1'b0;
			end		
		endcase
	
		if(ALU_Op_reg) begin
			case(funct3)
				`FNC_ADD_SUB: begin
					if((Inst_bit30==`FNC2_SUB) && (Opcode==`OPC_ARI_RTYPE)) begin
						ALU_Ctl_reg=`ALU_SUB;
					end
					else begin
						ALU_Ctl_reg=`ALU_ADD;
					end
				end
				`FNC_SLL: begin
					ALU_Ctl_reg=`ALU_SLL;
				end
				`FNC_SLT: begin
					ALU_Ctl_reg=`ALU_SLT;
				end
				`FNC_SLTU: begin
					ALU_Ctl_reg=`ALU_SLTU;
				end
				`FNC_XOR: begin
					ALU_Ctl_reg=`ALU_XOR;
				end
				`FNC_SRL_SRA: begin
					ALU_Ctl_reg=`ALU_SRL_SRA;
				end
				`FNC_OR: begin
					ALU_Ctl_reg=`ALU_OR;
				end
				`FNC_AND: begin
					ALU_Ctl_reg=`ALU_AND;
				end
				default: begin
					ALU_Ctl_reg=`ALU_ADD;
				end
			endcase
		end
	end

endmodule