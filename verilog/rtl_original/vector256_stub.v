// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Thu Jul  2 20:22:23 2020
// Host        : NorliFive running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/Guy/X_projects/NeuroMem2018/NeuroMem2018.runs/vector256_synth_1/vector256_stub.v
// Design      : vector256
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.2" *)
module vector256(a, d, clk, we, spo)
/* synthesis syn_black_box black_box_pad_pin="a[7:0],d[7:0],clk,we,spo[7:0]" */;
  input [7:0]a;
  input [7:0]d;
  input clk;
  input we;
  output [7:0]spo;
endmodule
