`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Opcode.vh"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"


module jump_target
(
	input  [`XLEN-1:0] pc_plus4D,
	input  [`XLEN-1:0] Imm,
	input  [`XLEN-1:0] rs1,
	input              jop,
	output [`XLEN-1:0] JTarg
);

	reg [`XLEN-1:0] JTarg_reg;
	always @(*) begin
		case(jop)
			1'b0: begin
				JTarg_reg=(pc_plus4D-4)+Imm;
			end
			1'b1: begin
				JTarg_reg=(rs1+Imm)&(32'hffff_fffe);
			end
			default: begin
				JTarg_reg=32'd0;
			end
		endcase
	end

	assign JTarg=JTarg_reg;

endmodule
