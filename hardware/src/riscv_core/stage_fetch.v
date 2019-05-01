`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"
module stage_fetch
(
	input    clk,
	input    rst,
	input    stallF,
	input [`XLEN-1:0]  mem_data_in,
	input [`XLEN-1:0]  jump_result,
	input [`XLEN-1:0]  branch_result,
	input [1:0]        pc_selD,
	output [`XLEN-1:0] instrF,
	output [`XLEN-1:0] pc_plus4F
);

	reg [`XLEN-1:0] pc_plus4F_reg;
	reg [`XLEN-1:0] fetch_pc;

	always @(*) begin
		case(pc_selD)
			2'b00: begin
				fetch_pc=pc_plus4F_reg+4;
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
			pc_plus4F_reg<=32'h4000_0000;		
		end
		else begin
			if(stallF) begin
				pc_plus4F_reg<=pc_plus4F_reg;
			end
			else begin
				pc_plus4F_reg<=fetch_pc;
			end
		end
	end

	assign instrF=mem_data_in;
	assign pc_plus4F=pc_plus4F_reg;

endmodule