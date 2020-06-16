-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Mon Oct 28 13:07:52 2019
-- Host        : BLT-WKS-1909-11 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               C:/training/7_series_IO_resources/completed/verilog/ioserdes.srcs/sources_1/ip/input_interface/input_interface_sim_netlist.vhdl
-- Design      : input_interface
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7k70tfbg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity input_interface_input_interface_selectio_wiz is
  port (
    data_in_from_pins_p : in STD_LOGIC_VECTOR ( 0 to 0 );
    data_in_from_pins_n : in STD_LOGIC_VECTOR ( 0 to 0 );
    data_in_to_device : out STD_LOGIC_VECTOR ( 13 downto 0 );
    delay_locked : out STD_LOGIC;
    ref_clock : in STD_LOGIC;
    bitslip : in STD_LOGIC_VECTOR ( 0 to 0 );
    clk_in_p : in STD_LOGIC;
    clk_in_n : in STD_LOGIC;
    clk_div_out : out STD_LOGIC;
    clk_reset : in STD_LOGIC;
    io_reset : in STD_LOGIC
  );
  attribute DEV_W : integer;
  attribute DEV_W of input_interface_input_interface_selectio_wiz : entity is 14;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of input_interface_input_interface_selectio_wiz : entity is "input_interface_selectio_wiz";
  attribute SYS_W : integer;
  attribute SYS_W of input_interface_input_interface_selectio_wiz : entity is 1;
  attribute num_serial_bits : integer;
  attribute num_serial_bits of input_interface_input_interface_selectio_wiz : entity is 14;
end input_interface_input_interface_selectio_wiz;

architecture STRUCTURE of input_interface_input_interface_selectio_wiz is
  signal \^clk_div_out\ : STD_LOGIC;
  signal clk_in_int : STD_LOGIC;
  signal clk_in_int_buf : STD_LOGIC;
  signal clk_in_int_delay : STD_LOGIC;
  signal data_in_from_pins_delay : STD_LOGIC;
  signal data_in_from_pins_int : STD_LOGIC;
  signal \pins[0].icascade1\ : STD_LOGIC;
  signal \pins[0].icascade2\ : STD_LOGIC;
  signal ref_clock_bufg : STD_LOGIC;
  signal NLW_idelaye2_clk_CNTVALUEOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal \NLW_pins[0].idelaye2_bus_CNTVALUEOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal \NLW_pins[0].iserdese2_master_O_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].iserdese2_slave_O_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].iserdese2_slave_Q1_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].iserdese2_slave_Q2_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].iserdese2_slave_SHIFTOUT1_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_pins[0].iserdese2_slave_SHIFTOUT2_UNCONNECTED\ : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of bufio_inst : label is "PRIMITIVE";
  attribute BOX_TYPE of clkout_buf_inst : label is "PRIMITIVE";
  attribute BOX_TYPE of delayctrl : label is "PRIMITIVE";
  attribute IODELAY_GROUP : string;
  attribute IODELAY_GROUP of delayctrl : label is "input_interface_group";
  attribute BOX_TYPE of ibufds_clk_inst : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of ibufds_clk_inst : label is "DONT_CARE";
  attribute IBUF_DELAY_VALUE : string;
  attribute IBUF_DELAY_VALUE of ibufds_clk_inst : label is "0";
  attribute IFD_DELAY_VALUE : string;
  attribute IFD_DELAY_VALUE of ibufds_clk_inst : label is "AUTO";
  attribute BOX_TYPE of idelaye2_clk : label is "PRIMITIVE";
  attribute IODELAY_GROUP of idelaye2_clk : label is "input_interface_group";
  attribute SIM_DELAY_D : integer;
  attribute SIM_DELAY_D of idelaye2_clk : label is 0;
  attribute BOX_TYPE of \pins[0].ibufds_inst\ : label is "PRIMITIVE";
  attribute CAPACITANCE of \pins[0].ibufds_inst\ : label is "DONT_CARE";
  attribute IBUF_DELAY_VALUE of \pins[0].ibufds_inst\ : label is "0";
  attribute IFD_DELAY_VALUE of \pins[0].ibufds_inst\ : label is "AUTO";
  attribute BOX_TYPE of \pins[0].idelaye2_bus\ : label is "PRIMITIVE";
  attribute IODELAY_GROUP of \pins[0].idelaye2_bus\ : label is "input_interface_group";
  attribute SIM_DELAY_D of \pins[0].idelaye2_bus\ : label is 0;
  attribute BOX_TYPE of \pins[0].iserdese2_master\ : label is "PRIMITIVE";
  attribute OPT_MODIFIED : string;
  attribute OPT_MODIFIED of \pins[0].iserdese2_master\ : label is "MLO";
  attribute BOX_TYPE of \pins[0].iserdese2_slave\ : label is "PRIMITIVE";
  attribute OPT_MODIFIED of \pins[0].iserdese2_slave\ : label is "MLO";
  attribute BOX_TYPE of ref_clk_bufg : label is "PRIMITIVE";
begin
  clk_div_out <= \^clk_div_out\;
