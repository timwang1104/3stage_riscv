`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module data_path
(
	input [`XLEN-1:0]  instr,
	input [`XLEN-1:0]  din,
	input clk,
	input reset,
	output [`XLEN-1:0] PCPlus4,
	output [`XLEN-1:0] mem_adr,
	output [`XLEN-1:0] mem_wdata,
	output [3:0]       wea,
	output             instr_stop
);

	wire [`XLEN-1:0] branch_result;
	wire [`XLEN-1:0] JResult; 
	wire [`XLEN-1:0] PCF;
	wire [`XLEN-1:0] rs1D, rs2D;
	wire [`XLEN-1:0] ALU_OutE;
	wire [`XLEN-1:0] mem_resultM;

	//decode
	wire [6:0] OpcodeD;
	wire [4:0] rdD;
	wire [2:0] funct3D;
	wire [4:0] adr1D;
	wire [4:0] adr2D;
	wire [6:0] funct7D;
	wire [`XLEN-1:0] immD;

	//mem
	wire [1:0] mem_sftE;

	//Control wires
	wire [1:0] PCSel;
	wire OpB_SelD;
	wire [1:0] OpA_SelD;
	wire Reg_WriteD;
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

	reg [6:0]       OpcodeE, OpcodeM;
	reg [`XLEN-1:0] fetch_pc;
	reg [`XLEN-1:0] PCD, PCE;
	reg [`XLEN-1:0] PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
	reg [`XLEN-1:0] instrD;


	//control signal stages
	reg OpB_SelE;
	reg [1:0] OpA_SelE;
	reg [4:0] ALU_CtlE;
	reg Reg_WriteE, Reg_WriteM, Reg_WriteW;
	reg [1:0] WB_SelE, WB_SelM, WB_SelW;
	reg [2:0] funct3E, funct3M;
	reg [6:0] funct7E;

	reg [`XLEN-1:0] forward_rs1D, forward_rs2D;
	reg [`XLEN-1:0] forward_rs1E, forward_rs2E;
	reg [`XLEN-1:0] rs1E, rs2E;
	reg [`XLEN-1:0] immE;
	reg [`XLEN-1:0] ALU_OpA, ALU_OpB;
	reg [`XLEN-1:0] ALU_OutM, ALU_OutW;
	reg [1:0]       mem_sftM;
	reg [`XLEN-1:0] mem_resultW;
	reg [`XLEN-1:0] WB_result;
	reg [4:0] adr1E;
	reg [4:0] adr2E;
	reg [4:0] rdE, rdM, rdW;
	reg jump_or_branch;


	//fetch
	always @(*) begin
		case(PCSel)
			2'b00: begin
				fetch_pc=PCPlus4F+4;
			end
			2'b01: begin
				fetch_pc=JResult;
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
				PCPlus4F<=PCPlus4F;
			end
			else begin
				PCPlus4F<=fetch_pc;
			end

			if(StallD) begin
				instrD       <= instrD;
				PCPlus4D     <= PCPlus4D;
			end	
			else begin
				if((PCSel==2'b01) || (PCSel==2'b10)) begin //flush if jump/branch is taken
					instrD         <= 32'd0;
					PCD            <= 32'd0;
					PCPlus4D       <= 32'd0;
					jump_or_branch <=1'b1;

				end
				else begin
					instrD   <= instr;
					PCD      <= PCF;
					PCPlus4D <= PCPlus4F;
					jump_or_branch <=1'b0;
				end
			end

			if(FlushE) begin
				OpcodeE      <= 7'd0;
				OpB_SelE     <= 1'b0;
				OpA_SelE     <= 2'd0;
				WB_SelE      <= 2'd0;
				Reg_WriteE   <= 1'b0;
				PCE          <= 32'd0;
				PCPlus4E     <= 32'd0;

				forward_rs1E <= 32'd0;
				forward_rs2E <= 32'd0;
				immE         <= 32'd0;

				funct3E      <= 3'd0;
				funct7E      <= 7'd0;
				ALU_CtlE     <= 5'd0;
				adr1E        <= 5'd0;
				adr2E        <= 5'd0;
				rdE          <= 5'd0;
			end
			else begin
				OpcodeE      <= OpcodeD;
				OpB_SelE     <= OpB_SelD;
				OpA_SelE     <= OpA_SelD;
				WB_SelE      <= WB_SelD;
				Reg_WriteE   <= Reg_WriteD;
				PCE          <= PCD;
				PCPlus4E     <= PCPlus4D;

				forward_rs1E <= forward_rs1D;
				forward_rs2E <= forward_rs2D;
				immE         <= immD;

				funct3E      <= funct3D;
				funct7E      <= funct7D;
				ALU_CtlE     <= ALU_CtlD;
				adr1E        <= adr1D;
				adr2E        <= adr2D;
				rdE          <= rdD;
			end

			OpcodeM          <= OpcodeE;
			funct3M          <= funct3E;
			ALU_OutM         <= ALU_OutE;
			mem_sftM         <= mem_sftE;
			PCPlus4M         <= PCPlus4E;
			WB_SelM          <= WB_SelE;
			Reg_WriteM       <= Reg_WriteE;
			rdM              <= rdE;

			PCPlus4W         <=PCPlus4M;
			mem_resultW      <=mem_resultM;
			ALU_OutW         <=ALU_OutM;
			WB_SelW          <=WB_SelM;
			Reg_WriteW       <=Reg_WriteM;
			rdW              <=rdM;
		end
	end
	
	//pre_decode
	pre_decoder m_pre_decoder(.instr(instrD),.Opcode(OpcodeD),.rd(rdD),.funct3(funct3D),.adr1(adr1D),.adr2(adr2D),.funct7(funct7D),.imm(immD));
	//decode
	reg_file m_reg_file(.clk(clk),.we(Reg_WriteW),.adr1(adr1D),.adr2(adr2D),.rd(rdW),.wd(WB_result),.rst(reset),.rs1(rs1D),.rs2(rs2D));
	
	//execute
	ALU m_ALU(.A(ALU_OpA),.B(ALU_OpB),.ALU_Ctl(ALU_CtlE), .funct7(funct7E) ,.ALU_Out(ALU_OutE));

	//memory
	store_mask_gen m_store_mask_gen(.Opcode(OpcodeE),.funct3(funct3E), .sft(mem_sftE),.wea(wea));
	data_alignment m_data_alignment(.din(din),.sft(mem_sftM),.funct3(funct3M),.dout(mem_resultM));

	branch_target m_branch_target(.BImm(immD),.PC(PCD),.rs1(forward_rs1D),.rs2(forward_rs2D),.funct3(funct3D),.branch(branchD),.BTarg(branch_result),.PCSel_bit1(PCSel_bit1));
	jump_target m_jump_target(.PC(PCD),.Imm(immD),.rs1(forward_rs1D),.jop(jopD),.JTarg(JResult));
	//hazard unit
	hazard_unit m_hazard_unit(.adr1D(adr1D),.adr2D(adr2D),.branchD(branchD), .jumpD(PCSel_bit0),.adr1E(adr1E),.adr2E(adr2E),.WB_SelE(WB_SelE),.RegWriteE(Reg_WriteE),.rdE(rdE),.rdM(rdM),.rdW(rdW),.RegWriteM(Reg_WriteM),.RegWriteW(Reg_WriteW),.StallF(StallF),.StallD(StallD),.Forward1D(Forward1D),.Forward2D(Forward2D),.Forward1E(Forward1E),.Forward2E(Forward2E),.FlushE(FlushE));
	control_path m_control_path(.Opcode(OpcodeD),.funct3(funct3D),.Inst_bit30(funct7D[5]),.Reg_Write(Reg_WriteD),.Inst_or_rs2(OpB_SelD),.OpA_Sel(OpA_SelD),.WB_Sel(WB_SelD),.PCSel_bit0(PCSel_bit0),.branch(branchD),.jop(jopD),.ALU_Ctl(ALU_CtlD));

	always @(*) begin
		case(Forward1D)
			2'b00: begin
				forward_rs1D=rs1D;
			end
			2'b01: begin
				forward_rs1D=WB_result;
			end
			2'b10: begin
				forward_rs1D=ALU_OutM;
			end
			// 2'b11: begin
			// 	forward_rs1D=ALU_OutE;
			// end
			default:begin
				forward_rs1D=32'd0;
			end				
		endcase

		case(Forward2D)
			2'b00: begin
				forward_rs2D=rs2D;
			end
			2'b01: begin
				forward_rs2D=WB_result;
			end
			2'b10: begin
				forward_rs2D=ALU_OutM;
			end
			// 2'b11: begin
			// 	forward_rs2D=ALU_OutE;
			// end
			default:begin
				forward_rs2D=32'd0;
			end				
		endcase

		case(Forward1E)
			2'b00: begin
				rs1E=forward_rs1E;
			end
			2'b01: begin
				rs1E=WB_result;
			end
			2'b10: begin
				rs1E=ALU_OutM;
			end
			default: begin
				rs1E=32'd0;
			end
		endcase

		case(Forward2E)
			2'b00: begin
				rs2E=forward_rs2E;
			end
			2'b01: begin
				rs2E=WB_result;
			end
			2'b10: begin
				rs2E=ALU_OutM;
			end
			default: begin
				rs2E=32'd0;
			end
		endcase

		case(OpA_SelE)
			2'b00: begin
				ALU_OpA=rs1E;
			end
			2'b01: begin
				ALU_OpA=PCE;
			end
			2'b10: begin
				ALU_OpA=32'd0;
			end
			default: begin
				ALU_OpA=32'd0;
			end
		endcase

		case(OpB_SelE)
			1'b0: begin
				ALU_OpB=immE;
			end
			1'b1: begin
				ALU_OpB=rs2E;
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
	assign PCF=PCPlus4F-4;
	assign PCSel={PCSel_bit1,PCSel_bit0};
	assign mem_sftE=ALU_OutE[1:0];


	//outputs
	assign mem_adr=ALU_OutE;
	assign mem_wdata=rs2E;
	assign PCPlus4=PCPlus4F;
	assign instr_stop=StallD||StallF||jump_or_branch;

endmodule