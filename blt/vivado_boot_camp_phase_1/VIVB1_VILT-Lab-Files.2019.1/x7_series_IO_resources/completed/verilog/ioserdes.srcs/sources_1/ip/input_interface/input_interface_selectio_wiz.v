
// file: input_interface_selectio_wiz.v
// (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
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
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//----------------------------------------------------------------------------

`timescale 1ps/1ps

module input_interface_selectio_wiz
   // width of the data for the system
 #(parameter SYS_W = 1,
   // width of the data for the device
   parameter DEV_W = 14)
 (
  // From the system into the device
  input  [SYS_W-1:0] data_in_from_pins_p,
  input  [SYS_W-1:0] data_in_from_pins_n,
  output [DEV_W-1:0] data_in_to_device,
 
  output             delay_locked,   // Locked signal from IDELAYCTRL
  input              ref_clock,      // Reference clock for IDELAYCTRL. Has to come from BUFG.
  input  [SYS_W-1:0]             bitslip,       // Bitslip module is enabled in NETWORKING mode
                                    // User should tie it to '0' if not needed
  input              clk_in_p,      // Differential clock from IOB
  input              clk_in_n,
  output             clk_div_out,   // Slow clock output
  input              clk_reset,
  input              io_reset);
  localparam         num_serial_bits = DEV_W/SYS_W;
  wire clock_enable = 1'b1;
  // Signal declarations
  ////------------------------------
  // After the buffer
  wire   [SYS_W-1:0] data_in_from_pins_int;
  // Between the delay and serdes
  wire [SYS_W-1:0]  data_in_from_pins_delay;
  wire ref_clock_bufg;
  // Array to use intermediately from the serdes to the internal
  //  devices. bus "0" is the leftmost bus
  wire [SYS_W-1:0]  iserdes_q[0:13];   // fills in starting with 0
  // Create the clock logic

  IBUFDS
    #(.IOSTANDARD ("LVDS"))
   ibufds_clk_inst
     (.I          (clk_in_p),
      .IB         (clk_in_n),
      .O          (clk_in_int));

  // delay the input clock
      (* IODELAY_GROUP = "input_interface_group" *)
      IDELAYE2
         # (
            .CINVCTRL_SEL           ("FALSE"),            // TRUE, FALSE
            .DELAY_SRC              ("IDATAIN"),        // IDATAIN, DATAIN
            .HIGH_PERFORMANCE_MODE  ("FALSE"),             // TRUE, FALSE
            .IDELAY_TYPE            ("FIXED"),          // FIXED, VARIABLE, or VAR_LOADABLE
            .IDELAY_VALUE           (5),                // 0 to 31
            .REFCLK_FREQUENCY       (200.0),
            .PIPE_SEL               ("FALSE"),
            .SIGNAL_PATTERN         ("CLOCK"))           // CLOCK, DATA
         idelaye2_clk
           (
            .DATAOUT                (clk_in_int_delay),  // Delayed clock
            .DATAIN                 (1'b0),              // Data from FPGA logic
            .C                      (1'b0),
            .CE                     (1'b0),
            .INC                    (1'b0),
            .IDATAIN                (clk_in_int),
            .LD                     (io_reset),
            .LDPIPEEN               (1'b0),
            .REGRST                 (1'b0),
            .CNTVALUEIN             (5'b00000),
            .CNTVALUEOUT            (),
            .CINVCTRL               (1'b0)
         );

// High Speed BUFIO clock buffer
 BUFIO bufio_inst
   (.O(clk_in_int_buf),
    .I(clk_in_int_delay));

  
   // BUFR generates the slow clock
   BUFR
    #(.SIM_DEVICE("7SERIES"),
    .BUFR_DIVIDE("7"))
    clkout_buf_inst
    (.O (clk_div),
     .CE(1'b1),
     .CLR(clk_reset),
     .I (clk_in_int_delay));

   assign clk_div_out = clk_div; // This is regional clock

  // We have multiple bits- step over every bit, instantiating the required elements
  genvar pin_count;
  genvar slice_count;
  generate for (pin_count = 0; pin_count < SYS_W; pin_count = pin_count + 1) begin: pins
    // Instantiate the buffers
    ////------------------------------
    // Instantiate a buffer for every bit of the data bus
    IBUFDS
      #(.DIFF_TERM  ("FALSE"),             // Differential termination
        .IOSTANDARD ("LVDS"))
     ibufds_inst
       (.I          (data_in_from_pins_p  [pin_count]),
        .IB         (data_in_from_pins_n  [pin_count]),
        .O          (data_in_from_pins_int[pin_count]));

    // Instantiate the delay primitive
    ////-------------------------------

     (* IODELAY_GROUP = "input_interface_group" *)
     IDELAYE2
       # (
         .CINVCTRL_SEL           ("FALSE"),                            // TRUE, FALSE
         .DELAY_SRC              ("IDATAIN"),                          // IDATAIN, DATAIN
         .HIGH_PERFORMANCE_MODE  ("FALSE"),                            // TRUE, FALSE
         .IDELAY_TYPE            ("FIXED"),              // FIXED, VARIABLE, or VAR_LOADABLE
         .IDELAY_VALUE           (0),                  // 0 to 31
         .REFCLK_FREQUENCY       (200.0),
         .PIPE_SEL               ("FALSE"),
         .SIGNAL_PATTERN         ("DATA"))                             // CLOCK, DATA
       idelaye2_bus
           (
         .DATAOUT                (data_in_from_pins_delay[pin_count]),
         .DATAIN                 (1'b0),                               // Data from FPGA logic
         .C                      (clk_div),
         .CE                     (1'b0),
         .INC                    (1'b0),
         .IDATAIN                (data_in_from_pins_int  [pin_count]), // Driven by IOB
         .LD                     (1'b0),
         .REGRST                 (1'b0),
         .LDPIPEEN               (1'b0),
         .CNTVALUEIN             (5'b00000),
         .CNTVALUEOUT            (),
         .CINVCTRL               (1'b0)
         );


     // Instantiate the serdes primitive
     ////------------------------------

     // local wire only for use in this generate loop
     wire cascade_shift;
     wire [SYS_W-1:0] icascade1;
     wire [SYS_W-1:0] icascade2;
     wire clk_in_int_inv;

     assign clk_in_int_inv = ~ (clk_in_int_buf);    

     // declare the iserdes
     ISERDESE2
       # (
         .DATA_RATE         ("DDR"),
         .DATA_WIDTH        (14),
         .INTERFACE_TYPE    ("NETWORKING"), 
         .DYN_CLKDIV_INV_EN ("FALSE"),
         .DYN_CLK_INV_EN    ("FALSE"),
         .NUM_CE            (2),
         .OFB_USED          ("FALSE"),
         .IOBDELAY          ("IFD"),                                // Use input at DDLY to output the data on Q
         .SERDES_MODE       ("MASTER"))
       iserdese2_master (
         .Q1                (iserdes_q[0][pin_count]),
         .Q2                (iserdes_q[1][pin_count]),
         .Q3                (iserdes_q[2][pin_count]),
         .Q4                (iserdes_q[3][pin_count]),
         .Q5                (iserdes_q[4][pin_count]),
         .Q6                (iserdes_q[5][pin_count]),
         .Q7                (iserdes_q[6][pin_count]),
         .Q8                (iserdes_q[7][pin_count]),
         .SHIFTOUT1         (icascade1[pin_count]),                 // Cascade connections to Slave ISERDES
         .SHIFTOUT2         (icascade2[pin_count]),                 // Cascade connections to Slave ISERDES
         .BITSLIP           (bitslip[pin_count]),                             // 1-bit Invoke Bitslip. This can be used with any DATA_WIDTH, cascaded or not.
                                                                   // The amount of BITSLIP is fixed by the DATA_WIDTH selection.
         .CE1               (clock_enable),                        // 1-bit Clock enable input
         .CE2               (clock_enable),                        // 1-bit Clock enable input
         .CLK               (clk_in_int_buf),                      // Fast source synchronous clock driven by BUFIO
         .CLKB              (clk_in_int_inv),                      // Locally inverted fast 
         .CLKDIV            (clk_div),                             // Slow clock from BUFR.
         .CLKDIVP           (1'b0),
         .D                 (1'b0),                                // 1-bit Input signal from IOB
         .DDLY              (data_in_from_pins_delay[pin_count]),  // 1-bit Input from Input Delay component 
         .RST               (io_reset),                            // 1-bit Asynchronous reset only.
         .SHIFTIN1          (1'b0),
         .SHIFTIN2          (1'b0),
    // unused connections
         .DYNCLKDIVSEL      (1'b0),
         .DYNCLKSEL         (1'b0),
         .OFB               (1'b0),
         .OCLK              (1'b0),
         .OCLKB             (1'b0),
         .O                 ());                                   // unregistered output of ISERDESE1

     ISERDESE2
       # (
         .DATA_RATE         ("DDR"),
         .DATA_WIDTH        (14),
         .INTERFACE_TYPE    ("NETWORKING"),
         .DYN_CLKDIV_INV_EN ("FALSE"),
         .DYN_CLK_INV_EN    ("FALSE"),
         .NUM_CE            (2),
         .OFB_USED          ("FALSE"),
         .IOBDELAY          ("IFD"),                // Use input at DDLY to output the data on Q
         .SERDES_MODE       ("SLAVE"))
       iserdese2_slave (
         .Q1                (),
         .Q2                (),
         .Q3                (iserdes_q[8][pin_count]),
         .Q4                (iserdes_q[9][pin_count]),
         .Q5                (iserdes_q[10][pin_count]),
         .Q6                (iserdes_q[11][pin_count]),
         .Q7                (iserdes_q[12][pin_count]),
         .Q8                (iserdes_q[13][pin_count]),
         .SHIFTOUT1         (),
         .SHIFTOUT2         (),
         .SHIFTIN1          (icascade1[pin_count]),  // Cascade connection with Master ISERDES
         .SHIFTIN2          (icascade2[pin_count]),  // Cascade connection with Master ISERDES
         .BITSLIP           (bitslip[pin_count]),               // 1-bit Invoke Bitslip. This can be used with any DATA_WIDTH, cascaded or not.
                                                     // The amount of BITSLIP is fixed by the DATA_WIDTH selection .
         .CE1               (clock_enable),          // 1-bit Clock enable input
         .CE2               (clock_enable),          // 1-bit Clock enable input 
         .CLK               (clk_in_int_buf),        // Fast source synchronous serdes clock
         .CLKB              (clk_in_int_inv),        // Locally inverted fast clock
         .CLKDIV            (clk_div),               // Slow clock from BUFR.
         .CLKDIVP           (1'b0),
         .D                 (1'b0),                  // Slave ISERDES. No need to connect D, DDLY
         .DDLY              (1'b0),
         .RST               (io_reset),              // 1-bit Asynchronous reset only.
   // unused connections
         .DYNCLKDIVSEL      (1'b0),
         .DYNCLKSEL         (1'b0),
         .OFB               (1'b0),
         .OCLK              (1'b0),
         .OCLKB             (1'b0),
         .O                 ());                     // unregistered output of ISERDESE1
     // Concatenate the serdes outputs together. Keep the timesliced
     //   bits together, and placing the earliest bits on the right
     //   ie, if data comes in 0, 1, 2, 3, 4, 5, 6, 7, ...
     //       the output will be 3210, 7654, ...
     ////---------------------------------------------------------
     for (slice_count = 0; slice_count < num_serial_bits; slice_count = slice_count + 1) begin: in_slices
        // This places the first data in time on the right
        assign data_in_to_device[slice_count] =
          iserdes_q[num_serial_bits-slice_count-1];
        // To place the first data in time on the left, use the
        //   following code, instead
        // assign data_in_to_device[slice_count] =
        //   iserdes_q[slice_count];
     end
  end
  endgenerate
  
//// NO ODELAY

// IDELAYCTRL is needed for calibration
(* IODELAY_GROUP = "input_interface_group" *)
  IDELAYCTRL
    delayctrl (
     .RDY    (delay_locked),
     .REFCLK (ref_clock_bufg),
     .RST    (io_reset));

  BUFG
    ref_clk_bufg (
     .I (ref_clock),
     .O (ref_clock_bufg));
endmodule
