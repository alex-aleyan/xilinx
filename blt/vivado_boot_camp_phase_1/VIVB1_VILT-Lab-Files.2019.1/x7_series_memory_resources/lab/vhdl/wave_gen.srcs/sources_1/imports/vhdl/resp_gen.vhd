--<insert: c:\HW\releasedULD\headers\resp_gen.head>
-- -----------------------------------------------------------------------------
--
-- module:    resp_gen
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This module is responsible for pushing data into the character FIFO to  
--   send to the user over the serial  link.
--   There are two interfaces from the command parser to this module.  The
--   first is the one that echoes received characters back to the  user
--   (giving full duplex communication) - every character received while  the
--   character FIFO is not full is simply pushed into the  FIFO.
--   The second is the generation of the response string when a command  (or
--   error) is entered. There are 3 types of  responses
--   - The error response (normally   -ERR\n )
--   - The OK response (normally   -OK\n )
--   - The data response the '-' followed by 4 hex digits, a space, and  5
--   decimal digits, then the  \n
--   
-- Notes:  
--   For PC usage, we must send a  Carriage return  (ascii 0xD).  The
--   terminal program should append a line  feed.
--   
-- Multicycle and False  Paths
--   The submodule  to_dec.v  contains a 5 cycle Multi-Cycle Path
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


library utilities_lib;   
use utilities_lib.string_utilities_synth_pkg.all;                     -- string management functions

--
-- the wave_gen package contains state, response types, and command characters
library WORK;
use work.wave_gen_pkg.ALL;


entity resp_gen is
    Port ( clk_rx              : in  std_logic;                       -- receiver clock
           rst_clk_rx          : in  std_logic;                       -- reset signal synchronized to clk_rx
           send_char_valid     : in  std_logic;                       -- single pulse asserted to show valid send_char
           send_char           : in  std_logic_vector (7 downto 0);   -- character to return to user. valid when send_char_val asserted
           send_resp_valid     : in  std_logic;                       -- asserted when new response reqd. Type indicated by send_resp_typ and remains asserted until send_resp_done asserted
           send_resp_type      : in  RESPONSE_TYPE;                   -- indicates type of response required. Vaild whn send_resp_type is asserted (00: ack; 01: error; 10: data; 11: not used)
           send_resp_data      : in  std_logic_vector (15 downto 0);  -- data to send. only valid when send_resp_val is asserted and send_resp_type is "10"
           send_resp_done      : out std_logic;                       -- pulsed for 1 clock when requestd response is complete. Send_resp_val must be deasserted on the next clock
           char_fifo_din       : out std_logic_vector (7 downto 0);   -- character to push to FIFO - not from a F/F
           char_fifo_wr_en     : out std_logic;                       -- write enable to the FIFO
           char_fifo_full      : in  std_logic                        -- indicates full FIFO. data should NOT be presented to the FIFO when this signal is asserted (high)
           );
end resp_gen;



