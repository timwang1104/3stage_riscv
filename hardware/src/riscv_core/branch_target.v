`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Opcode.vh"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module branch_target
(
	input  [`XLEN-1:0] BImm,
	input  [`XLEN-1:0] PC,
	input  [`XLEN-1:0] rs1,
	input  [`XLEN-1:0] rs2,
	input  [2:0]       funct3,
	input              branch,
	output [`XLEN-1:0] BTarg,
	output reg         PCSel_bit1
);

	always @(*) begin
		if(branch==1) begin
			case(funct3)
				`FNC_BEQ: begin
					if(rs1==rs2) begin
						PCSel_bit1=1'b1;
					end
					else begin
						PCSel_bit1=1'b0;
					end
				end
				`FNC_BNE: begin
					if(rs1!=rs2) begin
						PCSel_bit1=1'b1;
					end
					else begin
						PCSel_bit1=1'b0;
					end
				end
				`FNC_BLT: begin
					if($signed(rs1)<$signed(rs2)) begin
						PCSel_bit1=1'b1;
					end
					else begin
						PCSel_bit1=1'b0;
					end
				end
				`FNC_BGE: begin
					if(!($signed(rs1)<$signed(rs2))) begin
						PCSel_bit1=1'b1;
					end
					else begin
						PCSel_bit1=1'b0;
					end
				end
				`FNC_BLTU: begin
					if(rs1<rs2) begin
						PCSel_bit1=1'b1;
					end
					else begin
						PCSel_bit1=1'b0;
					end
				end
				`FNC_BGEU: begin
					if(!(rs1<rs2)) begin
						PCSel_bit1=1'b1;
					end
					else begin
						PCSel_bit1=1'b0;
					end
				end
				default: begin
					PCSel_bit1=1'b0;
				end
			endcase
		end
		else begin
			PCSel_bit1=1'b0;
		end

	end

	assign BTarg = BImm+PC;
endmodule
