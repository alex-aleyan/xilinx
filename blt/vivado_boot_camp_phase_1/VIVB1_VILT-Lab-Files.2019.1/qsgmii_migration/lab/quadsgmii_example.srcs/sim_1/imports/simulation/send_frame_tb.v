//------------------------------------------------------------------------------
// File       : send_frame_tb.v
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
// Description:Send frame test bench generates the stimulus to excite the transceiver 
// on the DUT receive  side and data input on the DUT QSGMII adapt side. 
// Four instances of the send frame testbench are instantiated, 
// with each instance representing one channel.
//------------------------------------------------------------------------------


`timescale 1 ps/1 ps

module send_frame_tb (
                       output reg [7:0] gmii_txd,
                       output reg       gmii_tx_en,
                       output reg       gmii_tx_er,

                       output reg [7:0] rx_pdata,
                       output reg       rx_is_k,

                       // input         rx_rundisp_pos,

                       input            speed_is_10_100,
                       input            speed_is_100,

                       input            configuration_finished,

                       input            clock_enable,
                       input            sgmii_clk_en,

                       input            stim_tx_clk,
                       input            stim_rx_clk
                     );


  parameter INSTANCE_NUMBER = 0;

`define FRAME_TYP [8*74+74+74:1]

  // reg [7:0] gmii_txd;
  // reg       gmii_tx_en;
  // reg       gmii_tx_er;



  reg       rx_even;


  frame_typ_tb tx_stimulus_working_frame();
  frame_typ_tb rx_stimulus_working_frame();

  frame_typ_tb frame0();
  frame_typ_tb frame1();
  frame_typ_tb frame2();
  frame_typ_tb frame3();

  
  //----------------------------------------------------------------------------
  // Stimulus - Frame data
  //----------------------------------------------------------------------------
  // The following constant holds the stimulus for the testbench. It is
  // an ordered array of frames, with frame 0 the first to be injected
  // into the core by the testbench.
  //
  // This stimulus is used for both transmitter and receiver paths.
  //----------------------------------------------------------------------------
  initial
  begin
    // Frame 0...
    frame0.data[0]  = 8'h55;  frame0.valid[0]  = 1'b1;  frame0.error[0]  = 1'b0; // Preamble
    frame0.data[1]  = 8'h55;  frame0.valid[1]  = 1'b1;  frame0.error[1]  = 1'b0;
    frame0.data[2]  = 8'h55;  frame0.valid[2]  = 1'b1;  frame0.error[2]  = 1'b0;
    frame0.data[3]  = 8'h55;  frame0.valid[3]  = 1'b1;  frame0.error[3]  = 1'b0;
    frame0.data[4]  = 8'h55;  frame0.valid[4]  = 1'b1;  frame0.error[4]  = 1'b0;
    frame0.data[5]  = 8'h55;  frame0.valid[5]  = 1'b1;  frame0.error[5]  = 1'b0;
    frame0.data[6]  = 8'h55;  frame0.valid[6]  = 1'b1;  frame0.error[6]  = 1'b0;
    frame0.data[7]  = 8'hd5;  frame0.valid[7]  = 1'b1;  frame0.error[7]  = 1'b0; // SFD
    frame0.data[8]  = 8'hda;  frame0.valid[8]  = 1'b1;  frame0.error[8]  = 1'b0; // Destination Address (DA)
    frame0.data[9]  = 8'h02;  frame0.valid[9]  = 1'b1;  frame0.error[9]  = 1'b0;
    frame0.data[10] = 8'h03;  frame0.valid[10] = 1'b1;  frame0.error[10] = 1'b0;
    frame0.data[11] = 8'h04;  frame0.valid[11] = 1'b1;  frame0.error[11] = 1'b0;
    frame0.data[12] = 8'h05;  frame0.valid[12] = 1'b1;  frame0.error[12] = 1'b0;
    frame0.data[13] = 8'h06;  frame0.valid[13] = 1'b1;  frame0.error[13] = 1'b0;
    frame0.data[14] = 8'h5a;  frame0.valid[14] = 1'b1;  frame0.error[14] = 1'b0; // Source Address  (5A)
    frame0.data[15] = 8'h02;  frame0.valid[15] = 1'b1;  frame0.error[15] = 1'b0;
    frame0.data[16] = 8'h03;  frame0.valid[16] = 1'b1;  frame0.error[16] = 1'b0;
    frame0.data[17] = 8'h04;  frame0.valid[17] = 1'b1;  frame0.error[17] = 1'b0;
    frame0.data[18] = 8'h05;  frame0.valid[18] = 1'b1;  frame0.error[18] = 1'b0;
    frame0.data[19] = 8'h06;  frame0.valid[19] = 1'b1;  frame0.error[19] = 1'b0;
    frame0.data[20] = 8'h00;  frame0.valid[20] = 1'b1;  frame0.error[20] = 1'b0;
    frame0.data[21] = 8'h2e;  frame0.valid[21] = 1'b1;  frame0.error[21] = 1'b0; // Length/Type = Length = 46
    frame0.data[22] = 8'h01;  frame0.valid[22] = 1'b1;  frame0.error[22] = 1'b0;
    frame0.data[23] = 8'h02;  frame0.valid[23] = 1'b1;  frame0.error[23] = 1'b0; // Data
    frame0.data[24] = 8'h03;  frame0.valid[24] = 1'b1;  frame0.error[24] = 1'b0;
    frame0.data[25] = 8'h04;  frame0.valid[25] = 1'b1;  frame0.error[25] = 1'b0;
    frame0.data[26] = 8'h05;  frame0.valid[26] = 1'b1;  frame0.error[26] = 1'b0;
    frame0.data[27] = 8'h06;  frame0.valid[27] = 1'b1;  frame0.error[27] = 1'b0;
    frame0.data[28] = 8'h07;  frame0.valid[28] = 1'b1;  frame0.error[28] = 1'b0;
    frame0.data[29] = 8'h08;  frame0.valid[29] = 1'b1;  frame0.error[29] = 1'b0;
    frame0.data[30] = 8'h09;  frame0.valid[30] = 1'b1;  frame0.error[30] = 1'b0;
    frame0.data[31] = 8'h0a;  frame0.valid[31] = 1'b1;  frame0.error[31] = 1'b0;
    frame0.data[32] = 8'h0b;  frame0.valid[32] = 1'b1;  frame0.error[32] = 1'b0;
    frame0.data[33] = 8'h0c;  frame0.valid[33] = 1'b1;  frame0.error[33] = 1'b0;
    frame0.data[34] = 8'h0d;  frame0.valid[34] = 1'b1;  frame0.error[34] = 1'b0;
    frame0.data[35] = 8'h0e;  frame0.valid[35] = 1'b1;  frame0.error[35] = 1'b0;
    frame0.data[36] = 8'h0f;  frame0.valid[36] = 1'b1;  frame0.error[36] = 1'b0;
    frame0.data[37] = 8'h10;  frame0.valid[37] = 1'b1;  frame0.error[37] = 1'b0;
    frame0.data[38] = 8'h11;  frame0.valid[38] = 1'b1;  frame0.error[38] = 1'b0;
    frame0.data[39] = 8'h12;  frame0.valid[39] = 1'b1;  frame0.error[39] = 1'b0;
    frame0.data[40] = 8'h13;  frame0.valid[40] = 1'b1;  frame0.error[40] = 1'b0;
    frame0.data[41] = 8'h14;  frame0.valid[41] = 1'b1;  frame0.error[41] = 1'b0;
    frame0.data[42] = 8'h15;  frame0.valid[42] = 1'b1;  frame0.error[42] = 1'b0;
    frame0.data[43] = 8'h16;  frame0.valid[43] = 1'b1;  frame0.error[43] = 1'b0;
    frame0.data[44] = 8'h17;  frame0.valid[44] = 1'b1;  frame0.error[44] = 1'b0;
    frame0.data[45] = 8'h18;  frame0.valid[45] = 1'b1;  frame0.error[45] = 1'b0;
    frame0.data[46] = 8'h19;  frame0.valid[46] = 1'b1;  frame0.error[46] = 1'b0;
    frame0.data[47] = 8'h1a;  frame0.valid[47] = 1'b1;  frame0.error[47] = 1'b0;
    frame0.data[48] = 8'h1b;  frame0.valid[48] = 1'b1;  frame0.error[48] = 1'b0;
    frame0.data[49] = 8'h1c;  frame0.valid[49] = 1'b1;  frame0.error[49] = 1'b0;
    frame0.data[50] = 8'h1d;  frame0.valid[50] = 1'b1;  frame0.error[50] = 1'b0;
    frame0.data[51] = 8'h1e;  frame0.valid[51] = 1'b1;  frame0.error[51] = 1'b0;
    frame0.data[52] = 8'h1f;  frame0.valid[52] = 1'b1;  frame0.error[52] = 1'b0;
    frame0.data[53] = 8'h20;  frame0.valid[53] = 1'b1;  frame0.error[53] = 1'b0;
    frame0.data[54] = 8'h21;  frame0.valid[54] = 1'b1;  frame0.error[54] = 1'b0;
    frame0.data[55] = 8'h22;  frame0.valid[55] = 1'b1;  frame0.error[55] = 1'b0;
    frame0.data[56] = 8'h23;  frame0.valid[56] = 1'b1;  frame0.error[56] = 1'b0;
    frame0.data[57] = 8'h24;  frame0.valid[57] = 1'b1;  frame0.error[57] = 1'b0;
    frame0.data[58] = 8'h25;  frame0.valid[58] = 1'b1;  frame0.error[58] = 1'b0;
    frame0.data[59] = 8'h26;  frame0.valid[59] = 1'b1;  frame0.error[59] = 1'b0;
    frame0.data[60] = 8'h27;  frame0.valid[60] = 1'b1;  frame0.error[60] = 1'b0;
    frame0.data[61] = 8'h28;  frame0.valid[61] = 1'b1;  frame0.error[61] = 1'b0;
    frame0.data[62] = 8'h29;  frame0.valid[62] = 1'b1;  frame0.error[62] = 1'b0;
    frame0.data[63] = 8'h2a;  frame0.valid[63] = 1'b1;  frame0.error[63] = 1'b0;
    frame0.data[64] = 8'h2b;  frame0.valid[64] = 1'b1;  frame0.error[64] = 1'b0;
    frame0.data[65] = 8'h2c;  frame0.valid[65] = 1'b1;  frame0.error[65] = 1'b0;
    frame0.data[66] = 8'h2d;  frame0.valid[66] = 1'b1;  frame0.error[66] = 1'b0;
    frame0.data[67] = 8'h2e;  frame0.valid[67] = 1'b1;  frame0.error[67] = 1'b0;
    frame0.data[68] = 8'h14;  frame0.valid[68] = 1'b1;  frame0.error[68] = 1'b0; // FCS field
    frame0.data[69] = 8'h19;  frame0.valid[69] = 1'b1;  frame0.error[69] = 1'b0;
    frame0.data[70] = 8'hd1;  frame0.valid[70] = 1'b1;  frame0.error[70] = 1'b0;
    frame0.data[71] = 8'hdd;  frame0.valid[71] = 1'b1;  frame0.error[71] = 1'b0;
    frame0.data[72] = 8'h00;  frame0.valid[72] = 1'b0;  frame0.error[72] = 1'b0;
    frame0.data[73] = 8'h00;  frame0.valid[73] = 1'b0;  frame0.error[73] = 1'b0;

    // frame 1...
    frame1.data[0]  = 8'h55;  frame1.valid[0]  = 1'b1;  frame1.error[0]  = 1'b0; // Preamble
    frame1.data[1]  = 8'h55;  frame1.valid[1]  = 1'b1;  frame1.error[1]  = 1'b0;
    frame1.data[2]  = 8'h55;  frame1.valid[2]  = 1'b1;  frame1.error[2]  = 1'b0;
    frame1.data[3]  = 8'h55;  frame1.valid[3]  = 1'b1;  frame1.error[3]  = 1'b0;
    frame1.data[4]  = 8'h55;  frame1.valid[4]  = 1'b1;  frame1.error[4]  = 1'b0;
    frame1.data[5]  = 8'h55;  frame1.valid[5]  = 1'b1;  frame1.error[5]  = 1'b0;
    frame1.data[6]  = 8'h55;  frame1.valid[6]  = 1'b1;  frame1.error[6]  = 1'b0;
    frame1.data[7]  = 8'hd5;  frame1.valid[7]  = 1'b1;  frame1.error[7]  = 1'b0; // SFD
    frame1.data[8]  = 8'hda;  frame1.valid[8]  = 1'b1;  frame1.error[8]  = 1'b0; // Destination Address (DA)
    frame1.data[9]  = 8'h02;  frame1.valid[9]  = 1'b1;  frame1.error[9]  = 1'b0;
    frame1.data[10] = 8'h03;  frame1.valid[10] = 1'b1;  frame1.error[10] = 1'b0;
    frame1.data[11] = 8'h04;  frame1.valid[11] = 1'b1;  frame1.error[11] = 1'b0;
    frame1.data[12] = 8'h05;  frame1.valid[12] = 1'b1;  frame1.error[12] = 1'b0;
    frame1.data[13] = 8'h06;  frame1.valid[13] = 1'b1;  frame1.error[13] = 1'b0;
    frame1.data[14] = 8'h5a;  frame1.valid[14] = 1'b1;  frame1.error[14] = 1'b0; // Source Address  (5A)
    frame1.data[15] = 8'h02;  frame1.valid[15] = 1'b1;  frame1.error[15] = 1'b0;
    frame1.data[16] = 8'h03;  frame1.valid[16] = 1'b1;  frame1.error[16] = 1'b0;
    frame1.data[17] = 8'h04;  frame1.valid[17] = 1'b1;  frame1.error[17] = 1'b0;
    frame1.data[18] = 8'h05;  frame1.valid[18] = 1'b1;  frame1.error[18] = 1'b0;
    frame1.data[19] = 8'h06;  frame1.valid[19] = 1'b1;  frame1.error[19] = 1'b0;
    frame1.data[20] = 8'h80;  frame1.valid[20] = 1'b1;  frame1.error[20] = 1'b0;
    frame1.data[21] = 8'h00;  frame1.valid[21] = 1'b1;  frame1.error[21] = 1'b0; // Length/Type = Length = 8000
    frame1.data[22] = 8'h01;  frame1.valid[22] = 1'b1;  frame1.error[22] = 1'b0;
    frame1.data[23] = 8'h02;  frame1.valid[23] = 1'b1;  frame1.error[23] = 1'b0; // Data
    frame1.data[24] = 8'h03;  frame1.valid[24] = 1'b1;  frame1.error[24] = 1'b0;
    frame1.data[25] = 8'h04;  frame1.valid[25] = 1'b1;  frame1.error[25] = 1'b0;
    frame1.data[26] = 8'h05;  frame1.valid[26] = 1'b1;  frame1.error[26] = 1'b0;
    frame1.data[27] = 8'h06;  frame1.valid[27] = 1'b1;  frame1.error[27] = 1'b0;
    frame1.data[28] = 8'h07;  frame1.valid[28] = 1'b1;  frame1.error[28] = 1'b0;
    frame1.data[29] = 8'h08;  frame1.valid[29] = 1'b1;  frame1.error[29] = 1'b0;
    frame1.data[30] = 8'h09;  frame1.valid[30] = 1'b1;  frame1.error[30] = 1'b0;
    frame1.data[31] = 8'h0a;  frame1.valid[31] = 1'b1;  frame1.error[31] = 1'b0;
    frame1.data[32] = 8'h0b;  frame1.valid[32] = 1'b1;  frame1.error[32] = 1'b0;
    frame1.data[33] = 8'h0c;  frame1.valid[33] = 1'b1;  frame1.error[33] = 1'b0;
    frame1.data[34] = 8'h0d;  frame1.valid[34] = 1'b1;  frame1.error[34] = 1'b0;
    frame1.data[35] = 8'h0e;  frame1.valid[35] = 1'b1;  frame1.error[35] = 1'b0;
    frame1.data[36] = 8'h0f;  frame1.valid[36] = 1'b1;  frame1.error[36] = 1'b0;
    frame1.data[37] = 8'h10;  frame1.valid[37] = 1'b1;  frame1.error[37] = 1'b0;
    frame1.data[38] = 8'h11;  frame1.valid[38] = 1'b1;  frame1.error[38] = 1'b0;
    frame1.data[39] = 8'h12;  frame1.valid[39] = 1'b1;  frame1.error[39] = 1'b0;
    frame1.data[40] = 8'h13;  frame1.valid[40] = 1'b1;  frame1.error[40] = 1'b0;
    frame1.data[41] = 8'h14;  frame1.valid[41] = 1'b1;  frame1.error[41] = 1'b0;
    frame1.data[42] = 8'h15;  frame1.valid[42] = 1'b1;  frame1.error[42] = 1'b0;
    frame1.data[43] = 8'h16;  frame1.valid[43] = 1'b1;  frame1.error[43] = 1'b0;
    frame1.data[44] = 8'h17;  frame1.valid[44] = 1'b1;  frame1.error[44] = 1'b0;
    frame1.data[45] = 8'h18;  frame1.valid[45] = 1'b1;  frame1.error[45] = 1'b0;
    frame1.data[46] = 8'h19;  frame1.valid[46] = 1'b1;  frame1.error[46] = 1'b0;
    frame1.data[47] = 8'h1a;  frame1.valid[47] = 1'b1;  frame1.error[47] = 1'b0;
    frame1.data[48] = 8'h1b;  frame1.valid[48] = 1'b1;  frame1.error[48] = 1'b0;
    frame1.data[49] = 8'h1c;  frame1.valid[49] = 1'b1;  frame1.error[49] = 1'b0;
    frame1.data[50] = 8'h1d;  frame1.valid[50] = 1'b1;  frame1.error[50] = 1'b0;
    frame1.data[51] = 8'h1e;  frame1.valid[51] = 1'b1;  frame1.error[51] = 1'b0;
    frame1.data[52] = 8'h1f;  frame1.valid[52] = 1'b1;  frame1.error[52] = 1'b0;
    frame1.data[53] = 8'h20;  frame1.valid[53] = 1'b1;  frame1.error[53] = 1'b0;
    frame1.data[54] = 8'h21;  frame1.valid[54] = 1'b1;  frame1.error[54] = 1'b0;
    frame1.data[55] = 8'h22;  frame1.valid[55] = 1'b1;  frame1.error[55] = 1'b0;
    frame1.data[56] = 8'h23;  frame1.valid[56] = 1'b1;  frame1.error[56] = 1'b0;
    frame1.data[57] = 8'h24;  frame1.valid[57] = 1'b1;  frame1.error[57] = 1'b0;
    frame1.data[58] = 8'h25;  frame1.valid[58] = 1'b1;  frame1.error[58] = 1'b0;
    frame1.data[59] = 8'h26;  frame1.valid[59] = 1'b1;  frame1.error[59] = 1'b0;
    frame1.data[60] = 8'h27;  frame1.valid[60] = 1'b1;  frame1.error[60] = 1'b0;
    frame1.data[61] = 8'h28;  frame1.valid[61] = 1'b1;  frame1.error[61] = 1'b0;
    frame1.data[62] = 8'h29;  frame1.valid[62] = 1'b1;  frame1.error[62] = 1'b0;
    frame1.data[63] = 8'h2a;  frame1.valid[63] = 1'b1;  frame1.error[63] = 1'b0;
    frame1.data[64] = 8'h2b;  frame1.valid[64] = 1'b1;  frame1.error[64] = 1'b0;
    frame1.data[65] = 8'h2c;  frame1.valid[65] = 1'b1;  frame1.error[65] = 1'b0;
    frame1.data[66] = 8'h2d;  frame1.valid[66] = 1'b1;  frame1.error[66] = 1'b0;
    frame1.data[67] = 8'h2e;  frame1.valid[67] = 1'b1;  frame1.error[67] = 1'b0;
    frame1.data[68] = 8'h2f;  frame1.valid[68] = 1'b1;  frame1.error[68] = 1'b0;
    frame1.data[69] = 8'h33;  frame1.valid[69] = 1'b1;  frame1.error[69] = 1'b0; // FCS field
    frame1.data[70] = 8'ha9;  frame1.valid[70] = 1'b1;  frame1.error[70] = 1'b0;
    frame1.data[71] = 8'haf;  frame1.valid[71] = 1'b1;  frame1.error[71] = 1'b0;
    frame1.data[72] = 8'h1d;  frame1.valid[72] = 1'b1;  frame1.error[72] = 1'b0;
    frame1.data[73] = 8'h00;  frame1.valid[73] = 1'b0;  frame1.error[73] = 1'b0;

    // frame 2...
    frame2.data[0]  = 8'h55;  frame2.valid[0]  = 1'b1;  frame2.error[0]  = 1'b0; // Preamble
    frame2.data[1]  = 8'h55;  frame2.valid[1]  = 1'b1;  frame2.error[1]  = 1'b0;
    frame2.data[2]  = 8'h55;  frame2.valid[2]  = 1'b1;  frame2.error[2]  = 1'b0;
    frame2.data[3]  = 8'h55;  frame2.valid[3]  = 1'b1;  frame2.error[3]  = 1'b0;
    frame2.data[4]  = 8'h55;  frame2.valid[4]  = 1'b1;  frame2.error[4]  = 1'b0;
    frame2.data[5]  = 8'h55;  frame2.valid[5]  = 1'b1;  frame2.error[5]  = 1'b0;
    frame2.data[6]  = 8'h55;  frame2.valid[6]  = 1'b1;  frame2.error[6]  = 1'b0;
    frame2.data[7]  = 8'hd5;  frame2.valid[7]  = 1'b1;  frame2.error[7]  = 1'b0; // SFD
    frame2.data[8]  = 8'hda;  frame2.valid[8]  = 1'b1;  frame2.error[8]  = 1'b0; // Destination Address (DA)
    frame2.data[9]  = 8'h02;  frame2.valid[9]  = 1'b1;  frame2.error[9]  = 1'b0;
    frame2.data[10] = 8'h03;  frame2.valid[10] = 1'b1;  frame2.error[10] = 1'b0;
    frame2.data[11] = 8'h04;  frame2.valid[11] = 1'b1;  frame2.error[11] = 1'b0;
    frame2.data[12] = 8'h05;  frame2.valid[12] = 1'b1;  frame2.error[12] = 1'b0;
    frame2.data[13] = 8'h06;  frame2.valid[13] = 1'b1;  frame2.error[13] = 1'b0;
    frame2.data[14] = 8'h5a;  frame2.valid[14] = 1'b1;  frame2.error[14] = 1'b0; // Source Address  (5A)
    frame2.data[15] = 8'h02;  frame2.valid[15] = 1'b1;  frame2.error[15] = 1'b0;
    frame2.data[16] = 8'h03;  frame2.valid[16] = 1'b1;  frame2.error[16] = 1'b0;
    frame2.data[17] = 8'h04;  frame2.valid[17] = 1'b1;  frame2.error[17] = 1'b0;
    frame2.data[18] = 8'h05;  frame2.valid[18] = 1'b1;  frame2.error[18] = 1'b0;
    frame2.data[19] = 8'h06;  frame2.valid[19] = 1'b1;  frame2.error[19] = 1'b0;
    frame2.data[20] = 8'h00;  frame2.valid[20] = 1'b1;  frame2.error[20] = 1'b0;
    frame2.data[21] = 8'h2e;  frame2.valid[21] = 1'b1;  frame2.error[21] = 1'b0; // Length/Type = Length = 46
    frame2.data[22] = 8'h01;  frame2.valid[22] = 1'b1;  frame2.error[22] = 1'b0;
    frame2.data[23] = 8'h02;  frame2.valid[23] = 1'b1;  frame2.error[23] = 1'b0; // Data
    frame2.data[24] = 8'h03;  frame2.valid[24] = 1'b1;  frame2.error[24] = 1'b0;
    frame2.data[25] = 8'h04;  frame2.valid[25] = 1'b1;  frame2.error[25] = 1'b0;
    frame2.data[26] = 8'h05;  frame2.valid[26] = 1'b1;  frame2.error[26] = 1'b0;
    frame2.data[27] = 8'h06;  frame2.valid[27] = 1'b1;  frame2.error[27] = 1'b0;
    frame2.data[28] = 8'h07;  frame2.valid[28] = 1'b1;  frame2.error[28] = 1'b0;
    frame2.data[29] = 8'h08;  frame2.valid[29] = 1'b1;  frame2.error[29] = 1'b0;
    frame2.data[30] = 8'h09;  frame2.valid[30] = 1'b1;  frame2.error[30] = 1'b0;
    frame2.data[31] = 8'h0a;  frame2.valid[31] = 1'b1;  frame2.error[31] = 1'b0;
    frame2.data[32] = 8'h0b;  frame2.valid[32] = 1'b1;  frame2.error[32] = 1'b0;
    frame2.data[33] = 8'h0c;  frame2.valid[33] = 1'b1;  frame2.error[33] = 1'b0;
    frame2.data[34] = 8'h0d;  frame2.valid[34] = 1'b1;  frame2.error[34] = 1'b0;
    frame2.data[35] = 8'h0e;  frame2.valid[35] = 1'b1;  frame2.error[35] = 1'b0;
    frame2.data[36] = 8'h0f;  frame2.valid[36] = 1'b1;  frame2.error[36] = 1'b0;
    frame2.data[37] = 8'h10;  frame2.valid[37] = 1'b1;  frame2.error[37] = 1'b0;
    frame2.data[38] = 8'h11;  frame2.valid[38] = 1'b1;  frame2.error[38] = 1'b0;
    frame2.data[39] = 8'h12;  frame2.valid[39] = 1'b1;  frame2.error[39] = 1'b0;
    frame2.data[40] = 8'h13;  frame2.valid[40] = 1'b1;  frame2.error[40] = 1'b0;
    frame2.data[41] = 8'h14;  frame2.valid[41] = 1'b1;  frame2.error[41] = 1'b0;
    frame2.data[42] = 8'h15;  frame2.valid[42] = 1'b1;  frame2.error[42] = 1'b0;
    frame2.data[43] = 8'h16;  frame2.valid[43] = 1'b1;  frame2.error[43] = 1'b0;
    frame2.data[44] = 8'h17;  frame2.valid[44] = 1'b1;  frame2.error[44] = 1'b0;
    frame2.data[45] = 8'h18;  frame2.valid[45] = 1'b1;  frame2.error[45] = 1'b0;
    frame2.data[46] = 8'h19;  frame2.valid[46] = 1'b1;  frame2.error[46] = 1'b0;
    frame2.data[47] = 8'h1a;  frame2.valid[47] = 1'b1;  frame2.error[47] = 1'b1; // Signal an Error
    frame2.data[48] = 8'h1b;  frame2.valid[48] = 1'b1;  frame2.error[48] = 1'b0;
    frame2.data[49] = 8'h1c;  frame2.valid[49] = 1'b1;  frame2.error[49] = 1'b0;
    frame2.data[50] = 8'h1d;  frame2.valid[50] = 1'b1;  frame2.error[50] = 1'b0;
    frame2.data[51] = 8'h1e;  frame2.valid[51] = 1'b1;  frame2.error[51] = 1'b0;
    frame2.data[52] = 8'h1f;  frame2.valid[52] = 1'b1;  frame2.error[52] = 1'b0;
    frame2.data[53] = 8'h20;  frame2.valid[53] = 1'b1;  frame2.error[53] = 1'b0;
    frame2.data[54] = 8'h21;  frame2.valid[54] = 1'b1;  frame2.error[54] = 1'b0;
    frame2.data[55] = 8'h22;  frame2.valid[55] = 1'b1;  frame2.error[55] = 1'b0;
    frame2.data[56] = 8'h23;  frame2.valid[56] = 1'b1;  frame2.error[56] = 1'b0;
    frame2.data[57] = 8'h24;  frame2.valid[57] = 1'b1;  frame2.error[57] = 1'b0;
    frame2.data[58] = 8'h25;  frame2.valid[58] = 1'b1;  frame2.error[58] = 1'b0;
    frame2.data[59] = 8'h26;  frame2.valid[59] = 1'b1;  frame2.error[59] = 1'b0;
    frame2.data[60] = 8'h27;  frame2.valid[60] = 1'b1;  frame2.error[60] = 1'b0;
    frame2.data[61] = 8'h28;  frame2.valid[61] = 1'b1;  frame2.error[61] = 1'b0;
    frame2.data[62] = 8'h29;  frame2.valid[62] = 1'b1;  frame2.error[62] = 1'b0;
    frame2.data[63] = 8'h2a;  frame2.valid[63] = 1'b1;  frame2.error[63] = 1'b0;
    frame2.data[64] = 8'h2b;  frame2.valid[64] = 1'b1;  frame2.error[64] = 1'b0;
    frame2.data[65] = 8'h2c;  frame2.valid[65] = 1'b1;  frame2.error[65] = 1'b0;
    frame2.data[66] = 8'h2d;  frame2.valid[66] = 1'b1;  frame2.error[66] = 1'b0;
    frame2.data[67] = 8'h2e;  frame2.valid[67] = 1'b1;  frame2.error[67] = 1'b0;
    frame2.data[68] = 8'h14;  frame2.valid[68] = 1'b1;  frame2.error[68] = 1'b0; // FCS field
    frame2.data[69] = 8'h19;  frame2.valid[69] = 1'b1;  frame2.error[69] = 1'b0;
    frame2.data[70] = 8'hd1;  frame2.valid[70] = 1'b1;  frame2.error[70] = 1'b0;
    frame2.data[71] = 8'hdd;  frame2.valid[71] = 1'b1;  frame2.error[71] = 1'b0;
    frame2.data[72] = 8'h00;  frame2.valid[72] = 1'b0;  frame2.error[72] = 1'b0;
    frame2.data[73] = 8'h00;  frame2.valid[73] = 1'b0;  frame2.error[73] = 1'b0;

    // frame 3...
    frame3.data[0]  = 8'h55;  frame3.valid[0]  = 1'b1;  frame3.error[0]  = 1'b0; // Preamble
    frame3.data[1]  = 8'h55;  frame3.valid[1]  = 1'b1;  frame3.error[1]  = 1'b0;
    frame3.data[2]  = 8'h55;  frame3.valid[2]  = 1'b1;  frame3.error[2]  = 1'b0;
    frame3.data[3]  = 8'h55;  frame3.valid[3]  = 1'b1;  frame3.error[3]  = 1'b0;
    frame3.data[4]  = 8'h55;  frame3.valid[4]  = 1'b1;  frame3.error[4]  = 1'b0;
    frame3.data[5]  = 8'h55;  frame3.valid[5]  = 1'b1;  frame3.error[5]  = 1'b0;
    frame3.data[6]  = 8'h55;  frame3.valid[6]  = 1'b1;  frame3.error[6]  = 1'b0;
    frame3.data[7]  = 8'hd5;  frame3.valid[7]  = 1'b1;  frame3.error[7]  = 1'b0; // SFD
    frame3.data[8]  = 8'hda;  frame3.valid[8]  = 1'b1;  frame3.error[8]  = 1'b0; // Destination Address (DA)
    frame3.data[9]  = 8'h02;  frame3.valid[9]  = 1'b1;  frame3.error[9]  = 1'b0;
    frame3.data[10] = 8'h03;  frame3.valid[10] = 1'b1;  frame3.error[10] = 1'b0;
    frame3.data[11] = 8'h04;  frame3.valid[11] = 1'b1;  frame3.error[11] = 1'b0;
    frame3.data[12] = 8'h05;  frame3.valid[12] = 1'b1;  frame3.error[12] = 1'b0;
    frame3.data[13] = 8'h06;  frame3.valid[13] = 1'b1;  frame3.error[13] = 1'b0;
    frame3.data[14] = 8'h5a;  frame3.valid[14] = 1'b1;  frame3.error[14] = 1'b0; // Source Address  (5A)
    frame3.data[15] = 8'h02;  frame3.valid[15] = 1'b1;  frame3.error[15] = 1'b0;
    frame3.data[16] = 8'h03;  frame3.valid[16] = 1'b1;  frame3.error[16] = 1'b0;
    frame3.data[17] = 8'h04;  frame3.valid[17] = 1'b1;  frame3.error[17] = 1'b0;
    frame3.data[18] = 8'h05;  frame3.valid[18] = 1'b1;  frame3.error[18] = 1'b0;
    frame3.data[19] = 8'h06;  frame3.valid[19] = 1'b1;  frame3.error[19] = 1'b0;
    frame3.data[20] = 8'h00;  frame3.valid[20] = 1'b1;  frame3.error[20] = 1'b0;
    frame3.data[21] = 8'h03;  frame3.valid[21] = 1'b1;  frame3.error[21] = 1'b0; // Length/Type = Length = 3
    frame3.data[22] = 8'h01;  frame3.valid[22] = 1'b1;  frame3.error[22] = 1'b0;  // Therefore padding is required
    frame3.data[23] = 8'h02;  frame3.valid[23] = 1'b1;  frame3.error[23] = 1'b0;
    frame3.data[24] = 8'h03;  frame3.valid[24] = 1'b1;  frame3.error[24] = 1'b0;
    frame3.data[25] = 8'h00;  frame3.valid[25] = 1'b1;  frame3.error[25] = 1'b0;  // Padding (uses zero value bytes)
    frame3.data[26] = 8'h00;  frame3.valid[26] = 1'b1;  frame3.error[26] = 1'b0;
    frame3.data[27] = 8'h00;  frame3.valid[27] = 1'b1;  frame3.error[27] = 1'b0;
    frame3.data[28] = 8'h00;  frame3.valid[28] = 1'b1;  frame3.error[28] = 1'b0;
    frame3.data[29] = 8'h00;  frame3.valid[29] = 1'b1;  frame3.error[29] = 1'b0;
    frame3.data[30] = 8'h00;  frame3.valid[30] = 1'b1;  frame3.error[30] = 1'b0;
    frame3.data[31] = 8'h00;  frame3.valid[31] = 1'b1;  frame3.error[31] = 1'b0;
    frame3.data[32] = 8'h00;  frame3.valid[32] = 1'b1;  frame3.error[32] = 1'b0;
    frame3.data[33] = 8'h00;  frame3.valid[33] = 1'b1;  frame3.error[33] = 1'b0;
    frame3.data[34] = 8'h00;  frame3.valid[34] = 1'b1;  frame3.error[34] = 1'b0;
    frame3.data[35] = 8'h00;  frame3.valid[35] = 1'b1;  frame3.error[35] = 1'b0;
    frame3.data[36] = 8'h00;  frame3.valid[36] = 1'b1;  frame3.error[36] = 1'b0;
    frame3.data[37] = 8'h00;  frame3.valid[37] = 1'b1;  frame3.error[37] = 1'b0;
    frame3.data[38] = 8'h00;  frame3.valid[38] = 1'b1;  frame3.error[38] = 1'b0;
    frame3.data[39] = 8'h00;  frame3.valid[39] = 1'b1;  frame3.error[39] = 1'b0;
    frame3.data[40] = 8'h00;  frame3.valid[40] = 1'b1;  frame3.error[40] = 1'b0;
    frame3.data[41] = 8'h00;  frame3.valid[41] = 1'b1;  frame3.error[41] = 1'b0;
    frame3.data[42] = 8'h00;  frame3.valid[42] = 1'b1;  frame3.error[42] = 1'b0;
    frame3.data[43] = 8'h00;  frame3.valid[43] = 1'b1;  frame3.error[43] = 1'b0;
    frame3.data[44] = 8'h00;  frame3.valid[44] = 1'b1;  frame3.error[44] = 1'b0;
    frame3.data[45] = 8'h00;  frame3.valid[45] = 1'b1;  frame3.error[45] = 1'b0;
    frame3.data[46] = 8'h00;  frame3.valid[46] = 1'b1;  frame3.error[46] = 1'b0;
    frame3.data[47] = 8'h00;  frame3.valid[47] = 1'b1;  frame3.error[47] = 1'b0;
    frame3.data[48] = 8'h00;  frame3.valid[48] = 1'b1;  frame3.error[48] = 1'b0;
    frame3.data[49] = 8'h00;  frame3.valid[49] = 1'b1;  frame3.error[49] = 1'b0;
    frame3.data[50] = 8'h00;  frame3.valid[50] = 1'b1;  frame3.error[50] = 1'b0;
    frame3.data[51] = 8'h00;  frame3.valid[51] = 1'b1;  frame3.error[51] = 1'b0;
    frame3.data[52] = 8'h00;  frame3.valid[52] = 1'b1;  frame3.error[52] = 1'b0;
    frame3.data[53] = 8'h00;  frame3.valid[53] = 1'b1;  frame3.error[53] = 1'b0;
    frame3.data[54] = 8'h00;  frame3.valid[54] = 1'b1;  frame3.error[54] = 1'b0;
    frame3.data[55] = 8'h00;  frame3.valid[55] = 1'b1;  frame3.error[55] = 1'b0;
    frame3.data[56] = 8'h00;  frame3.valid[56] = 1'b1;  frame3.error[56] = 1'b0;
    frame3.data[57] = 8'h00;  frame3.valid[57] = 1'b1;  frame3.error[57] = 1'b0;
    frame3.data[58] = 8'h00;  frame3.valid[58] = 1'b1;  frame3.error[58] = 1'b0;
    frame3.data[59] = 8'h00;  frame3.valid[59] = 1'b1;  frame3.error[59] = 1'b0;
    frame3.data[60] = 8'h00;  frame3.valid[60] = 1'b1;  frame3.error[60] = 1'b0;
    frame3.data[61] = 8'h00;  frame3.valid[61] = 1'b1;  frame3.error[61] = 1'b0;
    frame3.data[62] = 8'h00;  frame3.valid[62] = 1'b1;  frame3.error[62] = 1'b0;
    frame3.data[63] = 8'h00;  frame3.valid[63] = 1'b1;  frame3.error[63] = 1'b0;
    frame3.data[64] = 8'h00;  frame3.valid[64] = 1'b1;  frame3.error[64] = 1'b0;
    frame3.data[65] = 8'h00;  frame3.valid[65] = 1'b1;  frame3.error[65] = 1'b0;
    frame3.data[66] = 8'h00;  frame3.valid[66] = 1'b1;  frame3.error[66] = 1'b0;
    frame3.data[67] = 8'h00;  frame3.valid[67] = 1'b1;  frame3.error[67] = 1'b0;
    frame3.data[68] = 8'h73;  frame3.valid[68] = 1'b1;  frame3.error[68] = 1'b0; // FCS field
    frame3.data[69] = 8'h00;  frame3.valid[69] = 1'b1;  frame3.error[69] = 1'b0;
    frame3.data[70] = 8'h75;  frame3.valid[70] = 1'b1;  frame3.error[70] = 1'b0;
    frame3.data[71] = 8'h22;  frame3.valid[71] = 1'b1;  frame3.error[71] = 1'b0;
    frame3.data[72] = 8'h00;  frame3.valid[72] = 1'b0;  frame3.error[72] = 1'b0;
    frame3.data[73] = 8'h00;  frame3.valid[73] = 1'b0;  frame3.error[73] = 1'b0;

  end


  //----------------------------------------------------------------------------
  // Tx stimulus process. This process will push frames of data into the
  // GMII transmitter side of the PCS/PMA core.
  //----------------------------------------------------------------------------

  //  A task to inject the current frame
  task tx_stimulus_send_frame;
    input   `FRAME_TYP frame;
    integer column_index;
    integer I;
  begin
    // import the frame into scratch space
    tx_stimulus_working_frame.frombits(frame);

    column_index = 0;
    gmii_txd   <= 8'h0;
    gmii_tx_en <= 1'b0;
    gmii_tx_er <= 1'b0;

    // loop over columns in frame.
    while (tx_stimulus_working_frame.valid[column_index] != 1'b0)
      begin
        gmii_txd   <= tx_stimulus_working_frame.data[column_index];
        gmii_tx_en <= tx_stimulus_working_frame.valid[column_index];
        gmii_tx_er <= tx_stimulus_working_frame.error[column_index];
        @(negedge stim_tx_clk);        // wait for next clock tick
        while (!sgmii_clk_en)
          @(negedge stim_tx_clk);
        column_index = column_index + 1;
      end

      // Clear the data lines.
      gmii_txd   <= 8'h0;
      gmii_tx_en <= 1'b0;
      gmii_tx_er <= 1'b0;

    for (I = 0; I < 12; I = I + 1)   // delay to create Inter Packet Gap.
    begin
      @(negedge stim_tx_clk);
      while(!sgmii_clk_en)
        @(negedge stim_tx_clk);
    end

     end
  endtask // tx_stimulus_send_frame


  // loop over all the frames in the stimulus vector
  initial
  begin : p_tx_stimulus

    gmii_txd   <= 8'h00;
    gmii_tx_en <= 1'b0;
    gmii_tx_er <= 1'b0;

    // Wait for the configuration process to finish
    wait (configuration_finished == 1);

    $display("Tx Stimulus %d: sending 4 frames ... ", INSTANCE_NUMBER);

    // Transmit four frames through the GMII transmit interface.
    //      -- frame 0 = standard frame
    //      -- frame 1 = type frame
    //      -- frame 2 = frame containing an error
    //      -- frame 3 = standard frame with padding

    @(negedge stim_tx_clk)
    while(!sgmii_clk_en)
      @(negedge stim_tx_clk);
    tx_stimulus_send_frame(frame0.tobits(0));
    tx_stimulus_send_frame(frame1.tobits(0));
    tx_stimulus_send_frame(frame2.tobits(0));
    tx_stimulus_send_frame(frame3.tobits(0));

  end // p_tx_stimulus


  // A task to create an Idle /I1/ code group
  task send_I1;
    begin
      rx_pdata  <= (INSTANCE_NUMBER == 0) ? 8'h3C : 8'hBC;  // /K28.5/
      rx_is_k   <= 1'b1;
      @(posedge stim_rx_clk);
      rx_pdata  <= 8'hC5;  // /D5.6/
      rx_is_k   <= 1'b0;
      @(posedge stim_rx_clk);
    end
  endtask // send_I1;

  // A task to create an Idle /I2/ code group
  task send_I2;
    begin
      rx_pdata  <= (INSTANCE_NUMBER == 0) ? 8'h3C : 8'hBC;  // /K28.5/
      rx_is_k   <= 1'b1;
      @(posedge stim_rx_clk);
      rx_pdata  <= 8'h50;  // /D16.2/
      rx_is_k   <= 1'b0;
      @(posedge stim_rx_clk);
    end
  endtask // send_I2;

  // A task to create a Start of Packet /S/ code group
  task send_S;
    begin
      rx_pdata  <= 8'hFB;  // /K27.7/
      rx_is_k   <= 1'b1;
      @(posedge stim_rx_clk);
    end
  endtask // send_S;

  // A task to create a Terminate /T/ code group
  task send_T;
    begin
      rx_pdata  <= 8'hFD;  // /K29.7/
      rx_is_k   <= 1'b1;
      @(posedge stim_rx_clk);
    end
  endtask // send_T;

  // A task to create a Carrier Extend /R/ code group
  task send_R;
    begin
      rx_pdata  <= 8'hF7;  // /K23.7/
      rx_is_k   <= 1'b1;
      @(posedge stim_rx_clk);
    end
  endtask // send_R;

  // A task to create an Error Propogation /V/ code group
  task send_V;
    begin
      rx_pdata  <= 8'hFE;  // /K30.7/
      rx_is_k   <= 1'b1;
      while (!clock_enable)
        @(posedge stim_rx_clk);
      @(posedge stim_rx_clk);
    end
  endtask // send_V;


  //  A task to inject the current frame
  task rx_stimulus_send_frame;
    input   `FRAME_TYP frame;
    integer column_index;
    integer I;
    begin
      // import the frame into scratch space
      rx_stimulus_working_frame.frombits(frame);

      //----------------------------------
      // Send a Start of Packet code group
      //----------------------------------
      send_S;

      //----------------------------------
      // Send frame data
      //----------------------------------
      column_index = 1;

      // loop over columns in frame
      while (rx_stimulus_working_frame.valid[column_index] != 1'b0) begin
        if (rx_stimulus_working_frame.error[column_index] == 1'b1)
          send_V; // insert an error propogation code group
        else
        begin
          rx_pdata <= rx_stimulus_working_frame.data[column_index];
          rx_is_k  <= 1'b0;
          while (!clock_enable)
            @(posedge stim_rx_clk);
          @(posedge stim_rx_clk);
        end
        column_index = column_index + 1;
      end // while

      //----------------------------------
      // Send a frame termination sequence
      //----------------------------------
      send_T;    // Terminate code group
      send_R;    // Carrier Extend code group

      // An extra Carrier Extend code group should be sent to end the frame
      // on an even boundary.
      if (rx_even == 1'b1)
        send_R;  // Carrier Extend code group

      //----------------------------------
      // Send an Inter Packet Gap.
      //----------------------------------
      // The initial Idle following a frame should be chosen to ensure
      // that the running disparity is returned to -ve.
      // if (rx_rundisp_pos == 1'b1)
        send_I1;  // /I1/ will flip the running disparity
      // else
      //   send_I2;  // /I2/ will maintain the running disparity

      // The remainder of the IPG is made up of /I2/ 's.
      // NOTE: the number 4 in the following calculations is made up
      //      from 2 bytes of the termination sequence and 2 bytes from
      //      the initial Idle.

      // 1Gb/s: 4 /I2/'s = 8 clock periods (12 - 4)
      if (!speed_is_10_100) begin
        for (I = 0; I < 4; I = I + 1)
          send_I1;
      end
      else begin
        // 100Mb/s: 58 /I2/'s = 116 clock periods (120 - 4)
        if (speed_is_100) begin
          for (I = 0; I < 58; I = I + 1)
            send_I1;
        end

        // 10Mb/s: 598 /I2/'s = 1196 clock periods (1200 - 4)
        else begin
          for (I = 0; I < 598; I = I + 1)
            send_I1;
        end
      end

    end
  endtask // rx_stimulus_send_frame;


  //----------------------------------------------------------------------------
  // A process to keep track of the even/odd code group position for the
  // injected receiver code groups.
  //----------------------------------------------------------------------------

  initial
  begin : p_rx_even_odd
    rx_even <= 1'b1;
    forever
    begin
      @(posedge stim_rx_clk)
      rx_even <= ! rx_even;
    end
  end // p_rx_even_odd

  
  //----------------------------------------------------------------------------
  // loop over all the frames in the stimulus vector
  //----------------------------------------------------------------------------
  initial
  begin : p_rx_stimulus

    // Initialise stimulus
    // rx_rundisp_pos <= 0;      // Initialise running disparity
    rx_pdata       <= (INSTANCE_NUMBER == 0) ? 8'h3C : 8'hBC;  // /K28.5/
    rx_is_k        <= 1'b1;

    // Wait for the Management MDIO transaction to finish.
    while (configuration_finished !== 1)
      send_I1;

    // Inject four frames into the receiver PHY interface
    //      -- frame 0 = standard frame
    //      -- frame 1 = type frame
    //      -- frame 2 = frame containing an error
    //      -- frame 3 = standard frame with padding
    $display("Rx Stimulus %d: sending 4 frames ...", INSTANCE_NUMBER);

    rx_stimulus_send_frame(frame0.tobits(0));
    rx_stimulus_send_frame(frame1.tobits(0));
    rx_stimulus_send_frame(frame2.tobits(0));
    rx_stimulus_send_frame(frame3.tobits(0));

    forever
      send_I1;

  end // p_rx_stimulus

endmodule

