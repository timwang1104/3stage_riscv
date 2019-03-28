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

	wire [`XLEN-1:0] branch_result;
	wire [`XLEN-1:0] jump_result; 
	wire [`XLEN-1:0] PCPlus4D;
	wire [`XLEN-1:0] rs1D, rs2D;
	wire [`XLEN-1:0] ALU_OutE;
	wire [`XLEN-1:0] mem_resultM;

	//decode
	wire [6:0] OpcodeD;
	wire [4:0] rdD;
	wire [2:0] funct3D;
	wire [4:0] adr1D;
	wire [4:0] adr2D;
	wire [4:0] shamtD;
	wire [6:0] funct7D;
	wire [`XLEN-1:0] immD;

	//Control wires
	wire [1:0] PCSel;
	wire Reg_WriteD;
	wire Inst_or_rs2;
	wire [1:0] OpA_Sel;
	wire WB_SelD;
	wire PCSel_bit0, PCSel_bit1;
	wire branchD;
	wire [4:0] ALU_CtlD;

	//hazard wires
	wire       StallF;
	wire       StallD;
	wire [1:0] Forward1D;
	wire [1:0] Forward2D;
	wire [1:0] Forward1E;
	wire [1:0] Forward2E;
	wire       FlushE;


	reg [`XLEN-1:0] fetch_pc;
	reg [`XLEN-1:0] PCF, PCD;
	reg [`XLEN-1:0] PCPlus4E, PCPlus4M, PCPlus4W;
	
	reg [`XLEN-1:0] instrD;
	reg [4:0] ALU_CtlE;
	reg Reg_WriteE, Reg_WriteM, Reg_WriteW;
	reg [4:0] shamtE;
	reg [1:0] WB_SelE, WB_SelM, WB_SelW;
	reg [2:0] funct3E, funct3M;


	reg [`XLEN-1:0] ALU_OpA, ALU_OpB;
	reg [`XLEN-1:0] hazard_rs1D, hazard_rs2D;
	reg [`XLEN-1:0] rs2E, rs2M;
	reg [`XLEN-1:0] OpAD, OpAE;
	reg [`XLEN-1:0] OpBD, OpBE;
	reg [`XLEN-1:0] ALU_OutM, ALU_OutW;
	reg [`XLEN-1:0] mem_resultW;
	reg [`XLEN-1:0] WB_result;
	reg [4:0] adr1E;
	reg [4:0] adr2E;
	reg [4:0] rdE, rdM, rdW;


	//fetch
	always @(*) begin
		case(PCSel)
			2'b00: begin
				fetch_pc=PCF+4;
			end
			2'b01: begin
				fetch_pc=jump_result;
			end
			2'b10: begin
				fetch_pc=branch_result;
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
			end
			else begin
				if(StallD) begin
					instrD   <= instrD;
					PCD      <= PCD;
				end	
				else begin
					instrD   <= instr;
					PCD      <= PCF;
				end
			end

			if(FlushE) begin
				WB_SelE      <= 2'd0;
				Reg_WriteE   <= 1'b0;
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
				WB_SelE      <= WB_SelD;
				Reg_WriteE   <= Reg_WriteD;
				PCPlus4E     <= PCPlus4D;
				OpAE         <= OpAD;
				OpBE         <= OpBD;
				shamtE       <= shamtD;
				funct3E      <= funct3D;
				ALU_CtlE     <= ALU_CtlD;
				adr1E        <= adr1D;
				adr2E        <= adr2D;
				rdE          <= rdD;
				rs2E         <= hazard_rs2D;
			end

			funct3M          <= funct3E;
			ALU_OutM         <= ALU_OutE;
			PCPlus4M         <= PCPlus4E;
			WB_SelM          <= WB_SelE;
			Reg_WriteM       <= Reg_WriteE;
			rdM              <= rdE;
			rs2M             <= rs2E;

			PCPlus4W         <=PCPlus4M;
			mem_resultW      <=mem_resultM;
			ALU_OutW         <=ALU_OutM;
			WB_SelW          <=WB_SelM;
			Reg_WriteW       <=Reg_WriteM;
			rdW              <=rdM;
		end
	end
	
	//pre_decode
	pre_decoder m_pre_decoder(.instr(instrD),.Opcode(OpcodeD),.rd(rdD),.funct3(funct3D),.adr1(adr1D),.adr2(adr2D),.shamt(shamtD),.funct7(funct7D),.imm(immD));
	//decode
	reg_file m_reg_file(.clk(clk),.we(Reg_WriteW),.adr1(adr1D),.adr2(adr2D),.rd(rdW),.wd(WB_result),.rst(reset),.rs1(rs1D),.rs2(rs2D));
	

	control_path m_control_path(.Opcode(OpcodeD),.funct3(funct3D),.Inst_bit30(funct7D[5]),.Reg_Write(Reg_WriteD),.Inst_or_rs2(Inst_or_rs2),.OpA_Sel(OpA_Sel),.WB_Sel(WB_SelD),.PCSel_bit0(PCSel_bit0),.branch(branchD),.jop(jopD),.ALU_Ctl(ALU_CtlD));

	//execute
	ALU m_ALU(.A(ALU_OpA),.B(ALU_OpB),.shamt(shamtE),.ALU_Ctl(ALU_CtlE),.ALU_Out(ALU_OutE));

	//memory
	store_mask_gen m_store_mask_gen(.funct3(funct3M), .sft(ALU_OutM[1:0]),.wea(wea));
	data_alignment m_data_alignment(.din(din),.sft(ALU_OutM[1:0]),.funct3(funct3M),.dout(mem_resultM));

	branch_target m_branch_target(.BImm(immD),.PC(PCD),.rs1(hazard_rs1D),.rs2(hazard_rs2D),.funct3(funct3D),.branch(branchD),.BTarg(branch_result),.PCSel_bit1(PCSel_bit1));
	// jump_target m_jump_target(.PC(PCD),.JImm(immD),.rs1(hazard_rs1D),.jop(jopD),.JTarg(jump_result),.JTargPlus4(PCPlus4D));
	//hazard unit
	hazard_unit m_hazard_unit(.adr1D(adr1D),.adr2D(adr2D),.branchD(branchD), .jumpD(PCSel_bit0),.adr1E(adr1E),.adr2E(adr2E),.WB_SelE(WB_SelE),.RegWriteE(Reg_WriteE),.rdE(rdE),.rdM(rdM),.rdW(rdW),.RegWriteM(Reg_WriteM),.RegWriteW(Reg_WriteW),.StallF(StallF),.StallD(StallD),.Forward1D(Forward1D),.Forward2D(Forward2D),.Forward1E(Forward1E),.Forward2E(Forward2E),.FlushE(FlushE));

	always @(*) begin
		case(OpA_Sel)
			2'b00: begin
				OpAD=hazard_rs1D;
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

		case(Inst_or_rs2)
			1'b0: begin
				OpBD=immD;
			end
			1'b1: begin
				OpBD=hazard_rs2D;
			end
			default: begin
				OpBD=rs2D;
			end
		endcase

		case(Forward1D)
			2'b00: begin
				hazard_rs1D=rs1D;
			end
			2'b01: begin
				hazard_rs1D=WB_result;
			end
			2'b10: begin
				hazard_rs1D=ALU_OutM;
			end
			default:begin
				hazard_rs1D=32'd0;
			end
		endcase

		case(Forward2D)
			2'b00: begin
				hazard_rs2D=rs1D;
			end
			2'b01: begin
				hazard_rs2D=WB_result;
			end
			2'b10: begin
				hazard_rs2D=ALU_OutM;
			end
			default:begin
				hazard_rs2D=32'd0;
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

	assign OpcodeD=instrD[6:0];
	assign jump_target=ALU_OutM;
	assign PCPlus4F=PCF+4;
	assign PCSel={PCSel_bit1,PCSel_bit0};


	//outputs
	assign mem_adr=ALU_OutM;
	assign mem_wdata=rs2M;
	assign PC=fetch_pc;

endmodule