`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module io_control#(
	parameter CPU_CLOCK_FREQ = 50_000_000
)
(
	input clk,
	input io_en,
	input [3:0] wea,
	input cpu_rst,
	input [`IO_MAP_WIDTH-1:0] adr,
	input instr_stop,
	input [`XLEN-1:0] din_io,
	input uart_serial_in,

	output [`XLEN-1:0] dout_io,
	output uart_serial_out
);
	wire [`XLEN-1:0] cycle_cnt;
	wire [`XLEN-1:0] instr_cnt;

	wire [7:0]       uart_data_in;
	wire [7:0]       uart_data_out;
	wire             uart_data_in_valid;
	wire             uart_data_in_ready;
	wire             uart_data_out_valid;
	wire             uart_data_out_ready;

	reg [`XLEN-1:0]  dout_io_reg;
	reg              counter_rst;

	reg [7:0]        uart_data_in_reg;
	reg              uart_data_in_valid_reg;
	reg              uart_data_out_ready_reg;

	cycle_counter           m_cycle_counter(.clk(clk), .counter_rst(counter_rst), .cycle_cnt(cycle_cnt));
	instr_counter           m_instr_counter(.clk(clk), .instr_stop(instr_stop), .counter_rst(counter_rst), .instr_cnt(instr_cnt));
	uart  #(CPU_CLOCK_FREQ) on_chip_uart(.clk(clk), .reset(cpu_rst), .data_in(uart_data_in), .data_in_valid(uart_data_in_valid), .data_in_ready(uart_data_in_ready), .data_out(uart_data_out),.data_out_valid(uart_data_out_valid), .data_out_ready(uart_data_out_ready), .serial_in(uart_serial_in), .serial_out(uart_serial_out));
	
	always @(negedge clk) begin
		if(cpu_rst) begin
			uart_data_in_valid_reg<=1'b0;
			uart_data_out_ready_reg<=1'b0;
		end
		else begin
			if(io_en) begin
				case(adr)
					5'b00001: begin //uart receiver data
						uart_data_out_ready_reg<=1'b1;
					end
					5'b00010: begin //uart transmitter data
						uart_data_in_valid_reg<=1'b1;
					end
					default: begin
						uart_data_in_valid_reg<=1'b0;
						uart_data_out_ready_reg<=1'b0;
					end
				endcase
			end
			else begin
				uart_data_in_valid_reg<=1'b0;
				uart_data_out_ready_reg<=1'b0;						
			end
		end
	end

	always @(posedge clk) begin
		if (cpu_rst) begin
			dout_io_reg<=32'd0;
			counter_rst<=1'b1;
			uart_data_in_reg<=8'd0;
		end
		else begin
			if (io_en) begin
				case(adr)
					5'b00000: begin //uart control
						dout_io_reg<={30'b0,uart_data_out_valid,uart_data_in_ready};
					end
					5'b00001: begin //uart receiver data
						dout_io_reg<={24'b0,uart_data_out};
					end
					5'b00010: begin //uart transmitter data
						uart_data_in_reg<=din_io[7:0];
					end

					5'b00100: begin
						dout_io_reg<=cycle_cnt;
					end
					5'b00101: begin
						dout_io_reg<=instr_cnt;
					end
					5'b00110: begin
						if(wea!=4'd0) begin
							counter_rst<=1'b1;
						end
						else begin
							counter_rst<=1'b0;
						end
					end
					default: begin
						dout_io_reg<=32'd0;
						counter_rst<=1'b0;
						uart_data_in_reg<=8'd0;
					end
				endcase
			end
			else begin
				dout_io_reg<=32'd0;
				counter_rst<=1'b0;
				uart_data_in_reg<=8'd0;
			end
		end
	end

	assign dout_io=dout_io_reg;

	assign uart_data_in=uart_data_in_reg;
	assign uart_data_in_valid=uart_data_in_valid_reg;


endmodule