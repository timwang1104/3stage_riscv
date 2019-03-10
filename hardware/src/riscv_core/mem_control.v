module mem_control
#(
	parameter fetch_bios_mem=1,
	parameter fetch_inst_mem=0,
	parameter read_data_mem=0,
	parameter read_bios_mem=1,
	parameter access_mem=0,
	parameter access_io=1
)
(
	input [3:0] wea,
	input [3:0] PC_Upper4,
	input [3:0] data_adr_Upper4,
	output [3:0] iwea,
	output [3:0] dwea,
	output iload_sel,
	output dload_sel,
	output mem_or_IO,
	output IOstore_en
);

	reg [3:0] iwea_reg, dwea_reg;
	reg iload_sel_reg, dload_sel_reg;
	reg mem_or_IO_reg;

	reg istore_en_reg, dstore_en_reg;
	
	always @(*) begin
		case(PC_Upper4)
			4'b0001: begin
				iload_sel_reg=`fetch_inst_mem;
			end
			4'b0100: begin
				iload_sel_reg=`fetch_bios_mem;
				
			end
			default: begin
				iload_sel_reg=1'b0;
			end
		endcase

		case(data_adr_Upper4)
			4'b0001: begin  //read/write data mem
				mem_or_IO_reg=`access_mem;
				dload_sel_reg=`read_data_mem;
				dstore_en_reg=1'b1;
			end
			4'b0010: begin  //write inst mem if PC[30]
				mem_or_IO_reg=`access_mem;
				if(PC_Upper4[2]==1) begin
					istore_en_reg=1'b1;
				end
				dstore_en_reg=1'b0;
			end

			4'b0011: begin //write inst mem if PC[30], read/write data mem
				mem_or_IO_reg=`access_mem;
				if(PC_Upper4[2]==1) begin
					istore_en_reg=1'b1;
				end
				dload_sel_reg=`read_data_mem;
				dstore_en_reg=1'b1;
			end
			4'b0100: begin
				mem_or_IO_reg=`access_mem;
				dload_sel_reg=`read_bios_mem;
			end
			4'b1000: begin
				mem_or_IO_reg=`access_io;
			end
			default: begin
				mem_or_IO_reg=1'b0;
				dload_sel_reg=1'b0;
				istore_en_reg=1'b0;
				dstore_en_reg=1'b0;
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
	assign mem_or_IO=mem_or_IO_reg;
	assign IOstore_en=mem_or_IO_reg;
	assign iload_sel=iload_sel_reg;
	assign dload_sel=dload_sel_reg;
endmodule