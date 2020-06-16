----------------------------------------------------------------------------------
-- Create Date: 09/14/2014 12:01:20 PM
-- Design Name: 
-- Module Name: comp_io - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.comp_io_pack.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity comp_io is
  Port ( 
    -- IDELAYCTRL interface
    clkref_p   : in std_logic;     -- Diff clock for IDELAYCTRL
    clkref_n   : in std_logic;
    rst        : in std_logic;     -- Delay calibration reset input
    rdy        : out std_logic;    -- IDELAYE3 Delay calibration complete indication
    
    -- Data Interface
    clk_p      : in std_logic;     -- Data capture clock
    clk_n      : in std_logic;
    datain_p   : in std_logic_vector(11 downto 0);  -- Center aligned data 
    datain_n   : in std_logic_vector(11 downto 0);
    
    dataport   : out sv12x4);      -- Parallel data output (12x4) 48 bits
   
end entity comp_io;

architecture rtl of comp_io is

signal clk1, clk       : std_logic; 
signal clkref1, clkref : std_logic;
signal clk_fab         : std_logic;
signal rst_reg         : std_logic;
signal datain          : std_logic_vector(11 downto 0);
signal datadelayed     : std_logic_vector(11 downto 0);
signal dataout         : sv12x8;
signal dataout_reg     : sv12x4 ;
signal dataout_reg1    : sv12x4 ;

begin
----------------------------------------------------------------------------------------------
-- Clock buffers for capture clock to ISERDES
   IBUFDS_clk_inst : IBUFDS
   generic map (
      DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
   )
   port map (
      O => clk1,   -- 1-bit output: Buffer output
      I => clk_p,  -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => clk_n  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
   );

-- Clock for ISERDES capture 
   BUFGCE_clk_inst : BUFGCE
   generic map (
      CE_TYPE => "SYNC",     -- ASYNC, SYNC
      IS_CE_INVERTED => '0', -- Programmable inversion on CE
      IS_I_INVERTED => '0'   -- Programmable inversion on I
   )
   port map (
      O => clk,   -- 1-bit output: Buffer
      CE => '1',  -- 1-bit input: Buffer enable
      I => clk1   -- 1-bit input: Buffer
   );
----------------------------------------------------------------------------------------------
--  Clock for fabric logic, divide-by 2 version of serial clock
   BUFGCE_DIV_inst : BUFGCE_DIV
   generic map (
      BUFGCE_DIVIDE => 2,     -- 1-8
      -- Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
      IS_CE_INVERTED => '0',  -- Optional inversion for CE
      IS_CLR_INVERTED => '0', -- Optional inversion for CLR
      IS_I_INVERTED => '0'    -- Optional inversion for I
   )
   port map (
      O => clk_fab, -- 1-bit output: Buffer
      CE => '1',    -- 1-bit input: Buffer enable
      CLR => '0',   -- 1-bit input: Asynchronous clear
      I => clk1     -- 1-bit input: Buffer
   );

-----------------------------------------------------------------------------------------------
-- Reference clock for IDELAYCTRL
IBUFDS_ref_inst : IBUFDS
   generic map (
      DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
   )
   port map (
      O => clkref1,   -- 1-bit output: Buffer output
      I => clkref_p,  -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => clkref_n  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
   );
   
   BUFGCE_clkr_inst : BUFGCE
   generic map (
      CE_TYPE => "SYNC",     -- ASYNC, SYNC
      IS_CE_INVERTED => '0', -- Programmable inversion on CE
      IS_I_INVERTED => '0'   -- Programmable inversion on I
   )
   port map (
      O => clkref,   -- 1-bit output: Buffer
      CE => '1',    -- 1-bit input: Buffer enable
      I => clkref1    -- 1-bit input: Buffer
   );

------------------------------------------------------------------------------------------------
-- IDELAYCTRL and reset for IDELAYCTRL

-- Register the rst input on clkref 
    process (clkref)
    begin
      if rising_edge(clkref) then
        rst_reg  <= rst;
      end if;
    end process;

   IDELAYCTRL_inst : IDELAYCTRL
   generic map (
         SIM_DEVICE => "ULTRASCALE"  -- Set the device version (7SERIES, ULTRASCALE)
   )
   port map (
      RDY    => rdy,           -- 1-bit output: Ready output
      REFCLK => clkref,
      RST    => rst_reg        -- 1-bit input: Active high reset input
   );

