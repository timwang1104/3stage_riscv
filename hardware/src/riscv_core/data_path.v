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

	wire [`XLEN-1:0] PCPlus4;

	wire [`XLEN-1:0] Ext_Result;
	//R-type decode
	wire [6:0]Opcode;
	wire [4:0] rdD;
	wire [2:0] funct3;
	wire [4:0] adr1D;
	wire [4:0] adr2D;
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

	//B-typte decode;
	wire [11:0] Btype_Imm;
	wire [31:0] Btype_Ext;

	//Control wires
	wire Reg_Write;
	wire Inst_or_rs2;
	wire [1:0] Extend_Sel;
	wire [1:0] OpA_Sel;
	wire [4:0] shamtD;
	wire WB_Sel;
	wire PCSel_bit0, PCSel_bit1;
	wire branchD;
	wire [4:0] ALU_CtlD;

	//hazard wires
	wire       StallF;
	wire       StallD;
	wire       Forward1D;
	wire       Forward2D;
	wire [1:0] Forward1E;
	wire [1:0] Forward2E;
	wire       FlushE;

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
	reg funct3E, funct3M;


	reg [1:0] PCSel;
	reg [`XLEN-1:0] rs1D;
	reg [`XLEN-1:0] rs2D;
	reg [`XLEN-1:0] branch_rs1D;
	reg [`XLEN-1:0] branch_rs2D;
	reg [`XLEN-1:0] OpAD, OpAE;
	reg [`XLEN-1:0] OpBD, OpBE;
	reg [`XLEN-1:0] ALU_OutE, ALU_OutM, ALU_OutW;
	reg [`XLEN-1:0] mem_resultM, mem_resultW;
	reg [`XLEN-1:0] WB_result;
	reg [4:0] adr1E;
	reg [4:0] adr2E;
	reg [4:0] rdE, rdM, rdW;
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
			PCPlus4_regF<=fetch_pc+4;
			PC_regD<=PC_regF;
			PCPlus4_regD<=PCPlus4_regF;

			WB_SelE<=WB_Sel;
			PCPlus4_regE<=PCPlus4_regD;
			OpAE<=OpAD;
			OpBE<=OpBD;
			shamtE<=shamtD;
			funct3E<=funct3;
			ALU_CtlE<=ALU_CtlD;
			adr1E<=adr1D;
			adr2E<=adr2D;
			rdE<=rdD;

			funct3M<=funct3E;
			ALU_OutM<=ALU_OutE;
			PCPlus4_regM<=PCPlus4_regE;
			WB_SelM<=WB_SelE;
			rdM<=rdE;

			PCPlus4_regW<=PCPlus4_regM;
			mem_resultW<mem_resultM;
			ALU_OutW<=ALU_OutM;
			WB_SelW<=WBSelM;
			rdW<=rdM;
		end
	end
	
	//decode
	reg_file m_reg_file(.clk(clk),.we(Reg_WriteW),.adr1(adr1D),.adr2(adr2D),.rd(rdW),.wd(WB_result),.rs1(rs1D),.rs2(rs2D));
	control_path m_control_path(.Opcode(Opcode),.funct3(funct3),.Inst_bit30(instr_regD[30]),.Reg_Write(Reg_Write),.Inst_or_rs2(Inst_or_rs2),.Extend_Sel(Extend_Sel),.OpA_Sel(OpA_Sel),.shamt(shamtD),.WB_Sel(WB_Sel),.PCSel_bit0(PCSel_bit0),.branch(branchD),.ALU_Ctl(ALU_CtlD));

	//execute
	ALU m_ALU(.A(ALU_OpA),.B(ALU_OpB),.shamt(shamtE),.ALU_Ctl(ALU_CtlE),.ALU_Out(ALU_OutE));

	//memory
	store_mask_gen m_store_mask_gen(.funct3(funct3M), .sft(ALU_OutM[1:0]),.wea(wea));
	data_alignment m_data_alignment(.din(din),.sft(ALU_OutM[1:0]),.funct3(funct3M),.dout(mem_resultM));

	branch_target m_branch_target(.BImm(Btype_Ext),.PC(PC_regD),.rs1(branch_rs1D),.rs2(branch_rs2D),.funct3(funct3D),.branch(branchD),.BTarg(branch_target),.PCSel_bit1(PCSel_bit1));

	//hazard unit
	hazard_unit m_hazard_unit(.adr1D(adr1D),.adr2D(adr2D),.branchD(branchD),.adr1E(adr1E),.adr2E(adr2E),.WB_SelE(WB_SelE),.RegWriteE(Reg_WriteE),.rdE(rdE),.rdM(rdM),.rdW(rdW),.RegWriteM(Reg_WriteM),.RegWriteW(Reg_WriteW),.StallF(StallF),.StallD(StallD),.Forward1D(Forward1D),.Forward2D(Forward2D),.Forward1E(Forward1E),.Forward2E(Forward2E),.FlushE(FlushE));

	always @(*) begin
		case(OpA_Sel)
			2'b00: begin
				OpAD=rs1D;
			end
			2'b01: begin
				OpAD=PC_regD;
			end
			2'b10: begin
				OpAD=32'd0;
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
				Ext_Result=Stype_Ext;
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

		case(Forward1E)
			2'b00: begin
				ALU_OpA=OpAE;
			end
			2'b01: begin
				ALU_OpA=WB_result;
			end
			2'b10: begin
				ALU_OpA=ALU_OutM;
			end
			default: begin
				ALU_OpA=32'd0;
			end
		endcase

		case(Forward2E)
			2'b00: begin
				ALU_OpB=OpBE;
			end
			2'b01: begin
				ALU_OpB=WB_result;
			end
			2'b10: begin
				ALU_OpB=ALU_OutM;
			end
			default: begin
				ALU_OpB=32'd0;
			end
		endcase

		case(WB_SelW)
			2'b00: begin
				WB_result=ALU_OutW;
			end
			2'b01: begin
				WB_result=mem_resultW;
			end
			2'b10: begin
				WB_result=PCPlus4_regW;
			end
			default: begin
				WB_result=32'd0;
			end
		endcase
	end

	assign PC=fetch_pc;
	assign instr_regD=instr;
	assign {funct7,adr2D,adr1D,funct3D,rdD,Opcode}=instr_regD;
	assign PCSel={PCSel_bit1,PCSel_bit0};
	assign Itype_Imm=instr_regD[31:20];
	assign Stype_Imm={instr_regD[31:25],instr_regD[11:7]};
	assign Utype_Imm=instr_regD[31:12];
	assign Jtype_Imm={instr_regD[31],instr_regD[19:12],instr_regD[20],instr_regD[30:21]};
	assign Btype_Imm={instr_regD[31],instr_regD[7],instr_regD[30:25],instr_regD[11:8]};
	assign Itype_Ext={20{Itype_Imm[11]},Itype_Imm};
	assign Stype_Ext={20{1'b0}, Stype_Imm};
	assign Utype_Ext={Utype_Imm,12{1'b0}};
	assign Jtype_Ext={11{Jtype_Imm[20]},Jtype_Imm,1'b0};
	assign Btype_Ext={19{Btype_Imm[11]},Btype_Imm,1'b0};
	assign branch_rs1D = (Forward1D)?ALU_OutM:rs1D;
	assign branch_rs2D = (Forward2D)?ALU_OutM:rs2D;

endmodule