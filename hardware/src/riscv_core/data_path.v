module data_path
(
	input [`XLEN-1:0]  instr,
	input [`XLEN-1:0]  din,
	output [`XLEN-1:0] PC,
	output [`XLEN-1:0] wadr,
	output [`XLEN-1:0] data,
	output [3:0]       wea
);

	reg [`XLEN-1:0] PC_reg;

	initial begin
		PC_reg=32'd0;
	end

	//fetch
	always @(*) begin


	end

	always @(posedge clk) begin

	end



endmodule