------------------------------------------------------------------------------------------------
-- Data input capture and output data generation

datacap : for i in 0 to 11 generate

   IBUFDSD_inst : IBUFDS
   generic map (
      DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
   )
   port map (
      O  => datain(i),     -- 1-bit output: Buffer output
      I  => datain_p(i),   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => datain_n(i)    -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
   );

   IDELAYE3_inst : IDELAYE3
   generic map (
      CASCADE => "NONE",         -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
      DELAY_FORMAT => "TIME",    -- Units of the DELAY_VALUE (COUNT, TIME)
      DELAY_SRC => "IDATAIN",    -- Delay input (DATAIN, IDATAIN)
      DELAY_TYPE => "FIXED",     -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
      DELAY_VALUE => 0,          -- Input delay value setting
      IS_CLK_INVERTED => '0',    -- Optional inversion for CLK
      IS_RST_INVERTED => '0',    -- Optional inversion for RST
      REFCLK_FREQUENCY => 250.0, -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0)     
      SIM_DEVICE => "ULTRASCALE", -- Set the device version (ULTRASCALE, ULTRASCALE_PLUS_ES1)
      UPDATE_MODE => "ASYNC"     -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
   )
   port map (
      CASC_OUT => open,          -- 1-bit output: Cascade delay output to ODELAY input cascade
      CNTVALUEOUT => open,       -- 9-bit output: Counter value output
      DATAOUT => datadelayed(i), -- 1-bit output: Delayed data output
      CASC_IN => '0',           -- 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
      CASC_RETURN => '0',       -- 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
      CE => '0',                -- 1-bit input: Active high enable increment/decrement input
      CLK => '0',               -- 1-bit input: Clock input
      CNTVALUEIN =>"000000000", -- 9-bit input: Counter value input
      DATAIN => '0',            -- 1-bit input: Data input from the logic
      EN_VTC => '1',             -- 1-bit input: Keep delay constant over VT
      IDATAIN => datain(i),      -- 1-bit input: Data input from the IOBUF
      INC => '0',               -- 1-bit input: Increment / Decrement tap delay input
      LOAD => '0',              -- 1-bit input: Load DELAY_VALUE input
      RST => '0'                -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
   );

   ISERDESE3_inst : ISERDESE3
   generic map (
      DATA_WIDTH => 4,           -- Parallel data width (4,8)
      FIFO_ENABLE => "FALSE",    -- Enables the use of the FIFO
      FIFO_SYNC_MODE => "FALSE", -- Enables the use of internal 2-stage synchronizers on the FIFO
      -- Clock inversion for CLK_B absorbed into ISERDES through this attribute
      IS_CLK_B_INVERTED => '1',  -- Optional inversion for CLK_B 
      IS_CLK_INVERTED => '0',    -- Optional inversion for CLK
      IS_RST_INVERTED => '0',    -- Optional inversion for RST
      SIM_DEVICE => "ULTRASCALE"  -- Set the device version (ULTRASCALE, ULTRASCALE_PLUS_ES1)
   )
   port map (
      FIFO_EMPTY => open,         -- 1-bit output: FIFO empty flag
      Q => dataout(i),            -- 8-bit registered output
      CLK => clk,
      CLKDIV => clk_fab,          -- 1-bit input: Divided Clock
      
      CLK_B => clk,               -- 1-bit input: Inversion of High-speed clock CLK 
                                  -- Inverted with attribute IS_CLK_B_INVERTED => '1'
                                  
      D => datadelayed(i),        -- 1-bit input: Serial Data Input
      FIFO_RD_CLK => '0',         -- 1-bit input: FIFO read clock
      FIFO_RD_EN => '0',          -- 1-bit input: Enables reading the FIFO when asserted
      RST => '0'                  -- 1-bit input: Asynchronous Reset
   );

-- Output data generation
    process (clk_fab)
    begin
      if rising_edge(clk_fab) then 
        dataout_reg(i)       <= dataout(i);
        dataout_reg1(i)      <= dataout_reg(i);
        dataport(i)          <= dataout_reg1(i);
      end if;
    end process; 
end generate;


end rtl;
