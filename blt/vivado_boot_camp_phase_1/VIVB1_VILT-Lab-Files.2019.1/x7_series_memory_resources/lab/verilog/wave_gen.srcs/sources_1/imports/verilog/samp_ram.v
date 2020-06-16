//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2009 Xilinx Inc.
//
//  Project  : Programmable Wave Generator
//  Module   : samp_ram.v
//  Parent   : wave_gen.v
//  Children : None
//
//  Description: 
//    This module infers the sample RAM - a 1024x16 dual port RAM
//
//  Parameters:
//     None
//
//  Notes       : 
//     This models a READ_FIRST memory
//
//  Multicycle and False Paths
//     None

`timescale 1ns/1ps


module samp_ram #(
  parameter DATA_WIDTH = 16,
  parameter ADDR_WIDTH = 10
 ) (
  // A port
  input                       clka,           // Clock
  input      [DATA_WIDTH-1:0] dina,           // Input data
  input      [ADDR_WIDTH-1:0] addra,          // Address
  input                       wea,            // Write enable
  output reg [DATA_WIDTH-1:0] douta,          // Output data
  // B port
  input                       clkb,           // Clock
  input      [DATA_WIDTH-1:0] dinb,           // Input data
  input      [ADDR_WIDTH-1:0] addrb,          // Address
  input                       web,            // Write enable
  output reg [DATA_WIDTH-1:0] doutb           // Output data
);

//***************************************************************************
// Function definitions
//***************************************************************************

//***************************************************************************
// Parameter definitions
//***************************************************************************

//***************************************************************************
// Reg declarations
//***************************************************************************

  reg [DATA_WIDTH-1:0] mem_array [0:(2**ADDR_WIDTH)-1];

//***************************************************************************
// Wire declarations
//***************************************************************************

//***************************************************************************
// Code
//***************************************************************************

  // A port operations
  always @(posedge clka)
  begin

    // Insert code for synchronous read here

    // Insert code for synchronous write here

  end

  // B port operations
  always @(posedge clkb)
  begin

    // Insert code for synchronous read here

    // Insert code for synchronous write here

  end

endmodule
