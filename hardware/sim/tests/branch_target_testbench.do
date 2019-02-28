vlib work
vmap work work
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/testbenches/branch_target_testbench.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/branch_target.v"
vsim -novopt work.branch_target_testbench
add wave branch_target_testbench/*
run 1000ns
