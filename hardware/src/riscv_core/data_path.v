module data_path
(
	input [`XLEN-1:0]  instr,
	input [`XLEN-1:0]  din,
	input clk,
	input reset,
	output [`XLEN-1:0] PC,
	output [`XLEN-1:0] wadr,
	output [`XLEN-1:0] data,
	output [3:0]       wea
);

	wire PCSel;
	reg [`XLEN-1:0] PC_regF;
	reg [`XLEN-1:0] fetch_pc;

	reg RegWriteW;
	reg rdW;
	wire result
	initial begin
		PC_reg=32'd0;
	end

	//fetch
	always @(*) begin
		case(PCSel) begin
			2'b00: begin
				fetch_pc=fetch_pc+4;
			end
			2'b01: begin
				fetch_pc=jump_target;
			end
			2'b10: begin
				fetch_pc=branch_target;
			end
			default: begin
				fetch_pc=fetch_pc+4
			end
		endcase

	end

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			PC_regF<=32'd0;
		end
		else begin
			PC_regF<=fetch_pc;
		end
	end
	
	//decode
	reg_file m_reg_file(.clk(clk),.we(RegWriteW),.adr1(instr[19:15]),.adr2(instr[24:20]),.rd(rdW),.wd(result),.rs1(rs1D),.rs2(rs2D));

	assign PC=fetch_pc;
endmodule