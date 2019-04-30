`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"
module stage_fetch
(
	input    clk,
	input    rst,
	input    stallF,
	input [`XLEN-1:0]  mem_data_in,
	input [`XLEN-1:0]  jump_result,
	input [`XLEN-1:0]  branch_result,
	input [1:0]        pc_selD,
	output [`XLEN-1:0] instrF,
	output [`XLEN-1:0] pcF
);

	reg [`XLEN-1:0] pcF_reg;
	reg [`XLEN-1:0] fetch_pc;

	always @(*) begin
		case(pc_selD)
			2'b00: begin
				fetch_pc=pcF_reg+4;
			end
			2'b01: begin
				fetch_pc=jump_result;
			end
			2'b10: begin
				fetch_pc=branch_result;
			end
			default: begin
				fetch_pc=fetch_pc;
			end
		endcase
	end


	always @(posedge clk) begin
		if (rst) begin
			pcF_reg<=32'h4000_0000;		
		end
		else begin
			if(stallF) begin
				pcF_reg<=pcF_reg;
			end
			else begin
				pcF_reg<=fetch_pc;
			end
		end
	end

	assign instrF=mem_data_in;
	assign pcF=pcF_reg;

endmodule