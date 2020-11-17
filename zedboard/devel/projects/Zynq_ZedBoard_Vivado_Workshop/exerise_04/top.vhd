--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
--Date        : Tue Nov 17 14:41:46 2020
--Host        : localhost running 64-bit unknown
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    gpio_tri_io : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    spi_io0_io : inout STD_LOGIC;
    spi_io1_io : inout STD_LOGIC;
    spi_sck_io : inout STD_LOGIC;
    spi_ss_io : inout STD_LOGIC_VECTOR ( 0 to 0 )
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    gpio_tri_i : in STD_LOGIC_VECTOR ( 15 downto 0 );
    gpio_tri_o : out STD_LOGIC_VECTOR ( 15 downto 0 );
    gpio_tri_t : out STD_LOGIC_VECTOR ( 15 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    spi_io0_i : in STD_LOGIC;
    spi_io0_o : out STD_LOGIC;
    spi_io0_t : out STD_LOGIC;
    spi_io1_i : in STD_LOGIC;
    spi_io1_o : out STD_LOGIC;
    spi_io1_t : out STD_LOGIC;
    spi_sck_i : in STD_LOGIC;
    spi_sck_o : out STD_LOGIC;
    spi_sck_t : out STD_LOGIC;
    spi_ss_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    spi_ss_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    spi_ss_t : out STD_LOGIC;
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component design_1;
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  signal gpio_tri_i_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio_tri_i_1 : STD_LOGIC_VECTOR ( 1 to 1 );
  signal gpio_tri_i_10 : STD_LOGIC_VECTOR ( 10 to 10 );
  signal gpio_tri_i_11 : STD_LOGIC_VECTOR ( 11 to 11 );
  signal gpio_tri_i_12 : STD_LOGIC_VECTOR ( 12 to 12 );
  signal gpio_tri_i_13 : STD_LOGIC_VECTOR ( 13 to 13 );
  signal gpio_tri_i_14 : STD_LOGIC_VECTOR ( 14 to 14 );
  signal gpio_tri_i_15 : STD_LOGIC_VECTOR ( 15 to 15 );
  signal gpio_tri_i_2 : STD_LOGIC_VECTOR ( 2 to 2 );
  signal gpio_tri_i_3 : STD_LOGIC_VECTOR ( 3 to 3 );
  signal gpio_tri_i_4 : STD_LOGIC_VECTOR ( 4 to 4 );
  signal gpio_tri_i_5 : STD_LOGIC_VECTOR ( 5 to 5 );
  signal gpio_tri_i_6 : STD_LOGIC_VECTOR ( 6 to 6 );
  signal gpio_tri_i_7 : STD_LOGIC_VECTOR ( 7 to 7 );
  signal gpio_tri_i_8 : STD_LOGIC_VECTOR ( 8 to 8 );
  signal gpio_tri_i_9 : STD_LOGIC_VECTOR ( 9 to 9 );
  signal gpio_tri_io_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio_tri_io_1 : STD_LOGIC_VECTOR ( 1 to 1 );
  signal gpio_tri_io_10 : STD_LOGIC_VECTOR ( 10 to 10 );
  signal gpio_tri_io_11 : STD_LOGIC_VECTOR ( 11 to 11 );
  signal gpio_tri_io_12 : STD_LOGIC_VECTOR ( 12 to 12 );
  signal gpio_tri_io_13 : STD_LOGIC_VECTOR ( 13 to 13 );
  signal gpio_tri_io_14 : STD_LOGIC_VECTOR ( 14 to 14 );
  signal gpio_tri_io_15 : STD_LOGIC_VECTOR ( 15 to 15 );
  signal gpio_tri_io_2 : STD_LOGIC_VECTOR ( 2 to 2 );
  signal gpio_tri_io_3 : STD_LOGIC_VECTOR ( 3 to 3 );
  signal gpio_tri_io_4 : STD_LOGIC_VECTOR ( 4 to 4 );
  signal gpio_tri_io_5 : STD_LOGIC_VECTOR ( 5 to 5 );
  signal gpio_tri_io_6 : STD_LOGIC_VECTOR ( 6 to 6 );
  signal gpio_tri_io_7 : STD_LOGIC_VECTOR ( 7 to 7 );
  signal gpio_tri_io_8 : STD_LOGIC_VECTOR ( 8 to 8 );
  signal gpio_tri_io_9 : STD_LOGIC_VECTOR ( 9 to 9 );
  signal gpio_tri_o_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio_tri_o_1 : STD_LOGIC_VECTOR ( 1 to 1 );
  signal gpio_tri_o_10 : STD_LOGIC_VECTOR ( 10 to 10 );
  signal gpio_tri_o_11 : STD_LOGIC_VECTOR ( 11 to 11 );
  signal gpio_tri_o_12 : STD_LOGIC_VECTOR ( 12 to 12 );
  signal gpio_tri_o_13 : STD_LOGIC_VECTOR ( 13 to 13 );
  signal gpio_tri_o_14 : STD_LOGIC_VECTOR ( 14 to 14 );
  signal gpio_tri_o_15 : STD_LOGIC_VECTOR ( 15 to 15 );
  signal gpio_tri_o_2 : STD_LOGIC_VECTOR ( 2 to 2 );
  signal gpio_tri_o_3 : STD_LOGIC_VECTOR ( 3 to 3 );
  signal gpio_tri_o_4 : STD_LOGIC_VECTOR ( 4 to 4 );
  signal gpio_tri_o_5 : STD_LOGIC_VECTOR ( 5 to 5 );
  signal gpio_tri_o_6 : STD_LOGIC_VECTOR ( 6 to 6 );
  signal gpio_tri_o_7 : STD_LOGIC_VECTOR ( 7 to 7 );
  signal gpio_tri_o_8 : STD_LOGIC_VECTOR ( 8 to 8 );
  signal gpio_tri_o_9 : STD_LOGIC_VECTOR ( 9 to 9 );
  signal gpio_tri_t_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio_tri_t_1 : STD_LOGIC_VECTOR ( 1 to 1 );
  signal gpio_tri_t_10 : STD_LOGIC_VECTOR ( 10 to 10 );
  signal gpio_tri_t_11 : STD_LOGIC_VECTOR ( 11 to 11 );
  signal gpio_tri_t_12 : STD_LOGIC_VECTOR ( 12 to 12 );
  signal gpio_tri_t_13 : STD_LOGIC_VECTOR ( 13 to 13 );
  signal gpio_tri_t_14 : STD_LOGIC_VECTOR ( 14 to 14 );
  signal gpio_tri_t_15 : STD_LOGIC_VECTOR ( 15 to 15 );
  signal gpio_tri_t_2 : STD_LOGIC_VECTOR ( 2 to 2 );
  signal gpio_tri_t_3 : STD_LOGIC_VECTOR ( 3 to 3 );
  signal gpio_tri_t_4 : STD_LOGIC_VECTOR ( 4 to 4 );
  signal gpio_tri_t_5 : STD_LOGIC_VECTOR ( 5 to 5 );
  signal gpio_tri_t_6 : STD_LOGIC_VECTOR ( 6 to 6 );
  signal gpio_tri_t_7 : STD_LOGIC_VECTOR ( 7 to 7 );
  signal gpio_tri_t_8 : STD_LOGIC_VECTOR ( 8 to 8 );
  signal gpio_tri_t_9 : STD_LOGIC_VECTOR ( 9 to 9 );
  signal spi_io0_i : STD_LOGIC;
  signal spi_io0_o : STD_LOGIC;
  signal spi_io0_t : STD_LOGIC;
  signal spi_io1_i : STD_LOGIC;
  signal spi_io1_o : STD_LOGIC;
  signal spi_io1_t : STD_LOGIC;
  signal spi_sck_i : STD_LOGIC;
  signal spi_sck_o : STD_LOGIC;
  signal spi_sck_t : STD_LOGIC;
  signal spi_ss_i_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal spi_ss_io_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal spi_ss_o_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal spi_ss_t : STD_LOGIC;
begin
design_1_i: component design_1
     port map (
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      gpio_tri_i(15) => gpio_tri_i_15(15),
      gpio_tri_i(14) => gpio_tri_i_14(14),
      gpio_tri_i(13) => gpio_tri_i_13(13),
      gpio_tri_i(12) => gpio_tri_i_12(12),
      gpio_tri_i(11) => gpio_tri_i_11(11),
      gpio_tri_i(10) => gpio_tri_i_10(10),
      gpio_tri_i(9) => gpio_tri_i_9(9),
      gpio_tri_i(8) => gpio_tri_i_8(8),
      gpio_tri_i(7) => gpio_tri_i_7(7),
      gpio_tri_i(6) => gpio_tri_i_6(6),
      gpio_tri_i(5) => gpio_tri_i_5(5),
      gpio_tri_i(4) => gpio_tri_i_4(4),
      gpio_tri_i(3) => gpio_tri_i_3(3),
      gpio_tri_i(2) => gpio_tri_i_2(2),
      gpio_tri_i(1) => gpio_tri_i_1(1),
      gpio_tri_i(0) => gpio_tri_i_0(0),
      gpio_tri_o(15) => gpio_tri_o_15(15),
      gpio_tri_o(14) => gpio_tri_o_14(14),
      gpio_tri_o(13) => gpio_tri_o_13(13),
      gpio_tri_o(12) => gpio_tri_o_12(12),
      gpio_tri_o(11) => gpio_tri_o_11(11),
      gpio_tri_o(10) => gpio_tri_o_10(10),
      gpio_tri_o(9) => gpio_tri_o_9(9),
      gpio_tri_o(8) => gpio_tri_o_8(8),
      gpio_tri_o(7) => gpio_tri_o_7(7),
      gpio_tri_o(6) => gpio_tri_o_6(6),
      gpio_tri_o(5) => gpio_tri_o_5(5),
      gpio_tri_o(4) => gpio_tri_o_4(4),
      gpio_tri_o(3) => gpio_tri_o_3(3),
      gpio_tri_o(2) => gpio_tri_o_2(2),
      gpio_tri_o(1) => gpio_tri_o_1(1),
      gpio_tri_o(0) => gpio_tri_o_0(0),
      gpio_tri_t(15) => gpio_tri_t_15(15),
      gpio_tri_t(14) => gpio_tri_t_14(14),
      gpio_tri_t(13) => gpio_tri_t_13(13),
      gpio_tri_t(12) => gpio_tri_t_12(12),
      gpio_tri_t(11) => gpio_tri_t_11(11),
      gpio_tri_t(10) => gpio_tri_t_10(10),
      gpio_tri_t(9) => gpio_tri_t_9(9),
      gpio_tri_t(8) => gpio_tri_t_8(8),
      gpio_tri_t(7) => gpio_tri_t_7(7),
      gpio_tri_t(6) => gpio_tri_t_6(6),
      gpio_tri_t(5) => gpio_tri_t_5(5),
      gpio_tri_t(4) => gpio_tri_t_4(4),
      gpio_tri_t(3) => gpio_tri_t_3(3),
      gpio_tri_t(2) => gpio_tri_t_2(2),
      gpio_tri_t(1) => gpio_tri_t_1(1),
      gpio_tri_t(0) => gpio_tri_t_0(0),
      spi_io0_i => spi_io0_i,
      spi_io0_o => spi_io0_o,
      spi_io0_t => spi_io0_t,
      spi_io1_i => spi_io1_i,
      spi_io1_o => spi_io1_o,
      spi_io1_t => spi_io1_t,
      spi_sck_i => spi_sck_i,
      spi_sck_o => spi_sck_o,
      spi_sck_t => spi_sck_t,
      spi_ss_i(0) => spi_ss_i_0(0),
      spi_ss_o(0) => spi_ss_o_0(0),
      spi_ss_t => spi_ss_t
    );
gpio_tri_iobuf_0: component IOBUF
     port map (
      I => gpio_tri_o_0(0),
      IO => gpio_tri_io(0),
      O => gpio_tri_i_0(0),
      T => gpio_tri_t_0(0)
    );
gpio_tri_iobuf_1: component IOBUF
     port map (
      I => gpio_tri_o_1(1),
      IO => gpio_tri_io(1),
      O => gpio_tri_i_1(1),
      T => gpio_tri_t_1(1)
    );
gpio_tri_iobuf_10: component IOBUF
     port map (
      I => gpio_tri_o_10(10),
      IO => gpio_tri_io(10),
      O => gpio_tri_i_10(10),
      T => gpio_tri_t_10(10)
    );
gpio_tri_iobuf_11: component IOBUF
     port map (
      I => gpio_tri_o_11(11),
      IO => gpio_tri_io(11),
      O => gpio_tri_i_11(11),
      T => gpio_tri_t_11(11)
    );
gpio_tri_iobuf_12: component IOBUF
     port map (
      I => gpio_tri_o_12(12),
      IO => gpio_tri_io(12),
      O => gpio_tri_i_12(12),
      T => gpio_tri_t_12(12)
    );
gpio_tri_iobuf_13: component IOBUF
     port map (
      I => gpio_tri_o_13(13),
      IO => gpio_tri_io(13),
      O => gpio_tri_i_13(13),
      T => gpio_tri_t_13(13)
    );
gpio_tri_iobuf_14: component IOBUF
     port map (
      I => gpio_tri_o_14(14),
      IO => gpio_tri_io(14),
      O => gpio_tri_i_14(14),
      T => gpio_tri_t_14(14)
    );
gpio_tri_iobuf_15: component IOBUF
     port map (
      I => gpio_tri_o_15(15),
      IO => gpio_tri_io(15),
      O => gpio_tri_i_15(15),
      T => gpio_tri_t_15(15)
    );
gpio_tri_iobuf_2: component IOBUF
     port map (
      I => gpio_tri_o_2(2),
      IO => gpio_tri_io(2),
      O => gpio_tri_i_2(2),
      T => gpio_tri_t_2(2)
    );
gpio_tri_iobuf_3: component IOBUF
     port map (
      I => gpio_tri_o_3(3),
      IO => gpio_tri_io(3),
      O => gpio_tri_i_3(3),
      T => gpio_tri_t_3(3)
    );
gpio_tri_iobuf_4: component IOBUF
     port map (
      I => gpio_tri_o_4(4),
      IO => gpio_tri_io(4),
      O => gpio_tri_i_4(4),
      T => gpio_tri_t_4(4)
    );
gpio_tri_iobuf_5: component IOBUF
     port map (
      I => gpio_tri_o_5(5),
      IO => gpio_tri_io(5),
      O => gpio_tri_i_5(5),
      T => gpio_tri_t_5(5)
    );
gpio_tri_iobuf_6: component IOBUF
     port map (
      I => gpio_tri_o_6(6),
      IO => gpio_tri_io(6),
      O => gpio_tri_i_6(6),
      T => gpio_tri_t_6(6)
    );
gpio_tri_iobuf_7: component IOBUF
     port map (
      I => gpio_tri_o_7(7),
      IO => gpio_tri_io(7),
      O => gpio_tri_i_7(7),
      T => gpio_tri_t_7(7)
    );
gpio_tri_iobuf_8: component IOBUF
     port map (
      I => gpio_tri_o_8(8),
      IO => gpio_tri_io(8),
      O => gpio_tri_i_8(8),
      T => gpio_tri_t_8(8)
    );
gpio_tri_iobuf_9: component IOBUF
     port map (
      I => gpio_tri_o_9(9),
      IO => gpio_tri_io(9),
      O => gpio_tri_i_9(9),
      T => gpio_tri_t_9(9)
    );
spi_io0_iobuf: component IOBUF
     port map (
      I => spi_io0_o,
      IO => spi_io0_io,
      O => spi_io0_i,
      T => spi_io0_t
    );
spi_io1_iobuf: component IOBUF
     port map (
      I => spi_io1_o,
      IO => spi_io1_io,
      O => spi_io1_i,
      T => spi_io1_t
    );
spi_sck_iobuf: component IOBUF
     port map (
      I => spi_sck_o,
      IO => spi_sck_io,
      O => spi_sck_i,
      T => spi_sck_t
    );
spi_ss_iobuf_0: component IOBUF
     port map (
      I => spi_ss_o_0(0),
      IO => spi_ss_io(0),
      O => spi_ss_i_0(0),
      T => spi_ss_t
    );
end STRUCTURE;
