
//------------------------------------------------------------------------------
// File       : clk_en_gen_tb.v
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
// Description:This module generates clock enables according to the configured speed.
//------------------------------------------------------------------------------

`timescale 1 ps/1 ps

module clk_en_gen_tb (
                       clock_enable,
                       speed_is_100,
                       speed_is_10_100,

                       clk
                     );
                     
                     
  output     clock_enable;

  input      speed_is_100;
  input      speed_is_10_100;

  input      clk;


  reg        clock_enable_1;
  reg        clock_enable_2;
  reg        clock_enable_3;
  reg        clock_enable;
  reg [6 :0] sample_count;


  // Set the expected data rate: sample the data on every clock at
  // 1Gbps, every 10 clocks at 100Mbps, every 100 clocks at 10Mbps

  initial
    sample_count = 0;

  always @(posedge clk)
  begin : gen_clock_enable
    if (speed_is_10_100 == 1'b0) begin
      sample_count <= 0;
      clock_enable_1 <= 1'b1;                            // sample on every clock
    end
    else begin
      if ((speed_is_100 &&  sample_count == 9) ||      // sample every 10 clocks
          (!speed_is_100 &&  sample_count == 99)) begin // sample every 100 clocks
        sample_count <= 0;
        clock_enable_1 <= 1'b1;
      end
      else begin
        if (sample_count == 99) begin
          sample_count <= 0;
        end
        else begin
          sample_count <= sample_count + 1;
        end
        clock_enable_1 <= 1'b0;
      end
    end
    clock_enable_2 <= clock_enable_1;
    clock_enable_3 <= clock_enable_2;
    clock_enable   <= clock_enable_3;
  end

endmodule

