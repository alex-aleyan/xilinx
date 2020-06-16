// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Mon Oct 28 13:07:52 2019
// Host        : BLT-WKS-1909-11 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/training/7_series_IO_resources/completed/verilog/ioserdes.srcs/sources_1/ip/input_interface/input_interface_stub.v
// Design      : input_interface
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module input_interface(data_in_from_pins_p, data_in_from_pins_n, 
  data_in_to_device, delay_locked, ref_clock, bitslip, clk_in_p, clk_in_n, clk_div_out, 
  clk_reset, io_reset)
/* synthesis syn_black_box black_box_pad_pin="data_in_from_pins_p[0:0],data_in_from_pins_n[0:0],data_in_to_device[13:0],delay_locked,ref_clock,bitslip[0:0],clk_in_p,clk_in_n,clk_div_out,clk_reset,io_reset" */;
  input [0:0]data_in_from_pins_p;
  input [0:0]data_in_from_pins_n;
  output [13:0]data_in_to_device;
  output delay_locked;
  input ref_clock;
  input [0:0]bitslip;
  input clk_in_p;
  input clk_in_n;
  output clk_div_out;
  input clk_reset;
  input io_reset;
endmodule
