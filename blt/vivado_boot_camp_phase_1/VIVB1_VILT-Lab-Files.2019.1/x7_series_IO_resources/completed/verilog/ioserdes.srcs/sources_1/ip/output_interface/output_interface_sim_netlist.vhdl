-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Mon Oct 28 13:07:52 2019
-- Host        : BLT-WKS-1909-11 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               C:/training/7_series_IO_resources/completed/verilog/ioserdes.srcs/sources_1/ip/output_interface/output_interface_sim_netlist.vhdl
-- Design      : output_interface
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7k70tfbg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity output_interface_output_interface_selectio_wiz is
  port (
    data_out_from_device : in STD_LOGIC_VECTOR ( 13 downto 0 );
    data_out_to_pins_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    data_out_to_pins_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    clk_in : in STD_LOGIC;
    clk_div_in : in STD_LOGIC;
    io_reset : in STD_LOGIC
  );
  attribute DEV_W : integer;
  attribute DEV_W of output_interface_output_interface_selectio_wiz : entity is 14;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of output_interface_output_interface_selectio_wiz : entity is "output_interface_selectio_wiz";
  attribute SYS_W : integer;
  attribute SYS_W of output_interface_output_interface_selectio_wiz : entity is 1;
  attribute num_serial_bits : integer;
  attribute num_serial_bits of output_interface_output_interface_selectio_wiz : entity is 14;
end output_interface_output_interface_selectio_wiz;

architecture STRUCTURE of output_interface_output_interface_selectio_wiz is
  signal data_out_to_pins_int : STD_LOGIC;
  signal \pins[0].ocascade_sm_d\ : STD_LOGIC;
  signal \pins[0].ocascade_sm_t\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_master_OFB_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_master_SHIFTOUT1_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_master_SHIFTOUT2_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_master_TBYTEOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_master_TFB_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_master_TQ_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_slave_OFB_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_slave_OQ_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_slave_TBYTEOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_slave_TFB_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].oserdese2_slave_TQ_UNCONNECTED\ : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of \pins[0].obufds_inst\ : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of \pins[0].obufds_inst\ : label is "DONT_CARE";
  attribute BOX_TYPE of \pins[0].oserdese2_master\ : label is "PRIMITIVE";
  attribute BOX_TYPE of \pins[0].oserdese2_slave\ : label is "PRIMITIVE";
begin
\pins[0].obufds_inst\: unisim.vcomponents.OBUFDS
     port map (
      I => data_out_to_pins_int,
      O => data_out_to_pins_p(0),
      OB => data_out_to_pins_n(0)
    );
\pins[0].oserdese2_master\: unisim.vcomponents.OSERDESE2
    generic map(
      DATA_RATE_OQ => "DDR",
      DATA_RATE_TQ => "SDR",
      DATA_WIDTH => 14,
      INIT_OQ => '0',
      INIT_TQ => '0',
      IS_CLKDIV_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_D1_INVERTED => '0',
      IS_D2_INVERTED => '0',
      IS_D3_INVERTED => '0',
      IS_D4_INVERTED => '0',
      IS_D5_INVERTED => '0',
      IS_D6_INVERTED => '0',
      IS_D7_INVERTED => '0',
      IS_D8_INVERTED => '0',
      IS_T1_INVERTED => '0',
      IS_T2_INVERTED => '0',
      IS_T3_INVERTED => '0',
      IS_T4_INVERTED => '0',
      SERDES_MODE => "MASTER",
      SRVAL_OQ => '0',
      SRVAL_TQ => '0',
      TBYTE_CTL => "FALSE",
      TBYTE_SRC => "FALSE",
      TRISTATE_WIDTH => 1
    )
        port map (
      CLK => clk_in,
      CLKDIV => clk_div_in,
      D1 => data_out_from_device(0),
      D2 => data_out_from_device(1),
      D3 => data_out_from_device(2),
      D4 => data_out_from_device(3),
      D5 => data_out_from_device(4),
      D6 => data_out_from_device(5),
      D7 => data_out_from_device(6),
      D8 => data_out_from_device(7),
      OCE => '1',
      OFB => \NLW_pins[0].oserdese2_master_OFB_UNCONNECTED\,
      OQ => data_out_to_pins_int,
      RST => io_reset,
      SHIFTIN1 => \pins[0].ocascade_sm_d\,
      SHIFTIN2 => \pins[0].ocascade_sm_t\,
      SHIFTOUT1 => \NLW_pins[0].oserdese2_master_SHIFTOUT1_UNCONNECTED\,
      SHIFTOUT2 => \NLW_pins[0].oserdese2_master_SHIFTOUT2_UNCONNECTED\,
      T1 => '0',
      T2 => '0',
      T3 => '0',
      T4 => '0',
      TBYTEIN => '0',
      TBYTEOUT => \NLW_pins[0].oserdese2_master_TBYTEOUT_UNCONNECTED\,
      TCE => '0',
      TFB => \NLW_pins[0].oserdese2_master_TFB_UNCONNECTED\,
      TQ => \NLW_pins[0].oserdese2_master_TQ_UNCONNECTED\
    );
