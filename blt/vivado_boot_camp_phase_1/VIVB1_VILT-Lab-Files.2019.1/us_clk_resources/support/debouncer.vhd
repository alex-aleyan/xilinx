--<insert: c:\HW\releasedULD\headers\debouncer.head>
-- -----------------------------------------------------------------------------
--
-- module:    debouncer
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   Simple switch debouncer. Filters out any transition that lasts less than
--   FILTER clocks long
-- 
-- known issues:
-- status           id     found     description                      by fixed date  by    comment
-- 
-- version history:
--   version    date    author     description
--    11.1-001 20 APR 2009 WK       First version for 11.1          
-- 
-- ---------------------------------------------------------------------------
-- 
-- disclaimer:
--   Disclaimer: LIMITED WARRANTY AND DISCLAMER. These designs  are
--   provided to you as is . Xilinx and its licensors make, and  you
--   receive no warranties or conditions, express,  implied,
--   statutory or otherwise, and Xilinx specifically disclaims  any
--   implied warranties of merchantability, non-infringement,  or
--   fitness for a particular purpose. Xilinx does not warrant  that
--   the functions contained in these designs will meet  your
--   requirements, or that the operation of these designs will  be
--   uninterrupted or error free, or that defects in the  Designs
--   will be corrected. Furthermore, Xilinx does not warrant  or
--   make any representations regarding use or the results of  the
--   use of the designs in terms of correctness,  accuracy,
--   reliability, or  otherwise.
--   
-- LIMITATION OF LIABILITY. In no event will Xilinx or  its
--   licensors be liable for any loss of data, lost profits,  cost
--   or procurement of substitute goods or services, or for  any
--   special, incidental, consequential, or indirect  damages
--   arising from the use or operation of the designs  or
--   accompanying documentation, however caused and on any  theory
--   of liability. This limitation will apply even if  Xilinx
--   has been advised of the possibility of such damage.  This
--   limitation shall apply not-withstanding the failure of  the
--   essential purpose of any limited remedies  herein.
--   
-- Copyright © 2002, 2008, 2009 Xilinx,  Inc.
--   All rights reserved
-- 
-- -----------------------------------------------------------------------------
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;


entity debouncer is
    generic ( FILTER     : integer := 2_000_000        -- number of clocks required to acknowledge a valid change in switch state
           );
   port (clk             : in  std_logic;              -- clock input
         rst             : in  std_logic;              -- active high reset - synchronous to clock
         signal_in       : in  std_logic;              -- un-debounced signal
         signal_out      : out std_logic               -- debounced signal
         );
    constant RELOAD      : integer := FILTER - 1;  

end debouncer;


architecture Behavioral of debouncer is
       
       signal signal_in_clk : std_logic := 'U';

       component meta_harden is
         port ( clk_dst          : in  std_logic;
                rst_dst         : in  std_logic;
                signal_src       : in  std_logic;
                signal_dst       : out std_logic
           );
       end component;
       
    begin

       -- Anti-meta-stability/synchronization circuit
       meta_harden_signal_in_i0: meta_harden
                   port map (clk_dst    => clk,
                            rst_dst        => rst,
                            signal_src     => signal_in,
                            signal_dst     => signal_in_clk);

       -- Only transition the output if the input has been stable at a new value for FILTER clocks
       dbnc: process (clk)
             variable signal_out_reg    : std_logic := 'U';
             variable count             : integer range 0 to FILTER := FILTER;
          begin
             if rising_edge(clk) then                     -- everything happens synchronously with the driving clock
                if (rst = '1') then                       -- if the reset is asserted
                   signal_out_reg := signal_in_clk;       -- initializes to the last value of signal_in when exiting reset
                   count      := RELOAD;                  -- start with an expired counter
                else                                      -- reset not asserted - do "normal" activities                 
                   if (signal_in_clk = signal_out_reg) then  -- if the current input is the same as the last debounced output...
                      count := RELOAD;                    -- reload the counter
                    elsif (count = 0) then                -- Otherwise, it is different... if the count has expired
                      signal_out_reg := signal_in_clk;    -- then it has been different long enough - time to switch the output
                      count := RELOAD;                    -- and reload the counter
                    else                                  -- otherwise we are still waiting for it to be different for "long enough"
                      count := count - 1;                 -- decrement the counter
                   end if;                                -- end of transition check
                end if;                                   -- end of reset/normal operation                
             end if;                                      -- end of synchronous events test      

            signal_out <= signal_out_reg;                 -- drive the output with the previously latched value                
            
          end process dbnc;
             
    end Behavioral;


