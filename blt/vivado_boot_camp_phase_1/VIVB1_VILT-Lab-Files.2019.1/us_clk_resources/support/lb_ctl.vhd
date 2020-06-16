--<insert: c:\HW\releasedULD\headers\wave_gen.head>
-- -----------------------------------------------------------------------------
--
-- module:    wave_gen
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This is the top level of the wave  generator.
--   It directly instantiates the I/O pads and all the submodules  required
--   to implement the  design.
--   
-- Multicycle and False  Paths
--   Some exist, embedded within the submodules. See the  submodule
--   descriptions.
-- 
-- known issues:
-- status           id     found     description                      by fixed date  by    comment
-- 
-- version history:
--   version    date    author     description
--    11.1-001 20 APR 2009 WK       New for version 11.1            
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

library WORK;
use WORK.wave_gen_pkg.all;                             -- load components


entity lb_ctl is
    Generic (CLOCK_RATE     : integer := 50_000_000);  -- clock frequency
    Port (clk_tx            : in  std_logic;           -- transmitter clock domain (destination)
          rst_clk_tx        : in  std_logic;           -- reset synchronized to transmitter clock domain
          lb_sel_async      : in  std_logic;           -- loopback selector (high = do loopback, low = use output from uart_tx)
          txd_clk_tx        : in  std_logic;           -- transmit data from uart
          rxd_async         : in  std_logic;           -- received data - not synchronous to this clock
          txd_o             : out std_logic            -- loopback output - either from the transmitter data or the receive loopback
          );
end lb_ctl;


architecture Behavioral of lb_ctl is
       signal lb_sel_clk_tx : std_logic := 'U';     -- loopback signal synchronized with the tx clock domain
       signal rxd_i_clk_tx  : std_logic;
    begin
    
       -- debounce the loopback control signal
       debouncer_i0: debouncer 
                   generic map (FILTER => CLOCK_RATE/10) -- 100ms to register a change  *note* - set filter to something really small for verification 
                   port map (clk=>clk_tx, rst=>rst_clk_tx, signal_in=>lb_sel_async, signal_out=>lb_sel_clk_tx);

       meta_harden_rxd_i_i0: meta_harden port map (rst_dst=>rst_clk_tx, clk_dst=>clk_tx, signal_src=>rxd_async, signal_dst=>rxd_i_clk_tx);

       -- construct the multiplexer
        lbMux: process (clk_tx)
          begin
             if rising_edge(clk_tx) then
                if (rst_clk_tx = '1') then
                   txd_o <= '0';
                else
                   if (lb_sel_clk_tx = '1') then
                     txd_o <= rxd_i_clk_tx;
                   else
                     txd_o <= txd_clk_tx;
                   end if;
                end if;
             end if;
          end process lbMux;


    end Behavioral;

