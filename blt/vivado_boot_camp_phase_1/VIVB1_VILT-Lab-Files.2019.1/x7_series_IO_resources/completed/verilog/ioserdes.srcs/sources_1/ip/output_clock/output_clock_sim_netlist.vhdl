-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Mon Oct 28 13:07:51 2019
-- Host        : BLT-WKS-1909-11 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               C:/training/7_series_IO_resources/completed/verilog/ioserdes.srcs/sources_1/ip/output_clock/output_clock_sim_netlist.vhdl
-- Design      : output_clock
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7k70tfbg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity output_clock_output_clock_selectio_wiz is
  port (
    data_out_from_device : in STD_LOGIC_VECTOR ( 1 downto 0 );
    data_out_to_pins_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    data_out_to_pins_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    clk_in : in STD_LOGIC;
    io_reset : in STD_LOGIC
  );
  attribute DEV_W : integer;
  attribute DEV_W of output_clock_output_clock_selectio_wiz : entity is 2;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of output_clock_output_clock_selectio_wiz : entity is "output_clock_selectio_wiz";
  attribute SYS_W : integer;
  attribute SYS_W of output_clock_output_clock_selectio_wiz : entity is 1;
end output_clock_output_clock_selectio_wiz;

architecture STRUCTURE of output_clock_output_clock_selectio_wiz is
  signal data_out_to_pins_int : STD_LOGIC;
  signal \NLW_pins[0].oddr_inst_S_UNCONNECTED\ : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of \pins[0].obufds_inst\ : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of \pins[0].obufds_inst\ : label is "DONT_CARE";
  attribute BOX_TYPE of \pins[0].oddr_inst\ : label is "PRIMITIVE";
  attribute OPT_MODIFIED : string;
  attribute OPT_MODIFIED of \pins[0].oddr_inst\ : label is "MLO";
  attribute \__SRVAL\ : string;
  attribute \__SRVAL\ of \pins[0].oddr_inst\ : label is "FALSE";
begin
\pins[0].obufds_inst\: unisim.vcomponents.OBUFDS
     port map (
      I => data_out_to_pins_int,
      O => data_out_to_pins_p(0),
      OB => data_out_to_pins_n(0)
    );
\pins[0].oddr_inst\: unisim.vcomponents.ODDR
    generic map(
      DDR_CLK_EDGE => "SAME_EDGE",
      INIT => '0',
      IS_C_INVERTED => '0',
      IS_D1_INVERTED => '0',
      IS_D2_INVERTED => '0',
      SRTYPE => "ASYNC"
    )
        port map (
      C => clk_in,
      CE => '1',
      D1 => data_out_from_device(0),
      D2 => data_out_from_device(1),
      Q => data_out_to_pins_int,
      R => io_reset,
      S => \NLW_pins[0].oddr_inst_S_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity output_clock is
  port (
    data_out_from_device : in STD_LOGIC_VECTOR ( 1 downto 0 );
    data_out_to_pins_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    data_out_to_pins_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    clk_in : in STD_LOGIC;
    io_reset : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of output_clock : entity is true;
  attribute DEV_W : integer;
  attribute DEV_W of output_clock : entity is 2;
  attribute SYS_W : integer;
  attribute SYS_W of output_clock : entity is 1;
end output_clock;

architecture STRUCTURE of output_clock is
  attribute DEV_W of inst : label is 2;
  attribute SYS_W of inst : label is 1;
begin
inst: entity work.output_clock_output_clock_selectio_wiz
     port map (
      clk_in => clk_in,
      data_out_from_device(1 downto 0) => data_out_from_device(1 downto 0),
      data_out_to_pins_n(0) => data_out_to_pins_n(0),
      data_out_to_pins_p(0) => data_out_to_pins_p(0),
      io_reset => io_reset
    );
end STRUCTURE;
