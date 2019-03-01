module mem_control
(
	input [3:0] wea,
	input [3:0] PC_Upper4,
	input [3:0] data_Upper4;
	output [3:0] iwea,
	output [3:0] dwea,
	output iload_sel,
	output dload_sel
);

	reg [3:0] iwea_reg, dwea_reg;
	reg iload_sel_reg, dload_sel_reg;
	wire istore_en, dstaore_en;
	always @(*) begin
		case(PC_Upper4)
			4'b0001: begin
				iload_sel_reg=1'b0;
			end
			4'b0100: begin
				iload_sel_reg=1'b1;
				
			end
			default: begin
				iload_sel_reg=1'b0;
			end
		endcase

		case(data_Upper4)
			4'b00x1: begin
				dload_sel_reg=1'b0;
			end
		endcase

		if(istore_en) begin
			iwea_reg=wea;
		end
		else begin
			iwea_reg=4'd0;
		end

		if(dstaore_en) begin
			dwea_reg=wea;
		end
		else begin
			dwea_reg=4'd0;
		end
	end

	assign iwea=iwea_reg;
	assign dwea=dwea_reg;
endmodule