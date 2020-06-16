//------------------------------------------------------------------------------
// File       : quadsgmii_clk_gen.v
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
// Description: This file creates the necessary receiver and transmitter
//              clocks and clock enables for use with the core.  Clock
//              frequencies are:
//                 * 125  MHz at an operating speed of 1Gbps
//                 * 25   MHz at an operating speed of 100Mbps
//                 * 2.5  MHz at an operating speed of 10Mbps
//
//              The 25MHz or 2.5MHz generated clock will be output
//              from the design, thereby forwarding the correct clock
//              frequency.  The forwarded clock is driven from an IOB
//              DDR output register.  This entity therefore sources
//              rising and falling edge clock signals which are routed
//              to the IOB.
//
//              Single clock period pulses are also generated at at the
//              12.5MHz frequency (a single clock period pulse every 10
//              clock periods of clk125m) and at the 1.25MHz frequency
//              (a single clock period pulse every 100 clock periods of
//              clk125m).  These pulses are used to create clock
//              enables.
//
//              All of the internal logic in the SGMII reference design
//              is clocked from the 125MHz reference clock from global
//              clock routing.  The derived clock enables are used to
//              toggle data at the correct frequency.




`timescale 1 ps/1 ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module quadsgmii_clk_gen
  (
    input      reset,               // Synchronous reset.
    input      clk125m,             // Reference 125MHz clock (as routed to TXUSRCLK2 and RXUSRCLK2 of Transceiver).
    input      speed_is_10_100,     // Core should operate at either 10Mbps or 100Mbps speeds
    input      speed_is_100,        // Core should operate at 100Mbps speed
    output reg sgmii_clk_r,         // Clock to client MAC (125MHz, 12.5MHz, 1.25MHz) (to rising edge DDR).
    output reg sgmii_clk_f,         // Clock to client MAC (125MHz, 12.5MHz, 1.25MHz) (to falling edge DDR).
    output reg sgmii_clk_en        // Clock enable for all SGMII adaptation logic (125MHz, 12.5MHz, 1.25MHz).
  );



  //----------------------------------------------------------------------------
  // internal signals used in this module.
  //----------------------------------------------------------------------------


  // 25MHz and 2.5 MHz clock enable pulses at 125 MHz
  wire clk_div10_plse_rise;
  wire clk_div10_plse_fall;

  // 2.5MHz clock generation signals
  wire clk1_25;             // 1.25MHz clock signal
  reg  clk1_25_reg;         // clk1_25 reclocked on the 125MHz reference clock (clk125m)
  reg  clk_en_1_25_fall;    // 1.25MHz clock enable pulse to mark the falling edge of the 1.25MHz clock

  // Falling edge reclocking
  reg  reset_fall;             // Synchronous reset on falling edge



  //----------------------------------------------------------------------------
  // Stage 1 : instantiate the first stage Johnson Counter to create
  //           25Mhz and 12.5MHz clock signals
  //----------------------------------------------------------------------------

  
  // Instantiate the clock divider to generate div by 5 and 10 respectively

  quadsgmii_clock_div clock_div_stg1
  (
    .reset                  (reset),               // Synchronous Reset
    .clk                    (clk125m),             // Input clock (always at 125MHz)
    .clk_div5_neg           (),                    // Clock divide by 5
    .clk_div5_pos           (),                    // Clock divide by 5
    .clk_div5_plse_fall     (), 
    .clk_div5_plse_rise     (), 
    .clk_div10              (),
    .clk_div10_plse_rise    (clk_div10_plse_rise),
    .clk_div10_plse_fall    (clk_div10_plse_fall)
  );


  //----------------------------------------------------------------------------
  // Stage 2 : instantiate the first stage Johnson Counter to create
  //           2.5Mhz and 1.2 MHz clock signals
  //----------------------------------------------------------------------------


  quadsgmii_johnson_cntr clk_div1_25 (
    .reset(reset),
    .clk(clk125m),        // 125MHz
    .clk_en(clk_div10_plse_rise),
    .clk_div10(clk1_25)   // 1.25MHz (12.5MHz divided by 10)
  );



  // Create the 2.5Mhz clock enable pulse.  This will pulse for a
  // single clk125m period once every fifty clk125m periods.
  // Create the 1.25Mhz clock enable pulse.  This will pulse for a
  // single clk125m period once every hundred clk125m periods.
  always @(posedge clk125m)
  begin
    if (reset == 1'b1) begin
      clk1_25_reg      <= 1'b0;
      clk_en_1_25_fall <= 1'b0;
    end
    else begin
      clk1_25_reg      <= clk1_25;
      clk_en_1_25_fall <= !clk1_25 && clk1_25_reg;     // signify the falling edge of the 1.25MHz clock
    end
  end



  //----------------------------------------------------------------------------
  // Use the generated clocks and clock enables to derive the required
  // clocks and clock enables for the logic of the SGMII adaptation
  //  module.  These are dependent on the speed at which the SGMII logic
  //  is operating (1Gbps, 100Mbps or 10Mbps).
  //----------------------------------------------------------------------------



  // Create the clock enables for the GMII logic.  These clock
  // enable will be constantly held high when operating at 1Gbps; they
  // will pulse once every ten clk125m periods when operating at 100Mbps;
  // they will pulse once every 100 clk125m periods when operating at
  // 100Mbps.
  always @(posedge clk125m)
  begin
    if (reset == 1'b1)
      sgmii_clk_en   <= 1'b0;
    else begin
      if (speed_is_10_100 == 1'b1) begin
        if (speed_is_100 == 1'b0)
          sgmii_clk_en  <= clk_en_1_25_fall;    // 1.25MHz at 10Mbps (falling edge of sgmii_clk)
        else
          sgmii_clk_en  <= clk_div10_plse_fall;    // 12.5MHz at 100Mbps (falling edge of sgmii_clk)
      end
      else
        sgmii_clk_en    <= 1'b1;                // Tie high for 1 Gbps
    end
  end

  // Create the DDR clock enables for the GMII logic.  These clock
  // enable will be constantly held high when operating at 1Gbps; they
  // will pulse once every five clk125m periods when operating at 100Mbps;
  // they will pulse once every 50 clk125m periods when operating at
  // 100Mbps.


  // Create the SGMII clock : part I.
  // This process creates an output clock signal synchronous to the
  // RISING edge of the 125MHz reference clk125m. It will be routed to
  // the RISING edge input of an IOB DDR output register.
  always @(posedge clk125m)
  begin
    if (reset == 1'b1)
      sgmii_clk_r   <= 1'b0;
    else
    begin
      sgmii_clk_r    <= 1'b0;            // Tie low at 1Gbps
    end
  end



  // Falling edge reclocking
  always @(negedge clk125m)
  begin
       reset_fall           <= reset;
  end



// Create the SGMII clock : part II.
  // This process creates an output clock signal synchronous to the
  // FALLING edge of the 125MHz reference clk125m. It will be routed to
  // the FALLING edge input of an IOB DDR output register.
  always @(negedge clk125m)
  begin
    if (reset_fall == 1'b1)
      sgmii_clk_f   <= 1'b1;
    else begin
        sgmii_clk_f    <= 1'b1;            // Tie low at 1Gbps
    end
  end



endmodule

