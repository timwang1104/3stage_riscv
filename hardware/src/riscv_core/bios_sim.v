`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/util.vh"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module bios_sim
(
	input [`BIOS_MEM_ADDR_WIDTH-1:0] adra,
	input [`BIOS_MEM_ADDR_WIDTH-1:0] adrb,
	input en,
	input clk,
	input reset,
	output [`XLEN-1:0] douta,
	output [`XLEN-1:0] doutb
);
	reg [`XLEN-1:0] bios_inst_mem [`pow2(`BIOS_MEM_ADDR_WIDTH)-1:0];
	reg [`XLEN-1:0] bios_data_mem [`pow2(`BIOS_MEM_ADDR_WIDTH)-1:0];

	reg [`XLEN-1:0] douta_reg;
	reg [`XLEN-1:0] doutb_reg;


	initial begin
		$readmemh("bios_inst.data", bios_inst_mem);
	end

	always @(posedge clk) begin
		if (reset) begin
			douta_reg<=32'd0;
			doutb_reg<=32'd0;
		end
		else begin
			if(en) begin
				douta_reg<=bios_inst_mem[adra];
				doutb_reg<=bios_data_mem[adrb];
			end
			else begin
				douta_reg<=douta_reg;
				doutb_reg<=doutb_reg;
			end
		end
	end

	assign douta=douta_reg;
	assign doutb=doutb_reg;

endmodule