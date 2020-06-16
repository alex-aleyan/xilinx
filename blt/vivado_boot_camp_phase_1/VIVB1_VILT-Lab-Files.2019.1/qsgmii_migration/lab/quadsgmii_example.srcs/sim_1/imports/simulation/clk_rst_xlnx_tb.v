//------------------------------------------------------------------------------
// File       : clk_rst_xlnx_tb.v
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
// Description: This module generates clocks and resets.
//------------------------------------------------------------------------------


`timescale 1 ps/1 ps

module clk_rst_xlnx_tb (
                         clk_5g,
                         clk_500m,
                         clk_125m_p,
                         clk_125m_n,
                         clk_2p5m,

                         rcvrd_clk_5g,
                         rcvrd_clk_500m,
                         rcvrd_clk_125m,

                         clk_200m,

                         gmii_phy_clk_125m,

                         clock_enable,

                         reset,

                         speed_is_10_100,
                         speed_is_100
                       );


    // parameter RCVRD_CLK_PERIOD = 200;

    // localparam RCVRD_CLK_HALF_PERIOD = RCVRD_CLK_PERIOD/2;
    parameter RCVRD_CLK_HALF_PERIOD = 100;



    output        clk_5g;
    output        clk_500m;
    output        clk_125m_p;
    output        clk_125m_n;
    output        clk_2p5m;

    output        rcvrd_clk_5g;
    output        rcvrd_clk_500m;
    output        rcvrd_clk_125m;

    output        clk_200m;

    output        gmii_phy_clk_125m;

    output [3 :0] clock_enable;

    output        reset;


    input  [3 :0] speed_is_10_100;
    input  [3 :0] speed_is_100;





    reg          clk_5g;
    reg          clk_500m;
    reg          clk_125m_p;
    reg          clk_125m_n;
    reg          clk_2p5m;

    reg          rcvrd_clk_5g;
    reg          rcvrd_clk_500m;
    reg          rcvrd_clk_125m;

    reg          clk_200m;

    reg          gmii_phy_clk_125m;

    reg          reset;

    reg [2 :0]   clk_500m_gen_cntr;
    reg          clk_125m_gen_cntr;
    reg [4 :0]   clk_2p5m_gen_cntr;

    reg [2 :0]   rcvrd_clk_500m_gen_cntr;
    reg          rcvrd_clk_125m_gen_cntr;

    
    wire [3 :0]  clock_enable;




    // Generate the 5GHz clock
    initial
    begin
      clk_5g = 1'h0;

      // forever #100000 clk_5g = ~clk_5g;
      forever #100 clk_5g = ~clk_5g;
    end


    initial
    begin
      clk_500m   = 1'h0;
      clk_125m_p = 1'h0;
      clk_125m_n = 1'h1;
      clk_2p5m   = 1'h0;

      clk_500m_gen_cntr = 3'h0;
      clk_125m_gen_cntr = 1'h0;
      clk_2p5m_gen_cntr = 5'h0;
    end


  // Generate the 500MHz clock from the 5GHz clock
  always @ (posedge clk_5g)
  begin
    if(clk_500m_gen_cntr == 3'h4)
    begin
      clk_500m          <= ~clk_500m;
      clk_500m_gen_cntr <= 3'h0;
    end
    else
      clk_500m_gen_cntr <= clk_500m_gen_cntr + 'h1;
  end


  // Generate the 125MHz clock from the 500MHz clock
  always @ (posedge clk_500m)
  begin
    if(clk_125m_gen_cntr == 1'h1)
    begin
      clk_125m_p        <= ~clk_125m_p;
      clk_125m_n        <= ~clk_125m_n;
      clk_125m_gen_cntr <= clk_125m_gen_cntr ^ 'h1;
    end
    else
      clk_125m_gen_cntr <= clk_125m_gen_cntr ^ 'h1;
  end


  // Generate the 2.5MHz clock from the 125MHz clock
  always @ (posedge clk_125m_p)
  begin
    if(clk_2p5m_gen_cntr == 5'h18)
    begin
      clk_2p5m          <= ~clk_2p5m;
      clk_2p5m_gen_cntr <= 5'h0;
    end
    else
      clk_2p5m_gen_cntr <= clk_2p5m_gen_cntr + 'h1;
  end


  // Generate the Asynchronous reset
  initial
  begin
    reset      = 1'h0;
    #100 reset = 1'h1;

    repeat (20) @(posedge clk_125m_p);
    reset = 1'h0;
  end


  // Generate the 5GHz recovered clock for the rx path
  initial
  begin
    rcvrd_clk_5g = 1'b0;

    forever #RCVRD_CLK_HALF_PERIOD rcvrd_clk_5g = ~rcvrd_clk_5g;
    // forever #99.98 rcvrd_clk_5g = ~rcvrd_clk_5g;
  end


  initial
  begin
    rcvrd_clk_500m = 1'h0;
    rcvrd_clk_125m = 1'h0;

    rcvrd_clk_500m_gen_cntr = 3'h0;
    rcvrd_clk_125m_gen_cntr = 1'h0;
  end


  // Generate the 500MHz clock from the 5GHz clock
  always @ (posedge rcvrd_clk_5g)
  begin
    if(rcvrd_clk_500m_gen_cntr == 3'h4)
    begin
      rcvrd_clk_500m          <= ~rcvrd_clk_500m;
      rcvrd_clk_500m_gen_cntr <= 3'h0;
    end
    else
      rcvrd_clk_500m_gen_cntr <= rcvrd_clk_500m_gen_cntr + 'h1;
  end


  // Generate the 125MHz clock from the 500MHz clock
  always @ (posedge rcvrd_clk_500m)
  begin
    if(rcvrd_clk_125m_gen_cntr == 1'h1)
    begin
      rcvrd_clk_125m          <= ~rcvrd_clk_125m;
      rcvrd_clk_125m_gen_cntr <= rcvrd_clk_125m_gen_cntr ^ 'h1;
    end
    else
      rcvrd_clk_125m_gen_cntr <= rcvrd_clk_125m_gen_cntr ^ 'h1;
  end

  
  // Generate the 200MHz clock
  initial
  begin
    clk_200m = 1'h0;

    forever #2500 clk_200m = ~clk_200m;
  end


  // Generate the 125MHz clock for GMII in Phy mode
  initial
  begin
    gmii_phy_clk_125m = 1'b0;

    forever #4000 gmii_phy_clk_125m = ~gmii_phy_clk_125m;
  end

  
  genvar kk;
  generate for(kk=0;kk<4;kk=kk+1)
  begin : clk_en_gen
    clk_en_gen_tb clk_en_gen_tb (
                                   .clock_enable     (clock_enable[kk]),
                                   .speed_is_100     (speed_is_100[kk]),
                                   .speed_is_10_100  (speed_is_10_100[kk]),

                                   .clk              (rcvrd_clk_125m)
                                );
  end
  endgenerate

endmodule

