// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Wed May 15 08:19:26 2019
// Host        : ubuntu running 64-bit Ubuntu 16.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/user/eecs151/3stage_riscv/hardware/src/memories/imem_blk_ram/imem_blk_ram_stub.v
// Design      : imem_blk_ram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.2" *)
module imem_blk_ram(clka, ena, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[3:0],addra[13:0],dina[31:0],clkb,addrb[13:0],doutb[31:0]" */;
  input clka;
  input ena;
  input [3:0]wea;
  input [13:0]addra;
  input [31:0]dina;
  input clkb;
  input [13:0]addrb;
  output [31:0]doutb;
endmodule
