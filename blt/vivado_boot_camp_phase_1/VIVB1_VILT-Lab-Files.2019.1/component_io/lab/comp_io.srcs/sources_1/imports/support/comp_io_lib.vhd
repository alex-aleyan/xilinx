----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2014 12:10:11 PM
-- Design Name: 
-- Module Name: comp_io_lib - Behavioral
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

package comp_io_pack is 

type sv12x4 is array (11 downto 0) of std_logic_vector(3 downto 0);
type sv12x8 is array (11 downto 0) of std_logic_vector(7 downto 0);

end package comp_io_pack;
