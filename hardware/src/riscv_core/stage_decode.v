`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module stage_decode
(
	input              clk
	input              reset,
	input [`XLEN-1:0]  instrD,
	input [`XLEN-1:0]  pcD,
	//hazard unit 
	input              stallD,
	input [1:0]        forward1D,
	input [1:0]        forward2D,
	//write back 
	input              reg_writeW,
	input [4:0]        rdW,
	input [`XLEN-1:0]  wb_resultW,

	//execuit
	input [`XLEN-1:0]  alu_outM,

	output [1:0]       op_a_selD,
	output             op_b_selD,
	output [1:0]       wb_sel,
	output [`XLEN-1:0] pc_plus4D,
	output [`XLEN-1:0] pcD,
	output [`XLEN-1:0] forward_rs1D,
	output [`XLEN-1:0] forward_rs2D,

	//pre decoder signals
	output wire [6:0]       opcodeD,
	output wire [`XLEN-1:0] immD,
	output wire [2:0]       funct3D,
	output wire [6:0]       funct7D,
	output wire [4:0]       adr1D,
	output wire [4:0]       adr2D,
	output wire [4:0]       rdD

	//control signals
	output wire [4:0]       alu_ctlD,
	output wire             reg_writeD,
	output wire             inst_or_rs2D,
	output wire [1:0]       op_a_selD,
	output wire             wb_sel
);


    wire             pc_sel_bit0D;
    wire             branchD;
    wire             jopD;
	wire             mem_accessD;

	//hazard signals
	reg  [`XLEN-1:0] forward_rs1D;
	reg  [`XLEN-1:0] forward_rs2D;

	//branch target signals
	wire             pc_sel_bit1;


	always @(*) begin
		case(forward1D)
			2'b00: begin
				forward_rs1D=rs1D;
			end
			2'b01: begin
				forward_rs1D=wb_resultW;
			end
			2'b10: begin
				forward_rs1D=alu_outM;
			end
			default:begin
				forward_rs1D=32'd0;
			end				
		endcase

		case(forward2D)
			2'b00: begin
				forward_rs2D=rs2D;
			end
			2'b01: begin
				forward_rs2D=wb_resultW;
			end
			2'b10: begin
				forward_rs2D=alu_outM;
			end
			default:begin
				forward_rs2D=32'd0;
			end				
		endcase
	end

	mini_decode m_mini_decode(
		.instr(instrD),
		.opcodeD(opcodeD),
		.rd(rdD),
		.funct3(funct3D),
		.adr1(adr1D),
		.adr2(adr2D),
		.funct7(funct7D),
		.imm(immD),
		.reg_write(reg_writeD),
		.inst_or_rs2(inst_or_rs2D),
		.op_a_sel(op_a_selD),
		.wb_sel(wb_selD),
		.pc_sel_bit0(pc_sel_bit0D),
		.branch(branchD),
		.jop(jopD),
		.alu_ctl(alu_ctlD),
		.mem_access(mem_accessD)	
	);

	reg_file m_reg_file(
		.clk(clk),
		.we(reg_writeW),
		.adr1(adr1D),
		.adr2(adr2D),
		.rd(rdW),
		.wd(wb_result),
		.rst(reset),
		.rs1(rs1D),
		.rs2(rs2D)
	);

	branch_target m_branch_target(
		.BImm(immD),
		.PC(pcD),
		.rs1(forward_rs1D),
		.rs2(forward_rs2D),
		.funct3(funct3D),
		.branch(branchD),
		.BTarg(branch_result),
		.PCSel_bit1(pc_sel_bit1)
	);

	jump_target m_jump_target(
		.PC(pcD),
		.Imm(immD),
		.rs1(forward_rs1D),
		.jop(jopD),
		.JTarg(jump_result),
		.JTargPlus4(pc_plus4D)
	);

endmodule