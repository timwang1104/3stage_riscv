module stage_mem
(
	input  [`XLEN-1:0] alu_outM,
	input  [`XLEN-1:0] forward_rs2M,
	input  [6:0]       opcodeM,
	input  [2:0]       funct3M,
	input              mem_accessM,
	input  [`XLEN-1:0] din,

	output [`XLEN-1:0] mem_adrM,
	output [`XLEN-1:0] mem_wdata,
	output [3:0]       wea,

	output [`XLEN-1:0] mem_resultM

);

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
		.sft(mem_sftM),
		.data(forward_rs2M),
		.wea(wea), 
		.write_data(mem_wdata)
	);

	data_alignment m_data_alignment(
		.din(din),
		.sft(mem_sftM),
		.funct3(funct3M),
		.dout(mem_resultM)
	);

	assign mem_adrM=mem_adrM_reg;
	assign mem_sftM=mem_adrM[1:0];



endmodule