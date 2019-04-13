`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module io_control
(
	input clk,
	input io_en,
	input [3:0] wea,
	input cpu_rst,
	input [`IO_MAP_WIDTH-1:0] adr,
	input instr_stop,
	output [`XLEN-1:0] dout_io
);

	reg [`XLEN-1:0]  dout_io_reg;
	reg counter_rst;

	wire [`XLEN-1:0] cycle_cnt;
	wire [`XLEN-1:0] instr_cnt;


	cycle_counter m_cycle_counter(.clk(clk), .counter_rst(counter_rst), .cycle_cnt(cycle_cnt));
	instr_counter m_instr_counter(.clk(clk), .instr_stop(instr_stop), .counter_rst(counter_rst), .instr_cnt(instr_cnt));

	always @(*) begin
		if (cpu_rst) begin
			dout_io_reg=32'd0;
			counter_rst=1'b1;
		end
		else begin
			if (io_en) begin
				case(adr)
					5'b00100: begin
						dout_io_reg<=cycle_cnt;
					end
					5'b00101: begin
						dout_io_reg<=instr_cnt;
					end
					5'b00110: begin
						if(wea!=4'd0) begin
							counter_rst=1'b1;
						end
						else begin
							counter_rst=1'b0;
						end
					end
					default: begin
						dout_io_reg<=32'd0;
						counter_rst<=1'b0;
					end
				endcase
			end
			else begin
				counter_rst=1'b0;
			end
		end
	end

	assign dout_io=dout_io_reg;


endmodule