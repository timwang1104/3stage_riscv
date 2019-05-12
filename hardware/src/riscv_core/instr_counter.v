`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module instr_counter
(
	input              clk,
	input              instr_stop,
	input              counter_rst,
	output [`XLEN-1:0] instr_cnt
);
	reg [`XLEN-1:0] instr_count_reg;

	always @(posedge clk) begin
		if(counter_rst) begin
			instr_count_reg<=0;
		end
		else begin
			if(instr_stop) begin
				instr_count_reg<=instr_count_reg;		
			end
			else begin
				instr_count_reg<=instr_count_reg+1;
			end			
		end
	end

	assign instr_cnt = instr_count_reg;


endmodule