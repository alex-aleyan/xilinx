
//------------------------------------------------------------------------------
// File       : mdio_cfg_tb.v
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
// Description: The programing of per channel configuration registers in the DUT is 
// performed through MDIO configuration test bench.
// There are four instances of this module with each instance representing one channel.
//------------------------------------------------------------------------------


`timescale 1 ps/1 ps

module mdio_cfg_tb (
                     output reg   configuration_finished,
                     output reg   mdio_i,

                     input        txp,
                     input [15:0] status_vector,

                     input        mdc
                   );

  

  parameter PHYAD = 0;


  // reg        configuration_finished;
  // reg        mdio_i;

  reg [0:63] mdio_data;

  integer    MDIO_BIT;       // Bit counter within MDIO frame


  
  //----------------------------------------------------------------------------
  // Stimulus - Management Frame data
  //----------------------------------------------------------------------------
  // Create management frame

  initial
  begin
    mdio_data[0:31]  = 32'hffffffff;  // preamble field
    mdio_data[32:33] = 2'h1;          // start opcode
    mdio_data[34:35] = 2'h1;          // write opcode
    mdio_data[36:40] = PHYAD;         // phyad (the PHY "broadcast" address: write to any connected device)
    mdio_data[41:45] = 5'h0;          // regad (write to Configuration Register)
    mdio_data[46:47] = 2'h2;          // Turn-around cycles

                                      // DATA FIELD

    mdio_data[48]    = 1'b0;          // Do not assert Reset
    mdio_data[49]    = 1'b0;          // No loopback
    mdio_data[50]    = 1'b0;          // Speed selection
    mdio_data[51]    = 1'b0;          // Disable Auto-Negotiation
    mdio_data[52]    = 1'b0;          // Disable Power Down
    mdio_data[53]    = 1'b0;          // Disable Isolate GMII
    mdio_data[54]    = 1'b0;          // Disable Auto-Negotiation Restart
    mdio_data[55]    = 1'b1;          // Full Duplex Mode
    mdio_data[56]    = 1'b0;          // Disable Collision Test
    mdio_data[57]    = 1'b0;          // Speed selection
    mdio_data[58:63] = 6'h0;          // Reserved

  end


  // Main configuration process
  initial
  begin : p_configuration

    $display("** Note: Timing checks are not valid");

    configuration_finished <= 0;
    mdio_i <= 1'b1;

    #10000000

    // wait until GTP has initialised (is toggling)
    wait (txp == 1);


    // Write to PCS Management configuration register 0.
    $display("Writing to Control Register in PCS sublayer....");

    @(negedge mdc)    // centre MDIO around MDC rising edge

    MDIO_BIT = 0;

    // transmit serial management frame
    while(MDIO_BIT !== 64)
    begin
      @(negedge mdc);
      mdio_i <= mdio_data[MDIO_BIT];
      MDIO_BIT = MDIO_BIT + 1;
    end

    @(negedge mdc)
    mdio_i <= 1'b1;  // simulate tri-state with pullup

    // wait for core to obtain synchronisation
    #10000000
    wait (status_vector[0] == 1);
    #10000000

    configuration_finished <= 1;
  end // p_configuration

endmodule

