`include "Opcode.vh"
`include "defines.v"

module branch_target
(
	input  [`XLEN-1:0] BImm,
	input  [`XLEN-1:0] pc_plus4D,
	input  [`XLEN-1:0] rs1,
	input  [`XLEN-1:0] rs2,
	input  [2:0]       funct3,
	input              branch,
	output [`XLEN-1:0] BTarg,
	output             PCSel_bit1
);

	reg PCSel_bit1_reg;
	always @(*) begin
		if(branch==1) begin
			case(funct3)
				`FNC_BEQ: begin
					if(rs1==rs2) begin
						PCSel_bit1_reg=1'b1;
					end
					else begin
						PCSel_bit1_reg=1'b0;
					end
				end
				`FNC_BNE: begin
					if(rs1!=rs2) begin
						PCSel_bit1_reg=1'b1;
					end
					else begin
						PCSel_bit1_reg=1'b0;
					end
				end
				`FNC_BLT: begin
					if($signed(rs1)<$signed(rs2)) begin
						PCSel_bit1_reg=1'b1;
					end
					else begin
						PCSel_bit1_reg=1'b0;
					end
				end
				`FNC_BGE: begin
					if(!($signed(rs1)<$signed(rs2))) begin
						PCSel_bit1_reg=1'b1;
					end
					else begin
						PCSel_bit1_reg=1'b0;
					end
				end
				`FNC_BLTU: begin
					if(rs1<rs2) begin
						PCSel_bit1_reg=1'b1;
					end
					else begin
						PCSel_bit1_reg=1'b0;
					end
					// $display("%t rs1 %h rs2 %h PCSel_bit1_reg %d", $time, rs1, rs2, PCSel_bit1_reg);
				end
				`FNC_BGEU: begin
					if(!(rs1<rs2)) begin
						PCSel_bit1_reg=1'b1;
					end
					else begin
						PCSel_bit1_reg=1'b0;
					end
				end
				default: begin
					PCSel_bit1_reg=1'b0;
				end
			endcase
		end
		else begin
			PCSel_bit1_reg=1'b0;
		end

	end

	assign BTarg = BImm+pc_plus4D-4;
	assign PCSel_bit1=PCSel_bit1_reg;
endmodule
