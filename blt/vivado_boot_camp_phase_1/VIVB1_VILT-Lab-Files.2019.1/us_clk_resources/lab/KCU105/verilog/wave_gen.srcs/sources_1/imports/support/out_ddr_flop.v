//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2009 Xilinx Inc.
//
//  Project  : Programmable Wave Generator
//  Module   : out_ddr_flop.v
//  Parent   : Various
//  Children : None
//
//  Description: 
//    This is a wrapper around a basic DDR output flop.
//    A version of this module with identical ports exists for all target
//    technologies for this design (Spartan 3E and Virtex 5).
//    
//
//  Parameters:
//    None
//
//  Notes       : 
//
//  Multicycle and False Paths, Timing Exceptions
//     None
//

`timescale 1ns/1ps


module out_ddr_flop (
  input            clk,          // Destination clock
  input            rst,          // Reset - synchronous to destination clock
  input            d_rise,       // Data for the rising edge of clock
  input            d_fall,       // Data for the falling edge of clock
  output           q             // Double data rate output
);


//***************************************************************************
// Register declarations
//***************************************************************************

//***************************************************************************
// Code
//***************************************************************************

   // ODDRE1: Dedicated Dual Data Rate (DDR) Output Register
   //         Kintex UltraScale
   // Xilinx HDL Language Template, version 2013.4

   ODDRE1 #(
      .SRVAL(0)  // Initializes the ODDRE1 Flip-Flops to the specified value 
   )
   ODDR_inst (
      .Q(q),       // 1-bit output: Data output to IOB
      .C(clk),     // 1-bit input: High-speed clock input
      .D1(d_rise), // 1-bit input: Parallel data input 1
      .D2(d_fall), // 1-bit input: Parallel data input 2
      .SR(rst)     // 1-bit input: Active High Reset
   );

   // End of ODDRE1_inst instantiation

endmodule

