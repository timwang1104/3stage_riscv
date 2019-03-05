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

	wire [1:0] PCSel;
	wire [`XLEN-1:0] PCPlus4;
	//I-type decode
	wire [6:0]Opcode;
	wire [4:0] rd;
	wire [2:0] funct3;
	wire [4:0] adr1;
	wire [4:0] adr2;
	wire [6:0] funct7;

	//Control wires
	wire Reg_Write;
	wire Inst_or_rs2;
	wire [1:0] Extend_Sel;
	wire [1:0] OpA_Sel;
	wire [4:0] shamt;
	wire WB_Sel;
	wire PCSel_bit0;
	wire branch;
	wire [4:0] ALU_Ctl;

    //Pipeline stages
	reg [`XLEN-1:0] fetch_pc;
	reg [`XLEN-1:0] PC_regF, PC_RegD;
	reg [`XLEN-1:0] PCPlus4_regF, PCPlus4_regD, PCPlus4_regE, PCPlus4_regM, PCPlus4_regW;
	
	reg [`XLEN-1:0] instr_regD;
	reg [4:0] ALU_CtlE;
	reg Reg_WriteE, Reg_WriteM, Reg_WriteW;
	reg Inst_or_rs2E;
	reg [4:0] shamtE;
	reg WB_SelE, WB_SelM, WB_SelW;
	reg PCSel_bit0E, PCSel_bit0M, PCSel_bit0W;

	reg [`XLEN-1:0] rs1D;
	reg [`XLEN-1:0] rs2D;
	reg [`XLEN-1:0] OpAD, OpAE;
	reg [`XLEN-1:0] OpBD, OpBE;



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
			PC_regD<=PC_regF;
			PCPlus4_regF<=fetch_pc+4;
			PCPlus4_regD<=PCPlus4_regF;
			PCPlus4_regE<=PCPlus4_regD;
			PCPlus4_regM<=PCPlus4_regE;
			PCPlus4_regW<=PCPlus4_regM;
		end
	end
	
	//decode
	reg_file m_reg_file(.clk(clk),.we(Reg_WriteW),.adr1(adr1),.adr2(adr2),.rd(rdW),.wd(result),.rs1(rs1),.rs2(rs2));
	control_path m_control_path(.Opcode(Opcode),.funct3(funct3),.Inst_bit30(instr_regD[30]),.Reg_Write(Reg_Write),.Inst_or_rs2(Inst_or_rs2),.Extend_Sel(Extend_Sel),.OpA_Sel(OpA_Sel),.shamt(shamt),.WB_Sel(WB_Sel),.PCSel_bit0(PCSel_bit0),.branch(branch),.ALU_Ctl(ALU_Ctl));

	always @(*) begin
		case(OpA_Sel)
			2'b00: begin
				OpAD=rs1D;
			end
			2'b01: begin
				OpAD=PC_regD;
			end
			default: begin
				OpAD=32'd0;
			end
		endcase

		case(Extend_Sel)
			2'b00: begin
				OpBD=
				
			end
			2'b01: begin
				
			end
			2'b10: begin
				
			end
			2'b11: begin
				
			end
			default: begin
				
			end
		endcase

	end

	assign PC=fetch_pc;
	assign instr_regD=instr;
	assign {funct7,adr2,adr1,funct3,rd,Opcode}=instr_regD;
endmodule