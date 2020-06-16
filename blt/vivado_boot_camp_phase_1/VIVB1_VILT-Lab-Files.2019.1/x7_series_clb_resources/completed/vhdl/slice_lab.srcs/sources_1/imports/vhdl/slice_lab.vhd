-------------------------------------------------------------------------------
--  
--  Copyright (c) 2009 Xilinx Inc.
--
--  Project  : Slice Lab
--  Module   : slice_lab.vhd
--  Parent   : None
--  Children : None
--
--  Description: 
--     This is the rtl file for the CLB architecture lab.
--
--  Parameters:
--     
--
--  Local Parameters:
--
--  Notes       : 
--
--  Multicycle and False Paths
--    
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity slice_lab is
  port(
    clk     : in  std_logic;
    rst     : in  std_logic;
    cnt_en  : in  std_logic;
    cnt_out : out std_logic_vector(31 downto 0);
    tc_out  : out std_logic
    );
end slice_lab;

architecture rtl of slice_lab is

  signal cnt       : std_logic_vector(31 downto 0);
  signal cnt_en_d1 : std_logic;

begin  -- rtl
  
  my_process: process (clk)
  begin
       
    if clk'event and clk = '1' then

      if rst = '1' then
        cnt       <= (OTHERS => '0');
        cnt_out   <= (OTHERS => '0');
        tc_out    <= '0';
        cnt_en_d1 <= '0';

      else
  
        cnt_en_d1 <= cnt_en;
     
        if (cnt_en_d1 = '1') then

          -- Insert counter code here
          cnt <= cnt + 1;
        end if;

          cnt_out <= cnt;
          
          if (cnt = x"FFFFFFFF") then
              tc_out <= '1';
          else
               tc_out <= '0';
          end if;    
        -- Insert terminal count code here

      end if;

    end if;
      
  end process my_process;

end rtl;
