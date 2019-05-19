`include "Opcode.vh"
`include "defines.v"

module store_mask_gen
(
	input  [6:0] Opcode,
	input  [2:0] funct3,
	input  [1:0] sft,
	input  [`XLEN-1:0] data,
	output [3:0] wea,
	output [`XLEN-1:0] write_data
);
	reg [3:0] wea_reg;
	reg [`XLEN-1:0] write_data_reg;

	always @(*) begin
		if(Opcode == `OPC_STORE) begin
			case(funct3)
				`FNC_SW: begin
					wea_reg=4'b1111;
					write_data_reg=data&32'hFFFF_FFFF;
				end
				`FNC_SH: begin
					case(sft)
						2'b00: begin
							wea_reg=4'b0011;
							write_data_reg=(data&32'h0000_FFFF);
						end
						2'b01: begin
							wea_reg=4'b0110;
							write_data_reg=(data&32'h00_FFFF)<<8;
						end
						2'b10: begin
							wea_reg=4'b1100;
							write_data_reg=(data&32'h00_FFFF)<<16;
						end
						default: begin
							wea_reg=4'b0000;
							write_data_reg=32'h0000_0000;
						end
					endcase
					
				end
				`FNC_SB: begin
					case(sft)
						2'b00: begin
							wea_reg=4'b0001;
							write_data_reg=(data&32'h0000_00FF);
						end
						2'b01: begin
							wea_reg=4'b0010;
							write_data_reg=(data&32'h0000_00FF)<<8;
						end
						2'b10: begin
							wea_reg=4'b0100;
							write_data_reg=(data&32'h0000_00FF)<<16;
						end
						2'b11: begin
							wea_reg=4'b1000;
							write_data_reg=(data&32'h0000_00FF)<<24;
						end
						default: begin
							wea_reg=4'b0000;
							write_data_reg=32'h0000_0000;
						end
					endcase
				end
				default: begin
					wea_reg=4'b0000;
					write_data_reg=32'h0000_0000;
				end
			endcase
		end
		else begin
			wea_reg=4'b0000;
			write_data_reg=32'h0000_0000;
		end
	end

	assign wea=wea_reg;
	assign write_data=write_data_reg;
endmodule