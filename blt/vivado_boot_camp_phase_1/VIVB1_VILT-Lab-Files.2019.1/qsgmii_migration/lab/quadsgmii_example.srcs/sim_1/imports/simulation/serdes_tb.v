
//------------------------------------------------------------------------------
// File       : serdes_tb.v
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
// Description:The SERDES module serializes the 10-bit data from the 8B/10B encoder and maps 
// it to the receive interface of the DUT transceiver. This module de-serializes the serial 
// bitstream from the transmit interface of the DUT transceiver and maps it to the 8B/10B decoder.
//------------------------------------------------------------------------------


`timescale 1 ps/1 ps

module serdes_tb (
                para_data_in,
                ser_data_out,

                ser_data_in,
                par_data_out,

                sync_reset,

                tx_par_clk,
                tx_ser_clk,

                rx_par_clk,
                rx_ser_clk
              );

    input  [9:0] para_data_in;
    output       ser_data_out;

    input        ser_data_in;
    output [9:0] par_data_out;

    input        sync_reset;

    input        tx_par_clk;
    input        tx_ser_clk;

    input        rx_par_clk;
    input        rx_ser_clk;




    reg    [9 :0] par_data_out;


    reg    [9 :0] para_data_in_ff1;
    reg    [9 :0] shift_reg_par_ser;
    reg    [3 :0] par_ser_cntr;

    reg    [9 :0] shift_reg_ser_par;
    reg    [9 :0] latch_val;
    reg    [3 :0] ser_par_cntr;


    wire   [9 :0] para_data_in_ff1_sync;

    wire          comma_detected;




    // Latch the input 10 bit parallel data from the 
    // encoder
    always @ (posedge tx_par_clk)
    begin
      if(sync_reset)
        para_data_in_ff1 <= 10'h0;
      else
        para_data_in_ff1 <= para_data_in;
    end


    // Convert parallel to serial via a shift register
    always @ (posedge tx_ser_clk)
    begin
      if(sync_reset)
        shift_reg_par_ser <= 10'h0;
      else if(par_ser_cntr == 4'h0)
        shift_reg_par_ser <= para_data_in_ff1;
      else
        shift_reg_par_ser <= shift_reg_par_ser >> 'h1;
    end


    // Counter to keep track of the no. of bits of serial data
    // transmitted
    always @ (posedge tx_ser_clk)
    begin
      if(sync_reset)
        par_ser_cntr <= 4'h0;
      else if(par_ser_cntr == 4'h9)
        par_ser_cntr <= 4'h0;
      else
        par_ser_cntr <= par_ser_cntr + 'h1;
    end


    // Output the serial data at 5GHz
    assign ser_data_out = shift_reg_par_ser[0];


    // Convert serial to parallel via a shift register
    always @ (posedge rx_ser_clk)
    begin
      if(sync_reset)
        shift_reg_ser_par <= 10'h0;
      else
        // shift_reg_ser_par <= {shift_reg_ser_par[8:0], ser_data_in};
        shift_reg_ser_par <= {ser_data_in, shift_reg_ser_par[9:1]};
    end


    // Latch the valid comma aligned data on the serial clock
    always @ (posedge rx_ser_clk)
    begin
      if(sync_reset)
        latch_val <= 10'h0;
      // else if(comma_detected | (ser_par_cntr == 4'h9))
      else if(ser_par_cntr == 4'h9)
        latch_val <= shift_reg_ser_par;
    end


    // Output the 10 bit parallel data on the 500 MHz clock
    always @ (posedge rx_par_clk)
    begin
      if(sync_reset)
        par_data_out <= 10'h0;
      else
        par_data_out <= latch_val;
    end


    // Counter to keep track of the number of bits that have
    // been aligned to the 10 bit boundary
    always @ (posedge rx_ser_clk)
    begin
      if(sync_reset)
        ser_par_cntr <= 4'h0;
      else if(comma_detected)
        ser_par_cntr <= 4'h7;
      else if(ser_par_cntr == 4'h9)
        ser_par_cntr <= 4'h0;
      else
        ser_par_cntr <= ser_par_cntr + 'h1;
    end


    // Logic to detect a comma
    assign comma_detected = (( shift_reg_ser_par[9] &  shift_reg_ser_par[8] &  shift_reg_ser_par[7] & 
                               shift_reg_ser_par[6] &  shift_reg_ser_par[5] & ~shift_reg_ser_par[4] &
                              ~shift_reg_ser_par[3]) |
                             (~shift_reg_ser_par[9] & ~shift_reg_ser_par[8] & ~shift_reg_ser_par[7] &
                              ~shift_reg_ser_par[6] & ~shift_reg_ser_par[5] &  shift_reg_ser_par[4] &
                               shift_reg_ser_par[3]));


    // assign comma_detected = ((~shift_reg_ser_par[9] & ~shift_reg_ser_par[8] &  shift_reg_ser_par[7] & 
    //                            shift_reg_ser_par[6] &  shift_reg_ser_par[5] &  shift_reg_ser_par[4] &
    //                            shift_reg_ser_par[3]) |
    //                          ( shift_reg_ser_par[9] &  shift_reg_ser_par[8] & ~shift_reg_ser_par[7] &
    //                           ~shift_reg_ser_par[6] & ~shift_reg_ser_par[5] & ~shift_reg_ser_par[4] &
    //                           ~shift_reg_ser_par[3]));

endmodule
                             
