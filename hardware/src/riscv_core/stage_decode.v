`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module stage_decode
(
	input               clk,
	input               rst,
	input [`XLEN-1:0]   instrD,
	input [`XLEN-1:0]   pc_plus4D,
	//hazard unit  
	input [1:0]         forward1D,
	input [1:0]         forward2D,
	//write back  
	input               reg_writeW,
	input [4:0]         rdW,
	input [`XLEN-1:0]   wb_resultW,
 
	//execuit 
	input [`XLEN-1:0]   alu_outM,

	output  [`XLEN-1:0] branch_result,
	output  [`XLEN-1:0] jump_result,
	output  [`XLEN-1:0] forward_rs1D,
	output  [`XLEN-1:0] forward_rs2D,

	//pre decoder signals
	output              branchD,
	output [6:0]        opcodeD,
	output [`XLEN-1:0]  immD,
	output [2:0]        funct3D,
	output [6:0]        funct7D,
	output [4:0]        adr1D,
	output [4:0]        adr2D,
	output [4:0]        rdD,
 
	//control signals 
	output [1:0]        pc_selD,
	output [4:0]        alu_ctlD,
	output              reg_writeD,
	output [1:0]        op_a_selD,
	output              op_b_selD,
	output              mem_accessD,
	output [1:0]        wb_selD
);


    // wire               branchD;
    wire               jopD;
  
    wire               pc_sel_bit0D;
	wire               pc_sel_bit1D;
	
	wire  [`XLEN-1:0]   rs1D;
	wire  [`XLEN-1:0]   rs2D;

	reg  [`XLEN-1:0]   forward_rs1D_reg;
	reg  [`XLEN-1:0]   forward_rs2D_reg;


	always @(*) begin
		case(forward1D)
			2'b00: begin
				forward_rs1D_reg=rs1D;
			end
			2'b01: begin
				forward_rs1D_reg=wb_resultW;
			end
			2'b10: begin
				forward_rs1D_reg=alu_outM;
			end
			default:begin
				forward_rs1D_reg=32'd0;
			end				
		endcase

		case(forward2D)
			2'b00: begin
				forward_rs2D_reg=rs2D;
			end
			2'b01: begin
				forward_rs2D_reg=wb_resultW;
			end
			2'b10: begin
				forward_rs2D_reg=alu_outM;
			end
			default:begin
				forward_rs2D_reg=32'd0;
			end				
		endcase
	end

	mini_decode m_mini_decode(
		.instrD(instrD),
		.opcodeD(opcodeD),
		.rd(rdD),
		.funct3(funct3D),
		.adr1(adr1D),
		.adr2(adr2D),
		.funct7(funct7D),
		.imm(immD),
		.reg_write(reg_writeD),
		.op_b_sel(op_b_selD),
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
		.wd(wb_resultW),
		.rst(rst),
		.rs1(rs1D),
		.rs2(rs2D)
	);

	branch_target m_branch_target(
		.BImm(immD),
		.pc_plus4D(pc_plus4D),
		.rs1(forward_rs1D_reg),
		.rs2(forward_rs2D_reg),
		.funct3(funct3D),
		.branch(branchD),
		.BTarg(branch_result),
		.PCSel_bit1(pc_sel_bit1D)
	);

	jump_target m_jump_target(
		.pc_plus4D(pc_plus4D),
		.Imm(immD),
		.rs1(forward_rs1D_reg),
		.jop(jopD),
		.JTarg(jump_result)
	);

	assign pc_selD={pc_sel_bit1D,pc_sel_bit0D};
	assign forward_rs1D=forward_rs1D_reg;
	assign forward_rs2D=forward_rs2D_reg;

endmodule