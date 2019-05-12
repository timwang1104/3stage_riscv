`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module reg_fetch_decode
(
	input              clk,
	input              rst,
	input  [`XLEN-1:0] pc_plus4F,
	input  [`XLEN-1:0] instrF,
	input              stallD,
	input  [1:0]       pc_selD,
	output [`XLEN-1:0] pc_plus4D,
	output [`XLEN-1:0] instrD
);

	reg [`XLEN-1:0] pc_plus4D_reg;
	reg [`XLEN-1:0] instrD_reg;

	always @(posedge clk) begin
		if (rst) begin
			pc_plus4D_reg<=0;
		end
		else begin
			if(stallD) begin
				pc_plus4D_reg<=pc_plus4D_reg;
				instrD_reg<=instrD_reg;
			end
			else begin
				pc_plus4D_reg<=pc_plus4F;
				instrD_reg<=instrF;
			end
		end
	end

	assign instrD=instrD_reg;
	assign pc_plus4D=pc_plus4D_reg;

endmodule