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

	wire [`XLEN-1:0] Ext_Result;
	//R-type decode
	wire [6:0]Opcode;
	wire [4:0] rd;
	wire [2:0] funct3;
	wire [4:0] adr1;
	wire [4:0] adr2;
	wire [6:0] funct7;

	//I-type decode
	wire [11:0] Itype_Imm;
	wire [31:0] Itype_Ext;

	//S-type decode
	wire [11:0] Stype_Imm;
	wire [31:0] Stype_Ext;

	//U-type decode
	wire [19:0] Utype_Imm;
	wire [31:0] Utype_Ext;

	//J-tpye decode
	wire [20:0] Jtype_Imm;
	wire [31:0] Jtype_Ext;

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
			OpAE<=OpAD;
			OpBE<=OpBD;
			rs2E
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
				Ext_Result=Itype_Ext;
				
			end
			2'b01: begin
				Ext_Result=Stype_Ext
			end
			2'b10: begin
				Ext_Result=Utype_Ext;
				
			end
			2'b11: begin
				Ext_Result=Jtype_Ext;
			end
			default: begin
				Ext_Result=Itype_Ext;
			end
		endcase

		case(Inst_or_rs2)
			1'b0: begin
				OpBD=Ext_Result;
			end
			1'b1: begin
				OpBD=rs2D;
			end
			default: begin
				OpBD=rs2D;
			end
		endcase

	end

	assign PC=fetch_pc;
	assign instr_regD=instr;
	assign {funct7,adr2,adr1,funct3,rd,Opcode}=instr_regD;
	assign Itype_Imm=instr_regD[31:20];
	assign Stype_Imm={instr_regD[31:25],instr_regD[11:7]};
	assign Utype_Imm=instr_regD[31:12];
	assign Jtype_Imm={instr_regD[31],instr_regD[19:12],instr_regD[20],instr_regD[30:21]};
	assign Itype_Ext={20{Itype_Imm[11]},Itype_Imm};
	assign Stype_Ext={20{1'b0}, Stype_Imm};
	assign Utype_Ext={Utype_Imm,12{1'b0}};
	assign Jtype_Ext={11{Jtype_Imm[20]},Jtype_Imm,1'b0};
endmodule