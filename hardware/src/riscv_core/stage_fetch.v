`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"
module stage_fetch
(
	input    clk,
	input    rst,
	input    stallF,
	input [`XLEN-1:0]  imem_instr,
	input [`XLEN-1:0]  bios_instr,
	input [1:0]        iload_sel,
	input [`XLEN-1:0]  jump_result,
	input [`XLEN-1:0]  branch_result,
	input [1:0]        pc_selD,
	output [`XLEN-1:0] instrF,
	output [`XLEN-1:0] pc_plus4F
);

	reg [1:0]       iload_sel_reg;
	reg [`XLEN-1:0] pc_plus4F_reg;
	reg [`XLEN-1:0] fetch_pc;
	reg [`XLEN-1:0] instrF_reg;

	always @(*) begin
		case(pc_selD)
			2'b00: begin
				fetch_pc=pc_plus4F_reg+4;
				case(iload_sel_reg)
        		    2'b00: begin
        		        instrF_reg=imem_instr;
        		    end
        		    2'b01: begin
        		        instrF_reg=bios_instr;
        		    end
        		    2'b10:begin
        		        instrF_reg=32'd0;
        		    end
        		    default: begin
        		        instrF_reg=32'd0;
        		    end
				endcase
			end
			2'b01: begin
				fetch_pc=jump_result;
				instrF_reg=32'd0;
			end
			2'b10: begin
				fetch_pc=branch_result;
				instrF_reg=32'd0;
			end
			default: begin
				fetch_pc=fetch_pc;
				instrF_reg=instrF_reg;
			end
		endcase
	end


	always @(posedge clk) begin
		if (rst) begin
			pc_plus4F_reg<=32'h4000_0000;		
		end
		else begin
			if(stallF) begin
				pc_plus4F_reg<=pc_plus4F_reg;
				iload_sel_reg<=iload_sel_reg;
			end
			else begin
				pc_plus4F_reg<=fetch_pc;
				iload_sel_reg<=iload_sel;
			end
		end
	end

	// assign instrF=mem_data_in;
	assign instrF=instrF_reg;
	assign pc_plus4F=(pc_selD!=2'b00)?32'd0:pc_plus4F_reg;

endmodule