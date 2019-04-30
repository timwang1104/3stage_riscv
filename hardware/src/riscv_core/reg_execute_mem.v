`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"
module reg_execute_mem
(

	input               clk,
 
	input [2:0]         funct3E,
	input [`XLEN-1:0]   alu_outE,
	input [`XLEN-1:0]   forward_rs2E,
	input [`XLEN-1:0]   jump_result_plus4E,
	input [6:0]         opcodeE,
	input               mem_accessE,
	input [1:0]         wb_selE,
	input               reg_writeE,
	input [4:0]         rdE,


	output [2:0]        funct3M,
	output [`XLEN-1:0]  alu_outM,
	output [`XLEN-1:0]  forward_rs2M,
	output [`XLEN-1:0]  jump_result_plus4M,
	output [6:0]        opcodeM,
	output              mem_accessM,
	output [1:0]        wb_selM,
	output              reg_writeM,
	output [4:0]        rdM
);

	reg [6:0]        opcodeM_reg;
	reg [2:0]        funct3M_reg;
	reg [`XLEN-1:0]  alu_outM_reg;
	reg [`XLEN-1:0]  forward_rs2M_reg;
	reg [`XLEN-1:0]  jump_result_plus4M_reg;
	reg              mem_accessM_reg;
	reg [1:0]        wb_selM_reg;
	reg              reg_writeM_reg;
	reg [4:0]        rdM_reg;

	always @(posedge clk) begin
		opcodeM_reg              <=    opcodeE;
		funct3M_reg              <=    funct3E;
		alu_outM_reg             <=    alu_outE;
		forward_rs2M_reg         <=    forward_rs2E;
		jump_result_plus4M_reg   <=    jump_result_plus4E;
		mem_accessM_reg          <=    mem_accessE;
		wb_selM_reg              <=    wb_selE;
		reg_writeM_reg           <=    reg_writeE;
		rdM_reg                  <=    rdE;
	end

assign   opcodeM                  =    opcodeM_reg;
assign   funct3M                  =    funct3M_reg;
assign   alu_outM                 =    alu_outM_reg;
assign   forward_rs2M             =    forward_rs2M_reg;
assign   jump_result_plus4M       =    jump_result_plus4M_reg;
assign   mem_accessM              =    mem_accessM_reg;
assign   wb_selM                  =    wb_selM_reg;
assign   reg_writeM               =    reg_writeM_reg;
assign   rdM                      =    rdM_reg;

endmodule