--<insert:  c:\HW\releasedULD\headers\rst_gen.head>
-- -----------------------------------------------------------------------------
--
-- module:    rst_gen
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
use IEEE.NUMERIC_STD.ALL;

library work;
use work.wave_gen_pkg.all;                    -- load component definitions


entity rst_gen is
    Port (clk_tx         : in  std_logic;     -- transmitter clock
          clk_rx         : in  std_logic;     -- receiver clock
          clk_samp       : in  std_logic;     -- sample clock
          rst_i          : in  std_logic;     -- asynchronous reset input
          clock_locked   : in  std_logic;     -- Locked signal from clk_core
          rst_clk_tx     : out std_logic;     -- reset synchronized to clk_tx
          rst_clk_rx     : out std_logic;     -- reset synchronized to clk_rx
          rst_clk_samp   : out std_logic      -- reset synchronized to clk_samp
         );
end rst_gen;


architecture Behavioral of rst_gen is

      signal int_rst     : std_logic := 'U';  -- asynchronous reset or MMCM not locked
    begin
       
      int_rst <= rst_i or not(clock_locked);

       -- generate 3 copies of the debouncer, each gets the same signal in, but in 3 different time domains
       reset_bridge_clk_tx_i0:   reset_bridge port map (clk_dst=>clk_tx,   rst_in=>int_rst, rst_dst=>rst_clk_tx);
       reset_bridge_clk_rx_i0:   reset_bridge port map (clk_dst=>clk_rx,   rst_in=>int_rst, rst_dst=>rst_clk_rx);
       reset_bridge_clk_samp_i0: reset_bridge port map (clk_dst=>clk_samp, rst_in=>int_rst, rst_dst=>rst_clk_samp);

    end Behavioral;

