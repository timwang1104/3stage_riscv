`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module cycle_counter
(
	input              clk,
	input              counter_rst,
	output [`XLEN-1:0] cycle_cnt
);
	reg [`XLEN-1:0] cycle_count_reg;

	always @(posedge clk) begin
		if(counter_rst) begin
			cycle_count_reg<=0;
		end
		else begin
			cycle_count_reg<=cycle_count_reg+1;
		end
	end

	assign cycle_cnt = cycle_count_reg;


endmodule