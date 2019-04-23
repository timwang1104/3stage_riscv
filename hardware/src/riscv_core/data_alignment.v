`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Opcode.vh"

module data_alignment
(
	input [`XLEN-1:0]  din,
	input [1:0]        sft,
	input [2:0]        funct3,
	output [`XLEN-1:0] dout
);

	reg [`XLEN-1:0] dout_reg;

	always @(*) begin
		case(funct3)
			`FNC_LW: begin
				dout_reg=din;
			end
			`FNC_LH: begin
				case(sft)
					2'b00: begin
						dout_reg={{16{din[15]}},din[15:0]};
					end
					2'b01: begin
						dout_reg={{16{din[23]}},din[23:8]};
					end
					2'b10: begin
						dout_reg={{16{din[31]}},din[31:16]};
					end
					default: begin
						dout_reg=32'd0;
					end
				endcase
			end
			`FNC_LB: begin
				case(sft)
					2'b00: begin
						dout_reg={{24{din[7]}},din[7:0]};
					end
					2'b01: begin
						dout_reg={{24{din[15]}},din[15:8]};
					end
					2'b10: begin
						dout_reg={{24{din[23]}},din[23:16]};
					end
					2'b11: begin
						dout_reg={{24{din[31]}},din[31:24]};
					end
					default: begin
						dout_reg=32'd0;
					end
				endcase
			end
			`FNC_LHU: begin
				case(sft)
					2'b00: begin
						dout_reg={{16{1'b0}},din[15:0]};
					end
					2'b01: begin
						dout_reg={{16{1'b0}},din[23:8]};
					end
					2'b10: begin
						dout_reg={{16{1'b0}},din[31:16]};
					end
					default: begin
						dout_reg=32'd0;
					end
				endcase
			end
			`FNC_LBU: begin
				case(sft)
					2'b00: begin
						dout_reg={{24{1'b0}},din[7:0]};
					end
					2'b01: begin
						dout_reg={{24{1'b0}},din[15:8]};
					end
					2'b10: begin
						dout_reg={{24{1'b0}},din[23:16]};
					end
					2'b11: begin
						dout_reg={{24{1'b0}},din[31:24]};
					end
					default: begin
						dout_reg=32'd0;
					end
				endcase
				$display("%d load data %h",$time, dout_reg);
			end
			default: begin
				dout_reg=32'd0;
			end
		endcase
	end
	assign dout = dout_reg;
endmodule