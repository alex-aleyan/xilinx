//------------------------------------------------------------------------------
// File       : quadsgmii_qgmii_adapt.v
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
// Description: This is the top level entity for the QGMII adaptation
//              module.  This module instantiates 4 SGMII adaptaion 
//              modules.


`timescale 1 ps/1 ps


//------------------------------------------------------------------------------
// The module declaration for the SGMII adaptation logic.
//------------------------------------------------------------------------------

module quadsgmii_qsgmii_adapt
  (
    input            reset,            // Asynchronous reset for entire core.
    input            clk125m,          // Reference 125MHz clock.

  //-------------
  // Channel 0
  //-------------
    // Clock derivation
    //-----------------
    output           sgmii_clk_r_ch0,      // Clock to client MAC (125MHz, 12.5MHz or 1.25MHz) (to rising edge DDR) for Channel 0.
    output           sgmii_clk_f_ch0,      // Clock to client MAC (125MHz, 12.5MHz or 1.25MHz) (to falling edge DDR) for Channel 0.
    output           sgmii_clk_en_ch0,     // Clock enable to client MAC (125MHz, 12.5MHz or 1.25MHz) for Channel 0.

    // GMII Tx
    //--------
    input  [7:0]     gmii_txd_in_ch0,      // Transmit data from client MAC for Channel 0.
    input            gmii_tx_en_in_ch0,    // Transmit data valid signal from client MAC for Channel 0.
    input            gmii_tx_er_in_ch0,    // Transmit error signal from client MAC for Channel 0.
    output [7:0]     gmii_rxd_out_ch0,     // Received Data to client MAC for Channel 0.
    output           gmii_rx_dv_out_ch0,   // Received data valid signal to client MAC for Channel 0.
    output           gmii_rx_er_out_ch0,   // Received error signal to client MAC for Channel 0.

    // GMII Rx
    //--------
    input [7:0]      gmii_rxd_in_ch0,      // Received Data to client MAC for Channel 0.
    input            gmii_rx_dv_in_ch0,    // Received data valid signal to client MAC for Channel 0.
    input            gmii_rx_er_in_ch0,    // Received error signal to client MAC for Channel 0.
    output [7:0]     gmii_txd_out_ch0,     // Transmit data from client MAC for Channel 0.
    output           gmii_tx_en_out_ch0,   // Transmit data valid signal from client MAC for Channel 0.
    output           gmii_tx_er_out_ch0,   // Transmit error signal from client MAC for Channel 0.

    // Speed Control
    //--------------
    input            speed_is_10_100_ch0,  // Core should operate at either 10Mbps or 100Mbps speeds for Channel 0
    input            speed_is_100_ch0,     // Core should operate at 100Mbps speed for Channel 0

  //-------------
  // Channel 1
  //-------------
    // Clock derivation
    //-----------------
    output           sgmii_clk_r_ch1,      // Clock to client MAC (125MHz, 12.5MHz or 1.25MHz) (to rising edge DDR) for Channel 1.
    output           sgmii_clk_f_ch1,      // Clock to client MAC (125MHz, 12.5MHz or 1.25MHz) (to falling edge DDR) for Channel 1.
    output           sgmii_clk_en_ch1,     // Clock enable to client MAC (125MHz, 12.5MHz or 1.25MHz) for Channel 1.

    // GMII Tx
    //--------
    input  [7:0]     gmii_txd_in_ch1,      // Transmit data from client MAC for Channel 1.
    input            gmii_tx_en_in_ch1,    // Transmit data valid signal from client MAC for Channel 1.
    input            gmii_tx_er_in_ch1,    // Transmit error signal from client MAC for Channel 1.
    output [7:0]     gmii_rxd_out_ch1,     // Received Data to client MAC for Channel 1.
    output           gmii_rx_dv_out_ch1,   // Received data valid signal to client MAC for Channel 1.
    output           gmii_rx_er_out_ch1,   // Received error signal to client MAC for Channel 1.

    // GMII Rx
    //--------
    input [7:0]      gmii_rxd_in_ch1,      // Received Data to client MAC for Channel 1.
    input            gmii_rx_dv_in_ch1,    // Received data valid signal to client MAC for Channel 1.
    input            gmii_rx_er_in_ch1,    // Received error signal to client MAC for Channel 1.
    output [7:0]     gmii_txd_out_ch1,     // Transmit data from client MAC for Channel 1.
    output           gmii_tx_en_out_ch1,   // Transmit data valid signal from client MAC for Channel 1.
    output           gmii_tx_er_out_ch1,   // Transmit error signal from client MAC for Channel 1.

    // Speed Control
    //--------------
    input            speed_is_10_100_ch1,  // Core should operate at either 10Mbps or 100Mbps speeds for Channel 1
    input            speed_is_100_ch1,     // Core should operate at 100Mbps speed for Channel 1

  //-------------
  // Channel 2
  //-------------
    // Clock derivation
    //-----------------
    output           sgmii_clk_r_ch2,      // Clock to client MAC (125MHz, 12.5MHz or 1.25MHz) (to rising edge DDR) for Channel 2.
    output           sgmii_clk_f_ch2,      // Clock to client MAC (125MHz, 12.5MHz or 1.25MHz) (to falling edge DDR) for Channel 2.
    output           sgmii_clk_en_ch2,     // Clock enable to client MAC (125MHz, 12.5MHz or 1.25MHz) for Channel 2.

    // GMII Tx
    //--------
    input  [7:0]     gmii_txd_in_ch2,      // Transmit data from client MAC for Channel 2.
    input            gmii_tx_en_in_ch2,    // Transmit data valid signal from client MAC for Channel 2.
    input            gmii_tx_er_in_ch2,    // Transmit error signal from client MAC for Channel 2.
    output [7:0]     gmii_rxd_out_ch2,     // Received Data to client MAC for Channel 2.
    output           gmii_rx_dv_out_ch2,   // Received data valid signal to client MAC for Channel 2.
    output           gmii_rx_er_out_ch2,   // Received error signal to client MAC for Channel 2.

    // GMII Rx
    //--------
    input [7:0]      gmii_rxd_in_ch2,      // Received Data to client MAC for Channel 2.
    input            gmii_rx_dv_in_ch2,    // Received data valid signal to client MAC for Channel 2.
    input            gmii_rx_er_in_ch2,    // Received error signal to client MAC for Channel 2.
    output [7:0]     gmii_txd_out_ch2,     // Transmit data from client MAC for Channel 2.
    output           gmii_tx_en_out_ch2,   // Transmit data valid signal from client MAC for Channel 2.
    output           gmii_tx_er_out_ch2,   // Transmit error signal from client MAC for Channel 2.

    // Speed Control
    //--------------
    input            speed_is_10_100_ch2,  // Core should operate at either 10Mbps or 100Mbps speeds for Channel 2
    input            speed_is_100_ch2,     // Core should operate at 100Mbps speed for Channel 2

  //-------------
  // Channel 3
  //-------------
    // Clock derivation
    //-----------------
    output           sgmii_clk_r_ch3,      // Clock to client MAC (125MHz, 12.5MHz or 1.25MHz) (to rising edge DDR) for Channel 3.
    output           sgmii_clk_f_ch3,      // Clock to client MAC (125MHz, 12.5MHz or 1.25MHz) (to falling edge DDR) for Channel 3.
    output           sgmii_clk_en_ch3,     // Clock enable to client MAC (125MHz, 12.5MHz or 1.25MHz) for Channel 3.

    // GMII Tx
    //--------
    input  [7:0]     gmii_txd_in_ch3,      // Transmit data from client MAC for Channel 3.
    input            gmii_tx_en_in_ch3,    // Transmit data valid signal from client MAC for Channel 3.
    input            gmii_tx_er_in_ch3,    // Transmit error signal from client MAC for Channel 3.
    output [7:0]     gmii_rxd_out_ch3,     // Received Data to client MAC for Channel 3.
    output           gmii_rx_dv_out_ch3,   // Received data valid signal to client MAC for Channel 3.
    output           gmii_rx_er_out_ch3,   // Received error signal to client MAC for Channel 3.

    // GMII Rx
    //--------
    input [7:0]      gmii_rxd_in_ch3,      // Received Data to client MAC for Channel 3.
    input            gmii_rx_dv_in_ch3,    // Received data valid signal to client MAC for Channel 3.
    input            gmii_rx_er_in_ch3,    // Received error signal to client MAC for Channel 3.
    output [7:0]     gmii_txd_out_ch3,     // Transmit data from client MAC for Channel 3.
    output           gmii_tx_en_out_ch3,   // Transmit data valid signal from client MAC for Channel 3.
    output           gmii_tx_er_out_ch3,   // Transmit error signal from client MAC for Channel 3.

    // Speed Control
    //--------------
    input            speed_is_10_100_ch3,  // Core should operate at either 10Mbps or 100Mbps speeds for Channel 3
    input            speed_is_100_ch3      // Core should operate at 100Mbps speed for Channel 3

  );


  //----------------------------------------------------------------------------
  // internal signals used in this wrapper.
  //----------------------------------------------------------------------------

  // create a synchronous reset in the clk125m clock domain
  wire         sync_reset;

  // Resynchronous the speed settings into the local clock domain
  wire         speed_is_10_100_resync;
  wire         speed_is_100_resync;



  //----------------------------------------------------------------------------
  // Clock Resynchronisation logic
  //----------------------------------------------------------------------------

  // Create synchronous reset in the clk125m clock domain.
  quadsgmii_reset_sync gen_sync_reset (
    .clk                 (clk125m),
    .reset_in            (reset),
    .reset_out           (sync_reset)
  );


  //----------------------------------------------------------------------------
  // Component Instantiation for Channel 0 of sgmii adapt logic
  //----------------------------------------------------------------------------

  quadsgmii_sgmii_adapt sgmii_adapt_ch0  (
    .reset               (sync_reset),
    .clk125m             (clk125m),
    .sgmii_clk_r         (sgmii_clk_r_ch0),
    .sgmii_clk_f         (sgmii_clk_f_ch0),
    .sgmii_clk_en        (sgmii_clk_en_ch0),
    .gmii_txd_in         (gmii_txd_in_ch0),
    .gmii_tx_en_in       (gmii_tx_en_in_ch0),
    .gmii_tx_er_in       (gmii_tx_er_in_ch0),
    .gmii_rxd_out        (gmii_rxd_out_ch0),
    .gmii_rx_dv_out      (gmii_rx_dv_out_ch0),
    .gmii_rx_er_out      (gmii_rx_er_out_ch0),
    .gmii_rxd_in         (gmii_rxd_in_ch0),
    .gmii_rx_dv_in       (gmii_rx_dv_in_ch0),
    .gmii_rx_er_in       (gmii_rx_er_in_ch0),
    .gmii_txd_out        (gmii_txd_out_ch0),
    .gmii_tx_en_out      (gmii_tx_en_out_ch0),
    .gmii_tx_er_out      (gmii_tx_er_out_ch0),
    .speed_is_10_100     (speed_is_10_100_ch0),
    .speed_is_100        (speed_is_100_ch0) 
  );

  //----------------------------------------------------------------------------
  // Component Instantiation for Channel 1 of sgmii adapt logic
  //----------------------------------------------------------------------------

  quadsgmii_sgmii_adapt sgmii_adapt_ch1  (
    .reset               (sync_reset),
    .clk125m             (clk125m),
    .sgmii_clk_r         (sgmii_clk_r_ch1),
    .sgmii_clk_f         (sgmii_clk_f_ch1),
    .sgmii_clk_en        (sgmii_clk_en_ch1),
    .gmii_txd_in         (gmii_txd_in_ch1),
    .gmii_tx_en_in       (gmii_tx_en_in_ch1),
    .gmii_tx_er_in       (gmii_tx_er_in_ch1),
    .gmii_rxd_out        (gmii_rxd_out_ch1),
    .gmii_rx_dv_out      (gmii_rx_dv_out_ch1),
    .gmii_rx_er_out      (gmii_rx_er_out_ch1),
    .gmii_rxd_in         (gmii_rxd_in_ch1),
    .gmii_rx_dv_in       (gmii_rx_dv_in_ch1),
    .gmii_rx_er_in       (gmii_rx_er_in_ch1),
    .gmii_txd_out        (gmii_txd_out_ch1),
    .gmii_tx_en_out      (gmii_tx_en_out_ch1),
    .gmii_tx_er_out      (gmii_tx_er_out_ch1),
    .speed_is_10_100     (speed_is_10_100_ch1),
    .speed_is_100        (speed_is_100_ch1) 
  );

  //----------------------------------------------------------------------------
  // Component Instantiation for Channel 2 of sgmii adapt logic
  //----------------------------------------------------------------------------

  quadsgmii_sgmii_adapt sgmii_adapt_ch2  (
    .reset               (sync_reset),
    .clk125m             (clk125m),
    .sgmii_clk_r         (sgmii_clk_r_ch2),
    .sgmii_clk_f         (sgmii_clk_f_ch2),
    .sgmii_clk_en        (sgmii_clk_en_ch2),
    .gmii_txd_in         (gmii_txd_in_ch2),
    .gmii_tx_en_in       (gmii_tx_en_in_ch2),
    .gmii_tx_er_in       (gmii_tx_er_in_ch2),
    .gmii_rxd_out        (gmii_rxd_out_ch2),
    .gmii_rx_dv_out      (gmii_rx_dv_out_ch2),
    .gmii_rx_er_out      (gmii_rx_er_out_ch2),
    .gmii_rxd_in         (gmii_rxd_in_ch2),
    .gmii_rx_dv_in       (gmii_rx_dv_in_ch2),
    .gmii_rx_er_in       (gmii_rx_er_in_ch2),
    .gmii_txd_out        (gmii_txd_out_ch2),
    .gmii_tx_en_out      (gmii_tx_en_out_ch2),
    .gmii_tx_er_out      (gmii_tx_er_out_ch2),
    .speed_is_10_100     (speed_is_10_100_ch2),
    .speed_is_100        (speed_is_100_ch2) 
  );

  //----------------------------------------------------------------------------
  // Component Instantiation for Channel 3 of sgmii adapt logic
  //----------------------------------------------------------------------------

  quadsgmii_sgmii_adapt sgmii_adapt_ch3  (
    .reset               (sync_reset),
    .clk125m             (clk125m),
    .sgmii_clk_r         (sgmii_clk_r_ch3),
    .sgmii_clk_f         (sgmii_clk_f_ch3),
    .sgmii_clk_en        (sgmii_clk_en_ch3),
    .gmii_txd_in         (gmii_txd_in_ch3),
    .gmii_tx_en_in       (gmii_tx_en_in_ch3),
    .gmii_tx_er_in       (gmii_tx_er_in_ch3),
    .gmii_rxd_out        (gmii_rxd_out_ch3),
    .gmii_rx_dv_out      (gmii_rx_dv_out_ch3),
    .gmii_rx_er_out      (gmii_rx_er_out_ch3),
    .gmii_rxd_in         (gmii_rxd_in_ch3),
    .gmii_rx_dv_in       (gmii_rx_dv_in_ch3),
    .gmii_rx_er_in       (gmii_rx_er_in_ch3),
    .gmii_txd_out        (gmii_txd_out_ch3),
    .gmii_tx_en_out      (gmii_tx_en_out_ch3),
    .gmii_tx_er_out      (gmii_tx_er_out_ch3),
    .speed_is_10_100     (speed_is_10_100_ch3),
    .speed_is_100        (speed_is_100_ch3) 
  );
endmodule

