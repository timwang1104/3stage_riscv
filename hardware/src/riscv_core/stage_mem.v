`include "defines.v"
module stage_mem
(
	input  [`XLEN-1:0] alu_outM,
	input  [`XLEN-1:0] rs2M,
	input  [6:0]       opcodeM,
	input  [2:0]       funct3M,
	input              mem_accessM,

	output [`XLEN-1:0] mem_adrM,
	output [`XLEN-1:0] mem_wdataM,
	output [3:0]       wea
);

	reg [`XLEN-1:0] mem_adrM_reg;

	always @(*) begin
		case(mem_accessM)
			1'b0: begin
				mem_adrM_reg=32'd0;
			end
			1'b1: begin
				mem_adrM_reg=alu_outM;
			end
			default: begin
				mem_adrM_reg=32'd0;
			end
		endcase
	end

	store_mask_gen m_store_mask_gen(
		.Opcode(opcodeM),
		.funct3(funct3M),
		.sft(mem_adrM_reg[1:0]),
		.data(rs2M),
		.wea(wea), 
		.write_data(mem_wdataM)
	);


	assign mem_adrM=mem_adrM_reg;



endmodule