bufio_inst: unisim.vcomponents.BUFIO
     port map (
      I => clk_in_int_delay,
      O => clk_in_int_buf
    );
clkout_buf_inst: unisim.vcomponents.BUFR
    generic map(
      BUFR_DIVIDE => "7",
      SIM_DEVICE => "7SERIES"
    )
        port map (
      CE => '1',
      CLR => clk_reset,
      I => clk_in_int_delay,
      O => \^clk_div_out\
    );
delayctrl: unisim.vcomponents.IDELAYCTRL
    generic map(
      SIM_DEVICE => "7SERIES"
    )
        port map (
      RDY => delay_locked,
      REFCLK => ref_clock_bufg,
      RST => io_reset
    );
ibufds_clk_inst: unisim.vcomponents.IBUFDS
     port map (
      I => clk_in_p,
      IB => clk_in_n,
      O => clk_in_int
    );
idelaye2_clk: unisim.vcomponents.IDELAYE2
    generic map(
      CINVCTRL_SEL => "FALSE",
      DELAY_SRC => "IDATAIN",
      HIGH_PERFORMANCE_MODE => "FALSE",
      IDELAY_TYPE => "FIXED",
      IDELAY_VALUE => 5,
      IS_C_INVERTED => '0',
      IS_DATAIN_INVERTED => '0',
      IS_IDATAIN_INVERTED => '0',
      PIPE_SEL => "FALSE",
      REFCLK_FREQUENCY => 200.000000,
      SIGNAL_PATTERN => "CLOCK"
    )
        port map (
      C => '0',
      CE => '0',
      CINVCTRL => '0',
      CNTVALUEIN(4 downto 0) => B"00000",
      CNTVALUEOUT(4 downto 0) => NLW_idelaye2_clk_CNTVALUEOUT_UNCONNECTED(4 downto 0),
      DATAIN => '0',
      DATAOUT => clk_in_int_delay,
      IDATAIN => clk_in_int,
      INC => '0',
      LD => io_reset,
      LDPIPEEN => '0',
      REGRST => '0'
    );
\pins[0].ibufds_inst\: unisim.vcomponents.IBUFDS
     port map (
      I => data_in_from_pins_p(0),
      IB => data_in_from_pins_n(0),
      O => data_in_from_pins_int
    );
\pins[0].idelaye2_bus\: unisim.vcomponents.IDELAYE2
    generic map(
      CINVCTRL_SEL => "FALSE",
      DELAY_SRC => "IDATAIN",
      HIGH_PERFORMANCE_MODE => "FALSE",
      IDELAY_TYPE => "FIXED",
      IDELAY_VALUE => 0,
      IS_C_INVERTED => '0',
      IS_DATAIN_INVERTED => '0',
      IS_IDATAIN_INVERTED => '0',
      PIPE_SEL => "FALSE",
      REFCLK_FREQUENCY => 200.000000,
      SIGNAL_PATTERN => "DATA"
    )
        port map (
      C => \^clk_div_out\,
      CE => '0',
      CINVCTRL => '0',
      CNTVALUEIN(4 downto 0) => B"00000",
      CNTVALUEOUT(4 downto 0) => \NLW_pins[0].idelaye2_bus_CNTVALUEOUT_UNCONNECTED\(4 downto 0),
      DATAIN => '0',
      DATAOUT => data_in_from_pins_delay,
      IDATAIN => data_in_from_pins_int,
      INC => '0',
      LD => '0',
      LDPIPEEN => '0',
      REGRST => '0'
    );
\pins[0].iserdese2_master\: unisim.vcomponents.ISERDESE2
    generic map(
      DATA_RATE => "DDR",
      DATA_WIDTH => 14,
      DYN_CLKDIV_INV_EN => "FALSE",
      DYN_CLK_INV_EN => "FALSE",
      INIT_Q1 => '0',
      INIT_Q2 => '0',
      INIT_Q3 => '0',
      INIT_Q4 => '0',
      INTERFACE_TYPE => "NETWORKING",
      IOBDELAY => "IFD",
      IS_CLKB_INVERTED => '1',
      IS_CLKDIVP_INVERTED => '0',
      IS_CLKDIV_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_OCLKB_INVERTED => '0',
      IS_OCLK_INVERTED => '0',
      NUM_CE => 2,
      OFB_USED => "FALSE",
      SERDES_MODE => "MASTER",
      SRVAL_Q1 => '0',
      SRVAL_Q2 => '0',
      SRVAL_Q3 => '0',
      SRVAL_Q4 => '0'
    )
        port map (
      BITSLIP => bitslip(0),
      CE1 => '1',
      CE2 => '1',
      CLK => clk_in_int_buf,
      CLKB => clk_in_int_buf,
      CLKDIV => \^clk_div_out\,
      CLKDIVP => '0',
      D => '0',
      DDLY => data_in_from_pins_delay,
      DYNCLKDIVSEL => '0',
      DYNCLKSEL => '0',
      O => \NLW_pins[0].iserdese2_master_O_UNCONNECTED\,
      OCLK => '0',
      OCLKB => '0',
      OFB => '0',
      Q1 => data_in_to_device(13),
      Q2 => data_in_to_device(12),
      Q3 => data_in_to_device(11),
      Q4 => data_in_to_device(10),
      Q5 => data_in_to_device(9),
      Q6 => data_in_to_device(8),
      Q7 => data_in_to_device(7),
      Q8 => data_in_to_device(6),
      RST => io_reset,
      SHIFTIN1 => '0',
      SHIFTIN2 => '0',
      SHIFTOUT1 => \pins[0].icascade1\,
      SHIFTOUT2 => \pins[0].icascade2\
    );
