----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:42 09/02/2011 
-- Design Name: 
-- Module Name:    tb_uart_monitor - Behavioral 
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
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


library UTILITIES_LIB;
use UTILITIES_LIB.time_utilities_pkg.all;
use UTILITIES_LIB.string_utilities_sim_pkg.all;
use UTILITIES_LIB.string_utilities_synth_pkg.all;

entity tb_uart_monitor is
  generic(CLOCK_PERIOD: time := 10 ns;
          BIT_PERIOD : time:= 8681 ns  
         );  

    Port ( start_monitor   : in boolean;    
           data_in         : in  std_logic;
           character_out   : out character;
           character_valid : out boolean
          );
end tb_uart_monitor;

architecture Behavioral of tb_uart_monitor is

      signal slvCharacter : std_logic_vector(7 downto 0);
  
   begin

      for_eachchar: process 
         begin
            if ((data_in'event) and (data_in ='0')) then     -- Start capturing data when the data line goes low, the first bit is the start bit  
               if start_monitor then                         -- hold off collecting data until the valid input commands are present
                  wait for bit_period * 1.5;                 -- Wait for 1.5 bit period. We should now be on the middle of the first data bit.
                  get_each_bit: for i in 0 to 7 loop
                     slvCharacter(i) <= data_in;             -- The LSB is sent out first
                     wait for bit_period;
                  end loop get_each_bit;
               end if;
       
               -- We should be in the middle of the stop
               assert (data_in /= '1')
               report "ERROR Framing error detected in :" & time'image(now)
               severity WARNING;
          
               -- Send the character out with a valid signal 
               character_out   <= slvToChar(slvCharacter);
               character_valid <= true;
               report "(monitor): Sending character " & slvToChar(slvCharacter);
               wait for 1 ns;
               character_valid <= false; 
            else 
              wait until data_in'event and data_in ='0' and start_monitor;
            end if;  
            
         end process for_eachchar;

   end Behavioral;

