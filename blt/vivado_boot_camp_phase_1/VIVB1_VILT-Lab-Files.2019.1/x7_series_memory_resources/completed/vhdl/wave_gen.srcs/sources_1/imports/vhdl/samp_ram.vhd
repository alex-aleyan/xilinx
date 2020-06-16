----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    26/08/2010 
-- Design Name: 
-- Module Name:    samp_ram - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--    This is an inferrable READ_FIRST dual port RAM
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY samp_ram IS
        generic (
          DATA_WIDTH: integer := 16;
          ADDR_WIDTH: integer := 10   -- 2^10 = 1024
                );
	port (
        -- A port
	clka:  IN  std_logic;
	wea:   IN  std_logic_VECTOR(0 downto 0);
	addra: IN  std_logic_VECTOR(ADDR_WIDTH-1 downto 0);
	dina:  IN  std_logic_VECTOR(DATA_WIDTH-1 downto 0);
	douta: OUT std_logic_VECTOR(DATA_WIDTH-1 downto 0);
        -- B port
	clkb:  IN  std_logic;                     
	web:   IN  std_logic_VECTOR(0 downto 0);
	addrb: IN  std_logic_VECTOR(ADDR_WIDTH-1 downto 0);
	dinb:  IN  std_logic_VECTOR(DATA_WIDTH-1 downto 0);
	doutb: OUT std_logic_VECTOR(DATA_WIDTH-1 downto 0));
END samp_ram;


architecture Behavioral of samp_ram is
    type ram_type is array ((2**ADDR_WIDTH)-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
    shared variable mem_array: ram_type;

    begin
    
       -- A port operations
    process (clka)
    begin
       if rising_edge(clka) then

--          douta <= mem_array(to_integer(unsigned(addra))); -- Synchronous read

--          if (wea = "1") then
--             mem_array(to_integer(unsigned(addra))) := dina; -- Synchronous write
--          end if;

--write first behaviour of port A

         if (wea = "1") then
          mem_array(to_integer(unsigned(addra))) := dina;
          douta <= dina;
        else	
          douta <= mem_array(to_integer(unsigned(addra)));
        end if;
      end if;
     end process;
    
    -- B port operations
                process (clkb)
                begin
                   if rising_edge(clkb) then
          
                      doutb <= mem_array(to_integer(unsigned(addrb))); -- Synchronous read
          
                      if (web = "1") then
                         mem_array(to_integer(unsigned(addrb))) := dinb; -- Synchronous write
                      end if;

         end if;
      end process;
       
    
    end Behavioral;

