
vlib work
vmap work work
file copy -force ../../../software/bios151v3/bios151v3.mif imem_blk_ram.mif
file copy -force ../../../software/bios151v3/bios151v3.mif dmem_blk_ram.mif
file copy -force ../../../software/bios151v3/bios151v3.mif bios_mem.mif

vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Riscv151.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/riscv_core.v"

vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/stage_fetch.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/stage_decode.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/stage_execute.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/stage_mem.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/stage_wb.v"

vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/reg_fetch_decode.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/reg_decode_execute.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/reg_execute_mem.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/reg_mem_wb.v"


vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/memories/bios_mem/simulation/blk_mem_gen_v8_4.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/memories/bios_mem/sim/bios_mem.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/memories/dmem_blk_ram/sim/dmem_blk_ram.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/memories/imem_blk_ram/sim/imem_blk_ram.v"

vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/mem_control.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/cycle_counter.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/instr_counter.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/io_control.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/branch_target.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/jump_target.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/mini_decode.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/reg_file.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/ALU.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/data_alignment.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/hazard_unit.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/store_mask_gen.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/testbenches/bios151v3_testbench.v"

vsim -novopt work.bios151v3_testbench


add wave bios151v3_testbench/*
add wave bios151v3_testbench/CPU/*
add wave bios151v3_testbench/CPU/m_mem_control/*
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_fetch/*
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_decode/*
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_decode/m_mini_decode/Jtype_Imm
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_decode/m_mini_decode/Jtype_Ext
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_decode/m_jump_target/*
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_decode/m_branch_target/*
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_decode/m_reg_file/reg_array
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_execute/*
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_mem/*
add wave bios151v3_testbench/CPU/m_riscv_core/m_stage_wb/*
add wave bios151v3_testbench/CPU/m_riscv_core/m_hazard_unit/*

add wave bios151v3_testbench/CPU/m_io_control/*
add wave bios151v3_testbench/off_chip_uart/*
#add wave bios151v3_testbench/off_chip_uart/uatransmit/clock_counter

#run 1500000ns
run 600000ns
