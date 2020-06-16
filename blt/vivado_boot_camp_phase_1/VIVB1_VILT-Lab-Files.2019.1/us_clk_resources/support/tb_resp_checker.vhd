----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:17:36 09/05/2011 
-- Design Name: 
-- Module Name:    tb_resp_checker - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_resp_checker is
   port (start_response_checker : in boolean;    -- need to check if this pin has to be removed in top level implementation
         data_from_fifo         : in character;
         data_from_uut          : in character;
         data_ready             : in boolean;
         fifo_empty             : in boolean;
         read_fifo              : out boolean
        );  
end entity tb_resp_checker;


architecture Behavioral of tb_resp_checker is  
   begin

      resp_check: process
            variable fifo_data        : character;
            variable uut_data         : character;
            variable last_data_ready  : boolean := false;
         begin
            wait until data_ready'event and data_ready =true;           ---Wait until valid data is received from the Monitor.  
            start_check: if start_response_checker then            
               uut_data := data_from_uut;                                -- Capture only after the DUT transmits valid data  
               do_check: if fifo_empty then
                  report "ERROR Data FIFO is not empty when expected";
                  read_fifo <= false;
               else        
                  read_fifo <= true;
                  wait for 500 ps;
                  fifo_data := data_from_fifo;    
                  data_match: if (uut_data /= fifo_data) then
                     report time'image(now) & "(response check) ERROR Character mismatch. Expected   " & fifo_data & " but received " & uut_data;
                  else 
                     report time'image(now) & "(response check) Correct character received  " &  fifo_data;
                  end if data_match;
                  wait for 0.5 ns;
                  read_fifo <= false;           
               end if do_check;          
            end if start_check;
    
         end process resp_check;

   end architecture behavioral;

