`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/util.vh"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module imem_sim
(
	input [`INST_MEM_ADDR_WIDTH-1:0] adra,
	input [`INST_MEM_ADDR_WIDTH-1:0] adrb,
	input [`XLEN-1:0] dina,
	input [3:0] wea,
	input clk,
	input reset,
	output [`XLEN-1:0] doutb
);
	
	reg [`XLEN-1:0] inst_mem [`pow2(`INST_MEM_ADDR_WIDTH)-1:0];
	reg [`XLEN-1:0] doutb_reg;

	wire [31:0] expend_mask={wea[3]?8'hFF:8'h00,
							 wea[2]?8'hFF:8'h00,
							 wea[1]?8'hFF:8'h00,
							 wea[0]?8'hFF:8'h00
							};

	always @(posedge clk) begin
		if (reset) begin
			doutb_reg<=32'd0;
		end
		else begin
			if(wea!=4'b0000) begin
				inst_mem[adra]<=(inst_mem[adra]&~expend_mask)|(dina&expend_mask);
			end
			doutb_reg<=inst_mem[adrb];
		end
	end

	assign doutb=doutb_reg;

endmodule