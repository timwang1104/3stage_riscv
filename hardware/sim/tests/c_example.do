vlib work
vmap work work
file copy -force ../../../software/c_example/c_example.data bios_inst.data
file copy -force ../../../software/c_example/dmem.data dmem_inst.data

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
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/branch_target.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/jump_target.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/pre_decoder.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/reg_file.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/ALU.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/data_alignment.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/hazard_unit.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/store_mask_gen.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/control_path.v"