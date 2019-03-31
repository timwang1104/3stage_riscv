`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Opcode.vh"


module store_mask_gen
(
	input  [6:0] Opcode,
	input  [2:0] funct3,
	input  [1:0] sft,
	output [3:0] wea
);
	reg [3:0] wea_reg;

	always @(*) begin
		if(Opcode == `OPC_STORE) begin
			case(funct3)
				`FNC_SW: begin
					wea_reg=4'b1111;
				end
				`FNC_SH: begin
					case(sft)
						2'b00: begin
							wea_reg=4'b0011;
						end
						2'b01: begin
							wea_reg=4'b0110;
						end
						2'b10: begin
							wea_reg=4'b1100;
						end
						default: begin
							wea_reg=4'b0000;
						end
					endcase
				end
				`FNC_SB: begin
					case(sft)
						2'b00: begin
							wea_reg=4'b0001;
						end
						2'b01: begin
							wea_reg=4'b0010;
						end
						2'b10: begin
							wea_reg=4'b0100;
						end
						2'b11: begin
							wea_reg=4'b1000;
						end
						default: begin
							wea_reg=4'b0000;
						end
					endcase
				end
				default: begin
					wea_reg=4'b0000;
				end
			endcase
		end
		else begin
			wea_reg=4'b0000;
		end
	end

	assign wea=wea_reg;
endmodule