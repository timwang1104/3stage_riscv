module reg_mem_wb
(
	input              clk,
	input  [`XLEN-1:0] jump_result_plus4M,
	input  [`XLEN-1:0] mem_resultM,
	input  [`XLEN-1:0] alu_outM,
	input  [1:0]       wb_selM,
	input              reg_writeM,
	input              rdM,

	output [`XLEN-1:0] jump_result_plus4W,
	output [`XLEN-1:0] mem_resultW,
	output [`XLEN-1:0] alu_outW,
	output [1:0]       wb_selW,
	output             reg_writeW,
	output             rdW
);

	reg [`XLEN-1:0] jump_result_plus4W_reg;
	reg [`XLEN-1:0] mem_resultW_reg;
	reg [`XLEN-1:0] alu_outW_reg;
	reg [1:0]       mem_shiftW_reg;
	reg [1:0]       wb_selW_reg;
	reg             reg_writeW_reg;
	reg             rdW_reg;

	always @(posedge clk) begin
		jump_result_plus4W_reg   <=  jump_result_plus4M;
		mem_resultW_reg           <=  mem_resultM;
		alu_outW_reg              <=  alu_outM;
		mem_shiftW_reg            <=  mem_shiftM;
		reg_writeW_reg            <=  reg_writeM;
		rdW_reg                   <=  rdM;
	end

	assign jump_result_plus4W    =   jump_result_plus4W_reg;
	assign mem_resultW            =   mem_resultW_reg;
	assign alu_outW               =   alu_outW_reg;
	assign wb_selW                =   wb_selW_reg;
	assign reg_writeW             =   reg_writeW_reg;
	assign rdW                    =   rdW_reg;
endmodule