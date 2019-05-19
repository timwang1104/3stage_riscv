`include "defines.v"

module reg_mem_wb
(
	input              clk,
	input  [2:0]       funct3M,
	input  [`XLEN-1:0] mem_adrM,
	input  [`XLEN-1:0] pc_plus4M,
	input  [`XLEN-1:0] alu_outM,
	input  [1:0]       wb_selM,
	input              reg_writeM,
	input  [4:0]       rdM,

	output [2:0]       funct3W,
	output [`XLEN-1:0] mem_adrW,
	output [`XLEN-1:0] pc_plus4W,
	output [`XLEN-1:0] alu_outW,
	output [1:0]       wb_selW,
	output             reg_writeW,
	output [4:0]       rdW
);

	reg [2:0]       funct3W_reg;
	reg [`XLEN-1:0] mem_adrW_reg;
	reg [`XLEN-1:0] pc_plus4W_reg;
	reg [`XLEN-1:0] alu_outW_reg;
	reg [1:0]       wb_selW_reg;
	reg             reg_writeW_reg;
	reg [4:0]       rdW_reg;

	always @(posedge clk) begin
		mem_adrW_reg              <=  mem_adrM;
		funct3W_reg               <=  funct3M;
		pc_plus4W_reg             <=  pc_plus4M;
		alu_outW_reg              <=  alu_outM;
		wb_selW_reg               <=  wb_selM;
		reg_writeW_reg            <=  reg_writeM;
		rdW_reg                   <=  rdM;
	end

	assign funct3W                =   funct3W_reg;
	assign mem_adrW               =   mem_adrW_reg;

	assign pc_plus4W              =   pc_plus4W_reg;
	assign alu_outW               =   alu_outW_reg;
	assign wb_selW                =   wb_selW_reg;
	assign reg_writeW             =   reg_writeW_reg;
	assign rdW                    =   rdW_reg;
endmodule