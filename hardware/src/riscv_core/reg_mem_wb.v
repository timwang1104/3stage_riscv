`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module reg_mem_wb
(
	input              clk,
	input  [`XLEN-1:0] jump_result_plus4M,
	input  [`XLEN-1:0] mem_resultM,
	input  [`XLEN-1:0] alu_outM,
	input  [1:0]       wb_selM,
	input              reg_writeM,
	input  [4:0]       rdM,

	output [`XLEN-1:0] jump_result_plus4W,
	output [`XLEN-1:0] mem_resultW,
	output [`XLEN-1:0] alu_outW,
	output [1:0]       wb_selW,
	output             reg_writeW,
	output [4:0]       rdW
);

	reg [`XLEN-1:0] jump_result_plus4W_reg;
	reg [`XLEN-1:0] mem_resultW_reg;
	reg [`XLEN-1:0] alu_outW_reg;
	reg [1:0]       wb_selW_reg;
	reg             reg_writeW_reg;
	reg [4:0]       rdW_reg;

	always @(posedge clk) begin
		jump_result_plus4W_reg   <=  jump_result_plus4M;
		mem_resultW_reg           <=  mem_resultM;
		alu_outW_reg              <=  alu_outM;
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