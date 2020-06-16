//------------------------------------------------------------------------------
// File       : quadsgmii_clock_div.v
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
//  Description:  This logic describes a standard clock divider to
//                create divided down clocks.  
//                Three clocks are created: 
//                      a> Divide by 5
//                      b> Divide by 10
//                      c> Divide by 50
//
//                The capabilities of this clock divideris extended
//                with the use of the clock enables - it is only the
//                clock-enabled cycles which are divided down.
//
//                The three divided clockw are output directly from a rising
//                edge triggered flip-flop (clocked on the input clk).


`timescale 1 ps/1 ps


//------------------------------------------------------------------------------
// Module declaration.
//-----------------------------------------------------------------------------

(* DowngradeIPIdentifiedWarnings="yes" *)
module quadsgmii_clock_div
  (
    input      reset,             // Synchronous Reset
    input      clk,               // Input clock (always at 125MHz)
    output reg clk_div5_neg,      // Clock divide by 5
    output reg clk_div5_pos,      // Clock divide by 5
    output reg clk_div5_plse_rise,
    output reg clk_div5_plse_fall,
    output reg clk_div10,         // Clock divide by 10
    output reg clk_div10_plse_rise,
    output reg clk_div10_plse_fall
  );



   reg  [2:0] clk_counter_pos_stg1;
   reg  [2:0] clk_counter_neg_stg1;
   reg        reset_neg;
   reg        clk_div5_reg1;
   reg        clk_div5_plse_rise_sig;
   reg        clk_div5_plse_fall_sig;
   reg        clk_div10_reg1;

   always @(posedge clk)
   begin
       if (reset == 1'b1) begin
           clk_counter_pos_stg1 <= 3'b000;
       end
       else begin
           if (clk_counter_pos_stg1 == 3'b100) begin
               clk_counter_pos_stg1 <= 3'b000;
           end else begin
               clk_counter_pos_stg1 <= clk_counter_pos_stg1 + 3'b001;
         end
       end
   end

   always @(negedge clk)
   begin
       clk_counter_neg_stg1 <= clk_counter_pos_stg1;
       reset_neg            <= reset;
   end
   
   always @(posedge clk)
   begin
       if (reset == 1'b1) begin
               clk_div5_pos <= 1'b0;
       end else begin
           if (clk_counter_neg_stg1 == 3'b001) begin
               clk_div5_pos <= 1'b1;
           end else if (clk_counter_neg_stg1 == 3'b100) begin
               clk_div5_pos <= 1'b0;
           end
       end
   end

   always @(negedge clk)
   begin
       if (reset_neg == 1'b1) begin
               clk_div5_neg <= 1'b0;
       end else begin
           if (clk_counter_pos_stg1 == 3'b010) begin
               clk_div5_neg <= 1'b1;
           end else if (clk_counter_pos_stg1 == 3'b100) begin
               clk_div5_neg <= 1'b0;
           end
       end
   end
   
   always @(posedge clk)
   begin
       if (reset == 1'b1) begin
           clk_div5_reg1          <= 1'b0;
           clk_div5_plse_rise_sig <= 1'b0;
           clk_div5_plse_fall_sig <= 1'b0;
           clk_div5_plse_rise     <= 1'b0;
           clk_div5_plse_fall     <= 1'b0;
           clk_div10              <= 1'b0;
           clk_div10_reg1         <= 1'b0;
           clk_div10_plse_rise    <= 1'b0;
           clk_div10_plse_fall    <= 1'b0;
       end else begin
           clk_div5_reg1          <= clk_div5_pos;
           clk_div10_reg1         <= clk_div10;
           clk_div5_plse_rise_sig <= clk_div5_pos && !clk_div5_reg1;
           clk_div5_plse_fall_sig <= !clk_div5_pos && clk_div5_reg1;
           clk_div5_plse_rise     <= clk_div5_plse_rise_sig;
           clk_div5_plse_fall     <= clk_div5_plse_fall_sig;
           clk_div10_plse_rise    <= clk_div10 && !clk_div10_reg1;
           clk_div10_plse_fall    <= !clk_div10 && clk_div10_reg1;
           if (clk_div5_pos && !clk_div5_reg1) begin
               clk_div10     <= !clk_div10;
           end
       end
   end
          
endmodule

