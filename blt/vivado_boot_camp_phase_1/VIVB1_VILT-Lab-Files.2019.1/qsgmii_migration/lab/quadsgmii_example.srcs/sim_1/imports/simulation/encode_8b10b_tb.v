
//------------------------------------------------------------------------------
// File       : encode_8b10b_tb.v
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
// Description:The 8B/10B encoder test bench module converts 8-bit data from arbiter to 
// 10 bits as specified by IEEE 802.3-2008 standard clause 36.
//------------------------------------------------------------------------------


`timescale 1 ps/1 ps

module encode_8b10b_tb (
                         output reg [9:0] q10_ff,
                         output reg       disparity_pos_out_ff,

                         input      [7:0] d8,
                         input            is_k,
                         input            disparity_pos_in,

                         input            encode_clk
                       );

  // reg [0:9] q10_ff;
  // reg       disparity_pos_out_ff;


  reg [5:0] b6;
  reg [3:0] b4;
  reg       pdes6;
  reg [9:0] q10;
  reg       disparity_pos_out;


  wire      k28, a7, l13, l31, a, b, c, d, e;

  integer I;



  initial
  begin
    q10_ff               = 10'h0;
    disparity_pos_out_ff = 1'h0;
  end


  always @(posedge encode_clk)
  begin
    q10_ff               <= q10;
    disparity_pos_out_ff <= disparity_pos_out;
  end


  // precalculate some common terms
  assign a = d8[0];
  assign b = d8[1];
  assign c = d8[2];
  assign d = d8[3];
  assign e = d8[4];

  assign k28 = (is_k && (d8[4:0] === 5'b11100));

  assign l13 = (((a ^ b) & !(c | d))
               | ((c ^ d) & !(a | b)));

  assign l31 = (((a ^ b) & (c & d))
               | ((c ^ d) & (a & b)));

  assign a7  = is_k | ((l31 & d & !e & disparity_pos_in)
                    | (l13 & !d & e & !disparity_pos_in));


  always @*
  begin
    // calculate the running disparity after the 5B6B block encode
    if (k28)                           //K.28
    begin
      if (!disparity_pos_in)
        b6 = 6'b111100;
      else
        b6 = 6'b000011;
    end
    else
    begin
      case (d8[4:0])
      5'b00000 :                 //D.0
      begin
        if (disparity_pos_in)
          b6 = 6'b000110;
        else
          b6 = 6'b111001;
      end

      5'b00001 :                 //D.1
      begin
        if (disparity_pos_in)
          b6 = 6'b010001;
        else
          b6 = 6'b101110;
      end

      5'b00010 :                 //D.2
      begin
        if (disparity_pos_in)
          b6 = 6'b010010;
        else
          b6 = 6'b101101;
      end

      5'b00011 :
        b6 = 6'b100011;              //D.3

      5'b00100 :                 //-D.4
      begin
        if (disparity_pos_in)
          b6 = 6'b010100;
        else
          b6 = 6'b101011;
      end

      5'b00101 :
        b6 = 6'b100101;          //D.5

      5'b00110 :
        b6 = 6'b100110;          //D.6

      5'b00111 :                 //D.7
      begin
        if (!disparity_pos_in)
          b6 = 6'b000111;
        else
          b6 = 6'b111000;
      end

      5'b01000 :                 //D.8
      begin
        if (disparity_pos_in)
          b6 = 6'b011000;
        else
          b6 = 6'b100111;
      end

      5'b01001 :
        b6 = 6'b101001;          //D.9

      5'b01010 :
        b6 = 6'b101010;          //D.10

      5'b01011 :
        b6 = 6'b001011;          //D.11

      5'b01100 :
        b6 = 6'b101100;          //D.12

      5'b01101 :
        b6 = 6'b001101;          //D.13

      5'b01110 :
        b6 = 6'b001110;          //D.14

      5'b01111 :                 //D.15
      begin
        if (disparity_pos_in)
          b6 = 6'b000101;
        else
          b6 = 6'b111010;
      end

      5'b10000 :                 //D.16
      begin
        if (!disparity_pos_in)
          b6 = 6'b110110;
        else
          b6 = 6'b001001;
      end

      5'b10001 :
        b6 = 6'b110001;          //D.17

      5'b10010 :
        b6 = 6'b110010;          //D.18

      5'b10011 :
        b6 = 6'b010011;          //D.19

      5'b10100 :
        b6 = 6'b110100;          //D.20

      5'b10101 :
        b6 = 6'b010101;          //D.21

      5'b10110 :
        b6 = 6'b010110;          //D.22

      5'b10111 :                 //D/K.23
      begin
        if (!disparity_pos_in)
          b6 = 6'b010111;
        else
          b6 = 6'b101000;
      end

      5'b11000 :                 //D.24
      begin
        if (disparity_pos_in)
          b6 = 6'b001100;
        else
          b6 = 6'b110011;
      end

      5'b11001 :
        b6 = 6'b011001;          //D.25

      5'b11010 :
        b6 = 6'b011010;          //D.26

      5'b11011 :                 //D/K.27
      begin
        if (!disparity_pos_in)
          b6 = 6'b011011;
        else
          b6 = 6'b100100;
      end

      5'b11100 :
        b6 = 6'b011100;          //D.28

      5'b11101 :                 //D/K.29
      begin
        if (!disparity_pos_in)
          b6 = 6'b011101;
        else
          b6 = 6'b100010;
      end

      5'b11110 :                 //D/K.30
      begin
        if (!disparity_pos_in)
          b6 = 6'b011110;
        else
          b6 = 6'b100001;
      end

      5'b11111 :                 //D.31
      begin
        if (!disparity_pos_in)
          b6 = 6'b110101;
        else
          b6 = 6'b001010;
      end

      default :
        b6 = 6'bXXXXXX;
      endcase // case(d8[4:0])
    end
  end


  always @*
  begin
    // reverse the bits
    for (I = 0; I < 6; I = I + 1)
      q10[I] = b6[I];
  end


  always @*
  begin
    // calculate the running disparity after the 5B6B block encode
    if (k28)
      pdes6 = !disparity_pos_in;
    else
    begin
      case (d8[4:0])
              5'b00000 : pdes6 = !disparity_pos_in;
              5'b00001 : pdes6 = !disparity_pos_in;
              5'b00010 : pdes6 = !disparity_pos_in;
              5'b00011 : pdes6 = disparity_pos_in;
              5'b00100 : pdes6 = !disparity_pos_in;
              5'b00101 : pdes6 = disparity_pos_in;
              5'b00110 : pdes6 = disparity_pos_in;
              5'b00111 : pdes6 = disparity_pos_in;
              5'b01000 : pdes6 = !disparity_pos_in;
              5'b01001 : pdes6 = disparity_pos_in;
              5'b01010 : pdes6 = disparity_pos_in;
              5'b01011 : pdes6 = disparity_pos_in;
              5'b01100 : pdes6 = disparity_pos_in;
              5'b01101 : pdes6 = disparity_pos_in;
              5'b01110 : pdes6 = disparity_pos_in;
              5'b01111 : pdes6 = !disparity_pos_in;
              5'b10000 : pdes6 = !disparity_pos_in;
              5'b10001 : pdes6 = disparity_pos_in;
              5'b10010 : pdes6 = disparity_pos_in;
              5'b10011 : pdes6 = disparity_pos_in;
              5'b10100 : pdes6 = disparity_pos_in;
              5'b10101 : pdes6 = disparity_pos_in;
              5'b10110 : pdes6 = disparity_pos_in;
              5'b10111 : pdes6 = !disparity_pos_in;
              5'b11000 : pdes6 = !disparity_pos_in;
              5'b11001 : pdes6 = disparity_pos_in;
              5'b11010 : pdes6 = disparity_pos_in;
              5'b11011 : pdes6 = !disparity_pos_in;
              5'b11100 : pdes6 = disparity_pos_in;
              5'b11101 : pdes6 = !disparity_pos_in;
              5'b11110 : pdes6 = !disparity_pos_in;
              5'b11111 : pdes6 = !disparity_pos_in;
              default  : pdes6 = disparity_pos_in;
      endcase // case(d8[4:0])
    end
  end


  always @*
  begin
    case (d8[7:5])
      3'b000 :                     //D/K.x.0
      begin
      if (pdes6)
        b4 = 4'b0010;
      else
        b4 = 4'b1101;
      end

      3'b001 :                     //D/K.x.1
      begin
      if (k28 && !pdes6)
        b4 = 4'b0110;
      else
        b4 = 4'b1001;
      end

      3'b010 :                     //D/K.x.2
      begin
      if (k28 && !pdes6)
        b4 = 4'b0101;
      else
        b4 = 4'b1010;
      end

      3'b011 :                     //D/K.x.3
      begin
      if (!pdes6)
        b4 = 4'b0011;
      else
        b4 = 4'b1100;
      end

      3'b100 :                     //D/K.x.4
      begin
      if (pdes6)
        b4 = 4'b0100;
      else
        b4 = 4'b1011;
      end

      3'b101 :                     //D/K.x.5
      begin
      if (k28 && !pdes6)
        b4 = 4'b1010;
      else
        b4 = 4'b0101;
      end

      3'b110 :                     //D/K.x.6
      begin
      if (k28 && !pdes6)
        b4 = 4'b1001;
      else
        b4 = 4'b0110;
      end

      3'b111 :                     //D.x.P7
      begin
        if (!a7)
        begin
          if (!pdes6)
            b4 = 4'b0111;
          else
            b4 = 4'b1000;
        end
        else                   //D/K.y.A7
        begin
          if (!pdes6)
            b4 = 4'b1110;
          else
            b4 = 4'b0001;
        end
      end

      default :
        b4 = 4'bXXXX;
    endcase
  end


  always @*
  begin
    // Reverse the bits
    for (I = 0; I < 4; I = I + 1)
      q10[I+6] = b4[I];
  end


  always @*
  begin
    // Calculate the running disparity after the 4B group
    case (d8[7:5])
      3'b000  : disparity_pos_out = ~pdes6;
      3'b001  : disparity_pos_out = pdes6;
      3'b010  : disparity_pos_out = pdes6;
      3'b011  : disparity_pos_out = pdes6;
      3'b100  : disparity_pos_out = ~pdes6;
      3'b101  : disparity_pos_out = pdes6;
      3'b110  : disparity_pos_out = pdes6;
      3'b111  : disparity_pos_out = ~pdes6;
      default : disparity_pos_out = pdes6;
    endcase
  end

endmodule