\pins[0].iserdese2_slave\: unisim.vcomponents.ISERDESE2
    generic map(
      DATA_RATE => "DDR",
      DATA_WIDTH => 14,
      DYN_CLKDIV_INV_EN => "FALSE",
      DYN_CLK_INV_EN => "FALSE",
      INIT_Q1 => '0',
      INIT_Q2 => '0',
      INIT_Q3 => '0',
      INIT_Q4 => '0',
      INTERFACE_TYPE => "NETWORKING",
      IOBDELAY => "IFD",
      IS_CLKB_INVERTED => '1',
      IS_CLKDIVP_INVERTED => '0',
      IS_CLKDIV_INVERTED => '0',
      IS_CLK_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_OCLKB_INVERTED => '0',
      IS_OCLK_INVERTED => '0',
      NUM_CE => 2,
      OFB_USED => "FALSE",
      SERDES_MODE => "SLAVE",
      SRVAL_Q1 => '0',
      SRVAL_Q2 => '0',
      SRVAL_Q3 => '0',
      SRVAL_Q4 => '0'
    )
        port map (
      BITSLIP => bitslip(0),
      CE1 => '1',
      CE2 => '1',
      CLK => clk_in_int_buf,
      CLKB => clk_in_int_buf,
      CLKDIV => \^clk_div_out\,
      CLKDIVP => '0',
      D => '0',
      DDLY => '0',
      DYNCLKDIVSEL => '0',
      DYNCLKSEL => '0',
      O => \NLW_pins[0].iserdese2_slave_O_UNCONNECTED\,
      OCLK => '0',
      OCLKB => '0',
      OFB => '0',
      Q1 => \NLW_pins[0].iserdese2_slave_Q1_UNCONNECTED\,
      Q2 => \NLW_pins[0].iserdese2_slave_Q2_UNCONNECTED\,
      Q3 => data_in_to_device(5),
      Q4 => data_in_to_device(4),
      Q5 => data_in_to_device(3),
      Q6 => data_in_to_device(2),
      Q7 => data_in_to_device(1),
      Q8 => data_in_to_device(0),
      RST => io_reset,
      SHIFTIN1 => \pins[0].icascade1\,
      SHIFTIN2 => \pins[0].icascade2\,
      SHIFTOUT1 => \NLW_pins[0].iserdese2_slave_SHIFTOUT1_UNCONNECTED\,
      SHIFTOUT2 => \NLW_pins[0].iserdese2_slave_SHIFTOUT2_UNCONNECTED\
    );
ref_clk_bufg: unisim.vcomponents.BUFG
     port map (
      I => ref_clock,
      O => ref_clock_bufg
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity input_interface is
  port (
    data_in_from_pins_p : in STD_LOGIC_VECTOR ( 0 to 0 );
    data_in_from_pins_n : in STD_LOGIC_VECTOR ( 0 to 0 );
    data_in_to_device : out STD_LOGIC_VECTOR ( 13 downto 0 );
    delay_locked : out STD_LOGIC;
    ref_clock : in STD_LOGIC;
    bitslip : in STD_LOGIC_VECTOR ( 0 to 0 );
    clk_in_p : in STD_LOGIC;
    clk_in_n : in STD_LOGIC;
    clk_div_out : out STD_LOGIC;
    clk_reset : in STD_LOGIC;
    io_reset : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of input_interface : entity is true;
  attribute DEV_W : integer;
  attribute DEV_W of input_interface : entity is 14;
  attribute SYS_W : integer;
  attribute SYS_W of input_interface : entity is 1;
end input_interface;

architecture STRUCTURE of input_interface is
  attribute DEV_W of inst : label is 14;
  attribute SYS_W of inst : label is 1;
  attribute num_serial_bits : integer;
  attribute num_serial_bits of inst : label is 14;
begin
inst: entity work.input_interface_input_interface_selectio_wiz
     port map (
      bitslip(0) => bitslip(0),
      clk_div_out => clk_div_out,
      clk_in_n => clk_in_n,
      clk_in_p => clk_in_p,
      clk_reset => clk_reset,
      data_in_from_pins_n(0) => data_in_from_pins_n(0),
      data_in_from_pins_p(0) => data_in_from_pins_p(0),
      data_in_to_device(13 downto 0) => data_in_to_device(13 downto 0),
      delay_locked => delay_locked,
      io_reset => io_reset,
      ref_clock => ref_clock
    );
end STRUCTURE;
