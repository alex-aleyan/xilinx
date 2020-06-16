--<insert: c:\HW\releasedULD\headers\uart_tx_ctl.head>
-- -----------------------------------------------------------------------------
--
-- module:    uart_tx_ctl
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

entity uart_tx_ctl is
    Port ( clk_tx           : in  std_logic;
           rst_clk_tx       : in  std_logic;
           baud_x16_en      : in  std_logic;
           char_fifo_empty  : in  std_logic;
           char_fifo_rd_en  : out std_logic;
           char_fifo_dout   : in  std_logic_vector (7 downto 0);
           txd_tx           : out std_logic
           );
end uart_tx_ctl;

architecture Behavioral of uart_tx_ctl is
       type VALID_STATES is (IDLE, START, DATA, STOP);
       signal state : VALID_STATES := IDLE;
       
       signal over_sample_cnt_done   : std_logic := 'U';
       signal bit_cnt_done           : std_logic := 'U';
       signal over_sample_cnt        : integer range 0 to 15 := 0;
       signal bit_cnt                : integer range 0 to  8 := 0;
       signal char_fifo_pop          : std_logic := 'U';     -- POP indication to FIFO

    begin

       -- main state machine
       stmch: process (clk_tx)
          begin
             if rising_edge(clk_tx) then                                 -- act only on rising edge of clock
                if (rst_clk_tx = '1') then                               -- is the reset active?
                   state         <= IDLE;
                   char_fifo_pop <= '0';
                else                                                     -- if not reset active, do "normal" activities
                   if (baud_x16_en = '1') then                           -- if the x16 clock has ticked...                     
                      char_fifo_pop <= '0';
                      case (state) is                                    -- find the current state and execute it
                         when IDLE =>                                    -- IDLE state (waits or the fifo to not be empty)
                            if (char_fifo_empty = '0') then              -- there is data in the FIFO
                               state <= START;                           -- advance to the beginning of the transmission state
                            end if;                                      -- end of check for data to be in the FIFO
                            
                         when START =>                                   -- start transmission
                            if (over_sample_cnt_done = '1') then         -- is it time to send the next datum? (sync time with oversample counter)
                               state <= DATA;                            -- advance to selecting the 
                            end if;                                      -- end of check to send the next datum
                            
                         when DATA =>                                    -- send information
                            if ((over_sample_cnt_done = '1') and (bit_cnt_done = '1')) then   -- have we sent all the data?
                               state         <= STOP;                    -- advance to the state to send the stop bit
                          char_fifo_pop <= '1';                     -- pop a datum off the stack
                            end if;                                      -- end of detection of last data sent
                            
                         when STOP =>                                    -- send stop bit
                            if (over_sample_cnt_done = '1') then         -- 
                               if (char_fifo_empty = '1') then           -- more stuff to send?
                                  state <= IDLE;                            -- nope, return to idle and wait for more data
                               else                                      -- FIFO not empty
                                  state <= START;                        -- send the next character
                               end if;                                   -- done looking for restart or end
                            end if;                                      -- end of sending stop bit
                      end case;                                          -- end of state selections
                   end if;                                               -- end of test for oversample enable
                end if;                                                  -- end of normal activities
             end if;                                                     -- end of synchronous events
          end process stmch;
       
       -- Oversample counter
       -- Pre-load whenever we are starting a new character (in IDLE or in STOP),
       -- or whenever we are within a character (when we are in START or DATA).
       ovrsmpl: process (clk_tx)
          begin
             if rising_edge(clk_tx) then                                 -- test for synch event
                if (rst_clk_tx = '1') then                               -- has the reset been asserted?
                   over_sample_cnt <= 0;                                 -- reset the counter
                else                                                     -- not reset, do "normal" behavior
                   if (baud_x16_en = '1') then                           -- have we been enabled (occurs at x16 the baud rate)
                      if (over_sample_cnt_done = '0') then               -- are we still counting?
                            over_sample_cnt <= over_sample_cnt - 1;      -- decrement the current count 
                      else                                               -- nope, we're done counting - define when to reset
                         -- define the conditions at which the counter should reset                    
                         if (((state = IDLE) and (char_fifo_empty = '0')) or -- idle state and data is in fifo
                             ((state = STOP) and (char_fifo_empty = '0')) or -- stop state and data is in fifo
                             (state = START) or                          -- start state
                             (state = DATA) ) then                       -- data state
                            over_sample_cnt <= 15;                       -- preload the counter
                         end if;                                         -- end of conditions to preload
                      end if;                                            -- end of counting activities
                   end if;                                               -- end of x16 check
                end if;                                                  -- end of "normal" activities
             end if;                                                     -- end of sync event
          end process ovrsmpl;
       
       -- track which bit we are about to transmit
       -- cleared in start state, incremented in data states
       trkbit: process (clk_tx)
          begin
             if rising_edge(clk_tx) then                                 -- test for synch event
                if (rst_clk_tx = '1') then                               -- has the reset been asserted?
                   bit_cnt <= 0;                                         -- reset the counter
                else                                                     -- not reset, do "normal" behavior
                   if (baud_x16_en = '1') then                           -- have we been enabled (occurs at x16 the baud rate)
                      if (over_sample_cnt_done = '1') then               -- are we still counting?
                         if (state = START) then                         -- are we starting again?
                            bit_cnt <= 0;                                -- clear the number of bits send
                         elsif (state = DATA) then                       -- are we currently sending data?
                            bit_cnt <= bit_cnt + 1;                      -- increment the bit count                            
                         end if;                                         -- end of state check
                      end if;                                            -- end of counting activities
                   end if;                                               -- end of x16 check
                end if;                                                  -- end of "normal" activities
             end if;                                                     -- end of sync event
          end process trkbit;     
          
      -- is the count done?
      bit_cnt_done         <= '1' when (bit_cnt = 7)         else '0';
      over_sample_cnt_done <= '1' when (over_sample_cnt = 0) else '0';
        
       --
       -- generate the output
       genOut: process (clk_tx)
          begin
             if rising_edge(clk_tx) then                                 -- test for synch events
                if (rst_clk_tx = '1') then                               -- are we in reset?
                   txd_tx <= '1';                                        -- always drive the line high during reset
                else                                                     -- not in reset, must be "normal" activities
                   if (baud_x16_en = '1') then                           -- have we been enabled (occurs at x16 the baud rate)
                      if (state = STOP) then                             -- if we're in the stop state then 
                         txd_tx <= '1';                                  -- line idles at a "high"
                         if (char_fifo_empty = '0') then                 -- if there is more data in the fifo
                         end if;                                         -- end of fifo test
                      elsif (state = IDLE) then                          -- if we're in the idle state, then we must drive the line high
                         txd_tx <= '1';                                  -- line idles at a "high"
                      elsif (state = START) then                         -- we're in the start state                  
                         txd_tx <= '0';                                  -- drive the line low                  
                      else                                               -- we must be in data state
                         txd_tx <= char_fifo_dout(bit_cnt);              -- send the appropriate bit of data
                      end if;                                            -- end of state checking
                   end if;                                               -- end of x16 check
                end if;                                                  -- end of reset/normal test
             end if;                                                     -- end of synch events
          end process genOut;

      -- insure that the fifo only gets enabled once per baud_x16_en
     char_fifo_rd_en <= char_fifo_pop and baud_x16_en;
          
    end Behavioral;

