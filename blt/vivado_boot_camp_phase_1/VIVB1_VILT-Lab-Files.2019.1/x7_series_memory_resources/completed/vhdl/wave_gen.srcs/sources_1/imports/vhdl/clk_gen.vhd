--<insert:  c:\HW\releasedULD\headers\clk_gen.head>
-- -----------------------------------------------------------------------------
--
-- module:    clk_gen
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This module is the clock generator for the  design.
--   It takes in a single clock input (nominally 100MHz), and  generates
--   three output clocks using a single clock generator:
--     clk_rx   - running at the same frequency as the input clock
--     clk_tx   - either running at hte same frequency as the input clock
--                or running at 31/32 times the frequency
--   clk_samp   - a decimated version of clk_tx using a BUFHCE (from clk_tx)
--              - running at 1/prescale the frequency of clk_tx
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
-- Copyright � 2002, 2008, 2009 Xilinx,  Inc.
--   All rights reserved
-- 
-- -----------------------------------------------------------------------------
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.wave_gen_pkg.all;                    -- load component definitions


entity clk_gen is
    Port (
          rst_i             : in  std_logic;                       -- external reset
          clk_pin_p         : in  std_logic;                       -- primary clock input (un-buffered)
          clk_pin_n         : in  std_logic;                       --   - and differential input
          clk_rx            : out std_logic;                       -- clock for UART receiver and parser portion of the design
          clk_tx            : out std_logic;                       -- clock for UART transmitter and output portion of the design
          prescale_clk_tx   : in  std_logic_vector(15 downto 0);   -- current prescalar value synchronized to clk_tx
          en_clk_samp       : out std_logic;                       -- indication that the next rising edge of clk_tx will coincide with the rising edge of clk_samp
          clk_samp          : out std_logic                        -- clock for the sampling portion of the design (waveform output)
         );
end clk_gen;


architecture Behavioral of clk_gen is

       signal clock_locked           : std_logic := 'U';
       signal clk_rx_internal        : std_logic := 'U';
       signal clk_tx_internal        : std_logic := 'U';
       signal clk_samp_internal      : std_logic := 'U';
       signal rst_clk_tx             : std_logic := 'U';
       signal en_clk_samp_internal   : std_logic := 'U';                 -- connection between the clk_div module and the BUFGCE

       component clk_core
         port (CLK_IN1_P         : IN  std_logic;
               CLK_IN1_N         : IN  std_logic;
               CLK_OUT1          : OUT std_logic;
               CLK_OUT2          : OUT std_logic;
               RESET             : IN  std_logic;
               LOCKED            : OUT std_logic
             );
       end component clk_core;

    begin

       -- instantiate the prescale divider
       clk_div_i0: clk_div 
          port map(clk_tx            => clk_tx_internal,
                   rst_clk_tx        => rst_clk_tx,
                   prescale_clk_tx   => prescale_clk_tx,
                   en_clk_samp       => en_clk_samp_internal
                );
       en_clk_samp <= en_clk_samp_internal;


       -- Instantiate clk_core - generated by the Clocking Wizard

       clk_core_i0: clk_core 
          port map (
             CLK_IN1_P         => clk_pin_p,
             CLK_IN1_N         => clk_pin_n,
             CLK_OUT1          => clk_rx_internal,
             CLK_OUT2          => clk_tx_internal,
             RESET             => rst_i,
             LOCKED            => clock_locked        
          );

       -- BUFHCE: Clock buffer for a single clocking region with clock enable
       --         Virtex-6
       -- Xilinx HDL Language Template, version 11.2

       BUFHCE_clk_samp_i0 : BUFHCE
       generic map (
          INIT_OUT => 0  -- Initial output value, also indicates stop low vs stop high behavior
       )
       port map (
          O  => clk_samp_internal,    -- 1-bit The output of the BUFH
          CE => en_clk_samp_internal, -- 1-bit Enables propagation of signal from I to O. When low, sets output to 0.
          I  => clk_tx_internal       -- 1-bit The input to the BUFH
       ); -- BUFHCE
       
       clk_rx   <= clk_rx_internal;
       clk_tx   <= clk_tx_internal;
       clk_samp <= clk_samp_internal;

       -- generate the reset based on the lock status of the DCM
       rst_clk_tx <= not clock_locked;
       

    end Behavioral;

