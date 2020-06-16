//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2010 Xilinx Inc.
//
//  Project  : I/O Serdes Lab
//  Module   : test_ioserdes.v
//  Parent   : None
//  Children : io_serdes.v
//
//  Description: 
//     This is the testbench for the io_serdes.v module.
//
//  Parameters:
//
//  Local Parameters:
//
//  Notes       : 
//
//  Multicycle and False Paths
//    
//

`timescale 1ns/1ps

module test_ioserdes;

  reg  clk_tx_pin = 0;  // TX clock at pin 
  reg  ref_clk_pin = 0; // Reference clock for IDELAYCTRL
  reg  rst_tx_pin;      // Active high reset for TX side
  reg  bitslip_en_pin = 0; // Bitslip
  reg  rst_rx_clk_pin;
  reg  rst_rx_pin;

  integer i;

  wire data_p_pin;
  wire data_n_pin;
  wire clk_p_pin;
  wire clk_n_pin;

  ioserdes ioserdes_i0 (
    .clk_tx_pin     (clk_tx_pin),
    .rst_tx_pin     (rst_tx_pin),
    .data_out_p_pin (data_p_pin),
    .data_out_n_pin (data_n_pin),
    .clk_out_p_pin  (clk_p_pin),
    .clk_out_n_pin  (clk_n_pin),
    .data_in_p_pin  (data_p_pin), // Looped around
    .data_in_n_pin  (data_n_pin), // Looped around
    .clk_in_p_pin   (clk_p_pin),  // Looped around
    .clk_in_n_pin   (clk_n_pin),  // Looped around
    .rst_rx_clk_pin (rst_rx_clk_pin),
    .rst_rx_pin     (rst_rx_pin),
    .bitslip_en_pin (bitslip_en_pin),
    .match_pin      (match_pin)
  );

  // Generate a 100MHz clock for clk_tx_pin
  always
  begin
    #5 clk_tx_pin = !clk_tx_pin;
  end

  // Manage the rst_tx_pin
  initial 
  begin
          rst_tx_pin = 1'b1;
    #1000 rst_tx_pin = 1'b0;
  end

  // Manage the rst_rx_clk_pin
  initial 
  begin
          rst_rx_clk_pin = 1'b1;
    #2000 rst_rx_clk_pin = 1'b0;
  end
  
  // Manage the rst_rx_pin
  initial 
  begin
          rst_rx_pin = 1'b1;
    #3000 rst_rx_pin = 1'b0;
  end

  initial
  begin
  #4000;
    bitslip_en_pin = 0;
    for (i=0; i<=15; i=i+1)
    begin
      bitslip_en_pin = 1;
      #10 bitslip_en_pin = 0;
      #1000;
    end
    $stop;
  end

endmodule
