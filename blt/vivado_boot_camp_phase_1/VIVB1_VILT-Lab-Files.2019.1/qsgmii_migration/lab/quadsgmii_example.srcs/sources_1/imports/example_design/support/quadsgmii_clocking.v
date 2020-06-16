//------------------------------------------------------------------------------
// File       : quadsgmii_clocking.v
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
// Description: This module holds the per-core clocking for the
//              QSGMII core


`timescale 1 ps/1 ps


//------------------------------------------------------------------------------
// The module declaration for the example design
//------------------------------------------------------------------------------

module quadsgmii_clocking
   (
      input            gtrefclk_p,                // Differential +ve of reference clock for MGT: 125MHz, very high quality.
      input            gtrefclk_n,                // Differential -ve of reference clock for MGT: 125MHz, very high quality.
      input            txoutclk,                  // txoutclk from GT transceiver.
      input            rxoutclk,                  // txoutclk from GT transceiver.

      output           gtrefclk,                  // gtrefclk routed through an IBUFG.
      output  wire     mmcm_locked,               // MMCM locked

      output           rxuserclk,                 // for GT PMA reference clock
      output           rxuserclk2,                // 125MHz clock for core reference clock.
      output           userclk,                   // for GT PMA reference clock
      output           userclk2                   // 125MHz clock for core reference clock.
   );

   wire         txoutclk_bufg;
   wire         rxrecclk_bufmr;
   wire         rxrecclk_buf;

   //---------------------------------------------------------------------------
   // Transceiver Clock Management
   //---------------------------------------------------------------------------

   // Clock circuitry for the Transceiver uses a differential input clock.
   // gtrefclk is routed to the tranceiver.

   IBUFDS_GTE2 ibufds_gtrefclk (
      .I     (gtrefclk_p),
      .IB    (gtrefclk_n),
      .CEB   (1'b0),
      .O     (gtrefclk),
      .ODIV2 ()
   );

   // Route txoutclk input through a BUFG
   BUFG  bufg_txoutclk (
      .I         (txoutclk),
      .O         (txoutclk_bufg)
   );

   assign userclk2    = txoutclk_bufg;
   assign userclk     = txoutclk_bufg;
   assign mmcm_locked = 1'b1;

   // Place the Rx recovered clock on a Global Clock Buffer (it may be possible
   // to switch this for a BUFHCE)
   BUFG rxrecclkbufg (
      .I   (rxoutclk),
      .O   (rxrecclk_buf)
   );
  assign rxuserclk2 = rxrecclk_buf;
  assign rxuserclk  = rxrecclk_buf;



endmodule // quadsgmii_clocking
