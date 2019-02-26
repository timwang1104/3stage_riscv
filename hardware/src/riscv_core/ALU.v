module ALU
(
	input [`XLEN-1:0] A, B;
	input [4:0] shamt;
	input [4:0] ALU_Ctl;
	output [`XLEN-1:0] ALU_Out;
	// output zero
);

always @(*) begin
	case(ALU_Ctl)
		`ALU_ADD: begin
			ALU_Out=A+B;
		end
		`ALU_SLTU: begin
			ALU_Out=(A<B)?1:0;
		end
		`ALU_AND: begin
			ALU_Out=A&B;
		end
		`ALU_OR: begin
			ALU_Out=A|B;
		end
		`ALU_XOR: begin
			ALU_Out=A^B;
		end
		`ALU_SLL: begin
			ALU_Out=A<<B;
		end
		`ALU_SRL_SRA: begin
			if(B[30]) begin
				ALU_Out=$signed(A)>>>B;				
			end
			else begin
				ALU_Out=A>>B;
			end
		end
		`ALU_ADD_SFT: begin
			ALU_Out=A+(B<<shamt);
		end
		`ALU_SUB: begin
			ALU_Out=A-B;
		end
		`ALU_SLT: begin
			ALU_SLT= $signed(A)<$signed(B)?1:0;
		end
		default: ALU_Out=0;
	endcase
end