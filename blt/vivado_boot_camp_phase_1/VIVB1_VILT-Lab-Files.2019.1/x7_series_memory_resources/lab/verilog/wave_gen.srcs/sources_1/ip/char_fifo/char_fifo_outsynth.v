`timescale 1 ps / 1 ps
// lib work
(* XLNX_LINE_FILE = "249856" *) (* x_core_info = "fifo_generator_v9_2, Xilinx CORE Generator 14.2" *) (* keep_hierarchy = "yes" *) 
(* CHECK_LICENSE_TYPE = "char_fifo,fifo_generator_v9_2,{}" *) (* core_generation_info = "char_fifo,fifo_generator_v9_2,{c_add_ngc_constraint=0,c_application_type_axis=0,c_application_type_rach=0,c_application_type_rdch=0,c_application_type_wach=0,c_application_type_wdch=0,c_application_type_wrch=0,c_axi_addr_width=32,c_axi_aruser_width=1,c_axi_awuser_width=1,c_axi_buser_width=1,c_axi_data_width=64,c_axi_id_width=4,c_axi_ruser_width=1,c_axi_type=0,c_axi_wuser_width=1,c_axis_tdata_width=64,c_axis_tdest_width=4,c_axis_tid_width=8,c_axis_tkeep_width=4,c_axis_tstrb_width=4,c_axis_tuser_width=4,c_axis_type=0,c_common_clock=0,c_count_type=0,c_data_count_width=11,c_default_value=BlankString,c_din_width=8,c_din_width_axis=1,c_din_width_rach=32,c_din_width_rdch=64,c_din_width_wach=32,c_din_width_wdch=64,c_din_width_wrch=2,c_dout_rst_val=0,c_dout_width=8,c_enable_rlocs=0,c_enable_rst_sync=1,c_error_injection_type=0,c_error_injection_type_axis=0,c_error_injection_type_rach=0,c_error_injection_type_rdch=0,c_error_injection_type_wach=0,c_error_injection_type_wdch=0,c_error_injection_type_wrch=0,c_family=kintex7,c_full_flags_rst_val=0,c_has_almost_empty=0,c_has_almost_full=0,c_has_axi_aruser=0,c_has_axi_awuser=0,c_has_axi_buser=0,c_has_axi_rd_channel=0,c_has_axi_ruser=0,c_has_axi_wr_channel=0,c_has_axi_wuser=0,c_has_axis_tdata=0,c_has_axis_tdest=0,c_has_axis_tid=0,c_has_axis_tkeep=0,c_has_axis_tlast=0,c_has_axis_tready=1,c_has_axis_tstrb=0,c_has_axis_tuser=0,c_has_backup=0,c_has_data_count=0,c_has_data_counts_axis=0,c_has_data_counts_rach=0,c_has_data_counts_rdch=0,c_has_data_counts_wach=0,c_has_data_counts_wdch=0,c_has_data_counts_wrch=0,c_has_int_clk=0,c_has_master_ce=0,c_has_meminit_file=0,c_has_overflow=0,c_has_prog_flags_axis=0,c_has_prog_flags_rach=0,c_has_prog_flags_rdch=0,c_has_prog_flags_wach=0,c_has_prog_flags_wdch=0,c_has_prog_flags_wrch=0,c_has_rd_data_count=0,c_has_rd_rst=0,c_has_rst=1,c_has_slave_ce=0,c_has_srst=0,c_has_underflow=0,c_has_valid=0,c_has_wr_ack=0,c_has_wr_data_count=0,c_has_wr_rst=0,c_implementation_type=6,c_implementation_type_axis=1,c_implementation_type_rach=1,c_implementation_type_rdch=1,c_implementation_type_wach=1,c_implementation_type_wdch=1,c_implementation_type_wrch=1,c_init_wr_pntr_val=0,c_interface_type=0,c_memory_type=4,c_mif_file_name=BlankString,c_msgon_val=1,c_optimization_mode=0,c_overflow_low=0,c_preload_latency=0,c_preload_regs=1,c_prim_fifo_type=2kx9,c_prog_empty_thresh_assert_val=6,c_prog_empty_thresh_assert_val_axis=1022,c_prog_empty_thresh_assert_val_rach=1022,c_prog_empty_thresh_assert_val_rdch=1022,c_prog_empty_thresh_assert_val_wach=1022,c_prog_empty_thresh_assert_val_wdch=1022,c_prog_empty_thresh_assert_val_wrch=1022,c_prog_empty_thresh_negate_val=7,c_prog_empty_type=0,c_prog_empty_type_axis=0,c_prog_empty_type_rach=0,c_prog_empty_type_rdch=0,c_prog_empty_type_wach=0,c_prog_empty_type_wdch=0,c_prog_empty_type_wrch=0,c_prog_full_thresh_assert_val=2038,c_prog_full_thresh_assert_val_axis=1023,c_prog_full_thresh_assert_val_rach=1023,c_prog_full_thresh_assert_val_rdch=1023,c_prog_full_thresh_assert_val_wach=1023,c_prog_full_thresh_assert_val_wdch=1023,c_prog_full_thresh_assert_val_wrch=1023,c_prog_full_thresh_negate_val=2037,c_prog_full_type=0,c_prog_full_type_axis=0,c_prog_full_type_rach=0,c_prog_full_type_rdch=0,c_prog_full_type_wach=0,c_prog_full_type_wdch=0,c_prog_full_type_wrch=0,c_rach_type=0,c_rd_data_count_width=11,c_rd_depth=2048,c_rd_freq=193,c_rd_pntr_width=11,c_rdch_type=0,c_reg_slice_mode_axis=0,c_reg_slice_mode_rach=0,c_reg_slice_mode_rdch=0,c_reg_slice_mode_wach=0,c_reg_slice_mode_wdch=0,c_reg_slice_mode_wrch=0,c_synchronizer_stage=2,c_underflow_low=0,c_use_common_overflow=0,c_use_common_underflow=0,c_use_default_settings=0,c_use_dout_rst=0,c_use_ecc=0,c_use_ecc_axis=0,c_use_ecc_rach=0,c_use_ecc_rdch=0,c_use_ecc_wach=0,c_use_ecc_wdch=0,c_use_ecc_wrch=0,c_use_embedded_reg=0,c_use_fifo16_flags=0,c_use_fwft_data_count=0,c_valid_low=0,c_wach_type=0,c_wdch_type=0,c_wr_ack_low=0,c_wr_data_count_width=11,c_wr_depth=2048,c_wr_depth_axis=1024,c_wr_depth_rach=16,c_wr_depth_rdch=1024,c_wr_depth_wach=16,c_wr_depth_wdch=1024,c_wr_depth_wrch=16,c_wr_freq=200,c_wr_pntr_width=11,c_wr_pntr_width_axis=10,c_wr_pntr_width_rach=4,c_wr_pntr_width_rdch=10,c_wr_pntr_width_wach=4,c_wr_pntr_width_wdch=10,c_wr_pntr_width_wrch=4,c_wr_response_latency=1,c_wrch_type=0}" *) (* FILE0 = "c:/training/des_7/labs/memory_architecture/kc705/verilog/wave_gen.srcs/sources_1/ip/char_fifo/tmp/_cg/_dbg/char_fifo.vhd" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module char_fifo
   (rst,
    wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty);
  input rst;
  input wr_clk;
  input rd_clk;
  input [7:0]din;
  input wr_en;
  input rd_en;
  output [7:0]dout;
  output full;
  output empty;

  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rst;
  wire wr_clk;
  wire wr_en;
  wire xlnx_opt_;
  wire xlnx_opt__1;
  wire xlnx_opt__10;
  wire xlnx_opt__11;
  wire xlnx_opt__12;
  wire xlnx_opt__2;
  wire xlnx_opt__3;
  wire xlnx_opt__4;
  wire xlnx_opt__5;
  wire xlnx_opt__6;
  wire xlnx_opt__7;
  wire xlnx_opt__8;
  wire xlnx_opt__9;

IBUF IBUF
       (.I(rst),
        .O(xlnx_opt_));
IBUF IBUF_1
       (.I(wr_clk),
        .O(xlnx_opt__1));
IBUF IBUF_10
       (.I(din[0]),
        .O(xlnx_opt__10));
IBUF IBUF_11
       (.I(wr_en),
        .O(xlnx_opt__11));
IBUF IBUF_12
       (.I(rd_en),
        .O(xlnx_opt__12));
IBUF IBUF_2
       (.I(rd_clk),
        .O(xlnx_opt__2));
IBUF IBUF_3
       (.I(din[7]),
        .O(xlnx_opt__3));
IBUF IBUF_4
       (.I(din[6]),
        .O(xlnx_opt__4));
IBUF IBUF_5
       (.I(din[5]),
        .O(xlnx_opt__5));
IBUF IBUF_6
       (.I(din[4]),
        .O(xlnx_opt__6));
IBUF IBUF_7
       (.I(din[3]),
        .O(xlnx_opt__7));
IBUF IBUF_8
       (.I(din[2]),
        .O(xlnx_opt__8));
IBUF IBUF_9
       (.I(din[1]),
        .O(xlnx_opt__9));
fifo_generator_v9_2 U0
       (.din({xlnx_opt__3,xlnx_opt__4,xlnx_opt__5,xlnx_opt__6,xlnx_opt__7,xlnx_opt__8,xlnx_opt__9,xlnx_opt__10}),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(xlnx_opt__2),
        .rd_en(xlnx_opt__12),
        .rst(xlnx_opt_),
        .wr_clk(xlnx_opt__1),
        .wr_en(xlnx_opt__11));
endmodule
// lib work
module fifo_generator_v9_2
   (empty,
    full,
    dout,
    rd_clk,
    rst,
    wr_clk,
    wr_en,
    din,
    rd_en);
  output empty;
  output full;
  output [7:0]dout;
  input rd_clk;
  input rst;
  input wr_clk;
  input wr_en;
  input [7:0]din;
  input rd_en;

  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rst;
  wire wr_clk;
  wire wr_en;

fifo_generator_v9_2_xst xst_fifo_generator
       (.din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .rst(rst),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule
// lib work
module fifo_generator_v9_2_builtin
   (empty,
    full,
    dout,
    rd_clk,
    rst,
    wr_clk,
    wr_en,
    din,
    rd_en);
  output empty;
  output full;
  output [7:0]dout;
  input rd_clk;
  input rst;
  input wr_clk;
  input wr_en;
  input [7:0]din;
  input rd_en;

  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire n_0_rstbt;
  wire rd_clk;
  wire rd_en;
  wire rst;
  wire wr_clk;
  wire wr_en;

fifo_generator_v9_2_reset_builtin rstbt
       (.RST(n_0_rstbt),
        .rd_clk(rd_clk),
        .rst(rst));
fifo_generator_v9_2_builtin_top_v6 \v6_fifo.fblk 
       (.RST(n_0_rstbt),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule
// lib work
module fifo_generator_v9_2_builtin_extdepth_v6
   (empty,
    full,
    dout,
    rd_clk,
    RST,
    wr_clk,
    wr_en,
    din,
    rd_en);
  output empty;
  output full;
  output [7:0]dout;
  input rd_clk;
  input RST;
  input wr_clk;
  input wr_en;
  input [7:0]din;
  input rd_en;

  wire RST;
  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire wr_clk;
  wire wr_en;

fifo_generator_v9_2_builtin_prim_v6 \gonep.inst_prim 
       (.RST(RST),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule
// lib work
module fifo_generator_v9_2_builtin_prim_v6
   (empty,
    full,
    dout,
    rd_clk,
    RST,
    wr_clk,
    wr_en,
    din,
    rd_en);
  output empty;
  output full;
  output [7:0]dout;
  input rd_clk;
  input RST;
  input wr_clk;
  input wr_en;
  input [7:0]din;
  input rd_en;

  wire \<const0> ;
  wire RST;
  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire \n_0_gf18e1_inst.sngfifo18e1 ;
  wire \n_10_gf18e1_inst.sngfifo18e1 ;
  wire \n_11_gf18e1_inst.sngfifo18e1 ;
  wire \n_12_gf18e1_inst.sngfifo18e1 ;
  wire \n_13_gf18e1_inst.sngfifo18e1 ;
  wire \n_14_gf18e1_inst.sngfifo18e1 ;
  wire \n_15_gf18e1_inst.sngfifo18e1 ;
  wire \n_16_gf18e1_inst.sngfifo18e1 ;
  wire \n_17_gf18e1_inst.sngfifo18e1 ;
  wire \n_18_gf18e1_inst.sngfifo18e1 ;
  wire \n_19_gf18e1_inst.sngfifo18e1 ;
  wire \n_1_gf18e1_inst.sngfifo18e1 ;
  wire \n_20_gf18e1_inst.sngfifo18e1 ;
  wire \n_21_gf18e1_inst.sngfifo18e1 ;
  wire \n_22_gf18e1_inst.sngfifo18e1 ;
  wire \n_23_gf18e1_inst.sngfifo18e1 ;
  wire \n_24_gf18e1_inst.sngfifo18e1 ;
  wire \n_25_gf18e1_inst.sngfifo18e1 ;
  wire \n_26_gf18e1_inst.sngfifo18e1 ;
  wire \n_27_gf18e1_inst.sngfifo18e1 ;
  wire \n_28_gf18e1_inst.sngfifo18e1 ;
  wire \n_29_gf18e1_inst.sngfifo18e1 ;
  wire \n_30_gf18e1_inst.sngfifo18e1 ;
  wire \n_31_gf18e1_inst.sngfifo18e1 ;
  wire \n_32_gf18e1_inst.sngfifo18e1 ;
  wire \n_33_gf18e1_inst.sngfifo18e1 ;
  wire \n_34_gf18e1_inst.sngfifo18e1 ;
  wire \n_35_gf18e1_inst.sngfifo18e1 ;
  wire \n_36_gf18e1_inst.sngfifo18e1 ;
  wire \n_37_gf18e1_inst.sngfifo18e1 ;
  wire \n_38_gf18e1_inst.sngfifo18e1 ;
  wire \n_39_gf18e1_inst.sngfifo18e1 ;
  wire \n_40_gf18e1_inst.sngfifo18e1 ;
  wire \n_41_gf18e1_inst.sngfifo18e1 ;
  wire \n_42_gf18e1_inst.sngfifo18e1 ;
  wire \n_43_gf18e1_inst.sngfifo18e1 ;
  wire \n_44_gf18e1_inst.sngfifo18e1 ;
  wire \n_45_gf18e1_inst.sngfifo18e1 ;
  wire \n_46_gf18e1_inst.sngfifo18e1 ;
  wire \n_47_gf18e1_inst.sngfifo18e1 ;
  wire \n_48_gf18e1_inst.sngfifo18e1 ;
  wire \n_49_gf18e1_inst.sngfifo18e1 ;
  wire \n_4_gf18e1_inst.sngfifo18e1 ;
  wire \n_50_gf18e1_inst.sngfifo18e1 ;
  wire \n_51_gf18e1_inst.sngfifo18e1 ;
  wire \n_52_gf18e1_inst.sngfifo18e1 ;
  wire \n_53_gf18e1_inst.sngfifo18e1 ;
  wire \n_5_gf18e1_inst.sngfifo18e1 ;
  wire \n_62_gf18e1_inst.sngfifo18e1 ;
  wire \n_63_gf18e1_inst.sngfifo18e1 ;
  wire \n_64_gf18e1_inst.sngfifo18e1 ;
  wire \n_65_gf18e1_inst.sngfifo18e1 ;
  wire \n_6_gf18e1_inst.sngfifo18e1 ;
  wire \n_7_gf18e1_inst.sngfifo18e1 ;
  wire \n_8_gf18e1_inst.sngfifo18e1 ;
  wire \n_9_gf18e1_inst.sngfifo18e1 ;
  wire rd_clk;
  wire rd_en;
  wire rden_tmp;
  wire wr_clk;
  wire wr_en;
  wire xlnx_opt_;
  wire xlnx_opt__13;
  wire xlnx_opt__14;
  wire xlnx_opt__15;
  wire xlnx_opt__16;
  wire xlnx_opt__17;
  wire xlnx_opt__18;
  wire xlnx_opt__19;
  wire xlnx_opt__20;
  wire xlnx_opt__21;

GND GND
       (.G(\<const0> ));
OBUF OBUF
       (.I(xlnx_opt_),
        .O(dout[7]));
OBUF OBUF_1
       (.I(xlnx_opt__13),
        .O(dout[6]));
OBUF OBUF_2
       (.I(xlnx_opt__14),
        .O(dout[5]));
OBUF OBUF_3
       (.I(xlnx_opt__15),
        .O(dout[4]));
OBUF OBUF_4
       (.I(xlnx_opt__16),
        .O(dout[3]));
OBUF OBUF_5
       (.I(xlnx_opt__17),
        .O(dout[2]));
OBUF OBUF_6
       (.I(xlnx_opt__18),
        .O(dout[1]));
OBUF OBUF_7
       (.I(xlnx_opt__19),
        .O(dout[0]));
OBUF OBUF_8
       (.I(xlnx_opt__20),
        .O(full));
OBUF OBUF_9
       (.I(xlnx_opt__21),
        .O(empty));
LUT2 #(
    .INIT(4'h2)) 
     _1
       (.I0(rd_en),
        .I1(xlnx_opt__21),
        .O(rden_tmp));
FIFO18E1 #(
    .ALMOST_EMPTY_OFFSET(13'h0006),
    .ALMOST_FULL_OFFSET(13'h000B),
    .DATA_WIDTH(9),
    .DO_REG(1),
    .EN_SYN("FALSE"),
    .FIFO_MODE("FIFO18"),
    .FIRST_WORD_FALL_THROUGH("TRUE"),
    .INIT(36'h000000000),
    .SIM_DEVICE("7SERIES"),
    .SRVAL(36'h000000000)) 
     \gf18e1_inst.sngfifo18e1 
       (.ALMOSTEMPTY(\n_0_gf18e1_inst.sngfifo18e1 ),
        .ALMOSTFULL(\n_1_gf18e1_inst.sngfifo18e1 ),
        .DI({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,din}),
        .DIP({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .DO({\n_30_gf18e1_inst.sngfifo18e1 ,\n_31_gf18e1_inst.sngfifo18e1 ,\n_32_gf18e1_inst.sngfifo18e1 ,\n_33_gf18e1_inst.sngfifo18e1 ,\n_34_gf18e1_inst.sngfifo18e1 ,\n_35_gf18e1_inst.sngfifo18e1 ,\n_36_gf18e1_inst.sngfifo18e1 ,\n_37_gf18e1_inst.sngfifo18e1 ,\n_38_gf18e1_inst.sngfifo18e1 ,\n_39_gf18e1_inst.sngfifo18e1 ,\n_40_gf18e1_inst.sngfifo18e1 ,\n_41_gf18e1_inst.sngfifo18e1 ,\n_42_gf18e1_inst.sngfifo18e1 ,\n_43_gf18e1_inst.sngfifo18e1 ,\n_44_gf18e1_inst.sngfifo18e1 ,\n_45_gf18e1_inst.sngfifo18e1 ,\n_46_gf18e1_inst.sngfifo18e1 ,\n_47_gf18e1_inst.sngfifo18e1 ,\n_48_gf18e1_inst.sngfifo18e1 ,\n_49_gf18e1_inst.sngfifo18e1 ,\n_50_gf18e1_inst.sngfifo18e1 ,\n_51_gf18e1_inst.sngfifo18e1 ,\n_52_gf18e1_inst.sngfifo18e1 ,\n_53_gf18e1_inst.sngfifo18e1 ,xlnx_opt_,xlnx_opt__13,xlnx_opt__14,xlnx_opt__15,xlnx_opt__16,xlnx_opt__17,xlnx_opt__18,xlnx_opt__19}),
        .DOP({\n_62_gf18e1_inst.sngfifo18e1 ,\n_63_gf18e1_inst.sngfifo18e1 ,\n_64_gf18e1_inst.sngfifo18e1 ,\n_65_gf18e1_inst.sngfifo18e1 }),
        .EMPTY(xlnx_opt__21),
        .FULL(xlnx_opt__20),
        .RDCLK(rd_clk),
        .RDCOUNT({\n_6_gf18e1_inst.sngfifo18e1 ,\n_7_gf18e1_inst.sngfifo18e1 ,\n_8_gf18e1_inst.sngfifo18e1 ,\n_9_gf18e1_inst.sngfifo18e1 ,\n_10_gf18e1_inst.sngfifo18e1 ,\n_11_gf18e1_inst.sngfifo18e1 ,\n_12_gf18e1_inst.sngfifo18e1 ,\n_13_gf18e1_inst.sngfifo18e1 ,\n_14_gf18e1_inst.sngfifo18e1 ,\n_15_gf18e1_inst.sngfifo18e1 ,\n_16_gf18e1_inst.sngfifo18e1 ,\n_17_gf18e1_inst.sngfifo18e1 }),
        .RDEN(rden_tmp),
        .RDERR(\n_4_gf18e1_inst.sngfifo18e1 ),
        .RST(RST),
        .WRCLK(wr_clk),
        .WRCOUNT({\n_18_gf18e1_inst.sngfifo18e1 ,\n_19_gf18e1_inst.sngfifo18e1 ,\n_20_gf18e1_inst.sngfifo18e1 ,\n_21_gf18e1_inst.sngfifo18e1 ,\n_22_gf18e1_inst.sngfifo18e1 ,\n_23_gf18e1_inst.sngfifo18e1 ,\n_24_gf18e1_inst.sngfifo18e1 ,\n_25_gf18e1_inst.sngfifo18e1 ,\n_26_gf18e1_inst.sngfifo18e1 ,\n_27_gf18e1_inst.sngfifo18e1 ,\n_28_gf18e1_inst.sngfifo18e1 ,\n_29_gf18e1_inst.sngfifo18e1 }),
        .WREN(wr_en),
        .WRERR(\n_5_gf18e1_inst.sngfifo18e1 ));
endmodule
// lib work
module fifo_generator_v9_2_builtin_top_v6
   (empty,
    full,
    dout,
    rd_clk,
    RST,
    wr_clk,
    wr_en,
    din,
    rd_en);
  output empty;
  output full;
  output [7:0]dout;
  input rd_clk;
  input RST;
  input wr_clk;
  input wr_en;
  input [7:0]din;
  input rd_en;

  wire RST;
  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire wr_clk;
  wire wr_en;

fifo_generator_v9_2_builtin_extdepth_v6 \gextw[1].gnll_fifo.inst_extd 
       (.RST(RST),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule
// lib work
module fifo_generator_v9_2_fifo_generator_top
   (empty,
    full,
    dout,
    rd_clk,
    rst,
    wr_clk,
    wr_en,
    din,
    rd_en);
  output empty;
  output full;
  output [7:0]dout;
  input rd_clk;
  input rst;
  input wr_clk;
  input wr_en;
  input [7:0]din;
  input rd_en;

  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rst;
  wire wr_clk;
  wire wr_en;

fifo_generator_v9_2_builtin \gbiv5.bi 
       (.din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .rst(rst),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule
// lib work
module fifo_generator_v9_2_reset_builtin
   (RST,
    rd_clk,
    rst);
  output RST;
  input rd_clk;
  input rst;

  wire \<const0> ;
  wire \<const1> ;
  wire GND_2;
  wire RST;
  wire VCC_2;
  wire \n_0_rsync.ric.power_on_rd_rst_reg[0]__0 ;
  wire \n_0_rsync.ric.power_on_rd_rst_reg[1]_srl5 ;
  wire \n_0_rsync.ric.rd_rst_fb_reg[1]_srl4 ;
  wire rd_clk;
  wire [0:0]rd_rst_fb;
  wire rd_rst_reg;
  wire rst;

GND GND
       (.G(\<const0> ));
GND GND_1
       (.G(GND_2));
VCC VCC
       (.P(\<const1> ));
VCC VCC_1
       (.P(VCC_2));
LUT2 #(
    .INIT(4'hE)) 
     rici_0
       (.I0(rd_rst_reg),
        .I1(\n_0_rsync.ric.power_on_rd_rst_reg[0]__0 ),
        .O(RST));
(* XILINX_LEGACY_PRIM = "FD" *) 
   FDCE #(
    .INIT(1'b1)) 
     \rsync.ric.power_on_rd_rst_reg[0]__0 
       (.C(rd_clk),
        .CE(VCC_2),
        .CLR(GND_2),
        .D(\n_0_rsync.ric.power_on_rd_rst_reg[1]_srl5 ),
        .Q(\n_0_rsync.ric.power_on_rd_rst_reg[0]__0 ));
(* XILINX_LEGACY_PRIM = "SRLC16E" *) 
   SRL16E #(
    .INIT(16'h001F)) 
     \rsync.ric.power_on_rd_rst_reg[1]_srl5 
       (.A0(\<const0> ),
        .A1(\<const0> ),
        .A2(\<const1> ),
        .A3(\<const0> ),
        .CE(\<const1> ),
        .CLK(rd_clk),
        .D(\<const0> ),
        .Q(\n_0_rsync.ric.power_on_rd_rst_reg[1]_srl5 ));
(* XILINX_LEGACY_PRIM = "FD" *) 
   FDCE #(
    .INIT(1'b0)) 
     \rsync.ric.rd_rst_fb_reg[0]__0 
       (.C(rd_clk),
        .CE(VCC_2),
        .CLR(GND_2),
        .D(\n_0_rsync.ric.rd_rst_fb_reg[1]_srl4 ),
        .Q(rd_rst_fb));
(* XILINX_LEGACY_PRIM = "SRLC16E" *) 
   SRL16E #(
    .INIT(16'h0000)) 
     \rsync.ric.rd_rst_fb_reg[1]_srl4 
       (.A0(\<const1> ),
        .A1(\<const1> ),
        .A2(\<const0> ),
        .A3(\<const0> ),
        .CE(\<const1> ),
        .CLK(rd_clk),
        .D(rd_rst_reg),
        .Q(\n_0_rsync.ric.rd_rst_fb_reg[1]_srl4 ));
(* ASYNC_REG *) 
   (* msgon = "true" *) 
   FDPE #(
    .INIT(1'b0)) 
     \rsync.ric.rd_rst_reg_reg 
       (.C(rd_clk),
        .CE(rd_rst_fb),
        .D(\<const0> ),
        .PRE(rst),
        .Q(rd_rst_reg));
endmodule
// lib work
module fifo_generator_v9_2_xst
   (empty,
    full,
    dout,
    rd_clk,
    rst,
    wr_clk,
    wr_en,
    din,
    rd_en);
  output empty;
  output full;
  output [7:0]dout;
  input rd_clk;
  input rst;
  input wr_clk;
  input wr_en;
  input [7:0]din;
  input rd_en;

  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rst;
  wire wr_clk;
  wire wr_en;

fifo_generator_v9_2_fifo_generator_top \gconvfifo.rf 
       (.din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .rst(rst),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule
