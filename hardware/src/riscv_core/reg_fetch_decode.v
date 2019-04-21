`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module reg_fetch_decode
(
	input  [`XLEN-1:0] pc_plus_4F,
	input  instr,
	input  stallD,
	input [1:0] pc_sel,
	input  rst,
	output [`XLEN-1:0] pc_plus_4D,
	output [`XLEN-1:0] instrD
);

	reg [`XLEN-1:0] pc_plus_4D_reg;
	reg [`XLEN-1:0] instrD_reg;

	always @(posedge clk) begin
		if (rst) begin
			pc_plus_4D_reg<=0;			
		end
		else begin
			if(stallD) begin
				pc_plus_4D_reg<=pc_plus_4D_reg;
			end
			else begin
				pc_plus_4D_reg<=pc_plus_4F;
			end
		end
	end

	always @(*) begin
		if (rst || (pc_sel==2'b01)||(pc_sel==2'b10)) begin
			instrD_reg=32'd0;			
		end
		else begin
			instrD_reg=instr;			
		end
	end

	assign instrD=instrD_reg;

endmodule