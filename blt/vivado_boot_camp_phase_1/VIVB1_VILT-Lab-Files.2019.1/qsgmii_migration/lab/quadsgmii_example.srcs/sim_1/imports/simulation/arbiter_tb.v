
//------------------------------------------------------------------------------
// File       : arbiter_tb.v
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
// Description: The Arbiter module selects one byte from each instance of the send
// frame test bench and passes it on to the 8B/10B encoder module.
//------------------------------------------------------------------------------

`timescale 1 ps/1 ps

module arbiter_tb (
                 gmii_txd_ch0,
                 gmii_txd_ch1,
                 gmii_txd_ch2,
                 gmii_txd_ch3,
                 txcharisk,
                 txchardispmode,
                 txchardispval,

                 arb_gmii_txd,
                 arb_txcharisk,
                 arb_txchardispmode,
                 arb_txchardispval,

                 sync_reset,
                 clk
               );

    input  [7:0]  gmii_txd_ch0;
    input  [7:0]  gmii_txd_ch1;
    input  [7:0]  gmii_txd_ch2;
    input  [7:0]  gmii_txd_ch3;
    input  [3:0]  txcharisk;
    input  [3:0]  txchardispmode;
    input  [3:0]  txchardispval;

    input         sync_reset;
    input         clk;


    output [7:0]  arb_gmii_txd;
    output        arb_txcharisk;
    output        arb_txchardispmode;
    output        arb_txchardispval;




    reg    [7:0]  arb_gmii_txd;
    reg           arb_txcharisk;
    reg           arb_txchardispmode;
    reg           arb_txchardispval;

    reg    [1:0]  cntr;

    reg    [7:0]  arb_gmii_txd_nxt;
    reg           arb_txcharisk_nxt;
    reg           arb_txchardispmode_nxt;
    reg           arb_txchardispval_nxt;





    // Free running counter used to determine the
    // port number
    always @ (posedge clk)
    begin
      if(sync_reset)
        cntr <= 2'h0;
      else
        cntr <= cntr + 'h1;
    end


    // Sequential logic
    always @ (posedge clk)
    begin
      if(sync_reset)
      begin
        arb_gmii_txd       <= 8'h0;  
        arb_txcharisk      <= 1'h0;
        arb_txchardispmode <= 1'h0;
        arb_txchardispval  <= 1'h0;
      end
      else
      begin
        arb_gmii_txd       <= arb_gmii_txd_nxt;
        arb_txcharisk      <= arb_txcharisk_nxt;
        arb_txchardispmode <= arb_txchardispmode_nxt;
        arb_txchardispval  <= arb_txchardispval_nxt;
      end
    end




    // logic to determine the port from which the data is sent
    // to the encoder
    always @*
    begin
      arb_gmii_txd_nxt       = gmii_txd_ch0;
      arb_txcharisk_nxt      = txcharisk[0];
      arb_txchardispmode_nxt = txchardispmode[0];
      arb_txchardispval_nxt  = txchardispval[0];

      case(cntr)
        2'h0:
        begin
          arb_gmii_txd_nxt       = gmii_txd_ch0;
          arb_txcharisk_nxt      = txcharisk[0];
          arb_txchardispmode_nxt = txchardispmode[0];
          arb_txchardispval_nxt  = txchardispval[0];
        end

        2'h1:
        begin
          arb_gmii_txd_nxt       = gmii_txd_ch1;
          arb_txcharisk_nxt      = txcharisk[1];
          arb_txchardispmode_nxt = txchardispmode[1];
          arb_txchardispval_nxt  = txchardispval[1];
        end

        2'h2:
        begin
          arb_gmii_txd_nxt       = gmii_txd_ch2;
          arb_txcharisk_nxt      = txcharisk[2];
          arb_txchardispmode_nxt = txchardispmode[2];
          arb_txchardispval_nxt  = txchardispval[2];
        end

        2'h3:
        begin
          arb_gmii_txd_nxt       = gmii_txd_ch3;
          arb_txcharisk_nxt      = txcharisk[3];
          arb_txchardispmode_nxt = txchardispmode[3];
          arb_txchardispval_nxt  = txchardispval[3];
        end
      endcase
    end

endmodule

