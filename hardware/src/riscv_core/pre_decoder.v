`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Opcode.vh"
module pre_decoder
(
	input  [`XLEN-1:0] instr,
	input  [6:0]       Opcode,
	output [4:0]       rd,
	output [2:0]       funct3,
	output [4:0]       adr1,
	output [4:0]       adr2,
	output [6:0]       funct7,
	output [`XLEN-1:0] imm
);


	
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

	//B-typte decode
	wire [11:0] Btype_Imm;
	wire [31:0] Btype_Ext;

	//reg addr decode
	wire [4:0]  rs1_addr;
	wire [4:0]  rs2_addr;
	wire [4:0]  rd_addr;

	//funct code decode
	wire [2:0] funct3_dat;
	wire [6:0] funct7_dat;
	wire [4:0] shamt_dat;

	reg [`XLEN-1:0] instr_reg;

	reg [4:0]       rd_reg;
	reg [2:0]       funct3_reg;
	reg [4:0]       adr1_reg;
	reg [4:0]       adr2_reg;
	reg [6:0]       funct7_reg;
	reg [`XLEN-1:0] imm_reg;

	always @(*) begin
		instr_reg=instr;

		case(Opcode)
			`OPC_LUI: begin
				rd_reg=rd_addr;
				funct3_reg=3'd0;
				adr1_reg=5'd0;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Utype_Ext;
			end
			`OPC_AUIPC: begin
				rd_reg=rd_addr;
				funct3_reg=3'd0;
				adr1_reg=5'd0;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Utype_Ext;			
			end
			`OPC_JAL: begin
				rd_reg=rd_addr;
				funct3_reg=3'd0;
				adr1_reg=5'd0;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Jtype_Ext;
			end
			`OPC_JALR: begin
				rd_reg=rd_addr;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Itype_Ext;
			end
			`OPC_BRANCH: begin
				rd_reg=5'd0;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=rs2_addr;
				funct7_reg=7'd0;
				imm_reg=Btype_Ext;			
			end
			`OPC_STORE: begin
				rd_reg=5'd0;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=rs2_addr;
				funct7_reg=7'd0;
				imm_reg=Stype_Ext;

			end
			`OPC_LOAD: begin
				rd_reg=rd_addr;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Itype_Ext;			
			end
			`OPC_ARI_RTYPE: begin
				rd_reg=rd_addr;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=rs2_addr;
				funct7_reg=funct7_dat;
				imm_reg=32'd0;				
			end
			`OPC_ARI_ITYPE: begin
				rd_reg=rd_addr;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=5'd0;
				if((funct3==3'b001)|| (funct3==3'b101)) begin
					funct7_reg=funct7_dat;
					imm_reg={{27{1'b0}},shamt_dat};	
				end
				else begin
					funct7_reg=7'd0;
					imm_reg=Itype_Ext;	
				end
			end
			default: begin //set default as R type
				rd_reg=rd_addr;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=rs2_addr;
				funct7_reg=funct7_dat;
				imm_reg=32'd0;
			end		
		endcase
	end
		
	//imm decode
	assign Itype_Imm=instr_reg[31:20];
	assign Stype_Imm={instr_reg[31:25],instr_reg[11:7]};
	assign Utype_Imm=instr_reg[31:12];
	assign Jtype_Imm={instr_reg[31],instr_reg[19:12],instr_reg[20],instr_reg[30:21]};
	assign Btype_Imm={instr_reg[31],instr_reg[7],instr_reg[30:25],instr_reg[11:8]};
	assign Itype_Ext={{20{Itype_Imm[11]}},Itype_Imm};
	assign Stype_Ext={{20{1'b0}}, Stype_Imm};
	assign Utype_Ext={Utype_Imm,{12{1'b0}}};
	assign Jtype_Ext={{11{Jtype_Imm[20]}},Jtype_Imm,1'b0};
	assign Btype_Ext={{19{Btype_Imm[11]}},Btype_Imm,1'b0};

	assign rs1_addr=instr_reg[19:15];
	assign rs2_addr=instr_reg[24:20];
	assign rd_addr=instr_reg[11:7];

	assign funct3_dat=instr_reg[14:12];
	assign funct7_dat=instr_reg[31:25];
	assign shamt_dat=instr_reg[24:20];

	//outputs
	assign rd=rd_reg;
	assign funct3=funct3_reg;
	assign adr1=adr1_reg;
	assign adr2=adr2_reg;
	assign funct7=funct7_reg;
	assign imm=imm_reg;

endmodule