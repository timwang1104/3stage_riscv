`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module data_path
(
	input [`XLEN-1:0]  instr,
	input [`XLEN-1:0]  din,
	input clk,
	input reset,
	output [`XLEN-1:0] PC,
	output [`XLEN-1:0] mem_adr,
	output [`XLEN-1:0] mem_wdata,
	output [3:0]       wea
);

	wire [`XLEN-1:0] branch_target;
	wire [`XLEN-1:0] jump_target; 
	wire [`XLEN-1:0] PCPlus4F;
	wire [`XLEN-1:0] rs1D, rs2D;
	wire [`XLEN-1:0] ALU_OutE;
	wire [`XLEN-1:0] mem_resultM;

	//R-type decode
	wire [6:0]Opcode;
	wire [4:0] rdD;
	wire [2:0] funct3D;
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
	wire [1:0] PCSel;
	wire Reg_Write;
	wire Inst_or_rs2;
	wire [1:0] Extend_Sel;
	wire [1:0] OpA_Sel;
	wire [4:0] shamtD;
	wire WB_SelD;
	wire PCSel_bit0D, PCSel_bit1;
	wire branchD;
	wire [4:0] ALU_CtlD;
	wire [`XLEN-1:0] branch_rs1D;
	wire [`XLEN-1:0] branch_rs2D;

	//hazard wires
	wire       StallF;
	wire       StallD;
	wire       Forward1D;
	wire       Forward2D;
	wire [1:0] Forward1E;
	wire [1:0] Forward2E;
	wire       FlushE;


	reg [`XLEN-1:0] Ext_Result;
	reg [`XLEN-1:0] fetch_pc;
	reg [`XLEN-1:0] PCF, PCD;
	reg [`XLEN-1:0] PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
	
	reg [`XLEN-1:0] instrD;
	reg [4:0] ALU_CtlE;
	reg Reg_WriteE, Reg_WriteM, Reg_WriteW;
	reg [4:0] shamtE;
	reg [1:0] WB_SelE, WB_SelM, WB_SelW;
	reg PCSel_bit0E, PCSel_bit0M, PCSel_bit0W;
	reg [2:0] funct3E, funct3M;


	reg [`XLEN-1:0] ALU_OpA, ALU_OpB;
	reg [`XLEN-1:0] rs2E, rs2M;
	reg [`XLEN-1:0] OpAD, OpAE;
	reg [`XLEN-1:0] OpBD, OpBE;
	reg [`XLEN-1:0] ALU_OutM, ALU_OutW;
	reg [`XLEN-1:0] mem_resultW;
	reg [`XLEN-1:0] WB_result;
	reg [4:0] adr1E;
	reg [4:0] adr2E;
	reg [4:0] rdE, rdM, rdW;

	// initial begin
	// 	fetch_pc=32'h4000_0000;
	// end

	//fetch
	always @(*) begin
		case(PCSel)
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
				fetch_pc=fetch_pc;
			end
		endcase

	end

	always @(posedge clk) begin
		if (reset) begin
			// reset
			fetch_pc<=32'h4000_0000;
		end
		else begin
			if(StallF) begin
				PCF<=PCF;
			end
			else begin
				PCF<=fetch_pc;

			end

			if(PCSel_bit1) begin
				instrD       <= 32'd0;
				PCD          <= 32'd0;
				PCPlus4D     <= 32'd0;
			end
			else begin
				if(StallD) begin
					instrD   <= instrD;
					PCD      <= PCD;
					PCPlus4D <= PCPlus4D;
				end	
				else begin
					instrD   <= instr;
					PCD      <= PCF;
					PCPlus4D <= PCPlus4F;
				end
			end

			if(FlushE) begin
				PCSel_bit0E  <= 1'd0;
				WB_SelE      <= 2'd0;
				PCPlus4E     <= 32'd0;
				OpAE         <= 32'd0;
				OpBE         <= 32'd0;
				shamtE       <= 5'd0;
				funct3E      <= 3'd0;
				ALU_CtlE     <= 5'd0;
				adr1E        <= 5'd0;
				adr2E        <= 5'd0;
				rdE          <= 5'd0;
				rs2E         <= 32'd0;

			end
			else begin
				PCSel_bit0E  <= PCSel_bit0D;
				WB_SelE      <= WB_SelD;
				PCPlus4E     <= PCPlus4D;
				OpAE         <= OpAD;
				OpBE         <= OpBD;
				shamtE       <= shamtD;
				funct3E      <= funct3D;
				ALU_CtlE     <= ALU_CtlD;
				adr1E        <= adr1D;
				adr2E        <= adr2D;
				rdE          <= rdD;
				rs2E         <= rs2D;
			end

			PCSel_bit0M      <= PCSel_bit0E;
			funct3M          <= funct3E;
			ALU_OutM         <= ALU_OutE;
			PCPlus4M         <= PCPlus4E;
			WB_SelM          <= WB_SelE;
			rdM              <= rdE;
			rs2M             <= rs2E;

			PCSel_bit0W      <= PCSel_bit0M;
			PCPlus4W         <=PCPlus4M;
			mem_resultW      <=mem_resultM;
			ALU_OutW         <=ALU_OutM;
			WB_SelW          <=WB_SelM;
			rdW              <=rdM;
		end
	end
	
	//decode
	reg_file m_reg_file(.clk(clk),.we(Reg_WriteW),.adr1(adr1D),.adr2(adr2D),.rd(rdW),.wd(WB_result),.rs1(rs1D),.rs2(rs2D));
	control_path m_control_path(.Opcode(Opcode),.funct3(funct3D),.Inst_bit30(instrD[30]),.Reg_Write(Reg_Write),.Inst_or_rs2(Inst_or_rs2),.Extend_Sel(Extend_Sel),.OpA_Sel(OpA_Sel),.shamt(shamtD),.WB_Sel(WB_SelD),.PCSel_bit0(PCSel_bit0D),.branch(branchD),.ALU_Ctl(ALU_CtlD));

	//execute
	ALU m_ALU(.A(ALU_OpA),.B(ALU_OpB),.shamt(shamtE),.ALU_Ctl(ALU_CtlE),.ALU_Out(ALU_OutE));

	//memory
	store_mask_gen m_store_mask_gen(.funct3(funct3M), .sft(ALU_OutM[1:0]),.wea(wea));
	data_alignment m_data_alignment(.din(din),.sft(ALU_OutM[1:0]),.funct3(funct3M),.dout(mem_resultM));

	branch_target m_branch_target(.BImm(Btype_Ext),.PC(PCD),.rs1(branch_rs1D),.rs2(branch_rs2D),.funct3(funct3D),.branch(branchD),.BTarg(branch_target),.PCSel_bit1(PCSel_bit1));

	//hazard unit
	hazard_unit m_hazard_unit(.adr1D(adr1D),.adr2D(adr2D),.branchD(branchD),.adr1E(adr1E),.adr2E(adr2E),.WB_SelE(WB_SelE),.RegWriteE(Reg_WriteE),.rdE(rdE),.rdM(rdM),.rdW(rdW),.RegWriteM(Reg_WriteM),.RegWriteW(Reg_WriteW),.StallF(StallF),.StallD(StallD),.Forward1D(Forward1D),.Forward2D(Forward2D),.Forward1E(Forward1E),.Forward2E(Forward2E),.FlushE(FlushE));

	always @(*) begin
		case(OpA_Sel)
			2'b00: begin
				OpAD=rs1D;
			end
			2'b01: begin
				OpAD=PCD;
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
				WB_result=PCPlus4W;
			end
			default: begin
				WB_result=32'd0;
			end
		endcase
	end

	assign jump_target=ALU_OutM;
	assign PCPlus4F=PCF+4;
	assign {funct7,adr2D,adr1D,funct3D,rdD,Opcode}=instrD;
	assign PCSel={PCSel_bit1,PCSel_bit0W};
	assign Itype_Imm=instrD[31:20];
	assign Stype_Imm={instrD[31:25],instrD[11:7]};
	assign Utype_Imm=instrD[31:12];
	assign Jtype_Imm={instrD[31],instrD[19:12],instrD[20],instrD[30:21]};
	assign Btype_Imm={instrD[31],instrD[7],instrD[30:25],instrD[11:8]};
	assign Itype_Ext={{20{Itype_Imm[11]}},Itype_Imm};
	assign Stype_Ext={{20{1'b0}}, Stype_Imm};
	assign Utype_Ext={Utype_Imm,{12{1'b0}}};
	assign Jtype_Ext={{11{Jtype_Imm[20]}},Jtype_Imm,1'b0};
	assign Btype_Ext={{19{Btype_Imm[11]}},Btype_Imm,1'b0};
	assign branch_rs1D = (Forward1D)?ALU_OutM:rs1D;
	assign branch_rs2D = (Forward2D)?ALU_OutM:rs2D;

	//outputs
	assign mem_adr=ALU_OutM;
	assign mem_wdata=rs2M;
	assign PC=PCF;

endmodule