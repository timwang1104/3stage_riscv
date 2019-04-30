module mini_decode
{
	input [`XLEN-1:0] instrD,
	//instruction format
	output [6:0]       opcodeD,
	output [4:0]       rd,
	output [2:0]       funct3,
	output [4:0]       adr1,
	output [4:0]       adr2,
	output [6:0]       funct7,
	output [`XLEN-1:0] imm

	//control signals
	output             reg_write,
    output             op_b_sel,
    output [1:0]       op_a_sel,
    output             wb_sel,
    output             pc_sel_bit0,
    output             branch,
    output             jop,
    output [4:0]       alu_ctl,
	output             mem_access	
}


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

	reg [6:0]       opcodeD_reg;
	reg [4:0]       rd_reg;
	reg [2:0]       funct3_reg;
	reg [4:0]       adr1_reg;
	reg [4:0]       adr2_reg;
	reg [6:0]       funct7_reg;
	reg [`XLEN-1:0] imm_reg;
	reg             mem_access_reg;

	reg ALU_Op_reg; 
    reg reg_write_reg;
    reg op_b_sel_reg;
    reg [1:0] op_a_sel_reg;
    reg wb_sel_reg;
    reg pc_sel_bit0_reg;
    reg branch_reg;
    reg jop_reg;
    reg [4:0] alu_ctl_reg;
	reg             mem_access_reg;

	always @(*) begin
		case(opcodeD_reg)
			`OPC_LUI: begin
				rd_reg=rd_addr;
				funct3_reg=3'd0;
				adr1_reg=5'd0;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Utype_Ext;

				reg_write_reg=1'b1;
				op_b_sel_reg=1'b0;
				op_a_sel_reg=2'b10;
				wb_sel_reg=2'b00;
				pc_sel_bit0_reg=1'b0;
				branch_reg=1'b0;
				jop_reg=1'b0;
				ALU_Op_reg=1'b0;
				mem_access_reg=1'b0;				
			end
			`OPC_AUIPC: begin
				rd_reg=rd_addr;
				funct3_reg=3'd0;
				adr1_reg=5'd0;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Utype_Ext;

				reg_write_reg=1'b1;
				op_b_sel_reg=1'b0;
				op_a_sel_reg=2'b01;
				wb_sel_reg=2'b00;
				pc_sel_bit0_reg=1'b0;
				branch_reg=1'b0;
				jop_reg=1'b0;
				ALU_Op_reg=1'b0;
				mem_access_reg=1'b0;
			end
			`OPC_JAL: begin
				rd_reg=rd_addr;
				funct3_reg=3'd0;
				adr1_reg=5'd0;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Jtype_Ext;

				reg_write_reg=1'b1;
				op_b_sel_reg=1'b0;
				op_a_sel_reg=2'b01;
				wb_sel_reg=2'b10;
				pc_sel_bit0_reg=1'b1;
				branch_reg=1'b0;
				jop_reg=1'b0;
				alu_ctl_reg=`ALU_ADD;
				ALU_Op_reg=1'b0;
				mem_access_reg=1'b0;
			end
			`OPC_JALR: begin
				rd_reg=rd_addr;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Itype_Ext;

				reg_write_reg=1'b1;
				op_b_sel_reg=1'b0;
				op_a_sel_reg=2'b00;
				wb_sel_reg=2'b10;
				pc_sel_bit0_reg=1'b1;
				branch_reg=1'b0;
				jop_reg=1'b1;
				alu_ctl_reg=`ALU_ADD;
				ALU_Op_reg=1'b0;
				mem_access_reg=1'b0;				
			end
			`OPC_BRANCH: begin
				rd_reg=5'd0;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=rs2_addr;
				funct7_reg=7'd0;
				imm_reg=Btype_Ext;

				reg_write_reg=1'b0;
				op_b_sel_reg=1'b0;
				op_a_sel_reg=2'b00;
				wb_sel_reg=2'b00;
				pc_sel_bit0_reg=1'b0;
				branch_reg=1'b1;
				jop_reg=1'b0;
				alu_ctl_reg=`ALU_ADD;
				ALU_Op_reg=1'b0;
				mem_access_reg=1'b0;				
			end
			`OPC_STORE: begin
				rd_reg=5'd0;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=rs2_addr;
				funct7_reg=7'd0;
				imm_reg=Stype_Ext;

				reg_write_reg=1'b0;
				op_b_sel_reg=1'b0;
				op_a_sel_reg=2'b00;
				wb_sel_reg=2'b00;
				pc_sel_bit0_reg=1'b0;
				branch_reg=1'b0;
				jop_reg=1'b0;
				ALU_Op_reg=1'b0;
				mem_access_reg=1'b1;
			end
			`OPC_LOAD: begin
				rd_reg=rd_addr;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=5'd0;
				funct7_reg=7'd0;
				imm_reg=Itype_Ext;

				reg_write_reg=1'b1;
				op_b_sel_reg=1'b0;
				op_a_sel_reg=2'b00;
				wb_sel_reg=2'b01;
				pc_sel_bit0_reg=1'b0;
				branch_reg=1'b0;
				jop_reg=1'b0;
				ALU_Op_reg=1'b0;
				mem_access_reg=1'b1;
			end
			`OPC_ARI_RTYPE: begin
				rd_reg=rd_addr;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=rs2_addr;
				funct7_reg=funct7_dat;
				imm_reg=32'd0;

				reg_write_reg=1'b1;
				op_b_sel_reg=1'b1;
				op_a_sel_reg=2'b00;
				wb_sel_reg=2'b00;
				pc_sel_bit0_reg=1'b0;
				branch_reg=1'b0;
				jop_reg=1'b0;
				ALU_Op_reg=1'b1;
				mem_access_reg=1'b0;
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

				reg_write_reg=1'b1;
				op_b_sel_reg=1'b0;
				op_a_sel_reg=2'b00;
				wb_sel_reg=2'b00;
				pc_sel_bit0_reg=1'b0;
				branch_reg=1'b0;
				jop_reg=1'b0;
				ALU_Op_reg=1'b1;
				mem_access_reg=1'b0;				
			end
			default: begin //set default as R type
				rd_reg=rd_addr;
				funct3_reg=funct3_dat;
				adr1_reg=rs1_addr;
				adr2_reg=rs2_addr;
				funct7_reg=funct7_dat;
				imm_reg=32'd0;

				reg_write_reg=1'b0;
				op_b_sel_reg=1'b0;
				op_a_sel_reg=2'b00;
				wb_sel_reg=2'b00;
				pc_sel_bit0_reg=1'b0;
				branch_reg=1'b0;
				jop_reg=1'b0;
				alu_ctl_reg=`ALU_ADD;
				ALU_Op_reg=1'b0;
				mem_access_reg=1'b0;
			end		
		endcase

		if(ALU_Op_reg) begin
			case(funct3)
				`FNC_ADD_SUB: begin
					if((instrD[30]==`FNC2_SUB) && (Opcode==`OPC_ARI_RTYPE)) begin
						alu_ctl_reg=`ALU_SUB;
					end
					else begin
						alu_ctl_reg=`ALU_ADD;
					end
				end
				`FNC_SLL: begin
					alu_ctl_reg=`ALU_SLL;
				end
				`FNC_SLT: begin
					alu_ctl_reg=`ALU_SLT;
				end
				`FNC_SLTU: begin
					alu_ctl_reg=`ALU_SLTU;
				end
				`FNC_XOR: begin
					alu_ctl_reg=`ALU_XOR;
				end
				`FNC_SRL_SRA: begin
					alu_ctl_reg=`ALU_SRL_SRA;
				end
				`FNC_OR: begin
					alu_ctl_reg=`ALU_OR;
				end
				`FNC_AND: begin
					alu_ctl_reg=`ALU_AND;
				end
				default: begin
					alu_ctl_reg=`ALU_ADD;
				end
			endcase
		end
		else begin
			alu_ctl_reg=`ALU_ADD;
		end

	end


	//opcode
	assign opcodeD_reg= instrD[6:0];

	//imm decode
	assign Itype_Imm=instrD[31:20];
	assign Stype_Imm={instrD[31:25],instrD[11:7]};
	assign Utype_Imm=instrD[31:12];
	assign Jtype_Imm={instrD[31],instrD[19:12],instrD[20],instrD[30:21]};
	assign Btype_Imm={instrD[31],instrD[7],instrD[30:25],instrD[11:8]};
	assign Itype_Ext={{20{Itype_Imm[11]}},Itype_Imm};
	assign Stype_Ext={{20{Stype_Imm[11]}}, Stype_Imm};
	assign Utype_Ext={Utype_Imm,{12{1'b0}}};
	assign Jtype_Ext={{11{Jtype_Imm[20]}},Jtype_Imm,1'b0};
	assign Btype_Ext={{19{Btype_Imm[11]}},Btype_Imm,1'b0};

	assign rs1_addr=instrD[19:15];
	assign rs2_addr=instrD[24:20];
	assign rd_addr=instrD[11:7];

	assign funct3_dat=instrD[14:12];
	assign funct7_dat=instrD[31:25];
	assign shamt_dat=instrD[24:20];

	//outputs
	assign opcodeD=opcodeD_reg;
	assign rd=rd_reg;
	assign funct3=funct3_reg;
	assign adr1=adr1_reg;
	assign adr2=adr2_reg;
	assign funct7=funct7_reg;
	assign imm=imm_reg;
	
	assign reg_write=reg_write_reg;
	assign op_b_sel=op_b_sel_reg;
	assign op_a_sel=op_a_sel_reg;
	assign wb_sel=wb_sel_reg;
	assign pc_sel_bit0=pc_sel_bit0_reg;
	assign branch=branch_reg;
	assign jop=jop_reg;
	assign alu_ctl=alu_ctl_reg;
	assign mem_access=mem_access_reg;

endmodule