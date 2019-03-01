module data_alignment
(
	input [`XLEN-1:0]  din,
	input [1:0]        sft,
	input [2:0]        funct3,
	output [`XLEN-1:0] dout
);

	reg dout_reg;

	always @(*) begin
		case(funct3)
			`FUN_LW: begin
				dout_reg=din;
			end
			`FUN_LH: begin
				case(sft)
					2'b00: begin
						dout_reg={16{din[15]},din[15:0]};
					end
					2'b01: begin
						dout_reg={16{din[23]},din[23:8]};
					end
					2'b10: begin
						dout_reg={16{din[31]},din[31:16]};
					end
					default: begin
						dout_reg=32'd0;
					end
				endcase
			end
			`FUN_LB: begin
				case(sft)
					2'b00: begin
						dout_reg={24{din[7]},din[7:0]};
					end
					2'b01: begin
						dout_reg={24{din[15]},din[15:8]};
					end
					2'b10: begin
						dout_reg={24{din[23]},din[23:16]};
					end
					2'b11: begin
						dout_reg={24{din[31]},din[31:24]};
					end
					default: begin
						dout_reg=32'd0;
					end
				endcase
			end
			`FUN_LHU: begin
				case(sft)
					2'b00: begin
						dout_reg={16{1'b0},din[15:0]};
					end
					2'b01: begin
						dout_reg={16{1'b0},din[23:8]};
					end
					2'b10: begin
						dout_reg={16{1'b0},din[31:16]};
					end
					default: begin
						dout_reg=32'd0;
					end
				endcase
			end
			`FUN_LBU: begin
				case(sft)
					2'b00: begin
						dout_reg={24{1'b0},din[7:0]};
					end
					2'b01: begin
						dout_reg={24{1'b0},din[15:8]};
					end
					2'b10: begin
						dout_reg={24{1'b0},din[23:16]};
					end
					2'b11: begin
						dout_reg={24{1'b0},din[31:24]};
					end
					default: begin
						dout_reg=32'd0;
					end
				endcase

			end
			default: begin
				dout_reg=32'd0;
			end
		endcase
	end
	assign dout = dout_reg;
endmodule