\pins[0].oserdese2_slave\: unisim.vcomponents.OSERDESE2
    generic map(
      DATA_RATE_OQ => "DDR",
      DATA_RATE_TQ => "SDR",
      DATA_WIDTH => 14,
      INIT_OQ => '0',
      INIT_TQ => '0',
      IS_CLKDIV_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_D1_INVERTED => '0',
      IS_D2_INVERTED => '0',
      IS_D3_INVERTED => '0',
      IS_D4_INVERTED => '0',
      IS_D5_INVERTED => '0',
      IS_D6_INVERTED => '0',
      IS_D7_INVERTED => '0',
      IS_D8_INVERTED => '0',
      IS_T1_INVERTED => '0',
      IS_T2_INVERTED => '0',
      IS_T3_INVERTED => '0',
      IS_T4_INVERTED => '0',
      SERDES_MODE => "SLAVE",
      SRVAL_OQ => '0',
      SRVAL_TQ => '0',
      TBYTE_CTL => "FALSE",
      TBYTE_SRC => "FALSE",
      TRISTATE_WIDTH => 1
    )
        port map (
      CLK => clk_in,
      CLKDIV => clk_div_in,
      D1 => '0',
      D2 => '0',
      D3 => data_out_from_device(8),
      D4 => data_out_from_device(9),
      D5 => data_out_from_device(10),
      D6 => data_out_from_device(11),
      D7 => data_out_from_device(12),
      D8 => data_out_from_device(13),
      OCE => '1',
      OFB => \NLW_pins[0].oserdese2_slave_OFB_UNCONNECTED\,
      OQ => \NLW_pins[0].oserdese2_slave_OQ_UNCONNECTED\,
      RST => io_reset,
      SHIFTIN1 => '0',
      SHIFTIN2 => '0',
      SHIFTOUT1 => \pins[0].ocascade_sm_d\,
      SHIFTOUT2 => \pins[0].ocascade_sm_t\,
      T1 => '0',
      T2 => '0',
      T3 => '0',
      T4 => '0',
      TBYTEIN => '0',
      TBYTEOUT => \NLW_pins[0].oserdese2_slave_TBYTEOUT_UNCONNECTED\,
      TCE => '0',
      TFB => \NLW_pins[0].oserdese2_slave_TFB_UNCONNECTED\,
      TQ => \NLW_pins[0].oserdese2_slave_TQ_UNCONNECTED\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity output_interface is
  port (
    data_out_from_device : in STD_LOGIC_VECTOR ( 13 downto 0 );
    data_out_to_pins_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    data_out_to_pins_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    clk_in : in STD_LOGIC;
    clk_div_in : in STD_LOGIC;
    io_reset : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of output_interface : entity is true;
  attribute DEV_W : integer;
  attribute DEV_W of output_interface : entity is 14;
  attribute SYS_W : integer;
  attribute SYS_W of output_interface : entity is 1;
end output_interface;

architecture STRUCTURE of output_interface is
  attribute DEV_W of inst : label is 14;
  attribute SYS_W of inst : label is 1;
  attribute num_serial_bits : integer;
  attribute num_serial_bits of inst : label is 14;
begin
inst: entity work.output_interface_output_interface_selectio_wiz
     port map (
      clk_div_in => clk_div_in,
      clk_in => clk_in,
      data_out_from_device(13 downto 0) => data_out_from_device(13 downto 0),
      data_out_to_pins_n(0) => data_out_to_pins_n(0),
      data_out_to_pins_p(0) => data_out_to_pins_p(0),
      io_reset => io_reset
    );
end STRUCTURE;
