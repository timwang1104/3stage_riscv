`include "defines.v"

module stage_execute
(

	input [1:0]        forward1E,
	input [1:0]        forward2E,
	input [`XLEN-1:0]  wb_resultW,
	input [`XLEN-1:0]  alu_outM,

	input [`XLEN-1:0]  pc_plus4E,
	input [`XLEN-1:0]  forward_rs1E,
	input [`XLEN-1:0]  forward_rs2E,
 
	input [`XLEN-1:0]  immE,
	input [6:0]        funct7E,
 
	input [4:0]        alu_ctlE,
	input [1:0]        op_a_selE,
	input              op_b_selE,

	output [`XLEN-1:0] rs2E,
	output [`XLEN-1:0] alu_outE
);

	reg [`XLEN-1:0] rs1E_reg;
	reg [`XLEN-1:0] rs2E_reg;

	reg [`XLEN-1:0] alu_op_a;
	reg [`XLEN-1:0] alu_op_b;

	always @(*) begin
		case(forward1E)
			2'b00: begin
				rs1E_reg=forward_rs1E;
			end
			2'b01: begin
				rs1E_reg=wb_resultW;
			end
			2'b10: begin
				rs1E_reg=alu_outM;
			end
			default: begin
				rs1E_reg=32'd0;
			end
		endcase

		case(forward2E)
			2'b00: begin
				rs2E_reg=forward_rs2E;
			end
			2'b01: begin
				rs2E_reg=wb_resultW;
			end
			2'b10: begin
				rs2E_reg=alu_outM;
			end
			default: begin
				rs2E_reg=32'd0;
			end
		endcase

		case(op_a_selE)
			2'b00: begin
				alu_op_a=rs1E_reg;
			end
			2'b01: begin
				alu_op_a=pc_plus4E-4;
			end
			2'b10: begin
				alu_op_a=32'd0;
			end
			default: begin
				alu_op_a=32'd0;
			end
		endcase

		case(op_b_selE)
			1'b0: begin
				alu_op_b=immE;
			end
			1'b1: begin
				alu_op_b=rs2E_reg;
			end
			default: begin
				alu_op_b=32'd0;
			end
		endcase
	end

	ALU m_ALU(
		.A(alu_op_a),
		.B(alu_op_b),
		.ALU_Ctl(alu_ctlE),
		.funct7(funct7E) ,
		.ALU_Out(alu_outE)
	);

	assign rs2E=rs2E_reg;


endmodule