module stage_wb
(
	input [`XLEN-1:0] 	jump_result_plus4W,
	input [`XLEN-1:0] 	mem_resultW,
	input [`XLEN-1:0] 	alu_outW,
	input [1:0]       	wb_selW,
	input             	reg_writeW,
	input             	rdW,

	output [`XLEN-1:0]  wb_resultW


);
	
	reg [`XLEN-1:0] wb_resultW_reg;
	
	always @(*) begin
		case(wb_selW)
			2'b00: begin
				wb_resultW_reg=alu_outW;
			end
			2'b01: begin
				wb_resultW_reg=mem_resultW;
			end
			2'b10: begin
				wb_resultW_reg=jump_result_plus4W;
			end
			default: begin
				wb_resultW_reg=32'd0;
			end
		endcase
	end

	assign wb_resultW = wb_resultW_reg;

endmodule