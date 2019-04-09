`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module ALU
(
	input [`XLEN-1:0] A, B,
	input [4:0] shamt,
	input [4:0] ALU_Ctl,
	input [6:0] funct7,
	output [`XLEN-1:0] ALU_Out
	// output zero
);

	reg [`XLEN-1:0] ALU_Out_reg;

	always @(*) begin
		case(ALU_Ctl)
			`ALU_ADD: begin
				ALU_Out_reg=A+B;
			end
			`ALU_SLTU: begin
				ALU_Out_reg=(A<B)?1:0;
			end
			`ALU_AND: begin
				ALU_Out_reg=A&B;
			end
			`ALU_OR: begin
				ALU_Out_reg=A|B;
			end
			`ALU_XOR: begin
				ALU_Out_reg=A^B;
			end
			`ALU_SLL: begin
				ALU_Out_reg=A<<B;
			end
			`ALU_SRL_SRA: begin
				if(funct7[5]) begin
					ALU_Out_reg=$signed(A)>>>B;				
				end
				else begin
					ALU_Out_reg=A>>B;
				end
			end
			`ALU_ADD_SFT: begin
				ALU_Out_reg=A+(B<<shamt);
			end
			`ALU_SUB: begin
				ALU_Out_reg=A-B;
			end
			`ALU_SLT: begin
				ALU_Out_reg= $signed(A)<$signed(B)?1:0;
			end
			default: ALU_Out_reg=0;
		endcase
	end

	assign ALU_Out=ALU_Out_reg;
endmodule