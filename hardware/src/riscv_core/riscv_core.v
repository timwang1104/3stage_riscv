`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"


module riscv_core
(
	input [`XLEN-1:0]  instr,
	input [`XLEN-1:0]  din,
	input clk,
	input rst,
	output [`XLEN-1:0] pc,
	output [`XLEN-1:0] mem_adr,
	output [`XLEN-1:0] mem_wdata,
	output [3:0]       wea,
	output             instr_stop,
	output             stallF
);

	wire [`XLEN-1:0] jump_result, branch_result;
	wire [`XLEN-1:0] instrF, pcF;
	wire [1:0]       pc_selD;
	wire             stallD;
	wire [`XLEN-1:0] instrD, pcD;
	wire [`XLEN-1:0] wb_resultW;
	wire [1:0]       forward1D, forward2D;
	wire [`XLEN-1:0] jump_result_plus4D, immD;
	wire [`XLEN-1:0] forward_rs1D, forward_rs2D;
	wire [6:0]       opcodeD;
	wire [2:0]       funct3D;
	wire [6:0]       funct7D;
	wire [4:0]       adr1D, adr2D, rdD;
	wire [4:0]       alu_ctlD;
	wire             reg_writeD;
	wire [1:0]       op_a_selD;
	wire             op_b_selD;
	wire             mem_accessD;
	wire [1:0]       wb_selD;
	wire [`XLEN-1:0] pcE;
	wire [`XLEN-1:0] jump_result_plus4E;
	wire [`XLEN-1:0] forward_rs1E;
	wire [`XLEN-1:0] forward_rs2E;

	wire [6:0]       opcodeE;
	wire [`XLEN-1:0] immE;
	wire [2:0]       funct3E;
	wire [6:0]       funct7E;
	wire [4:0]       adr1E;
	wire [4:0]       adr2E;
	wire [4:0]       rdE;

	wire [4:0]       alu_ctlE;
	wire             reg_writeE;
	wire [1:0]       op_a_selE;
	wire             op_b_selE;
	wire [1:0]       wb_selE;
	wire             mem_accessE;
	wire [`XLEN-1:0] alu_outE, alu_outM;
	wire [6:0]       opcodeM;
	wire [2:0]       funct3M;
	wire [`XLEN-1:0] forward_rs2M;
	wire [`XLEN-1:0] jump_result_plus4M;
	wire             mem_accessM;
	wire [1:0]       wb_selM;
	wire             reg_writeM;
	wire [4:0]       rdM;
	wire [`XLEN-1:0] mem_adrM;
	wire [`XLEN-1:0] mem_resultM;

	wire [4:0]       rdW;
	wire [`XLEN-1:0] jump_result_plus4W;
	wire [`XLEN-1:0] mem_resultW;
	wire [`XLEN-1:0] alu_outW;
	wire [1:0]       wb_selW;


	// wire             stallF;
	// wire             stallD;
	// wire [1:0]       forward1D;
	// wire [1:0]       forward2D;
	wire [1:0]       forward1E;
	wire [1:0]       forward2E;
	wire             flushE;

	stage_fetch m_stage_fetch(
		.clk(clk),
		.rst(rst),
		.stallF(stallF),
		.mem_data_in(instr),
		.jump_result(jump_result),
		.branch_result(branch_result),
		.pc_selD(pc_selD),
		.instrF(instrF),
		.pcF(pcF)
	);



	reg_fetch_decode m_fetch_decode(
		.clk(clk),
		.rst(rst),
		.pcF(pcF),
		.instrF(instrF),
		.stallD(stallD),
		.pc_selD(pc_selD),
		.pcD(pcD),
		.instrD(instrD)
	);

	stage_decode m_stage_decode(
		.clk(clk),
		.rst(rst),
		.instrD(instrD),
		.pcD(pcD),
		.stallD(stallD),
		.forward1D(forward1D),
		.forward2D(forward2D),

		.reg_writeW(reg_writeW),
		.rdW(rdW),
		.wb_resultW(wb_resultW),

		.alu_outM(alu_outM),
		.branch_result(branch_result),
		.jump_result(jump_result),
		.jump_result_plus4D(jump_result_plus4D),
		.forward_rs1D(forward_rs1D),
		.forward_rs2D(forward_rs2D),
		.opcodeD(opcodeD),
		.immD(immD),
		.funct3D(funct3D),
		.funct7D(funct7D),
		.adr1D(adr1D),
		.adr2D(adr2D),
		.rdD(rdD),
		.pc_selD(pc_selD),
		.alu_ctlD(alu_ctlD),
		.reg_writeD(reg_writeD),
		.op_a_selD(op_a_selD),
		.op_b_selD(op_b_selD),
		.mem_accessD(mem_accessD),
		.wb_selD(wb_selD)
	);



	reg_decode_execute m_reg_decode_execute(
		.clk(clk),
		.flushE(flushE),
		.pcD(pcD),
		.jump_result_plus4D(jump_result_plus4D),
		.forward_rs1D(forward_rs1D),
		.forward_rs2D(forward_rs2D),
		.opcodeD(opcodeD),
		.immD(immD),
		.funct3D(funct3D),
		.funct7D(funct7D),
		.adr1D(adr1D),
		.adr2D(adr2D),
		.rdD(rdD),
		.pc_selD(pc_selD),
		.alu_ctlD(alu_ctlD),
		.reg_writeD(reg_writeD),
		.inst_or_rs2D(inst_or_rs2D),
		.op_a_selD(op_a_selD),
		.op_b_selD(op_b_selD),
		.mem_accessD(mem_accessD),
		.wb_selD(wb_selD),
		.pcE(pcE),
		.jump_result_plus4E(jump_result_plus4E),
		.forward_rs1E(forward_rs1E),
		.forward_rs2E(forward_rs2E),
		.opcodeE(opcodeE),
		.immE(immE),
		.funct3E(funct3E),
		.funct7E(funct7E),
		.adr1E(adr1E),
		.adr2E(adr2E),
		.rdE(rdE),
		.alu_ctlE(alu_ctlE),
		.reg_writeE(reg_writeE),
		.op_a_selE(op_a_selE),
		.op_b_selE(op_b_selE),
		.wb_selE(wb_selE),
		.mem_accessE(mem_accessE)
	);


	stage_execute m_stage_execute(
		.forward1E(forward1E),
		.forward2E(forward2E),
		.wb_resultW(wb_resultW),
		.alu_outM(alu_outM),
		.pcE(pcE),
		.forward_rs1E(forward_rs1E),
		.forward_rs2E(forward_rs2E),
		.immE(immE),
		.funct7E(funct7E),
		.alu_ctlE(alu_ctlE),
		.op_a_selE(op_a_selE),
		.op_b_selE(op_b_selE),
		.alu_outE(alu_outE)
	);



	reg_execute_mem m_reg_execute_mem(
		.clk(clk),
		.opcodeE(opcodeE),
		.funct3E(funct3E),
		.alu_outE(alu_outE),
		.forward_rs2E(forward_rs2E),
		.jump_result_plus4E(jump_result_plus4E),
		.mem_accessE(mem_accessE),
		.wb_selE(wb_selE),
		.reg_writeE(reg_writeE),
		.rdE(rdE),
		.opcodeM(opcodeM),
		.funct3M(funct3M),
		.alu_outM(alu_outM),
		.forward_rs2M(forward_rs2M),
		.jump_result_plus4M(jump_result_plus4M),
		.mem_accessM(mem_accessM),
		.wb_selM(wb_selM),
		.reg_writeM(reg_writeM),
		.rdM(rdM)
	);



	stage_mem m_stage_mem(
		.alu_outM(alu_outM),
		.forward_rs2M(forward_rs2M),
		.opcodeM(opcodeM),
		.funct3M(funct3M),
		.mem_accessM(mem_accessM),
		.din(din),
		.mem_adrM(mem_adrM),
		.mem_wdata(mem_wdata),
		.wea(wea),
		.mem_resultM(mem_resultM)
	);

	reg_mem_wb m_reg_mem_wb(
		.clk(clk),
		.jump_result_plus4M(jump_result_plus4M),
		.mem_resultM(mem_resultM),
		.alu_outM(alu_outM),
		.wb_selM(wb_selM),
		.reg_writeM(reg_writeM),
		.rdM(rdM),
		.jump_result_plus4W(jump_result_plus4W),
		.mem_resultW(mem_resultW),
		.alu_outW(alu_outW),
		.wb_selW(wb_selW),
		.reg_writeW(reg_writeW),
		.rdW(rdW)
	);


	stage_wb m_stage_wb(
		.jump_result_plus4W(jump_result_plus4W),
		.mem_resultW(mem_resultW),
		.alu_outW(alu_outW),
		.wb_selW(wb_selW),
		.reg_writeW(reg_writeW),
		.rdW(rdW),
		.wb_resultW(wb_resultW)
	);

	hazard_unit m_hazard_unit(
		.rst(rst),
		.adr1D(adr1D),
		.adr2D(adr2D),
		.branchD(branchD),
		.jumpD(pc_selD[0]),
		.adr1E(adr1E),
		.adr2E(adr2E),
		.WB_SelE(wb_selE),
		.RegWriteE(reg_writeE),
		.rdE(rdE),
		.rdM(rdM),
		.rdW(rdW),
		.RegWriteM(reg_writeM),
		.RegWriteW(reg_writeW),
		.StallF(stallF),
		.StallD(stallD),
		.Forward1D(forward1D),
		.Forward2D(forward2D),
		.Forward1E(forward1E),
		.Forward2E(forward2E),
		.FlushE(flushE)
	);


endmodule