module mem_control
#(
	parameter fetch_bios_mem=1,
	parameter fetch_inst_mem=0,
	parameter read_data_mem=0,
	parameter read_bios_mem=1,
	parameter read_io=2,
	parameter access_mem=0,
	parameter access_io=1
)
(
	input clk,
	input [3:0] wea,
	input [3:0] PC_Upper4E,
	input [3:0] data_adr_Upper4E,
	output [3:0] iwea,
	output [3:0] dwea,
	output iload_sel,
	output [1:0] dload_sel
);

	reg [3:0] PC_Upper4M, data_adr_Upper4M;

	reg [3:0] iwea_reg, dwea_reg;
	reg iload_sel_reg;
	reg [1:0] dload_sel_reg;

	reg istore_en_reg, dstore_en_reg;

	always @(posedge clk) begin
		data_adr_Upper4M <= data_adr_Upper4E;
		PC_Upper4M       <= PC_Upper4E;
	end
	
	always @(*) begin
	//store mask
		case(data_adr_Upper4E)
			4'b0001: begin  //write data mem
				dstore_en_reg=1'b1;
			end
			4'b0010: begin  //write inst mem if PC[30]
				if(PC_Upper4E[2]==1) begin
					istore_en_reg=1'b1;
				end
				dstore_en_reg=1'b0;
			end

			4'b0011: begin //write inst mem if PC[30], read/write data mem
				if(PC_Upper4E[2]==1) begin
					istore_en_reg=1'b1;
				end
				dstore_en_reg=1'b1;
			end
			default: begin
				istore_en_reg=1'b0;
				dstore_en_reg=1'b0;
			end
		endcase
		//load mux
		case(PC_Upper4M)
			4'b0001: begin
				iload_sel_reg=fetch_inst_mem;
			end
			4'b0100: begin
				iload_sel_reg=fetch_bios_mem;
			end
			default: begin
				iload_sel_reg=1'b0;
			end
		endcase

		case(data_adr_Upper4M)
			4'b0001: begin  //read data mem
				dload_sel_reg=read_data_mem;
			end
			4'b0011: begin //read data mem
				dload_sel_reg=read_data_mem;
			end
			4'b0100: begin
				dload_sel_reg=read_bios_mem;
			end
			4'b1000: begin
				dload_sel_reg=read_io;
			end
			default: begin
				dload_sel_reg=2'd0;
			end
		endcase

		if(istore_en_reg) begin
			iwea_reg=wea;
		end
		else begin
			iwea_reg=4'd0;
		end

		if(dstore_en_reg) begin
			dwea_reg=wea;
		end
		else begin
			dwea_reg=4'd0;
		end
	end

	assign iwea=iwea_reg;
	assign dwea=dwea_reg;
	assign iload_sel=iload_sel_reg;
	assign dload_sel=dload_sel_reg;
endmodule