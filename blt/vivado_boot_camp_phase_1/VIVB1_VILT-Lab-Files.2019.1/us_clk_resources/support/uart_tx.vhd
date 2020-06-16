--<insert: c:\HW\releasedULD\headers\uart_tx.head>
-- -----------------------------------------------------------------------------
--
-- module:    uart_tx
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   UART transmit  controller
--   Implements the state machines for doing RS232  transmission.
--   
-- Whenever a character is ready for transmission (as indicated by  the
--   empty signal from the character FIFO), this module will transmit  the
--    character.
--   
-- The basis of this design is a simple state machine. When in IDLE,  it
--   waits for the character FIFO to indicate that a character is  available,
--   at which time, it immediately starts transmition. It spends  16
--   baud_x16_en periods in the START state, transmitting the  START
--   condition (1'b0), then tranisitions to the DATA state, where it  sends
--   the 8 data bits (LSbit first), each lasting 16 baud_x16_en periods,  and
--   finally going to the STOP state for 16 periods, where it transmits  the
--   STOP value  (1'b1).
--   
-- On the last baud_x16_en period of the last data bit (in the  DATA
--   state), it issues the POP signal to the character FIFO. Since the SM  is
--   only enabled when baud_x16_en is asserted, the resulting pop  signal
--   must then be ANDed with baud_x16_en to ensure that only one  character
--   is popped at a time.  
--   
-- On the last baud_x16_en period of the STOP state, the empty  indication
--   from the character FIFO is inspected; if asserted, the SM returns  to
--   the IDLE state, otherwise it transitions directly to the START state  to
--   start the transmission of the next  character.
--   
-- There are two internal counters - one which counts off the 16 pulses  of
--   baud_x16_en, and a second which counts the 8 bits of  data.
--   
-- The generation of the output (txd_tx) follows one complete  baud_x16_en
--   period after the state machine and other internal  counters.
--   
-- Multicycle and False  Paths
--   All flip-flops within this module share the same chip enable,  generated
--   by the Baud rate generator. Hence, all paths from FFs to FFs in  this
--   module are multicycle  paths.
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


entity uart_tx is
    Generic( CLOCK_RATE     : integer := 50_000_000;
             BAUD_RATE      : integer :=    115_200);
    Port ( clk_tx           : in  std_logic;
           rst_clk_tx       : in  std_logic;
           char_fifo_empty  : in  std_logic;
           char_fifo_dout   : in  std_logic_vector (7 downto 0);
           char_fifo_rd_en  : out std_logic;
           txd_tx           : out std_logic
          );
end uart_tx;


architecture Behavioral of uart_tx is
       
       signal baud_x16_en   : std_logic := 'U';

    begin

       -- 
       -- free running counter that divides the incoming clock by a value to generate
       -- a 16 x baud rate enable signal
       --
       -- all paths that start and end on flip-flops enabled by baud_x16_en are multi-cycle
       -- 
       uart_baud_gen_tx_i0: uart_baud_gen 
           generic map (CLOCK_RATE  => CLOCK_RATE,
                        BAUD_RATE   => BAUD_RATE)                      
           port map    (rst         => rst_clk_tx,
                        clk         => clk_tx, 
                        baud_x16_en => baud_x16_en
                 );

       uart_tx_ctl_i0: uart_tx_ctl
           Port map (clk_tx          => clk_tx,
                     rst_clk_tx      => rst_clk_tx,
                     baud_x16_en     => baud_x16_en,
                     char_fifo_empty => char_fifo_empty,
                     char_fifo_rd_en => char_fifo_rd_en,
                     char_fifo_dout  => char_fifo_dout,
                     txd_tx          => txd_tx
                    );


    end Behavioral;

