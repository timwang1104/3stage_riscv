`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"
module stage_fetch
(
	input clk,
	input rst,
	input stallF,
	input [`XLEN-1:0]  jump_result,
	input [`XLEN-1:0]  branch_result,
	input [1:0]        pc_sel,
	output [`XLEN-1:0] pc_plus_4F
);

	reg [`XLEN-1:0] pc_plus_4F_reg;

	always @(*) begin
		case(pc_sel)
			2'b00: begin
				fetch_pc=pc_plus_4F_reg+4;
			end
			2'b01: begin
				fetch_pc=jump_result;
			end
			2'b10: begin
				fetch_pc=branch_result;
			end
			default: begin
				fetch_pc=fetch_pc;
			end
		endcase
	end


	always @(posedge clk) begin
		if (rst) begin
			fetch_pc<=32'h4000_0000;			
		end
		else begin
			if(stallF) begin
				pc_plus_4F_reg<=pc_plus_4F_reg;
			end
			else begin
				pc_plus_4F_reg<=fetch_pc;
			end
		end
	end

	assign pc_plus_4F<=pc_plus_4F_reg;

endmodule