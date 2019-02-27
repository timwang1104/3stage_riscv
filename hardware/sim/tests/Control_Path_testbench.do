vlib work
vmap work work
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/testbenches/Control_Path_testbench.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/Control_Path.v"


vsim -novopt work.Control_Path_testbench
run 400000ns
