--<insert: c:\HW\releasedULD\headers\out_ddr_flop.head>
-- -----------------------------------------------------------------------------
--
-- module:    out_ddr_flop
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This is a wrapper around a basic DDR output flop. A version of this module
--   with identical ports exists for all target technologies for this design
--   (Spartan 3E and Virtex 5).
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

library UNISIM;
use UNISIM.VComponents.all;

entity out_ddr_flop is
    Port ( clk        : in  std_logic;
           rst        : in  std_logic;
           d_rise     : in  std_logic;
           d_fall     : in  std_logic;
           q          : out  std_logic
       );
end out_ddr_flop;

architecture Behavioral of out_ddr_flop is
       
       constant logic_high   : std_logic := '1';
       constant logic_low    : std_logic := '0';

    begin
       -- ODDRE1: Dedicated Dual Data Rate (DDR) Output Register
       --         Kintex UltraScale
       -- Xilinx HDL Language Template, version 2013.4

       ODDR_inst : ODDRE1
       generic map (
          SRVAL => '0'  -- Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
       )
       port map (
          Q => q,       -- 1-bit output: Data output to IOB
          C => clk,     -- 1-bit input: High-speed clock input
          D1 => d_rise, -- 1-bit input: Parallel data input 1
          D2 => d_fall, -- 1-bit input: Parallel data input 2
          SR => rst     -- 1-bit input: Active High Reset
       );

    end Behavioral;

