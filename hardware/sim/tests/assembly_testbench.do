#start assembly_testbench
#file copy -force ../../../software/assembly_tests/assembly_tests.mif imem_blk_ram.mif
#file copy -force ../../../software/assembly_tests/assembly_tests.mif dmem_blk_ram.mif
#file copy -force ../../../software/assembly_tests/assembly_tests.mif bios_mem.mif

vlib work
vmap work work
file copy -force ../../../software/assembly_tests/assembly_tests.data bios_inst.data
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Riscv151.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/data_path.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/bios_sim.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/imem_sim.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/dmem_sim.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/mem_control.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/branch_target.v"
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
add wave assembly_testbench/CPU/m_data_path/PCF
add wave assembly_testbench/CPU/m_data_path/PCSel
add wave assembly_testbench/CPU/m_data_path/StallF
run 100us

