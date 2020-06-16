
//------------------------------------------------------------------------------
// File       : decode_8b10b_tb.v
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
// Description: The 8B/10B decoder test bench module converts 10-bit data from SERDES on the
// transceiver transmit interface to 10 bits as specified by IEEE 802.3-2008 standard clause 36.
//------------------------------------------------------------------------------


`timescale 1 ps/1 ps

module decode_8b10b_tb (
                         output reg [7:0] q8_ff,
                         output reg       is_k_ff,

                         input      [9:0] d10,
                         input            decode_clk
                       );

  // reg [7:0] q8_ff;
  // reg       is_k_ff;
  reg [9:0] d10_ff;
  reg [9:0] d10_rev;

  reg [7:0] q8;

  wire      is_k;


  wire      k28;

  integer   I;


  initial
  begin
    d10_ff  = 10'h0;
    q8_ff   = 8'h0;
    is_k_ff = 1'h0;
  end


  always @(posedge decode_clk)
  begin
    d10_ff <= d10;
  end


  always @(posedge decode_clk)
  begin
    q8_ff   <= q8;
    is_k_ff <= is_k;
  end


   // always @*
   // begin
   //   // reverse the 10B codeword
   //   for (I = 0; I < 10; I = I + 1)
   //     d10_rev[I] = d10_ff[I];
   // end


   always @*
   begin
     case (d10_ff[5:0])
       6'b000110 : q8[4:0] = 5'b00000;   //D.0
       6'b111001 : q8[4:0] = 5'b00000;   //D.0
       6'b010001 : q8[4:0] = 5'b00001;   //D.1
       6'b101110 : q8[4:0] = 5'b00001;   //D.1
       6'b010010 : q8[4:0] = 5'b00010;   //D.2
       6'b101101 : q8[4:0] = 5'b00010;   //D.2
       6'b100011 : q8[4:0] = 5'b00011;   //D.3
       6'b010100 : q8[4:0] = 5'b00100;   //D.4
       6'b101011 : q8[4:0] = 5'b00100;   //D.4
       6'b100101 : q8[4:0] = 5'b00101;   //D.5
       6'b100110 : q8[4:0] = 5'b00110;   //D.6
       6'b000111 : q8[4:0] = 5'b00111;   //D.7
       6'b111000 : q8[4:0] = 5'b00111;   //D.7
       6'b011000 : q8[4:0] = 5'b01000;   //D.8
       6'b100111 : q8[4:0] = 5'b01000;   //D.8
       6'b101001 : q8[4:0] = 5'b01001;   //D.9
       6'b101010 : q8[4:0] = 5'b01010;   //D.10
       6'b001011 : q8[4:0] = 5'b01011;   //D.11
       6'b101100 : q8[4:0] = 5'b01100;   //D.12
       6'b001101 : q8[4:0] = 5'b01101;   //D.13
       6'b001110 : q8[4:0] = 5'b01110;   //D.14
       6'b000101 : q8[4:0] = 5'b01111;   //D.15
       6'b111010 : q8[4:0] = 5'b01111;   //D.15
       6'b110110 : q8[4:0] = 5'b10000;   //D.16
       6'b001001 : q8[4:0] = 5'b10000;   //D.16
       6'b110001 : q8[4:0] = 5'b10001;   //D.17
       6'b110010 : q8[4:0] = 5'b10010;   //D.18
       6'b010011 : q8[4:0] = 5'b10011;   //D.19
       6'b110100 : q8[4:0] = 5'b10100;   //D.20
       6'b010101 : q8[4:0] = 5'b10101;   //D.21
       6'b010110 : q8[4:0] = 5'b10110;   //D.22
       6'b010111 : q8[4:0] = 5'b10111;   //D/K.23
       6'b101000 : q8[4:0] = 5'b10111;   //D/K.23
       6'b001100 : q8[4:0] = 5'b11000;   //D.24
       6'b110011 : q8[4:0] = 5'b11000;   //D.24
       6'b011001 : q8[4:0] = 5'b11001;   //D.25
       6'b011010 : q8[4:0] = 5'b11010;   //D.26
       6'b011011 : q8[4:0] = 5'b11011;   //D/K.27
       6'b100100 : q8[4:0] = 5'b11011;   //D/K.27
       6'b011100 : q8[4:0] = 5'b11100;   //D.28
       6'b111100 : q8[4:0] = 5'b11100;   //K.28
       6'b000011 : q8[4:0] = 5'b11100;   //K.28
       6'b011101 : q8[4:0] = 5'b11101;   //D/K.29
       6'b100010 : q8[4:0] = 5'b11101;   //D/K.29
       6'b011110 : q8[4:0] = 5'b11110;   //D.30
       6'b100001 : q8[4:0] = 5'b11110;   //D.30
       6'b110101 : q8[4:0] = 5'b11111;   //D.31
       6'b001010 : q8[4:0] = 5'b11111;   //D.31
             default   : q8[4:0] = 5'b11110;    //CODE VIOLATION - return /E/
     endcase
   end

   assign k28 = ~((d10_ff[2] | d10_ff[3] | d10_ff[4] | d10_ff[5] | ~(d10_ff[8] ^ d10_ff[9])));
   // assign k28 = ~((d10_ff[7] | d10_ff[6] | d10_ff[5] | d10_ff[4] | ~(d10_ff[1] ^ d10_ff[0])));

   always @*
   begin
     case (d10_ff[9:6])
       4'b0010 : q8[7:5] = 3'b000;       //D/K.x.0
       4'b1101 : q8[7:5] = 3'b000;       //D/K.x.0
       4'b1001 :
         if (!k28)
           q8[7:5] = 3'b001;             //D/K.x.1
               else
           q8[7:5] = 3'b110;             //K28.6
       4'b0110 :
               if (k28)
                 q8[7:5] = 3'b001;         //K.28.1
               else
                 q8[7:5] = 3'b110;         //D/K.x.6
       4'b1010 :
               if (!k28)
                 q8[7:5] = 3'b010;         //D/K.x.2
               else
                 q8[7:5] = 3'b101;         //K28.5
       4'b0101 :
               if (k28)
                 q8[7:5] = 3'b010;         //K28.2
               else
                 q8[7:5] = 3'b101;         //D/K.x.5
       4'b0011 : q8[7:5] = 3'b011;       //D/K.x.3
       4'b1100 : q8[7:5] = 3'b011;       //D/K.x.3
       4'b0100 : q8[7:5] = 3'b100;       //D/K.x.4
       4'b1011 : q8[7:5] = 3'b100;       //D/K.x.4
       4'b0111 : q8[7:5] = 3'b111;       //D.x.7
       4'b1000 : q8[7:5] = 3'b111;       //D.x.7
       4'b1110 : q8[7:5] = 3'b111;       //D/K.x.7
       4'b0001 : q8[7:5] = 3'b111;       //D/K.x.7
       default : q8[7:5] = 3'b111;   //CODE VIOLATION - return /E/
     endcase
   end

   assign is_k = ((d10_ff[2] & d10_ff[3] & d10_ff[4] & d10_ff[5])
       | ~(d10_ff[2] | d10_ff[3] | d10_ff[4] | d10_ff[5])
       | ((d10_ff[4] ^ d10_ff[5]) & ((d10_ff[5] & d10_ff[7] & d10_ff[8] & d10_ff[9])
             | ~(d10_ff[5] | d10_ff[7] | d10_ff[8] | d10_ff[9]))));

   // assign is_k = ((d10_ff[7] & d10_ff[6] & d10_ff[5] & d10_ff[4])
   //     | ~(d10_ff[7] | d10_ff[6] | d10_ff[5] | d10_ff[4])
   //     | ((d10_ff[5] ^ d10_ff[4]) & ((d10_ff[4] & d10_ff[2] & d10_ff[1] & d10_ff[0])
   //           | ~(d10_ff[4] | d10_ff[2] | d10_ff[1] | d10_ff[0]))));

endmodule

