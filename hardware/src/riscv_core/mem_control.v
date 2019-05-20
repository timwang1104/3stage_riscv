module mem_control
#(
	parameter fetch_inst_mem=0,
	parameter fetch_bios_mem=1,
	parameter invalid=2,
	parameter read_data_mem=0,
	parameter read_bios_mem=1,
	parameter read_io=2,
	parameter access_mem=0,
	parameter access_io=1
)
(
	input clk,
	input [3:0] wea,
	input [3:0] pc_plus4_upper4F,
	input [3:0] pc_plus4_upper4M,
	input [3:0] data_adr_Upper4M,
	output [3:0] iwea,
	output [3:0] dwea,
	output iowea,
	output [1:0] iload_sel,
	output [1:0] dload_sel

);

	wire [3:0] pc_upper4F, pc_upper4M;
	reg [3:0] data_adr_Upper4W;

	reg [3:0] iwea_reg, dwea_reg;
	reg [1:0] iload_sel_reg;
	reg [1:0] dload_sel_reg;

	reg istore_en_reg, dstore_en_reg, iostore_en_reg;

	always @(posedge clk) begin
		data_adr_Upper4W <= data_adr_Upper4M;
	end
	
	always @(*) begin
	//store mask
		case(data_adr_Upper4M)
			4'b0001: begin  //write data mem
				istore_en_reg=1'b0;
				dstore_en_reg=1'b1;
				iostore_en_reg=1'b0;
			end
			4'b0010: begin  //write inst mem if PC[30]
				if(pc_upper4M[2]==1) begin
					istore_en_reg=1'b1;
				end
				dstore_en_reg=1'b0;
				iostore_en_reg=1'b0;
			end

			4'b0011: begin //write inst mem if PC[30], read/write data mem
				if(pc_upper4M[2]==1) begin
					istore_en_reg=1'b1;
				end
				dstore_en_reg=1'b1;
				iostore_en_reg=1'b0;

			end
			4'b1000: begin
				istore_en_reg=1'b0;
				dstore_en_reg=1'b0;
				iostore_en_reg=1'b1;
			end
			default: begin
				iostore_en_reg=1'b0;
				istore_en_reg=1'b0;
				dstore_en_reg=1'b0;
			end
		endcase
		//load mux
		case(pc_plus4_upper4F)
			4'b0001: begin
				iload_sel_reg=fetch_inst_mem;
			end
			4'b0100: begin
				iload_sel_reg=fetch_bios_mem;
			end
			default: begin
				iload_sel_reg=invalid;
			end
		endcase

		case(data_adr_Upper4W)
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

	assign pc_upper4F=pc_plus4_upper4F-4;
	assign pc_upper4M=pc_plus4_upper4M-4;
	
	assign iwea=iwea_reg;
	assign dwea=dwea_reg;
	assign iowea=iostore_en_reg;
	assign iload_sel=iload_sel_reg;
	assign dload_sel=dload_sel_reg;
endmodule