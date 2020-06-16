//------------------------------------------------------------------------------
// Title      : Top-level Transceiver GT wrapper for Ethernet
// Project    : QSGMII LogiCORE
// File       : quadsgmii_transceiver.v
// Author     : Xilinx
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
// Description:  This is the top-level Transceiver GT wrapper. It
//               instantiates the lower-level wrappers produced by
//               the Series-7 FPGA Transceiver GT Wrapper Wizard.
//------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

module quadsgmii_transceiver (
   input            encommaalign,
   input            loopback,
   input            powerdown,
   input            usrclk,
   input            usrclk2,
   input            rxusrclk,
   input            rxusrclk2,
   input            independent_clock_bufg,
   input            data_valid,
   input            mgt_tx_reset,
   input     [31:0] txdata,
   input     [3:0]  txchardispmode,
   input     [3:0]  txchardispval,
   input     [3:0]  txcharisk,
   input            mgt_rx_reset,
   output    [3:0]  rxchariscomma,
   output    [3:0]  rxcharisk,
   output    [2:0]  rxclkcorcnt,
   output    [31:0] rxdata,
   output    [3:0]  rxdisperr,
   output    [3:0]  rxnotintable,
   output    [3:0]  rxrundisp,
   output reg       txbuferr,
   output           plllkdet,
   output           txoutclk,
   output           rxoutclk,
   output           rxelecidle,
   output           txn,
   output           txp,
   input            rxn,
   input            rxp,
   input            gtrefclk,
   input            pmareset,
   output           resetdone,
   output           gt0_rxbyteisaligned_out,
   output           gt0_rxbyterealign_out,
   output           gt0_rxcommadet_out,
   input            gt0_gttxreset_in,
   output           gt0_cplllock_out,
   input            gt0_txpolarity_in,
   input   [3:0]    gt0_txdiffctrl_in,
   input   [4:0]    gt0_txpostcursor_in,
   input   [4:0]    gt0_txprecursor_in,
   input            gt0_rxpolarity_in,
   input            gt0_rxdfelpmreset_in,
   input            gt0_rxdfeagcovrden_in,
   input            gt0_rxlpmen_in,
   input   [2:0]    gt0_txprbssel_in,
   input            gt0_txprbsforceerr_in,
   input            gt0_rxprbscntreset_in,
   output  [1:0]    gt0_txbufstatus_out,
   output  [2:0]    gt0_rxbufstatus_out,
   input            gt0_rxbufreset_in,
   output           gt0_rxprbserr_out,
   input   [2:0]    gt0_rxprbssel_in,
   input   [2:0]    gt0_loopback_in,
   output  [7:0]    gt0_dmonitorout_out,
   input            gt0_txpcsreset_in,
   input            gt0_txpmareset_in,
   output           gt0_txresetdone_out,
   output           gt0_rxresetdone_out,
   input            gt0_eyescanreset_in,
   output           gt0_eyescandataerror_out,
   input            gt0_eyescantrigger_in,
   input            gt0_gtrxreset_in,
   input            gt0_rxpcsreset_in,
   input            gt0_rxpmareset_in,
   input   [2:0]    gt0_rxrate_in,
   input            gt0_rxcdrhold_in,
   output           gt0_rxratedone_out,
   output  [6:0]    gt0_rxmonitorout_out,
   input   [1:0]    gt0_rxmonitorsel_in,
   input   [8:0]    gt0_drpaddr_in,
   input            gt0_drpclk_in,
   input   [15:0]   gt0_drpdi_in,
   output  [15:0]   gt0_drpdo_out,
   input            gt0_drpen_in,
   output           gt0_drprdy_out,
   input            gt0_drpwe_in,
   input            gt0_qplloutclk_in,
   input            gt0_qplloutrefclk_in

);


  //----------------------------------------------------------------------------
  // Signal declarations
  //----------------------------------------------------------------------------

   wire             cplllock;
   wire             gt_reset_rx;
   wire             gt_reset_tx;
   wire             resetdone_tx;
   wire             resetdone_rx;

   wire      [1:0]  txbufstatus;
   reg       [1:0]  txbufstatus_reg;

   reg              data_valid_reg;
   wire             data_valid_reg2;

   // Signals for GT data reception
   wire             encommaalign_rec;

   wire       [1:0] powerdown_int;

   assign powerdown_int = {2{powerdown}};

   //---------------------------------------------------------------------------
   // The core works from a 125MHz clock source from USERCLK2, the GT transceiver fabric
   // interface works from a 125MHz clock source USERCLK.
   //---------------------------------------------------------------------------

  // Reclock encommaalign
  quadsgmii_reset_sync rxrecclk_encommaalign (
     .clk       (rxusrclk2),
     .reset_in  (encommaalign),
     .reset_out (encommaalign_rec)
  );


   //---------------------------------------------------------------------------
   // The core works from a 125MHz clock source userclk2, the GT transceiver fabric
   // interface works from a 125MHz clock source. 
   //---------------------------------------------------------------------------

   // Cross the clock domain
   always @(posedge usrclk)
   begin
     txbufstatus_reg    <= txbufstatus;
   end

   assign gt0_txbufstatus_out = txbufstatus;

   //---------------------------------------------------------------------------
   // The core works from a 125MHz clock source userclk2, the init statemachines 
   // work at 200 MHz. 
   //---------------------------------------------------------------------------

   // Cross the clock domain
   always @(posedge usrclk2)
   begin
     data_valid_reg    <= data_valid;
   end


   quadsgmii_sync_block sync_block_data_valid
          (
             .clk             (independent_clock_bufg),
             .data_in         (data_valid_reg),
             .data_out        (data_valid_reg2)
          );


   //---------------------------------------------------------------------------
   // Instantiate the Series-7 GTX
   //---------------------------------------------------------------------------
   // Direct from the Transceiver Wizard output
    quadsgmii_GTWIZARD gtwizard_inst
    (
        .sysclk_in                    (independent_clock_bufg),
        .soft_reset_in                (pmareset),
        .dont_reset_on_data_error_in  (1'b1),
        .gt0_tx_fsm_reset_done_out    (resetdone_tx),
        .gt0_rx_fsm_reset_done_out    (resetdone_rx),
        .gt0_data_valid_in            (data_valid_reg2),

    //_________________________________________________________________________
    //GT0  (X1Y0)
    //____________________________CHANNEL PORTS________________________________
    //------------------------------- CPLL Ports -------------------------------
        .gt0_cpllfbclklost_out        (),
        .gt0_cplllock_out             (cplllock),
        .gt0_cplllockdetclk_in        (independent_clock_bufg),
        .gt0_cpllreset_in             (pmareset),
    //------------------------ Channel - Clocking Ports ------------------------
        .gt0_gtrefclk0_in             (gtrefclk),
    //-------------------------- Channel - DRP Ports  --------------------------
        .gt0_drpaddr_in               (gt0_drpaddr_in),
        .gt0_drpclk_in                (gt0_drpclk_in),
        .gt0_drpdi_in                 (gt0_drpdi_in),
        .gt0_drpdo_out                (gt0_drpdo_out),
        .gt0_drpen_in                 (gt0_drpen_in),
        .gt0_drprdy_out               (gt0_drprdy_out),
        .gt0_drpwe_in                 (gt0_drpwe_in),
    //----------------------------- Loopback Ports -----------------------------
        .gt0_loopback_in              (gt0_loopback_in),
    //------------------------- Digital Monitor Ports --------------------------
        .gt0_dmonitorout_out          (gt0_dmonitorout_out),
    //--------------------------- PCI Express Ports ----------------------------
        .gt0_rxrate_in                (gt0_rxrate_in),
    //---------------------------- Power-Down Ports ----------------------------
        .gt0_rxpd_in                  (powerdown_int),
        .gt0_txpd_in                  (powerdown_int),
    //------------------- RX Initialization and Reset Ports --------------------
        .gt0_eyescanreset_in          (gt0_eyescanreset_in),
        .gt0_rxuserrdy_in             (cplllock),
    //------------------------ RX Margin Analysis Ports ------------------------
        .gt0_eyescandataerror_out     (gt0_eyescandataerror_out),
        .gt0_eyescantrigger_in        (gt0_eyescantrigger_in),
    //----------------------- Receive Ports - CDR Ports ------------------------
        .gt0_rxcdrhold_in             (gt0_rxcdrhold_in),
        .gt0_rxcdrlock_out            (), 
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .gt0_rxusrclk_in              (rxusrclk),
        .gt0_rxusrclk2_in             (rxusrclk2),
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt0_rxdata_out               (rxdata),
    //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt0_rxprbserr_out            (gt0_rxprbserr_out),
        .gt0_rxprbssel_in             (gt0_rxprbssel_in),
    //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt0_rxprbscntreset_in        (gt0_rxprbscntreset_in),
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt0_rxdisperr_out            (rxdisperr),
        .gt0_rxnotintable_out         (rxnotintable),
    //------------------------- Receive Ports - RX AFE -------------------------
        .gt0_gtxrxp_in                (rxp),
    //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt0_gtxrxn_in                (rxn),
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt0_rxbufreset_in            (gt0_rxbufreset_in),
        .gt0_rxbufstatus_out          (gt0_rxbufstatus_out),
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .gt0_rxbyteisaligned_out      (gt0_rxbyteisaligned_out),
        .gt0_rxbyterealign_out        (gt0_rxbyterealign_out),
        .gt0_rxcommadet_out           (gt0_rxcommadet_out),
        .gt0_rxmcommaalignen_in       (encommaalign_rec),
        .gt0_rxpcommaalignen_in       (encommaalign_rec),
    //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt0_rxdfeagcovrden_in        (gt0_rxdfeagcovrden_in),
        .gt0_rxdfelpmreset_in         (gt0_rxdfelpmreset_in),
        .gt0_rxmonitorout_out         (gt0_rxmonitorout_out),
        .gt0_rxmonitorsel_in          (gt0_rxmonitorsel_in),
    //---------- Receive Ports - RX Fabric ClocK Output Control Ports ----------
        .gt0_rxratedone_out           (gt0_rxratedone_out),
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt0_rxoutclk_out             (rxoutclk),
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt0_gtrxreset_in             (gt_reset_rx),
        .gt0_rxpcsreset_in            (gt0_rxpcsreset_in),
        .gt0_rxpmareset_in            (gt0_rxpmareset_in),
    //---------------- Receive Ports - RX Margin Analysis ports ----------------
        .gt0_rxlpmen_in               (gt0_rxlpmen_in),
    //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .gt0_rxpolarity_in            (gt0_rxpolarity_in),
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .gt0_rxchariscomma_out        (rxchariscomma),
        .gt0_rxcharisk_out            (rxcharisk),
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt0_rxresetdone_out          (),
    //---------------------- TX Configurable Driver Ports ----------------------
        .gt0_txpostcursor_in          (gt0_txpostcursor_in),
        .gt0_txprecursor_in           (gt0_txprecursor_in),
    //------------------- TX Initialization and Reset Ports --------------------
        .gt0_gttxreset_in             (gt_reset_tx),
        .gt0_txuserrdy_in             (cplllock),
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .gt0_txchardispmode_in        (txchardispmode),
        .gt0_txchardispval_in         (txchardispval),
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .gt0_txusrclk_in              (usrclk),
        .gt0_txusrclk2_in             (usrclk),
    //------------------- Transmit Ports - PCI Express Ports -------------------
        .gt0_txelecidle_in            (powerdown),
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt0_txprbsforceerr_in        (gt0_txprbsforceerr_in),
    //-------------------- Transmit Ports - TX Buffer Ports --------------------
        .gt0_txbufstatus_out          (txbufstatus),
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
        .gt0_txdiffctrl_in            (gt0_txdiffctrl_in),
    //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt0_txdata_in                (txdata),
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt0_gtxtxn_out               (txn),
        .gt0_gtxtxp_out               (txp),
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt0_txoutclk_out             (txoutclk),
        .gt0_txoutclkfabric_out       (),
        .gt0_txoutclkpcs_out          (),
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .gt0_txcharisk_in             (txcharisk),
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt0_txpcsreset_in            (gt0_txpcsreset_in),
        .gt0_txpmareset_in            (gt0_txpmareset_in),
        .gt0_txresetdone_out          (),
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .gt0_txpolarity_in            (gt0_txpolarity_in),
    //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt0_txprbssel_in             (gt0_txprbssel_in),


    //____________________________COMMON PORTS________________________________
        .gt0_qplloutclk_in                (gt0_qplloutclk_in),
        .gt0_qplloutrefclk_in             (gt0_qplloutrefclk_in)
    );

   //---------------------------------------------------------------------------
   // Instantiation of the FPGA Fabric Receiver Elastic Buffer
   // connected to the Transceiver
   //---------------------------------------------------------------------------


    assign rxrundisp   = 4'b0000;
    assign rxelecidle  = 1'b0;
    assign rxclkcorcnt = 3'b000;


   // Hold the transmitter and receiver paths of the GT transceiver in reset
   // until the PLL has locked.
   assign gt_reset_tx = (mgt_tx_reset && resetdone_tx) || gt0_gttxreset_in  ;
   assign gt_reset_rx = (mgt_rx_reset && resetdone_rx) || gt0_gtrxreset_in ;

   assign gt0_txresetdone_out = resetdone_tx;
   assign gt0_rxresetdone_out = resetdone_rx;

   // Output the PLL locked status
   assign plllkdet = cplllock;
   assign gt0_cplllock_out = cplllock;


   // Report overall status for both transmitter and receiver reset done signals
  assign  resetdone = cplllock;


   // Decode the GT transceiver buffer status signals
  always @(posedge usrclk2)
  begin
    txbuferr    <= txbufstatus_reg[1];
  end

endmodule
