library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;


entity zedboard_top is
    port (
        SW : in std_logic_vector(7 downto 0);
        LD : out std_logic_vector(7 downto 0)
    );
end zedboard_top;


architecture rtl of zedboard_top is

begin

    LD <= SW;

end rtl;
