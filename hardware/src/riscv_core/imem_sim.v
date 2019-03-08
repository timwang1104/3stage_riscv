`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/util.vh"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module imem_sim
(
	input [`INST_MEM_ADDR_WIDTH-1:0] adra,
	input [`INST_MEM_ADDR_WIDTH-1:0] adrb,
	input [`XLEN-1] dina;
	input [3:0] wea;
	input clk,
	output [`XLEN-1:0] doutb
);
	
	reg [`XLEN-1:0] inst_mem [`pow2(`INST_MEM_ADDR_WIDTH)-1:0];
	reg [`XLEN-1] doutb_reg;


	always @(posedge clk or posedge rst) begin
		if (rst) begin
			doutb_reg<=32'd0;
		end
		else begin
			case(wea)
				4'b0001: begin
					inst_mem[adra]<={24{1'bx},dina[7:0]};
				end
				4'b0001: begin
					inst_mem[adra]<={24{1'bx},dina[7:0]};
				end

			endcase

			douta_reg<=bios_inst_mem[adra];
			doutb_reg<=bios_data_mem[adrb];
		end
	end

	assign douta=douta_reg;
	assign doutb=doutb_reg;

endmodule