#start echo_testbench
#file copy -force ../../../software/echo/echo.mif imem_blk_ram.mif
#file copy -force ../../../software/echo/echo.mif dmem_blk_ram.mif
#file copy -force ../../../software/echo/echo.mif bios_mem.mif


vlib work
vmap work work
file copy -force ../../../software/echo/echo.data imem_inst.data
file copy -force ../../../software/echo/echo.data bios_inst.data
file copy -force ../../../software/echo/echo.data dmem_inst.data
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/io_circuits/uart.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/io_circuits/uart_receiver.v"
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/io_circuits/uart_transmitter.v"

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
vlog -novopt -incr -work work "/home/user/eecs151/3stage_riscv/hardware/src/testbenches/echo_testbench.v"

vsim -novopt work.echo_testbench


#add wave echo_testbench/*
add wave echo_testbench/CPU/*

add wave echo_testbench/CPU/m_data_path/PCF
add wave echo_testbench/CPU/m_data_path/fetch_pc
add wave echo_testbench/CPU/m_data_path/instr
add wave echo_testbench/CPU/m_data_path/instrD
add wave echo_testbench/CPU/m_data_path/instrE

add wave echo_testbench/CPU/m_data_path/m_ALU/*

add wave echo_testbench/CPU/m_io_control/*
add wave echo_testbench/CPU/m_io_control/on_chip_uart/uatransmit/*

add wave echo_testbench/off_chip_uart/uareceive/*

add wave echo_testbench/CPU/m_data_path/m_reg_file/reg_array

#add wave echo_testbench/off_chip_uart/*
#add wave echo_testbench/off_chip_uart/uatransmit/clock_counter

run 600000ns
