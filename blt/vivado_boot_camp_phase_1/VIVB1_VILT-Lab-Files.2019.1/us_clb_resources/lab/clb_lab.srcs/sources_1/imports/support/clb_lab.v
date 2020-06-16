//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2009 Xilinx Inc.
//
//  Project  : CLB Lab
//  Module   : clb_lab.v
//  Parent   : None
//  Children : None
//
//  Description: 
//     This is the rtl file for the CLB architecture lab.
//
//  Parameters:
//   None
//
//  Local Parameters:
//   None
//
//  Notes       : 
//
//  Multicycle and False Paths
//    None
//

`timescale 1ns/1ps

module clb_lab (
  input             clk,
  input             rst,
  input             cnt_en,
  output reg [31:0] cnt_out,
  output reg        tc_out
);

  reg [31:0] cnt;
  reg        cnt_en_d1;
  
  always @(posedge clk)
  begin
    if (rst)
    begin
      cnt         <= 32'b0;
      cnt_out     <= 32'b0;
      tc_out      <= 1'b0;
      cnt_en_d1   <= 1'b0;
    end
    else
    begin
      cnt_en_d1  <= cnt_en;

      if (cnt_en_d1)
      begin
             cnt <= cnt + 1'b1;
      end
      cnt_out <= cnt;
      tc_out  <= &cnt;
    end
  end
endmodule
