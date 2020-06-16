--<insert:  c:\HW\releasedULD\headers\clk_div.head>
-- -----------------------------------------------------------------------------
--
-- module:    clk_div
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This module is a programmable divider use for generating the sample clock
--   (clk_samp). It continuously counts down from pre_clk_tx-1 to 0, asserting
--   en_clk_samp during the 0  count.
--   
-- To ensure proper reset of the FFs running on the derived clock,
--   en_clk_samp is asserted during  reset.
--   
--  Notes:
--   pre_clk_tx must be at least 2 for this module to work. Since it is not
--   allowed to be less than 32 (by the parser), this is not a problem.
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


entity clk_div is
    Port ( clk_tx                 : in  std_logic;                       -- transmitter clock
           rst_clk_tx             : in  std_logic;                       -- reset signal synchronized to the transmitter clock
           prescale_clk_tx        : in  std_logic_vector (15 downto 0);  -- current prescaler value synchronized to clk_tx
           en_clk_samp            : out std_logic                        -- indication that the clk_samp is in the first clk_tx period after the rising edge. Asserted during clk_tx period after en_clk_samp
          );
end clk_div;

architecture Behavioral of clk_div is

begin

    clkDiv: process (clk_tx)
          variable internal_counter : integer range 0 to 65535 := 0;           -- set of registers for maintaining the count
       begin
          if rising_edge(clk_tx) then                                          -- synchronous event test
             if (rst_clk_tx = '1') then                                        -- reset asserted?
                internal_counter := 0;                                         -- reset the internal counter
                en_clk_samp      <= '0';                                       -- deassert the enable
             else                                                              -- non-reset behavior
                en_clk_samp      <= '0';                                       -- keep enable deasserted. overridden by count = 0 below
                if (internal_counter = 0) then                                 -- are we done with the count?
                   en_clk_samp      <= '1';                                    -- assert enable
                   internal_counter := to_integer(unsigned(prescale_clk_tx));  -- reset the internal counter the the specified value 
                else
                   internal_counter := internal_counter - 1;                   -- decrement count by 1
                end if;                                                        -- end of done with count
             end if;                                                           -- end of reset/normal operation
          end if;                                                              -- end of synchronous events
       end process clkDiv;

end Behavioral;