architecture Behavioral of resp_gen is
       
       type VALID_RESPONSE_STATES is (IDLE, SENDING);
       signal   state : VALID_RESPONSE_STATES := IDLE;    
       
       signal   value_valid    : std_logic := 'U';
       signal   bcd_out        : std_logic_vector(18 downto 0) := (others=>'U');
       signal   str_len        : integer range 0 to 15 := 0;

       signal   char_to_send   : integer range 0 to 12 := 0;

    begin
    
       -- convert the final value into BCD
       value_valid <= '1' when ((send_resp_valid = '1') and (send_resp_type = DATA)) else '0';
       to_bcd_i0: to_bcd PORT MAP(
          clk_rx      => clk_rx,
          rst_clk_rx  => rst_clk_rx,
          value_val   => value_valid,
          value       => send_resp_data,
          bcd_out     => bcd_out
       );          

       -- Echo the incoming character to the transmit FIFO, if there is room in the FIFO to the transmitter OR
        -- issue an expanded string to the transmit FIFO if provided
       stuffFIFO: process (clk_rx)
             variable last_valid : std_logic := 'U';
          begin
             if rising_edge(clk_rx) then                              -- test for synchronous events
                if (rst_clk_rx = '1') then                            -- if reset is asserted
                   state <= IDLE;                                     -- on reset, return to the IDLE state
                   char_to_send    <=  0;                             -- reset the pointer to the next character to send
                   send_resp_done  <= '0';                            -- ensure that the done flag is deasserted
                else                                                  -- reset not asserted
                   if (state = IDLE) then                             -- if in the idling state
                      send_resp_done <= '0';                          -- always keep the done flag deasserted unless...
                      if ((send_resp_valid = '1') and (last_valid = '0')) then -- a new response is requested
                         char_to_send<= 0;                            -- start with the "zeroth" character of the string    (preamble)                     
                         -- determine the kind of response requested
                         if (send_resp_type = ACK) then               -- only an acknoledgement is requested
                            str_len     <= 4;                         -- which is 4 characters long
                         elsif (send_resp_type = ERR) then            -- only an error message is requested
                            str_len     <= 5;                         -- which is 5 characters long                                
                         elsif (send_resp_type = DATA) then           -- a data response is requested
                            str_len     <= 12;                        -- which is 12 characters long                     
                         end if;                                      -- end of deciding type of response
                         state <= SENDING;                            -- advance to the sending state                        
                      end if;                                         -- no new character arrived, therefore no response needed
                   else                                               -- is a non-idle activity
                      if (char_fifo_full = '0') then                  -- room in the FIFO
                          send_resp_done <= '0';                          -- may not be done yet
                         if (char_to_send = str_len) then             -- have we sent all the characters yet?
                            state <= IDLE;                            -- return to the idle state
                            send_resp_done <= '1';                    -- signal the command parser that we're done sending the response (for 1 clock)
                         else                                         -- still more to send
                            char_to_send <= char_to_send + 1;         -- if there is not room in the fifo, incr the character count showing that there is one more to buffer
                         end if;                                      -- done consuming characters
                      end if;                                         -- end of FIFO full check  
                   end if;                                            -- end of non-idle state activities
                    last_valid := send_resp_valid;                     -- update signal to look for next rising edge
                end if;                                               -- end of non-reset activities
             end if;                                                  -- end of synchronous events
          end process stuffFIFO;

       char_fifo_wr_en <= '1' when (((state = IDLE) and (send_char_valid = '1')) or
                                    ((state = SENDING) and (char_fifo_full = '0'))) else '0';


       -- Generate the DATA to the FIFO
       -- If idle, the only thing we can be sending is the send_char
       -- If in the SENDING state, it depends on the send_resp_type, and where
       -- we are in the sequence
       genData: process (send_char, state, send_resp_type, bcd_out, send_resp_data, char_to_send)
             variable nibble     : std_logic_vector(3 downto 0) := (others=>'U');
          begin
             if (state = IDLE) then                                   -- if we're idling...
                char_fifo_din <= send_char;                           -- then mux the current character to send into the fifo
             else                                                     -- if we're not idling
                if (send_resp_type = ACK) then                        -- are we to send an acknowledgement?
                    case (char_to_send) is                             -- based on which iteration, pick...
                       when 0 => char_fifo_din <= slvDASH;             -- dash
                       when 1 => char_fifo_din <= slvUpperO;           --
                       when 2 => char_fifo_din <= slvUpperK;           -- 
                       when 3 => char_fifo_din <= slvCR;               -- carriage return
                       when 4 => char_fifo_din <= slvLF;               -- line feed
                       when others=> char_fifo_din <= slvQUESTIONMARK; -- for unidentified values of charToSend
                    end case;                                          -- end of possible cases for ACK
                 elsif (send_resp_type = ERR) then                     -- or are we to send an error?
                    case (char_to_send) is                             -- based on which iteration, pick...
                       when 0 => char_fifo_din <= slvDASH;             -- dash
                       when 1 => char_fifo_din <= slvUpperE;           --
                       when 2 => char_fifo_din <= slvUpperR;           -- 
                       when 3 => char_fifo_din <= slvUpperR;           -- 
                       when 4 => char_fifo_din <= slvCR;               -- carriage return
                       when 5 => char_fifo_din <= slvLF;               -- line feed
                       when others=> char_fifo_din <= slvQUESTIONMARK; -- for unidentified values of charToSend
                    end case;                                          -- end of possible cases for ACK
                else                                                  -- we should be sending back data
                    char_fifo_din <= (others=>'0');                    -- handle any unresolved case and avoid creating a latch
                   case (char_to_send) is                             -- based on the character count, send a ...
                      -- start the response with a dash
                      when  0 => char_fifo_din <= charToSlv('-');    -- dash
                      
                      -- the next 4 character are the ASCII representation of the raw hex data
                      when  1 => char_fifo_din <= charToSlv(slvToHexChar(send_resp_data(15 downto 12)));
                      when  2 => char_fifo_din <= charToSlv(slvToHexChar(send_resp_data(11 downto  8)));
                      when  3 => char_fifo_din <= charToSlv(slvToHexChar(send_resp_data( 7 downto  4)));
                      when  4 => char_fifo_din <= charToSlv(slvToHexChar(send_resp_data( 3 downto  0)));
                      
                      -- create a space in the display field
                      when  5 => char_fifo_din <= charToSlv(' ');   -- Space
                      
                      -- the next few counts take the bcd digit (value 0-9) and convert it to an 8 bit ASCII representation of '0'-'9'
                      when  6 => nibble := '0' & bcd_out(18 downto 16); char_fifo_din <= charToSlv(slvToDecChar(nibble));
                      when  7 => nibble := bcd_out(15 downto 12); char_fifo_din <= charToSlv(slvToDecChar(nibble));
                      when  8 => nibble := bcd_out(11 downto  8); char_fifo_din <= charToSlv(slvToDecChar(nibble));
                      when  9 => nibble := bcd_out( 7 downto  4); char_fifo_din <= charToSlv(slvToDecChar(nibble));
                      when 10 => nibble := bcd_out( 3 downto  0); char_fifo_din <= charToSlv(slvToDecChar(nibble));
                      
                      -- create an end of line
                      when 11 => char_fifo_din <= std_logic_vector(to_unsigned(13,8)); -- carriage return   
                      when 12 => char_fifo_din <= std_logic_vector(to_unsigned(10,8)); -- new line
                      
                      -- should never reach here
                      when others => char_fifo_din <= (others=>'0'); -- handle any unresolved case and avoid creating a latch;
                   end case;
                end if;                 -- end of RESP_DATA
             end if;                    -- end of check for send_char       
          end process genData;

    end Behavioral;

