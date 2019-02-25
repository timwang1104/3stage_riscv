vlib work
vmap work work
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/testbenches/reg_file_testbench.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/reg_file.v"


vsim -novopt work.reg_file_testbench
add wave reg_file_testbench/*
add wave reg_file_testbench/DUT/reg_array
run 4000ns
