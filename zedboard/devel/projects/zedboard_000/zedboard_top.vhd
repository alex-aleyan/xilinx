library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity zedboard_top is
    port (
        GCLK : in std_logic;

        SW : in std_logic_vector(7 downto 0);

        LD : out std_logic_vector(7 downto 0)
    );
end zedboard_top;


architecture rtl of zedboard_top is

signal clk_100mhz : std_logic;

attribute mark_debug : string;
attribute mark_debug of SW  : signal is "true";

begin

    BUFG_CLK_100MHZ_I : BUFG
    port map (
        O => clk_100mhz, -- 1-bit output: Clock output
        I => GCLK  -- 1-bit input: Clock input
    );

    process(clk_100mhz)
    begin
        if (rising_edge(clk_100mhz)) then
            LD <= SW;
        end if;
    end process;


end rtl;
