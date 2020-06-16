// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Mon Oct 28 13:07:51 2019
// Host        : BLT-WKS-1909-11 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/training/7_series_IO_resources/completed/verilog/ioserdes.srcs/sources_1/ip/output_clock/output_clock_stub.v
// Design      : output_clock
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module output_clock(data_out_from_device, data_out_to_pins_p, 
  data_out_to_pins_n, clk_in, io_reset)
/* synthesis syn_black_box black_box_pad_pin="data_out_from_device[1:0],data_out_to_pins_p[0:0],data_out_to_pins_n[0:0],clk_in,io_reset" */;
  input [1:0]data_out_from_device;
  output [0:0]data_out_to_pins_p;
  output [0:0]data_out_to_pins_n;
  input clk_in;
  input io_reset;
endmodule
