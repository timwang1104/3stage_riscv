vlib work
vmap work work
#file copy -force ../../../software/assembly_tests/assembly_tests.data bios_inst.data
#file copy -force ../../../software/assembly_tests/dmem.data dmem_inst.data

file copy -force ../../../software/assembly_tests/assembly_tests.mif imem_blk_ram.mif
file copy -force ../../../software/assembly_tests/assembly_tests.mif dmem_blk_ram.mif
file copy -force ../../../software/assembly_tests/assembly_tests.mif bios_mem.mif

vlog -novopt -incr -work work "Riscv151.v"
vlog -novopt -incr -work work "riscv_core.v"

vlog -novopt -incr -work work "stage_fetch.v"
vlog -novopt -incr -work work "stage_decode.v"
vlog -novopt -incr -work work "stage_execute.v"
vlog -novopt -incr -work work "stage_mem.v"
vlog -novopt -incr -work work "stage_wb.v"

vlog -novopt -incr -work work "reg_fetch_decode.v"
vlog -novopt -incr -work work "reg_decode_execute.v"
vlog -novopt -incr -work work "reg_execute_mem.v"
vlog -novopt -incr -work work "reg_mem_wb.v"

vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/memories/bios_mem/simulation/blk_mem_gen_v8_4.v"

vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/memories/bios_mem/sim/bios_mem.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/memories/dmem_blk_ram/sim/dmem_blk_ram.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/memories/imem_blk_ram/sim/imem_blk_ram.v"

vlog -novopt -incr -work work "mem_control.v"
vlog -novopt -incr -work work "cycle_counter.v"
vlog -novopt -incr -work work "instr_counter.v"
vlog -novopt -incr -work work "io_control.v"
vlog -novopt -incr -work work "branch_target.v"
vlog -novopt -incr -work work "jump_target.v"
vlog -novopt -incr -work work "mini_decode.v"
vlog -novopt -incr -work work "reg_file.v"
vlog -novopt -incr -work work "ALU.v"
vlog -novopt -incr -work work "data_alignment.v"
vlog -novopt -incr -work work "hazard_unit.v"
vlog -novopt -incr -work work "store_mask_gen.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/testbenches/assembly_testbench.v"

vsim -novopt work.assembly_testbench


add wave assembly_testbench/*
add wave assembly_testbench/CPU/*
add wave assembly_testbench/CPU/m_mem_control/*
add wave assembly_testbench/CPU/m_riscv_core/m_stage_fetch/*
add wave assembly_testbench/CPU/m_riscv_core/m_stage_decode/*
add wave assembly_testbench/CPU/m_riscv_core/m_stage_decode/m_mini_decode/imm_reg
add wave assembly_testbench/CPU/m_riscv_core/m_stage_decode/m_mini_decode/Jtype_Ext
add wave assembly_testbench/CPU/m_riscv_core/m_stage_decode/m_branch_target/*
add wave assembly_testbench/CPU/m_riscv_core/m_stage_decode/m_jump_target/*
add wave assembly_testbench/CPU/m_riscv_core/m_stage_decode/m_reg_file/reg_array
add wave assembly_testbench/CPU/m_riscv_core/m_stage_execute/*
add wave assembly_testbench/CPU/m_riscv_core/m_stage_mem/*
add wave assembly_testbench/CPU/m_riscv_core/m_stage_wb/*

#add wave assembly_testbench/CPU/m_dmem_sim/*
#add wave assembly_testbench/CPU/m_bios_sim/*
#add wave assembly_testbench/CPU/m_mem_control/*
add wave assembly_testbench/CPU/m_io_control/*
#add wave assembly_testbench/CPU/m_io_control/m_cycle_counter/*
#add wave assembly_testbench/CPU/m_io_control/m_instr_counter/*

run 6000ns

