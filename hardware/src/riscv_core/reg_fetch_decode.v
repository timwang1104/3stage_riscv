`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module reg_fetch_decode
(
	input  [`XLEN-1:0] pcF,
	input  instrF,
	input  stallD,
	input [1:0] pc_sel,
	input  rst,
	output [`XLEN-1:0] pcD,
	output [`XLEN-1:0] instrD
);

	reg [`XLEN-1:0] pcD_reg;
	reg [`XLEN-1:0] instrD_reg;

	always @(posedge clk) begin
		if (rst || (pc_sel==2'b01) || (pc_sel=2'b10)) begin
			pcD_reg<=0;
			instrD_reg<=0			
		end
		else begin
			if(stallD) begin
				pcD_reg<=pcD_reg;
				instrD_reg<=instrD_reg;
			end
			else begin
				pcD_reg<=pcF;
				instrD_reg<=instrF;
			end
		end
	end

	assign instrD=instrD_reg;
	assign pcD=pcD_reg;

endmodule