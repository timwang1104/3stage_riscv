`include "defines.v"


module riscv_core
(
	input [`XLEN-1:0]  imem_instr,
	input [`XLEN-1:0]  bios_instr,
	input [1:0]        iload_sel,
	input [`XLEN-1:0]  din,
	input clk,
	input rst,
	output [`XLEN-1:0] pc_plus4F,
	output [`XLEN-1:0] pc_plus4M,
	output [`XLEN-1:0] mem_adrM,
	output [`XLEN-1:0] mem_wdataM,
	output [3:0]       wea,
	output             instr_stop,
	output             stallF
);

	(*mark_debug="true"*) wire [`XLEN-1:0] jump_result, branch_result;
	(*mark_debug="true"*) wire [`XLEN-1:0] instrF;
	(*mark_debug="true"*) wire             branchD;
	(*mark_debug="true"*) wire [1:0]       pc_selD;
	(*mark_debug="true"*) wire             stallD;
	(*mark_debug="true"*) wire [`XLEN-1:0] instrD, pc_plus4D;
	(*mark_debug="true"*) wire [`XLEN-1:0] wb_resultW;
	(*mark_debug="true"*) wire [1:0]       forward1D, forward2D;
	(*mark_debug="true"*) wire [`XLEN-1:0] immD;
	(*mark_debug="true"*) wire [`XLEN-1:0] forward_rs1D, forward_rs2D;
	(*mark_debug="true"*) wire [6:0]       opcodeD;
	(*mark_debug="true"*) wire [2:0]       funct3D;
	(*mark_debug="true"*) wire [6:0]       funct7D;
	(*mark_debug="true"*) wire [4:0]       adr1D, adr2D, rdD;
	(*mark_debug="true"*) wire [4:0]       alu_ctlD;
	(*mark_debug="true"*) wire             reg_writeD;
	(*mark_debug="true"*) wire [1:0]       op_a_selD;
	(*mark_debug="true"*) wire             op_b_selD;
	(*mark_debug="true"*) wire             mem_accessD;
	(*mark_debug="true"*) wire [1:0]       wb_selD;
	(*mark_debug="true"*) wire [`XLEN-1:0] pc_plus4E;
	(*mark_debug="true"*) wire [`XLEN-1:0] forward_rs1E;
	(*mark_debug="true"*) wire [`XLEN-1:0] forward_rs2E;

	(*mark_debug="true"*) wire [6:0]       opcodeE;
	(*mark_debug="true"*) wire [`XLEN-1:0] immE;
	(*mark_debug="true"*) wire [2:0]       funct3E;
	(*mark_debug="true"*) wire [6:0]       funct7E;
	(*mark_debug="true"*) wire [4:0]       adr1E;
	(*mark_debug="true"*) wire [4:0]       adr2E;
	(*mark_debug="true"*) wire [4:0]       rdE;

	(*mark_debug="true"*) wire [4:0]       alu_ctlE;
	(*mark_debug="true"*) wire             reg_writeE;
	(*mark_debug="true"*) wire [1:0]       op_a_selE;
	(*mark_debug="true"*) wire             op_b_selE;
	(*mark_debug="true"*) wire [1:0]       wb_selE;
	(*mark_debug="true"*) wire             mem_accessE;
	(*mark_debug="true"*) wire [`XLEN-1:0] rs2E, rs2M;
	(*mark_debug="true"*) wire [`XLEN-1:0] alu_outE, alu_outM;
	(*mark_debug="true"*) wire [6:0]       opcodeM;
	(*mark_debug="true"*) wire [2:0]       funct3M;
	(*mark_debug="true"*) wire [`XLEN-1:0] forward_rs2M;
	(*mark_debug="true"*) wire             mem_accessM;
	(*mark_debug="true"*) wire [1:0]       wb_selM;
	(*mark_debug="true"*) wire             reg_writeM;
	(*mark_debug="true"*) wire [4:0]       rdM;

	(*mark_debug="true"*) wire [`XLEN-1:0] mem_adrW;
	(*mark_debug="true"*) wire [`XLEN-1:0] pc_plus4W;
	(*mark_debug="true"*) wire [2:0]       funct3W;

	(*mark_debug="true"*) wire [4:0]       rdW;
	(*mark_debug="true"*) wire [`XLEN-1:0] alu_outW;
	(*mark_debug="true"*) wire [1:0]       wb_selW;

	(*mark_debug="true"*) wire [1:0]       forward1E;
	(*mark_debug="true"*) wire [1:0]       forward2E;
	(*mark_debug="true"*) wire             flushE;

	stage_fetch m_stage_fetch(
		.clk(clk),
		.rst(rst),
		.stallF(stallF),
		.imem_instr(imem_instr),
		.bios_instr(bios_instr),
		.iload_sel(iload_sel),
		.jump_result(jump_result),
		.branch_result(branch_result),
		.pc_selD(pc_selD),
		.instrF(instrF),
		.pc_plus4F(pc_plus4F)
	);



	reg_fetch_decode m_fetch_decode(
		.clk(clk),
		.rst(rst),
		.pc_plus4F(pc_plus4F),
		.instrF(instrF),
		.stallD(stallD),
		.pc_selD(pc_selD),
		.pc_plus4D(pc_plus4D),
		.instrD(instrD)
	);

	stage_decode m_stage_decode(
		.clk(clk),
		.rst(rst),
		.instrD(instrD),
		.pc_plus4D(pc_plus4D),
		.forward1D(forward1D),
		.forward2D(forward2D),

		.reg_writeW(reg_writeW),
		.rdW(rdW),
		.wb_resultW(wb_resultW),

		.alu_outM(alu_outM),
		.branchD(branchD),
		.branch_result(branch_result),
		.jump_result(jump_result),
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
		.pc_plus4D(pc_plus4D),
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
		.pc_plus4E(pc_plus4E),
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
		.pc_plus4E(pc_plus4E),
		.forward_rs1E(forward_rs1E),
		.forward_rs2E(forward_rs2E),
		.immE(immE),
		.funct7E(funct7E),
		.alu_ctlE(alu_ctlE),
		.op_a_selE(op_a_selE),
		.op_b_selE(op_b_selE),
		.rs2E(rs2E),
		.alu_outE(alu_outE)
	);



	reg_execute_mem m_reg_execute_mem(
		.clk(clk),
		.opcodeE(opcodeE),
		.funct3E(funct3E),
		.rs2E(rs2E),
		.alu_outE(alu_outE),
		.forward_rs2E(forward_rs2E),
		.pc_plus4E(pc_plus4E),
		.mem_accessE(mem_accessE),
		.wb_selE(wb_selE),
		.reg_writeE(reg_writeE),
		.rdE(rdE),
		.opcodeM(opcodeM),
		.funct3M(funct3M),
		.pc_plus4M(pc_plus4M),
		.rs2M(rs2M),
		.alu_outM(alu_outM),
		.forward_rs2M(forward_rs2M),
		.mem_accessM(mem_accessM),
		.wb_selM(wb_selM),
		.reg_writeM(reg_writeM),
		.rdM(rdM)
	);



	stage_mem m_stage_mem(
		.alu_outM(alu_outM),
		.rs2M(rs2M),
		.opcodeM(opcodeM),
		.funct3M(funct3M),
		.mem_accessM(mem_accessM),
		.mem_adrM(mem_adrM),
		.mem_wdataM(mem_wdataM),
		.wea(wea)
	);

	reg_mem_wb m_reg_mem_wb(
		.clk(clk),
		.funct3M(funct3M),
		.mem_adrM(mem_adrM),
		.pc_plus4M(pc_plus4M),
		.alu_outM(alu_outM),
		.wb_selM(wb_selM),
		.reg_writeM(reg_writeM),
		.rdM(rdM),
		.funct3W(funct3W),
		.mem_adrW(mem_adrW),
		.pc_plus4W(pc_plus4W),
		.alu_outW(alu_outW),
		.wb_selW(wb_selW),
		.reg_writeW(reg_writeW),
		.rdW(rdW)
	);


	stage_wb m_stage_wb(
		.funct3W(funct3W),
		.mem_adrW(mem_adrW),
		.pc_plus4W(pc_plus4W),
		.din(din),
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
		.WB_SelM(wb_selM),
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

	assign instr_stop=stallD||stallF||(pc_selD==2'b01)||(pc_selD==2'b10);

endmodule