`include "util.vh"
`include "defines.v"

module imem_sim
(
	input [`INST_MEM_ADDR_WIDTH-1:0] adra,
	input [`INST_MEM_ADDR_WIDTH-1:0] adrb,
	input [`XLEN-1:0] dina,
	input en,
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

	initial begin
		$readmemh("imem_inst.data", inst_mem);
	end

	always @(posedge clk) begin
		if (reset) begin
			doutb_reg<=32'd0;
		end
		else begin
			if(en) begin
				doutb_reg<=inst_mem[adrb];
			end
			else begin
				doutb_reg<=doutb_reg;
			end

			if(wea!=4'b0000) begin
				inst_mem[adra]<=(inst_mem[adra]&~expend_mask)|(dina&expend_mask);
			end

		end
	end

	assign doutb=doutb_reg;

endmodule