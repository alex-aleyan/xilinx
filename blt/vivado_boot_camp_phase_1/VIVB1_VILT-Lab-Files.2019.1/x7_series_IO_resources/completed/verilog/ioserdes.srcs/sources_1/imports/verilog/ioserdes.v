//  
//  Copyright (c) 2010 Xilinx Inc.
//
//  Project  : I/O Serdes Lab
//  Module   : ioserdes.v
//  Parent   : None
//  Children : None
//
//  Description: 
//     This is the rtl file for the I/O Serdes lab
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

module ioserdes (
  input             clk_tx_pin,
  input             rst_tx_pin,
  output            data_out_p_pin,
  output            data_out_n_pin,
  output            clk_out_p_pin,
  output            clk_out_n_pin,
  input             data_in_p_pin,
  input             data_in_n_pin,
  input             clk_in_p_pin,
  input             clk_in_n_pin,
  input             rst_rx_clk_pin,
  input             rst_rx_pin,
  input             bitslip_en_pin,
  output            idelayctrl_rdy_pin,
  output            match_pin
);

  wire clk_tx_io;  // IO (high speed) clock
  wire clk_tx_div; // low speed clock

  wire rst_tx_in;
  wire ref_clk;
  
  wire data_out_to_delay;
  wire data_out_out;
  wire clk_out_to_delay;
  wire clk_out_out;

  wire idelayctrl_rdy_out;

  wire clk_in_in;
  wire data_in_in;
  wire bitslip_en_in;

  wire rst_rx_in;
  wire rst_rx_clk_in;

  wire [13:0]     rx_cnt;

  reg  [13:0]     tx_cnt;
  reg  [13:0]     old_rx_cnt;

  reg            match_out;

  IBUF IBUF_rst_tx_pin_i0     (.I(rst_tx_pin),     .O(rst_tx_in));

  IBUF IBUF_rst_rx_clk_pin_i0 (.I(rst_rx_clk_pin), .O(rst_rx_clk_in));

  IBUF IBUF_rst_rx_pin_i0     (.I(rst_rx_pin),     .O(rst_rx_in));

  IBUF IBUF_bitslip_pin_en_i0 (.I(bitslip_en_pin), .O(bitslip_en_in));



  /**********************************************************
  * Counter implementation
  ***********************************************************/

  always @(posedge clk_tx_div or posedge rst_tx_in)
  begin
    if (rst_tx_in)
    begin
      tx_cnt <= 14'b0;
    end
    else
    begin
      tx_cnt <= tx_cnt + 1'b1;
    end
  end

  /**********************************************************
  * Output Interface
  ***********************************************************/
 
  output_interface output_interface_i0
  (
    // From the device out to the system
    .data_out_from_device(tx_cnt[13:0]),
    .data_out_to_pins_p(data_out_p_pin),
    .data_out_to_pins_n(data_out_n_pin),

 
    .clk_in(clk_tx_io),        // Fast clock input from PLL/MMCM
    .clk_div_in(clk_tx_div),    // Slow clock input from PLL/MMCM
    .io_reset(rst_tx_in)
  );

  /**********************************************************
  * Input logic for high speed data
  * *********************************************************/
  input_interface input_interface_i0
  (
    // From the system into the device
    .data_in_from_pins_p(data_in_p_pin),
    .data_in_from_pins_n(data_in_n_pin),
    .data_in_to_device(rx_cnt),

    .delay_locked(),          // Locked signal from IDELAYCTRL
    .ref_clock(ref_clk),      // Reference clock for IDELAYCTRL. Has to come from BUFG.

    .bitslip(bitslip_en_in),  // Bitslip module is enabled in NETWORKING mode
                              // User should tie it to '0' if not needed
 
    .clk_in_p(clk_in_p_pin),  // Differential clock from IOB
    .clk_in_n(clk_in_n_pin),
    .clk_div_out(clk_rx_div), // Slow clock output
    .clk_reset(rst_rx_clk_in),
    .io_reset(rst_rx_in)
  );

  /**********************************************************
  * Output Clock
  ***********************************************************/
  output_clock output_clock_i0
  (
    // From the device out to the system
    .data_out_from_device(2'b01),
    .data_out_to_pins_p(clk_out_p_pin),
    .data_out_to_pins_n(clk_out_n_pin),

 
    .clk_in(clk_tx_io),        // Fast clock input from PLL/MMCM
    .io_reset(rst_tx_in)
  );
 
 wire [13:0] next_old_cnt = old_rx_cnt + 1'b1;

  always @(posedge clk_rx_div)
  begin
    if (rst_rx_in)
    begin
      old_rx_cnt <= 10'b0;
      match_out  <= 1'b0;
    end
    else
    begin
      old_rx_cnt <= rx_cnt;
      match_out  <= (rx_cnt == next_old_cnt);
    end
  end

  OBUF OBUF_match_pin_i0 (.I(match_out), .O(match_pin));

 
 
 /**********************************************************
  * Clocking section for Transmit
  * *********************************************************/

  tx_pll tx_pll_i0
  (// Clock in ports
   .clk_in1            (clk_tx_pin),      // IN
   // Clock out ports
   .clk_out1           (ref_clk),        // OUT
   .clk_out2           (pll_clk_hs));    // OUT


  BUFIO BUFIO_clk_tx_i0 (.I(pll_clk_hs),  .O(clk_tx_io));
  BUFR #(
    .BUFR_DIVIDE("7") 
  ) BUFR_clk_tx_i0 (
    .O(clk_tx_div), // Clock buffer output
    .CE(1'b1),      // Clock enable input
    .CLR(1'b0),     // Clock buffer reset input
    .I(pll_clk_hs)   // Clock buffer input
  );

endmodule
