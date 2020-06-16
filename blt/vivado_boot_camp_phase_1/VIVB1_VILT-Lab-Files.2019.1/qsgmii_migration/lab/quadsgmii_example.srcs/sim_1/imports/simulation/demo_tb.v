
//------------------------------------------------------------------------------
// File       : demo_tb.v
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
// Description: The top-level test bench entity instantiates the example design for the core, 
// which is the Device Under Test (DUT). Other modules needed to provide stimulus, clocks, resets
// and test bench semaphores are also instantiated in the top-level test bench. 
// This file describe the top-level of the demonstration test bench.
//------------------------------------------------------------------------------


`timescale 1 ps/1 ps

module demo_tb;

  reg         serdes_ser_data_out_p;
  reg         serdes_ser_data_out_n;

  // wire        independent_clock;
  wire        reset;

  wire        signal_detect;
  wire        core_clock_125;

  wire        txp;
  wire        txn;
  wire        rxp;
  wire        rxn;


  wire [7 :0] gmii_rxd_ch0;
  wire        gmii_rx_dv_ch0;
  wire        gmii_rx_er_ch0;

  wire        mdio_o_ch0;
  wire        mdio_t_ch0;
  wire        an_interrupt_ch0;
  wire [15:0] status_vector_ch0;


  wire [7 :0] gmii_rxd_ch1;
  wire        gmii_rx_dv_ch1;
  wire        gmii_rx_er_ch1;

  wire        mdio_o_ch1;
  wire        mdio_t_ch1;
  wire        an_interrupt_ch1;
  wire [15:0] status_vector_ch1;


  wire [7 :0] gmii_rxd_ch2;
  wire        gmii_rx_dv_ch2;
  wire        gmii_rx_er_ch2;

  wire        mdio_o_ch2;
  wire        mdio_t_ch2;
  wire        an_interrupt_ch2;
  wire [15:0] status_vector_ch2;


  wire [7 :0] gmii_rxd_ch3;
  wire        gmii_rx_dv_ch3;
  wire        gmii_rx_er_ch3;

  wire        mdio_o_ch3;
  wire        mdio_t_ch3;
  wire        an_interrupt_ch3;
  wire [15:0] status_vector_ch3;


  wire        clk_5g;
  wire        clk_500m;
  wire        clk_125m_p;
  wire        clk_125m_n;
  wire        clk_2p5m;

  wire        rcvrd_clk_5g;
  wire        rcvrd_clk_500m;
  wire        rcvrd_clk_125m;

  wire        clk_200m;

  wire        gmii_phy_clk_125m;

  wire [3 :0] clock_enable;

  wire [3 :0] sgmii_clk;
  wire [3 :0] sgmii_use_clk; 

  wire [3 :0] sgmii_clk_en;

  wire [3 :0] sgmii_phy_clk_sel;

  wire [63:0] status_vector;

  wire [3 :0] configuration_finished;
  wire [3 :0] mdio_i;

  wire [31:0] gmii_txd;
  wire [3 :0] gmii_tx_en;
  wire [3 :0] gmii_tx_er;

  wire [31:0] gmii_rxd;
  wire [3 :0] gmii_rx_dv;
  wire [3 :0] gmii_rx_er;

  wire [31:0] rx_pdata;
  wire [3 :0] rx_is_k;

  wire [9 :0] serdes_par_data_out;

  wire [7 :0] decoder_8b_data_out;
  wire        decoder_is_k;

  wire [31:0] tx_pdata;
  wire [3 :0] tx_is_k;

  wire [3 :0] tx_monitor_finished;
  wire [3 :0] rx_monitor_finished;

  wire [7 :0] arb_rx_pdata;
  wire        arb_rx_is_k;
  wire        arb_chardispmode_nc;
  wire        arb_chardispval_nc;

  wire        speed_is_10_100_ch0;
  wire        speed_is_100_ch0;

  wire        speed_is_10_100_ch1;
  wire        speed_is_100_ch1;

  wire        speed_is_10_100_ch2;
  wire        speed_is_100_ch2;

  wire        speed_is_10_100_ch3;
  wire        speed_is_100_ch3;

  wire [3 :0] speed_is_10_100_bus;
  wire [3 :0] speed_is_100_bus;

  wire [9 :0] encoder_10b_data_out;
  wire        encoder_disp_pos_out;

  wire        serdes_ser_data_out;

  wire        simulation_finished;




  initial
  begin
    serdes_ser_data_out_p = 1'h0;
    serdes_ser_data_out_n = 1'h0;
  end


  always @(posedge rcvrd_clk_5g)     
  begin
    serdes_ser_data_out_p <= serdes_ser_data_out;
    serdes_ser_data_out_n <= ~serdes_ser_data_out;
  end


  assign rxp = serdes_ser_data_out_p;
  assign rxn = serdes_ser_data_out_n;


  quadsgmii_example_design dut (
                                   .independent_clock         (clk_200m),
                                   .reset                     (reset),                     
                                   .signal_detect             (signal_detect),             
                                   .core_clock_125            (core_clock_125),

                                   .gtrefclk_p                (clk_125m_p),                
                                   .gtrefclk_n                (clk_125m_n),                
                                   .txp                       (txp),                       
                                   .txn                       (txn),                       
                                   .rxp                       (rxp),                       
                                   .rxn                       (rxn),                       

                                   .sgmii_clk_en_ch0          (sgmii_clk_en[0]),
                                   .gmii_txd_ch0             (gmii_txd[7:0]),              
                                   .gmii_tx_en_ch0           (gmii_tx_en[0]),            
                                   .gmii_tx_er_ch0           (gmii_tx_er[0]),            
                                   .gmii_rxd_ch0             (gmii_rxd[7:0]),              
                                   .gmii_rx_dv_ch0           (gmii_rx_dv[0]),            
                                   .gmii_rx_er_ch0           (gmii_rx_er[0]),            

                                   .mdc_ch0                   (clk_2p5m),                   
                                   .mdio_i_ch0                (mdio_i[0]),                
                                   .mdio_o_ch0                (mdio_o_ch0),                
                                   .mdio_t_ch0                (mdio_t_ch0),                
                                   .an_interrupt_ch0          (an_interrupt_ch0),          

                                   .speed_is_10_100_ch0       (speed_is_10_100_ch0),       
                                   .speed_is_100_ch0          (speed_is_100_ch0),

                                   .status_vector_ch0         (status_vector[15:0]),        

                                   .sgmii_clk_en_ch1          (sgmii_clk_en[1]),
                                   .gmii_txd_ch1              (gmii_txd[15:8]),              
                                   .gmii_tx_en_ch1            (gmii_tx_en[1]),            
                                   .gmii_tx_er_ch1            (gmii_tx_er[1]),            
                                   .gmii_rxd_ch1              (gmii_rxd[15:8]),              
                                   .gmii_rx_dv_ch1            (gmii_rx_dv[1]),            
                                   .gmii_rx_er_ch1            (gmii_rx_er[1]),            

                                   .mdc_ch1                   (clk_2p5m),                   
                                   .mdio_i_ch1                (mdio_i[1]),                
                                   .mdio_o_ch1                (mdio_o_ch1),                
                                   .mdio_t_ch1                (mdio_t_ch1),                
                                   .an_interrupt_ch1          (an_interrupt_ch1),          

                                   .speed_is_10_100_ch1       (speed_is_10_100_ch1),       
                                   .speed_is_100_ch1          (speed_is_100_ch1),

                                   .status_vector_ch1         (status_vector[31:16]),        

                                   .sgmii_clk_en_ch2          (sgmii_clk_en[2]),
                                   .gmii_txd_ch2              (gmii_txd[23:16]),              
                                   .gmii_tx_en_ch2            (gmii_tx_en[2]),            
                                   .gmii_tx_er_ch2            (gmii_tx_er[2]),            
                                   .gmii_rxd_ch2              (gmii_rxd[23:16]),              
                                   .gmii_rx_dv_ch2            (gmii_rx_dv[2]),            
                                   .gmii_rx_er_ch2            (gmii_rx_er[2]),            

                                   .mdc_ch2                   (clk_2p5m),                   
                                   .mdio_i_ch2                (mdio_i[2]),                
                                   .mdio_o_ch2                (mdio_o_ch2),                
                                   .mdio_t_ch2                (mdio_t_ch2),                
                                   .an_interrupt_ch2          (an_interrupt_ch2),          

                                   .speed_is_10_100_ch2       (speed_is_10_100_ch2),       
                                   .speed_is_100_ch2          (speed_is_100_ch2),

                                   .status_vector_ch2         (status_vector[47:32]),        

                                   .sgmii_clk_en_ch3          (sgmii_clk_en[3]),
                                   .gmii_txd_ch3              (gmii_txd[31:24]),              
                                   .gmii_tx_en_ch3            (gmii_tx_en[3]),            
                                   .gmii_tx_er_ch3            (gmii_tx_er[3]),            
                                   .gmii_rxd_ch3              (gmii_rxd[31:24]),              
                                   .gmii_rx_dv_ch3            (gmii_rx_dv[3]),            
                                   .gmii_rx_er_ch3            (gmii_rx_er[3]),            

                                   .mdc_ch3                   (clk_2p5m),                   
                                   .mdio_i_ch3                (mdio_i[3]),                
                                   .mdio_o_ch3                (mdio_o_ch3),                
                                   .mdio_t_ch3                (mdio_t_ch3),                
                                   .an_interrupt_ch3          (an_interrupt_ch3),          

                                   .speed_is_10_100_ch3       (speed_is_10_100_ch3),       
                                   .speed_is_100_ch3          (speed_is_100_ch3),

                                   .status_vector_ch3         (status_vector[63:48])          
    );


    clk_rst_xlnx_tb clk_rst_xlnx_tb_0 (
                                        .clk_5g            (clk_5g),
                                        .clk_500m          (clk_500m),
                                        .clk_125m_p        (clk_125m_p),
                                        .clk_125m_n        (clk_125m_n),
                                        .clk_2p5m          (clk_2p5m),

                                        .rcvrd_clk_5g      (rcvrd_clk_5g),
                                        .rcvrd_clk_500m    (rcvrd_clk_500m),
                                        .rcvrd_clk_125m    (rcvrd_clk_125m),

                                        .clk_200m          (clk_200m),

                                        .gmii_phy_clk_125m (gmii_phy_clk_125m),

                                        .clock_enable      (clock_enable),

                                        .reset             (reset),

                                        .speed_is_10_100   (speed_is_10_100_bus),
                                        .speed_is_100      (speed_is_100_bus)
                                      );


    mdio_cfg_tb # (.PHYAD (1))
    mdio_cfg_tb_ch0 (
                                .configuration_finished (configuration_finished[0]),
                                .mdio_i                 (mdio_i[0]),

                                .txp                    (txp),
                                .status_vector          (status_vector[15:0]),

                                .mdc                    (clk_2p5m)
                              );

    mdio_cfg_tb # (.PHYAD (2))
    mdio_cfg_tb_ch1 (
                                .configuration_finished (configuration_finished[1]),
                                .mdio_i                 (mdio_i[1]),

                                .txp                    (txp),
                                .status_vector          (status_vector[31:16]),

                                .mdc                    (clk_2p5m)
                              );

    mdio_cfg_tb # (.PHYAD (3))
    mdio_cfg_tb_ch2 (
                                .configuration_finished (configuration_finished[2]),
                                .mdio_i                 (mdio_i[2]),

                                .txp                    (txp),
                                .status_vector          (status_vector[47:32]),

                                .mdc                    (clk_2p5m)
                              );

    mdio_cfg_tb # (.PHYAD (4))
    mdio_cfg_tb_ch3 (
                                .configuration_finished (configuration_finished[3]),
                                .mdio_i                 (mdio_i[3]),

                                .txp                    (txp),
                                .status_vector          (status_vector[63:48]),

                                .mdc                    (clk_2p5m)
                              );


    assign sgmii_phy_clk_sel[0] = speed_is_10_100_bus[0] ? sgmii_use_clk[0] : gmii_phy_clk_125m;
    assign sgmii_phy_clk_sel[1] = speed_is_10_100_bus[1] ? sgmii_use_clk[1] : gmii_phy_clk_125m;
    assign sgmii_phy_clk_sel[2] = speed_is_10_100_bus[2] ? sgmii_use_clk[2] : gmii_phy_clk_125m;
    assign sgmii_phy_clk_sel[3] = speed_is_10_100_bus[3] ? sgmii_use_clk[3] : gmii_phy_clk_125m;

    assign sgmii_use_clk = {core_clock_125,core_clock_125,core_clock_125,core_clock_125};

    genvar jj;
    generate for(jj=0;jj<4;jj=jj+1)
    begin : send_frames
      send_frame_tb # (.INSTANCE_NUMBER (jj))
                    send_frame_tb (
                                    .gmii_txd                (gmii_txd[7+jj*8:jj*8]),
                                    .gmii_tx_en              (gmii_tx_en[jj]),
                                    .gmii_tx_er              (gmii_tx_er[jj]),

                                    .rx_pdata                (rx_pdata[7+jj*8:jj*8]),
                                    .rx_is_k                 (rx_is_k[jj]),

                                    .speed_is_10_100         (speed_is_10_100_bus[jj]),
                                    .speed_is_100            (speed_is_100_bus[jj]),

                                    .configuration_finished  (configuration_finished[jj]),

                                    .clock_enable            (clock_enable[jj]),
                                    .sgmii_clk_en            (sgmii_clk_en[jj]),

                                    .stim_tx_clk             (sgmii_phy_clk_sel[jj]),
                                    .stim_rx_clk             (rcvrd_clk_125m)
                                  );
    end
    endgenerate

    
   // Instantiate the serdes
   serdes_tb serdes_tb_inst0 (
                         .para_data_in  (encoder_10b_data_out),
                         .ser_data_out  (serdes_ser_data_out),

                         .ser_data_in   (txp),
                         .par_data_out  (serdes_par_data_out),

                         .sync_reset    (reset),

                         .tx_par_clk    (rcvrd_clk_500m),
                         .tx_ser_clk    (rcvrd_clk_5g),

                         .rx_par_clk    (clk_500m),
                         .rx_ser_clk    (clk_5g)
                       );


    decode_8b10b_tb decode_8b10b_tb_inst0 (
                                            .q8_ff      (decoder_8b_data_out),
                                            .is_k_ff    (decoder_is_k),
                                            .d10        (serdes_par_data_out),
                                            .decode_clk (clk_500m)
                                          );


    k28p1_swapper_tb k28p1_swapper_tb_inst0 (
                                              .data_8b_port0      (tx_pdata[7:0]),
                                              .is_k_port0         (tx_is_k[0]),
                                              .data_8b_port1      (tx_pdata[15:8]),
                                              .is_k_port1         (tx_is_k[1]),
                                              .data_8b_port2      (tx_pdata[23:16]),
                                              .is_k_port2         (tx_is_k[2]),
                                              .data_8b_port3      (tx_pdata[31:24]),
                                              .is_k_port3         (tx_is_k[3]),

                                              .decoder_8b_data_in (decoder_8b_data_out),
                                              .decoder_is_k       (decoder_is_k),

                                              .clk_500m           (clk_500m),
                                              .clk_125m           (clk_125m_p)
                                            );


    genvar kk;
    generate for(kk=0;kk<4;kk=kk+1)
    begin : monitor
      monitor_tb # (.INSTANCE_NUMBER (kk))
                 monitor_tb (
                              .tx_monitor_finished (tx_monitor_finished[kk]),
                              .rx_monitor_finished (rx_monitor_finished[kk]),

                              .tx_pdata            (tx_pdata[7+kk*8:kk*8]),
                              .tx_is_k             (tx_is_k[kk]),

                              .gmii_rx_dv          (gmii_rx_dv[kk]),
                              .gmii_rxd            (gmii_rxd[7+kk*8:kk*8]),
                              .gmii_rx_er          (gmii_rx_er[kk]),

                              .clock_enable        (clock_enable[kk]),
                              .sgmii_clk_en        (sgmii_clk_en[kk]),

                              .speed_is_10_100     (speed_is_10_100_bus[kk]),

                              .mon_tx_clk          (clk_125m_p),

                              .mon_rx_clk          (sgmii_use_clk[kk])
                            );
    end
    endgenerate


    arbiter_tb arbiter_tb_inst0 (
                            .gmii_txd_ch0       (rx_pdata[7 : 0]),
                            .gmii_txd_ch1       (rx_pdata[15: 8]),
                            .gmii_txd_ch2       (rx_pdata[23:16]),
                            .gmii_txd_ch3       (rx_pdata[31:24]),
                            .txcharisk          ({rx_is_k[3],
                                                  rx_is_k[2],
                                                  rx_is_k[1],
                                                  rx_is_k[0]}),
                            .txchardispmode     (4'h0),
                            .txchardispval      (4'h0),

                            .arb_gmii_txd       (arb_rx_pdata),
                            .arb_txcharisk      (arb_rx_is_k),
                            .arb_txchardispmode (arb_chardispmode_nc),
                            .arb_txchardispval  (arb_chardispval_nc),

                            .sync_reset         (reset),
                            .clk                (rcvrd_clk_500m)
                          );


    encode_8b10b_tb encode_8b10b_tb_inst0 (
                                            .q10_ff               (encoder_10b_data_out),
                                            .disparity_pos_out_ff (encoder_disp_pos_out),

                                            .d8                   (arb_rx_pdata),
                                            .is_k                 (arb_rx_is_k),
                                            .disparity_pos_in     (encoder_disp_pos_out),

                                            .encode_clk           (rcvrd_clk_500m)
                                          );




    assign signal_detect            = 1'h1;


    assign speed_is_10_100_ch0      = 1'h0;
    assign speed_is_100_ch0         = 1'h0;

    assign speed_is_10_100_ch1      = 1'h1;
    assign speed_is_100_ch1         = 1'h1;

    assign speed_is_10_100_ch2      = 1'h1;
    assign speed_is_100_ch2         = 1'h0;

    assign speed_is_10_100_ch3      = 1'h0;
    assign speed_is_100_ch3         = 1'h0;


    assign speed_is_10_100_bus = {speed_is_10_100_ch3, speed_is_10_100_ch2, speed_is_10_100_ch1, speed_is_10_100_ch0};
    assign speed_is_100_bus    = {speed_is_100_ch3, speed_is_100_ch2, speed_is_100_ch1, speed_is_100_ch0};


  //----------------------------------------------------------------------------
  // End the simulation.
  //----------------------------------------------------------------------------

  assign simulation_finished = (tx_monitor_finished[0] & rx_monitor_finished[0] &
                                tx_monitor_finished[1] & rx_monitor_finished[1] &
                                tx_monitor_finished[2] & rx_monitor_finished[2] &
                                tx_monitor_finished[3] & rx_monitor_finished[3]);

  initial
  begin : p_end_simulation
  fork: sim_in_progress
     @(posedge simulation_finished) disable sim_in_progress;
     #500000000                     disable sim_in_progress;
  join
  if (simulation_finished) begin
       #1000000
       $display("Test completed successfully");
       $display("Simulation Complete.");
  end
  else
     $display("** Error: Testbench timed out");
  $stop;
  end // p_end_simulation

endmodule

