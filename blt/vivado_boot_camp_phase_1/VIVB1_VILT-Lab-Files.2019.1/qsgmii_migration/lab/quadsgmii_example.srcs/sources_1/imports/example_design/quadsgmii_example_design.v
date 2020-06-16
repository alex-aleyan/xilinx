//------------------------------------------------------------------------------
// File       : quadsgmii_example_design.v
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
// Description: This is the top level verilog example design for the
//              Ethernet QGMII core.  The block level wrapper for the
//              core is instantiated and the tranceiver clock circuitry is
//              created.  Additionally, the I/O of the GMII-style
//              interface is provided with IOB flip-flops (infered)
//              which enables this example design to be implemented
//              using the Xilinx tools.
//
//           * Please refer to the Getting Started User Guide for
//             details of the example design file hierarchy.


`timescale 1 ps/1 ps


//------------------------------------------------------------------------------
// The module declaration for the example design
//------------------------------------------------------------------------------

module quadsgmii_example_design
   (

      // An independent clock source used as the reference clock for an
      // IDELAYCTRL (if present) and for the main GT transceiver reset logic.
      // This example design assumes that this is of frequency 200MHz.
      input            independent_clock,
      input            reset,                     // Asynchronous reset for entire core.
      input            signal_detect,             // Input from PMD to indicate presence of optical input.
      output           core_clock_125,            // 125 MHz core clock.

      // Tranceiver Interface
      //---------------------

      input            gtrefclk_p,                // Differential +ve of reference clock for MGT: 125MHz, very high quality.
      input            gtrefclk_n,                // Differential -ve of reference clock for MGT: 125MHz, very high quality.
      output           txp,                       // Differential +ve of serial transmission from PMA to PMD.
      output           txn,                       // Differential -ve of serial transmission from PMA to PMD.
      input            rxp,                       // Differential +ve for serial reception from PMD to PMA.
      input            rxn,                       // Differential -ve for serial reception from PMD to PMA.

      //--------------------------------------------
      // Channel 0
      //--------------------------------------------
      // GMII Interface (client MAC <=> PCS)
      //------------------------------------
      output           sgmii_clk_en_ch0,          // Clock enable for client MAC (125Mhz, 12.5MHz or 1.25MHz).

      input [7:0]      gmii_txd_ch0,              // Transmit data from client MAC.
      input            gmii_tx_en_ch0,            // Transmit control signal from client MAC.
      input            gmii_tx_er_ch0,            // Transmit control signal from client MAC.

      output     [7:0] gmii_rxd_ch0,              // Received Data to client MAC.
      output           gmii_rx_dv_ch0,            // Received control signal to client MAC.
      output           gmii_rx_er_ch0,            // Received control signal to client MAC.

      // Management: MDIO Interface
      //---------------------------
      input            mdc_ch0,                   // Management Data Clock
      input            mdio_i_ch0,                // Management Data In
      output           mdio_o_ch0,                // Management Data Out
      output           mdio_t_ch0,                // Management Data Tristate
      output           an_interrupt_ch0,          // Interrupt to processor to signal that Auto-Negotiation has completed

      // Speed Control
      //--------------
      input            speed_is_10_100_ch0,       // Core should operate at either 10Mbps or 100Mbps speeds
      input            speed_is_100_ch0,          // Core should operate at 100Mbps speed

      // General IO's
      //-------------
      output reg [15:0] status_vector_ch0,         // Core status.

      //--------------------------------------------
      // Channel 1
      //--------------------------------------------
      // GMII Interface (client MAC <=> PCS)
      //------------------------------------
      output           sgmii_clk_en_ch1,          // Clock enable for client MAC (125Mhz, 12.5MHz or 1.25MHz).

      input [7:0]      gmii_txd_ch1,              // Transmit data from client MAC.
      input            gmii_tx_en_ch1,            // Transmit control signal from client MAC.
      input            gmii_tx_er_ch1,            // Transmit control signal from client MAC.

      output     [7:0] gmii_rxd_ch1,              // Received Data to client MAC.
      output           gmii_rx_dv_ch1,            // Received control signal to client MAC.
      output           gmii_rx_er_ch1,            // Received control signal to client MAC.

      // Management: MDIO Interface
      //---------------------------
      input            mdc_ch1,                   // Management Data Clock
      input            mdio_i_ch1,                // Management Data In
      output           mdio_o_ch1,                // Management Data Out
      output           mdio_t_ch1,                // Management Data Tristate
      output           an_interrupt_ch1,          // Interrupt to processor to signal that Auto-Negotiation has completed

      // Speed Control
      //--------------
      input            speed_is_10_100_ch1,       // Core should operate at either 10Mbps or 100Mbps speeds
      input            speed_is_100_ch1,          // Core should operate at 100Mbps speed

      // General IO's
      //-------------
      output reg [15:0] status_vector_ch1,         // Core status.

      //--------------------------------------------
      // Channel 2
      //--------------------------------------------
      // GMII Interface (client MAC <=> PCS)
      //------------------------------------
      output           sgmii_clk_en_ch2,          // Clock enable for client MAC (125Mhz, 12.5MHz or 1.25MHz).

      input [7:0]      gmii_txd_ch2,              // Transmit data from client MAC.
      input            gmii_tx_en_ch2,            // Transmit control signal from client MAC.
      input            gmii_tx_er_ch2,            // Transmit control signal from client MAC.

      output [7:0]     gmii_rxd_ch2,              // Received Data to client MAC.
      output           gmii_rx_dv_ch2,            // Received control signal to client MAC.
      output           gmii_rx_er_ch2,            // Received control signal to client MAC.

      // Management: MDIO Interface
      //---------------------------
      input            mdc_ch2,                   // Management Data Clock
      input            mdio_i_ch2,                // Management Data In
      output           mdio_o_ch2,                // Management Data Out
      output           mdio_t_ch2,                // Management Data Tristate
      output           an_interrupt_ch2,          // Interrupt to processor to signal that Auto-Negotiation has completed

      // Speed Control
      //--------------
      input            speed_is_10_100_ch2,       // Core should operate at either 10Mbps or 100Mbps speeds
      input            speed_is_100_ch2,          // Core should operate at 100Mbps speed

      // General IO's
      //-------------
      output reg [15:0] status_vector_ch2,         // Core status.

      //--------------------------------------------
      // Channel 3
      //--------------------------------------------
      // GMII Interface (client MAC <=> PCS)
      //------------------------------------
      output           sgmii_clk_en_ch3,          // Clock enable for client MAC (125Mhz, 12.5MHz or 1.25MHz).

      input [7:0]      gmii_txd_ch3,              // Transmit data from client MAC.
      input            gmii_tx_en_ch3,            // Transmit control signal from client MAC.
      input            gmii_tx_er_ch3,            // Transmit control signal from client MAC.

      output [7:0]     gmii_rxd_ch3,              // Received Data to client MAC.
      output           gmii_rx_dv_ch3,            // Received control signal to client MAC.
      output           gmii_rx_er_ch3,            // Received control signal to client MAC.

      // Management: MDIO Interface
      //---------------------------
      input            mdc_ch3,                   // Management Data Clock
      input            mdio_i_ch3,                // Management Data In
      output           mdio_o_ch3,                // Management Data Out
      output           mdio_t_ch3,                // Management Data Tristate
      output           an_interrupt_ch3,          // Interrupt to processor to signal that Auto-Negotiation has completed

      // Speed Control
      //--------------
      input            speed_is_10_100_ch3,       // Core should operate at either 10Mbps or 100Mbps speeds
      input            speed_is_100_ch3,          // Core should operate at 100Mbps speed

      // General IO's
      //-------------
      output reg [15:0] status_vector_ch3         // Core status.
   );



  //----------------------------------------------------------------------------
  // internal signals used in this top level example design.
  //----------------------------------------------------------------------------

   // clock generation signals for tranceiver
   wire         userclk2;                        // 125MHz clock for core reference clock.
   wire         independent_clock_bufgdiv2;      // 100 MHz clock for drp
   wire         independent_clock_bufgdiv2_wire; // 100 MHz clock for drp


   // Extra registers to ease IOB placement
   wire  [15:0]  status_vector_ch0_int;
   wire  [15:0]  status_vector_ch1_int;
   wire  [15:0]  status_vector_ch2_int;
   wire  [15:0]  status_vector_ch3_int;
   



   //---------------------------------------------------------------------------
   // An independent clock source used as the reference clock for an
   // IDELAYCTRL (if present) and for the main GT transceiver reset logic.
   //---------------------------------------------------------------------------

   // Route independent_clock input through a BUFG
   BUFG  bufg_independent_clock (
      .I         (independent_clock),
      .O         (independent_clock_bufg)
   );

  // Divding independent clock by 2 as source for DRP clock
  BUFR # (
      .BUFR_DIVIDE ("2")
  )
  independent_clock_bufg_div2_wire (
      .I   (independent_clock_bufg),
      .O   (independent_clock_bufgdiv2_wire),
      .CE  (1'b1),
      .CLR (1'b0)
  );

   // Route independent_clock_bufgdiv2 input through a BUFG
   BUFG  bufg_independent_clock_bufg_div2 (
      .I         (independent_clock_bufgdiv2_wire),
      .O         (independent_clock_bufgdiv2)
   );


  //----------------------------------------------------------------------------
  // Instantiate the Core Block (core wrapper).
  //----------------------------------------------------------------------------
 quadsgmii_support core_support_i
     (
      .reset                     (reset),
      .gtrefclk_n                (gtrefclk_n),
      .gtrefclk_p                (gtrefclk_p),
      .gtrefclk_out              (),
      .txp                       (txp),
      .txn                       (txn),
      .rxp                       (rxp),
      .rxn                       (rxn),
      .userclk_out               (),
      .userclk2_out              (userclk2),
      .rxuserclk_out             (),
      .rxuserclk2_out            (),
      .independent_clock_bufg    (independent_clock_bufg),
      .pma_reset_out             (),
      .mmcm_locked_out           (),
      .sgmii_clk_en_ch0          (sgmii_clk_en_ch0),
      .gmii_txd_ch0              (gmii_txd_ch0),
      .gmii_tx_en_ch0            (gmii_tx_en_ch0),
      .gmii_tx_er_ch0            (gmii_tx_er_ch0),
      .gmii_rxd_ch0              (gmii_rxd_ch0),
      .gmii_rx_dv_ch0            (gmii_rx_dv_ch0),
      .gmii_rx_er_ch0            (gmii_rx_er_ch0),
      .mdc_ch0                   (mdc_ch0),
      .mdio_i_ch0                (mdio_i_ch0),
      .mdio_o_ch0                (mdio_o_ch0),
      .mdio_t_ch0                (mdio_t_ch0),
      .an_interrupt_ch0          (an_interrupt_ch0),
      .speed_is_10_100_ch0       (speed_is_10_100_ch0),
      .speed_is_100_ch0          (speed_is_100_ch0),
      .status_vector_ch0         (status_vector_ch0_int),
      .sgmii_clk_en_ch1          (sgmii_clk_en_ch1),
      .gmii_txd_ch1              (gmii_txd_ch1),
      .gmii_tx_en_ch1            (gmii_tx_en_ch1),
      .gmii_tx_er_ch1            (gmii_tx_er_ch1),
      .gmii_rxd_ch1              (gmii_rxd_ch1),
      .gmii_rx_dv_ch1            (gmii_rx_dv_ch1),
      .gmii_rx_er_ch1            (gmii_rx_er_ch1),
      .mdc_ch1                   (mdc_ch1),
      .mdio_i_ch1                (mdio_i_ch1),
      .mdio_o_ch1                (mdio_o_ch1),
      .mdio_t_ch1                (mdio_t_ch1),
      .an_interrupt_ch1          (an_interrupt_ch1),
      .speed_is_10_100_ch1       (speed_is_10_100_ch1),
      .speed_is_100_ch1          (speed_is_100_ch1),
      .status_vector_ch1         (status_vector_ch1_int),
      .sgmii_clk_en_ch2          (sgmii_clk_en_ch2),
      .gmii_txd_ch2              (gmii_txd_ch2),
      .gmii_tx_en_ch2            (gmii_tx_en_ch2),
      .gmii_tx_er_ch2            (gmii_tx_er_ch2),
      .gmii_rxd_ch2              (gmii_rxd_ch2),
      .gmii_rx_dv_ch2            (gmii_rx_dv_ch2),
      .gmii_rx_er_ch2            (gmii_rx_er_ch2),
      .mdc_ch2                   (mdc_ch2),
      .mdio_i_ch2                (mdio_i_ch2),
      .mdio_o_ch2                (mdio_o_ch2),
      .mdio_t_ch2                (mdio_t_ch2),
      .an_interrupt_ch2          (an_interrupt_ch2),
      .speed_is_10_100_ch2       (speed_is_10_100_ch2),
      .speed_is_100_ch2          (speed_is_100_ch2),
      .status_vector_ch2         (status_vector_ch2_int),
      .sgmii_clk_en_ch3          (sgmii_clk_en_ch3),
      .gmii_txd_ch3              (gmii_txd_ch3),
      .gmii_tx_en_ch3            (gmii_tx_en_ch3),
      .gmii_tx_er_ch3            (gmii_tx_er_ch3),
      .gmii_rxd_ch3              (gmii_rxd_ch3),
      .gmii_rx_dv_ch3            (gmii_rx_dv_ch3),
      .gmii_rx_er_ch3            (gmii_rx_er_ch3),
      .mdc_ch3                   (mdc_ch3),
      .mdio_i_ch3                (mdio_i_ch3),
      .mdio_o_ch3                (mdio_o_ch3),
      .mdio_t_ch3                (mdio_t_ch3),
      .an_interrupt_ch3          (an_interrupt_ch3),
      .speed_is_10_100_ch3       (speed_is_10_100_ch3),
      .speed_is_100_ch3          (speed_is_100_ch3),
      .status_vector_ch3         (status_vector_ch3_int),
      .gt0_gttxreset_in          (1'b0),
      .gt0_txpmareset_in         (1'b0),
      .gt0_txpcsreset_in         (1'b0),
      .gt0_rxchariscomma_out     (),
      .gt0_rxcharisk_out         (),
      .gt0_rxbyteisaligned_out   (),
      .gt0_rxbyterealign_out     (),
      .gt0_rxcommadet_out        (),
      .gt0_txpolarity_in         (1'b0),
      .gt0_txdiffctrl_in         (4'b1000),
      .gt0_txpostcursor_in       (5'b00000),
      .gt0_txprecursor_in        (5'b00000),
      .gt0_rxpolarity_in         (1'b0),
      .gt0_rxdfelpmreset_in      (1'b0),
      .gt0_rxdfeagcovrden_in     (1'b0),
      .gt0_rxlpmen_in            (1'b0),
      .gt0_txprbssel_in          (3'b000),
      .gt0_txprbsforceerr_in     (1'b0),
      .gt0_rxprbscntreset_in     (1'b0),
      .gt0_rxprbserr_out         (),
      .gt0_rxprbssel_in          (3'b000),
      .gt0_loopback_in           (3'b000),
      .gt0_txresetdone_out       (),
      .gt0_rxresetdone_out       (),
      .gt0_gtrxreset_in          (1'b0),
      .gt0_rxpmareset_in         (1'b0),
      .gt0_rxpcsreset_in         (1'b0),
      .gt0_txbufstatus_out       (),
      .gt0_rxbufstatus_out       (),
      .gt0_rxbufreset_in         (1'b0),
      .gt0_cplllock_out          (),
      .gt0_rxpmaresetdone_out    (),
      .gt0_drpaddr_in            (9'b0),
      .gt0_drpclk_in             (independent_clock_bufgdiv2),
      .gt0_drpdi_in              (16'b0),
      .gt0_drpdo_out             (),
      .gt0_drpen_in              (1'b0),
      .gt0_drprdy_out            (),
      .gt0_drpwe_in              (1'b0),
      .gt0_rxdisperr_out         (),
      .gt0_rxnotintable_out      (),
      .gt0_eyescanreset_in       (1'b0),
      .gt0_eyescandataerror_out  (),
      .gt0_eyescantrigger_in     (1'b0),
      .gt0_rxrate_in             (3'b000),
      .gt0_rxcdrhold_in          (1'b0),
      .gt0_rxratedone_out        (),
      .gt0_dmonitorout_out       (),
      .gt0_rxmonitorout_out      (),
      .gt0_rxmonitorsel_in       (2'b00),
      .gt0_qplloutclk_out        (),
      .gt0_qplloutrefclk_out     (),
      .signal_detect             (signal_detect)
      );


   //---------------------------------------------------------------------------
   // Extra registers to ease IOB placement
   //---------------------------------------------------------------------------
   always @ (posedge userclk2)
   begin
     status_vector_ch0 <= status_vector_ch0_int;
     status_vector_ch1 <= status_vector_ch1_int;
     status_vector_ch2 <= status_vector_ch2_int;
     status_vector_ch3 <= status_vector_ch3_int;
   end

   assign core_clock_125 = userclk2;

endmodule // quadsgmii_example_design
