`include "util.vh"
`include "defines.v"

module dmem_sim
(
	input [`DATA_MEM_ADDR_WIDTH-1:0] adra,
	input [`XLEN-1:0] dina,
	input [3:0] wea,
	input clk,
	input reset,
	output [`XLEN-1:0] douta
);
	
	reg [`XLEN-1:0] data_mem [`pow2(`DATA_MEM_ADDR_WIDTH)-1:0];
	reg [`XLEN-1:0] douta_reg;

	wire [31:0] expend_mask={wea[3]?8'hFF:8'h00,
							 wea[2]?8'hFF:8'h00,
							 wea[1]?8'hFF:8'h00,
							 wea[0]?8'hFF:8'h00
							};

	initial begin
		$readmemh("dmem_inst.data", data_mem);
	end

	always @(posedge clk) begin
		if (reset) begin
			douta_reg<=32'd0;
		end
		else begin
			if(wea!=4'b0000) begin
				data_mem[adra]<=(data_mem[adra]&~expend_mask)|(dina&expend_mask);
				$display("%d write addr %h data %h mask %h",$time, adra, dina, expend_mask);
			end
			douta_reg<=data_mem[adra];
		end
	end

	assign douta=douta_reg;

endmodule