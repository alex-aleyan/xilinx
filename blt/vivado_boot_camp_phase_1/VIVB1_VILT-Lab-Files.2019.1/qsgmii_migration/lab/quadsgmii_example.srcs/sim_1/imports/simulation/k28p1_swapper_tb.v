//------------------------------------------------------------------------------
// File       : k28p1_swapper_tb.v
// Author     : Xilinx Inc.
//------------------------------------------------------------------------------
// (c) Copyright 2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 
// 
// 
//------------------------------------------------------------------------------
// Description:The K28.1 swapper module swaps K28.1 characters received on port 0 
// with K28.5 as specified in the QSGMII specification.
//------------------------------------------------------------------------------


`timescale 1 ps/1 ps

module k28p1_swapper_tb (
                          data_8b_port0,
                          is_k_port0,
                          data_8b_port1,
                          is_k_port1,
                          data_8b_port2,
                          is_k_port2,
                          data_8b_port3,
                          is_k_port3,

                          decoder_8b_data_in,
                          decoder_is_k,

                          clk_500m,
                          clk_125m
                        );


  output [7:0] data_8b_port0;
  output       is_k_port0;

  output [7:0] data_8b_port1;
  output       is_k_port1;

  output [7:0] data_8b_port2;
  output       is_k_port2;

  output [7:0] data_8b_port3;
  output       is_k_port3;


  input  [7:0] decoder_8b_data_in;
  input        decoder_is_k;

  input        clk_500m;
  input        clk_125m;




  reg    [7:0] data_8b_port0;
  reg          is_k_port0;

  reg    [7:0] data_8b_port1;
  reg          is_k_port1;

  reg    [7:0] data_8b_port2;
  reg          is_k_port2;

  reg    [7:0] data_8b_port3;
  reg          is_k_port3;


  reg    [7:0] decoder_8b_data_in_ff;
  reg          decoder_is_k_ff;

  reg    [7:0] port0_data_ff;
  reg    [7:0] port1_data_ff;
  reg    [7:0] port2_data_ff;
  reg    [7:0] port3_data_ff;

  reg          port0_is_k_ff;
  reg          port1_is_k_ff;
  reg          port2_is_k_ff;
  reg          port3_is_k_ff;

  reg    [7:0] port0_data;
  reg    [7:0] port1_data;
  reg    [7:0] port2_data;
  reg    [7:0] port3_data;

  reg          port0_is_k;
  reg          port1_is_k;
  reg          port2_is_k;
  reg          port3_is_k;

  reg    [1:0] cntr;

  reg          is_k28p1_ff;




  wire         is_k28p1;




  initial
  begin
    data_8b_port0 = 8'h0;
    is_k_port0    = 1'h0;

    data_8b_port1 = 8'h0;
    is_k_port1    = 1'h0;

    data_8b_port2 = 8'h0;
    is_k_port2    = 1'h0;

    data_8b_port3 = 8'h0;
    is_k_port3    = 1'h0;


    decoder_8b_data_in_ff = 8'h0;
    decoder_is_k_ff       = 1'h0;

    port0_data_ff = 8'h0;
    port1_data_ff = 8'h0;
    port2_data_ff = 8'h0;
    port3_data_ff = 8'h0;

    port0_is_k_ff = 1'h0;
    port1_is_k_ff = 1'h0;
    port2_is_k_ff = 1'h0;
    port3_is_k_ff = 1'h0;

    port0_data = 8'h0;
    port1_data = 8'h0;
    port2_data = 8'h0;
    port3_data = 8'h0;

    port0_is_k = 1'h0;
    port1_is_k = 1'h0;
    port2_is_k = 1'h0;
    port3_is_k = 1'h0;

    cntr = 2'h0;

    is_k28p1_ff = 1'h0;
  end


  always @(posedge clk_500m)
  begin
    decoder_8b_data_in_ff <= decoder_8b_data_in;
    decoder_is_k_ff       <= decoder_is_k;
  end


  always @(posedge clk_500m)
  begin
    if(is_k28p1)
      cntr <= 2'h0;
    else
      cntr <= cntr + 'h1;
  end


  always @(posedge clk_500m)
  begin
    is_k28p1_ff <= is_k28p1;
  end


  always @(posedge clk_500m)
  begin
    if(cntr == 2'h0)
    begin
      port0_data_ff <= port0_data;
      port0_is_k_ff <= port0_is_k;
    end
  end


  always @(posedge clk_500m)
  begin
    if(cntr == 2'h1)
    begin
      port1_data_ff <= port1_data;
      port1_is_k_ff <= port1_is_k;
    end
  end


  always @(posedge clk_500m)
  begin
    if(cntr == 2'h2)
    begin
      port2_data_ff <= port2_data;
      port2_is_k_ff <= port2_is_k;
    end
  end


  always @(posedge clk_500m)
  begin
    if(cntr == 2'h3)
    begin
      port3_data_ff <= port3_data;
      port3_is_k_ff <= port3_is_k;
    end
  end


  always @*
  begin
    port0_data = port0_data_ff;
    port1_data = port1_data_ff;
    port2_data = port2_data_ff;
    port3_data = port3_data_ff;

    port0_is_k = port0_is_k_ff;
    port1_is_k = port1_is_k_ff;
    port2_is_k = port2_is_k_ff;
    port3_is_k = port3_is_k_ff;

    case(cntr)
      2'h0:
      begin
        port0_data = is_k28p1_ff ? 8'hBC : decoder_8b_data_in_ff;
        port0_is_k = decoder_is_k_ff;
      end

      2'h1:
      begin
        port1_data = decoder_8b_data_in_ff;
        port1_is_k = decoder_is_k_ff;
      end

      2'h2:
      begin
        port2_data = decoder_8b_data_in_ff;
        port2_is_k = decoder_is_k_ff;
      end

      2'h3:
      begin
        port3_data = decoder_8b_data_in_ff;
        port3_is_k = decoder_is_k_ff;
      end
    endcase
  end


  always @(posedge clk_125m)
  begin
    data_8b_port0 <= port0_data;
    data_8b_port1 <= port1_data;
    data_8b_port2 <= port2_data;
    data_8b_port3 <= port3_data;

    is_k_port0    <= port0_is_k;
    is_k_port1    <= port1_is_k;
    is_k_port2    <= port2_is_k;
    is_k_port3    <= port3_is_k;
  end


  assign is_k28p1 = (~decoder_8b_data_in[7] & ~decoder_8b_data_in[6] &
                      decoder_8b_data_in[5] &  decoder_8b_data_in[4] &
                      decoder_8b_data_in[3] &  decoder_8b_data_in[2] &
                     ~decoder_8b_data_in[1] & ~decoder_8b_data_in[0]);

endmodule

