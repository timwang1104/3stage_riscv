#start assembly_testbench
#file copy -force ../../../software/assembly_tests/assembly_tests.mif imem_blk_ram.mif
#file copy -force ../../../software/assembly_tests/assembly_tests.mif dmem_blk_ram.mif
#file copy -force ../../../software/assembly_tests/assembly_tests.mif bios_mem.mif

vlib work
vmap work work
file copy -force ../../../software/assembly_tests/assembly_tests.data bios_inst.data
file copy -force ../../../software/assembly_tests/dmem.data dmem_inst.data
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Riscv151.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/data_path.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/bios_sim.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/imem_sim.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/dmem_sim.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/mem_control.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/cycle_counter.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/instr_counter.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/io_control.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/branch_target.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/jump_target.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/pre_decoder.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/reg_file.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/ALU.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/data_alignment.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/hazard_unit.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/store_mask_gen.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/control_path.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/testbenches/assembly_testbench.v"

vsim -novopt work.assembly_testbench


add wave assembly_testbench/*
add wave assembly_testbench/CPU/*
add wave assembly_testbench/CPU/m_dmem_sim/*
add wave assembly_testbench/CPU/m_bios_sim/*
#add wave assembly_testbench/CPU/m_mem_control/*
#add wave assembly_testbench/CPU/m_io_control/*
add wave assembly_testbench/CPU/m_io_control/m_cycle_counter/*
#add wave assembly_testbench/CPU/m_io_control/m_instr_counter/*
add wave assembly_testbench/CPU/m_data_path/PCSel
add wave assembly_testbench/CPU/m_data_path/StallF
add wave assembly_testbench/CPU/m_data_path/PCPlus4F
add wave assembly_testbench/CPU/m_data_path/PCPlus4D
add wave assembly_testbench/CPU/m_data_path/PCF
add wave assembly_testbench/CPU/m_data_path/PCD
add wave assembly_testbench/CPU/m_data_path/fetch_pc
add wave assembly_testbench/CPU/m_data_path/instr
add wave assembly_testbench/CPU/m_data_path/instrD
add wave assembly_testbench/CPU/m_data_path/Forward1D
add wave assembly_testbench/CPU/m_data_path/forward_rs1D
add wave assembly_testbench/CPU/m_data_path/rs1D
add wave assembly_testbench/CPU/m_data_path/WB_result
add wave assembly_testbench/CPU/m_data_path/ALU_OutM




#add wave assembly_testbench/CPU/m_data_path/m_jump_target/*
#add wave assembly_testbench/CPU/m_data_path/m_branch_target/*

add wave assembly_testbench/CPU/m_data_path/m_reg_file/reg_array

add wave assembly_testbench/CPU/m_data_path/m_ALU/*
#add wave assembly_testbench/CPU/m_data_path/m_pre_decoder/*
add wave assembly_testbench/CPU/m_data_path/m_hazard_unit/StallF


run 6000ns

