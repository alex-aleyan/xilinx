--<insert:  c:\HW\releasedULD\headers\reset_bridge.head>
-- -----------------------------------------------------------------------------
--
-- module:    reset_gen
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This module is the reset generator for the  design.
--   It takes the asynchronous reset in (from the IBUF), and  generates
--   three synchronous resets - one on each clock domain.
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

entity reset_bridge is
    Port (clk_dst     : in  std_logic;     -- destination clock
          rst_in      : in  std_logic;     -- async reset signal
          rst_dst     : out std_logic      -- sync'd reset signal
          );
end reset_bridge;


architecture Behavioral of reset_bridge is
  
    signal rst_meta: std_logic;            -- can go metastable on deassertion of rst_in

    begin
       
       -- reset signal must assert asynchronously, but deassert synchronously
       rstSync: process (clk_dst, rst_in)
          begin
             if (rst_in = '1') then           -- if the reset is active then asynchronously
                rst_meta <= '1';              -- set the meta net to 1 and
                rst_dst  <= '1';              -- assert the reset; otherwise
             elsif rising_edge(clk_dst) then  -- when the reset is low, don't deassert the reset until the 2nd rising edge of the synchronizing clock
                rst_meta <= '0';              -- clock a 0 into the first flop - this can go metastable
                rst_dst  <= rst_meta;         -- let the 0 propagate through on the 2nd clock
             end if;                          -- end of synchronous tasks
          end process rstSync;

    end Behavioral;

