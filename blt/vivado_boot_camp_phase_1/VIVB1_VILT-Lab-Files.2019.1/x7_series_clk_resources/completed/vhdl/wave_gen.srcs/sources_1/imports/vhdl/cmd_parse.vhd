--<insert: c:\HW\releasedULD\headers\cmd_parse.head>
-- -----------------------------------------------------------------------------
--
-- module:    cmd_parse
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This module parses the incoming character stream looking for commands.
--   Characters are ignored when the char_fifo indicates that it is full. This
--   module also manages the sample RAM and maintains the 3 variables, nsamp,
--   prescale and speed. Parameters: PW: Width of pulse required for clock
--   crossing to the clk_tx domain should be set to  3
--   NSAMP_MIN: Minimum allowable value for NSAMP - should be set to  1
--   NSAMP_MAX: Maximum allowable value for NSAMP - should be set to  1024
--   PRESCALE_MIN: Minumum allowable value for prescale - should be  32
--   to correspond to the DAC SPI cycle
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
use utilities_lib.string_utilities_synth_pkg.all;

library WORK;
use work.wave_gen_pkg.ALL;                                               -- load component definitions

entity cmd_parse is
   generic (PW                    : integer :=  3;                       -- Number of clks to assert pulses going to the clk_tx domain. Must be enough to guarantee that the resulting signal is asserted for at least 2 full clk_tx periods (for calid
            NSAMP_WIDTH           : integer := 10
           );
   port    (clk_rx                : in  std_logic;                       -- receiver clock
            rst_clk_rx            : in  std_logic;                       -- reset signal synchronized with receiver clock
            rx_data               : in  std_logic_vector(7 downto 0);    -- received character valid when rx_data_rdy is asserted
            rx_data_rdy           : in  std_logic;                       -- indicates that the character presented on rx_data is valid - is asserted for one clock cycle of clk_rx (debug)
            
            char_fifo_full        : in  std_logic;                       -- high when character FIFO is full - new input cannot be accepted when FIFO is full
            send_char_valid       : out std_logic;                       -- pulses for 1 clk_rx when a new character on send_char is ready to send
            send_char             : out std_logic_vector(7 downto 0);    -- character to send to user
            send_resp_valid       : out std_logic;                       -- asserted when a new response is required. Type of response indicated with send_resp_type
            send_resp_type        : out RESPONSE_TYPE;                   -- indicates type of response required. Vaild whn send_resp_type is asserted (00: ack; 01: error; 10: data; 11: not used)
            send_resp_data        : out std_logic_vector(15 downto 0);   -- data to send
            send_resp_done        : in  std_logic;                       -- pusled for 1 click when requested response is complete. Send_resp_val must be deasserted on next clock
            
            nsamp_clk_rx          : out std_logic_vector(NSAMP_WIDTH-1 downto 0); -- current value of nsamp  
            nsamp_new_clk_rx      : out std_logic;                       -- pulsed for one clock when nsamp is changed
            pre_clk_rx            : out std_logic_vector(15 downto 0);   -- current value of prescale
            pre_new_clk_rx        : out std_logic;                       -- pulsed "capture" for new prescale value
            spd_clk_rx            : out std_logic_vector(15 downto 0);   -- current value of speed parameter
            spd_new_clk_rx        : out std_logic;                       -- pulsed "capture" for new speed value
            samp_gen_go_clk_rx    : out std_logic;                       -- asserted continuously between receipt of *C and *H command or pulsed for a PW clocks when *G received
            
            cmd_samp_ram_din      : out std_logic_vector(15 downto 0);   -- write data to Data RAM
            cmd_samp_ram_addr     : out std_logic_vector( 9 downto 0);   -- address to Data RAM
            cmd_samp_ram_we       : out std_logic;                       -- write enable to Data RAM
            cmd_samp_ram_dout     : in  std_logic_vector(15 downto 0)    -- read data from Data RAM
           );
end entity cmd_parse;


architecture Behavioral of cmd_parse is

      -- states and command characters are defined in the wave_gen_pkg
      signal state            : LEGAL_COMMAND_STATES := IDLE;

      signal data_here        : std_logic := 'U';                    -- asserts when there is a new character from the uart_rx ready for processing 
      signal found_go         : std_logic := 'U';                    -- asserts when ___ happens - expands output pulse
      signal samp_gen_go_ctr  : integer range 0 to PW-1 := PW - 1;   -- counts from PW-1 to 0
      signal samp_gen_go_cont : std_logic := 'U';                    -- state of continuous looping
        
      constant MAX_ARG_CH     : integer := 8;                        -- Number of characters in largest set of args
        
      signal arg_val          : std_logic_vector((4*MAX_ARG_CH)-1 downto 0) := (others=>'0');
      signal arg_list         : std_logic_vector((4*(MAX_ARG_CH-1))-1 downto 0) := (others=>'0');  -- maintain previous values
       
    begin
    
       -- Echo the incoming character to the output, if there is room in the FIFO
       echoChar: process (clk_rx)
          begin
             if rising_edge(clk_rx) then               -- has the clock edge arrived?				 
                if (rst_clk_rx = '1') then             -- is the reset condition active?
                   send_char_valid <= '0';             -- make certain that we are not trying to send a character during reset
                   send_char       <= (others=>'0');   -- drive the value on the output of hte module to all zeros during reset
                else                                   -- reset not active, do "normal" activities
                   send_char_valid <= '0';             -- keep the signal that indicates a new character should be written to the FIFO deasserted unless...
                   if (data_here = '1') then           -- has a new serial character arrived
                      send_char_valid <= '1';          -- assert the character valid signal to the FIFO
                      send_char       <= rx_data;      -- pass the new character on to the FIFO
                   end if;                             -- end of arrival of new character activities
                end if;                                -- end of reset/normal test				 
             end if;                                   -- end of synchronous events
          end process echoChar;
          
       
       -- Accept a new character when one is available, and we can push it into
       -- the response FIFO. A new character is available on the FIRST clock that
       -- rx_data_rdy is asserted - it remains asserted for 1/16th of a bit period.     
       
       -- if the outgoing FIFO is full, then the arriving data is ignored.
       
       --
       -- create a one clock wide pulse indicating that new data has arrived
       data_arrived: process (clk_rx)
             variable last_rx_data_rdy : std_logic := 'U';
          begin
             if rising_edge(clk_rx) then                              -- operates only on rising edge			 
                if (rst_clk_rx = '1') then                            -- reset is asserted
                   data_here <= '0';                                  -- don't indicate new data on reset
                else                                                  -- reset is not asserted
                   data_here <= '0';                                  -- normally low unless...
                   if ((rx_data_rdy = '1') and (last_rx_data_rdy = '0')) then -- has there been a change in status?
                      if (char_fifo_full = '0') then                  -- there is some room in the outgoing FIFO
                         data_here <= '1';                            -- data has arrived
                      end if;                                         -- check of the outgoing FIFO
                   end if;                                            -- end of test for change
                   last_rx_data_rdy := rx_data_rdy;                   -- update the status
                end if;                                               -- end of reset/non-reset events			 
             end if;                                                  -- end of synchronous events
          end process data_arrived;
        
        
       -- Assuming it is a value, the new digit is the least significant digit of
       -- those that have already come in - thus we need to concatenate the new 4
       -- bits to the right of the existing data
      arg_val <= arg_list & slvPrintableCharToSlv(rx_data); 

        
       --
       -- process the newly arrived command (if there is one)
       procCmd: process (clk_rx)
                      
             --
             -- the next four procedures are a quick "shorthand" for frequently required actions
             -- note the two versions of send_data which are overloaded based on the type of argument
             procedure send_data(x : std_logic_vector) is
                begin
                   send_resp_valid <= '1';                            -- indicate that a response is to be sent
                   send_resp_type  <= DATA;                           -- indicate that data is to be returned
                   send_resp_data  <= x;                              -- load the data
                   state          <= SEND_RESP;                       -- advance to sending the response state              
                end procedure send_data;         

             procedure send_data(x : integer) is
                   variable slv_x : std_logic_vector(15 downto 0) := (others=>'U');
                begin
                   send_resp_valid <= '1';                            -- indicate that a response is to be sent
                   send_resp_type  <= DATA;                           -- indicate that data is to be returned
                   slv_x           := std_logic_vector(to_unsigned(x,16));  -- convert from integer to std_logic_vector
                   send_resp_data  <= slv_x;                           -- load the data
                   state           <= SEND_RESP;                       -- advance to sending the response state              
                end procedure send_data;                  
             
             procedure send_ok is
                begin
                   send_resp_valid <= '1';                            -- indicate that a response is to be sent
                   send_resp_type  <= ACK;                            -- indicate that a positive acknowlegement should be returned
                   state           <= SEND_RESP;                      -- advance to sending the response state              
                end procedure send_ok;
                
             procedure send_error is
                begin
                   send_resp_valid <= '1';                            -- indicate that a response is to be sent
                   send_resp_type  <= ERR;                            -- indicate that a negative acknowlegement should be returned
                   state           <= SEND_RESP;                      -- advance to sending the response state
                end procedure send_error;  
             
             
             constant NSAMP_MIN         : integer := 1;               -- Minimum allowable value for nsamp
             constant NSAMP_MAX         : integer := 2**NSAMP_WIDTH;  -- Maximum allowable value for nsamp
             constant PRESCALE_MIN      : integer := 32;              -- Minimum allowable value for prescale 
             constant SPEED_MIN         : integer := 1;               -- Minimum allowable value for speed
             constant RAM_MAX           : integer := 1023; --NSAMP_MAX - 1; -- Last RAM location
             constant SAMP_WID          : integer := 16;              -- 16 bits per sample
             constant PRESCALE_WID      : integer := 16;              -- Width of prescale
             constant SPEED_WID         : integer := 16;              -- Width of speed           
             
             variable current_command   : std_logic_vector(7 downto 0) := (others=>'0');
             variable rx_data_value     : std_logic_vector(3 downto 0) := (others=>'0');
             variable arg_cnt           : integer range 0 to MAX_ARG_CH := 0;
             variable nsamples          : integer range 0 to NSAMP_MAX-1 := NSAMP_MIN;
             variable speed             : integer range 0 to 2**SPEED_WID-1 := SPEED_MIN;
             variable preScale          : integer range 0 to 2**PRESCALE_WID-1 := PRESCALE_MIN;
             
             variable int_address       : integer range 0 to 65535 := 0;
             variable int_value         : integer range 0 to 65535 := 0;
             
          begin
             if rising_edge(clk_rx) then                              -- for synchronous events			 
                if (rst_clk_rx = '1') then                            -- if reset is asserted
                   state                <= IDLE;
                   current_command      := (others=>'0');
                   arg_list             <= (others=>'0');
                   arg_cnt              :=  0;
                   cmd_samp_ram_we      <= '0';
                   cmd_samp_ram_addr    <= (others=>'0');
                   cmd_samp_ram_din     <= (others=>'0');
                   nsamples             := NSAMP_MIN;
                   nsamp_new_clk_rx     <= '0';
                   speed                := SPEED_MIN;
                   spd_new_clk_rx       <= '0';
                   prescale             := PRESCALE_MIN;
                   pre_new_clk_rx       <= '0';  
                   nsamp_clk_rx         <= (0=>'1',others=>'0');
                   spd_clk_rx           <= (0=>'1',others=>'0');
                   pre_clk_rx           <= (0=>'1',others=>'0');
                   send_resp_valid      <= '0';
                   send_resp_data       <= (others=>'0');
                   send_resp_type       <= UNKNOWN;                      
                   
                else                                                  -- non-reset events
                   
                   -- Defaults - overridden in the appropriate state
                   cmd_samp_ram_we      <= '0';
                   nsamp_new_clk_rx     <= '0';
                   spd_new_clk_rx       <= '0';
                   pre_new_clk_rx       <= '0';
                               
                   case (state) is

                      when IDLE =>                                                -- Wait for the '*'                    
                         if ((data_here = '1') and (rx_data = slvASTERISK)) then  -- if a new character has arrived and if it indicates the start of a command
                            state <= WAIT_FOR_CMD;                                -- advance to waiting for the command
                         end if;                                                  -- if asterisk found

                      when WAIT_FOR_CMD =>                                        -- Validate the incoming command
                         if (data_here = '1') then                                -- if the new character (which should be a command) has arrived
                            current_command := rx_data(7 downto 0);               -- capture and latch the character as the current command
                            case (current_command) is                             -- decipher the command                      
                            
                               when CMD_WRITE =>                                  -- write data to the memory
                                  state   <= GET_ARG;                             -- advance to collect the arguments
                                  arg_cnt := 8;                                   -- Get 8 characters of arguments, First 4 bytes are address - 2nd 4 bytes are data                       

                               when CMD_READ | CMD_SET_NSAMPLES | CMD_SET_PRESCALAR | CMD_SET_SPEED =>   -- read, set nsamp, set prescale, set speed
                                  state   <= GET_ARG;                             -- advance to collect the arguments
                                  arg_cnt := 4;                                   -- Get the 4 bytes of data
                                  
                               when CMD_GET_NSAMPLES =>                           -- print the current of value of NSamples
                                  send_data(nsamples);                            -- send the number of samples
                                  state <= SEND_RESP;                             -- advance to sending the response state
                                  
                               when CMD_GET_PRESCALAR =>                          -- print prescale
                                  send_data(prescale);                            -- send the prescalar value
                                  state <= SEND_RESP;                             -- advance to sending the response state                             

                               when CMD_GET_SPEED =>                              -- print the current value of speed
                                  send_data(speed);                               -- return the current value of speed 
                                  state <= SEND_RESP;                             -- advance to sending the response state     
                                  
                               when CMD_GO | CMD_CONTINUOUS |  CMD_HALT =>        -- go, continuous. halt
                                  send_ok;                                        -- send a positive acknowledgement
                                  state <= SEND_RESP;                             -- advance to sending the response state
                            
                               when others =>                                     -- unknown command
                                  send_error;                                     -- send an error                    
                         
                            end case;                                             -- end of decoding of command character
                         end if;                                                  -- end of checking for new character
                         
                      when GET_ARG => 
                         -- Get the correct number of characters of argument. Check that
                         -- all characters are legel HEX values.
                         -- Once the last character is successfully received, take action
                         -- based on what the current command is
                         -- Get the correct number of characters of argument. Check that
                         -- all characters are legel HEX values.
                         -- Once the last character is successfully received, take action
                         -- based on what the current command is
                         if (data_here = '1') then                                -- if a new character has arrived
                         
                            -- is it valid, if so add to the argument list
                            if (isHexChar(rx_data)) then                          -- character IS a digit
                               rx_data_value := hexCharToSlv(slvToChar(rx_data)); -- convert the received character to its hex equivalent
                               arg_list <= arg_val(27 downto 0); --arg_list(4*(MAX_ARG_CH-2)-1 downto 0) & rx_data_value;   -- append the current digit to the saved ones (shift in)                                  
                               arg_cnt  := arg_cnt - 1;                           -- Wait for the next character
                         
                               if (arg_cnt = 0) then                              -- This is the last char of arg
                               
                                  case (current_command) is                       -- figure out what the current command's arguments are
                                     when CMD_WRITE =>                            -- are we collecting arguments for the write to RAM command?
                                        -- Initiate a write to the RAM if in range
                                        --
                                        -- argument arrives at this point as an array of 8 
                                        --
                                        -- The first argument is the address - it needs to be less than NSAMP_MAX (largest possible value is 1024)
                                        -- for the write to be valid. Thus we need to check arg_val[31:16] - if its valid, then the bottom ten bits of this 
                                        -- are the address, and arg_val[15:0] is the data to write
                                        int_address := to_integer(unsigned(arg_val(27 downto 16)));   -- convert the 16 bits of address in the arg_list field into an integer for comparison
                                        if (int_address <= RAM_MAX) then          -- Valid address so write the RAM and send OK
                                           cmd_samp_ram_we   <= '1';              -- Write it to the RAM (enable the RAM)
                                           cmd_samp_ram_addr <= arg_val(25 downto 16); -- present the address from the first 4 nibbles (masked to 10 bits)
                                           cmd_samp_ram_din  <= arg_val(15 downto  0); -- present the data to the RAM
                                           send_ok;                               -- send a positive acknowledgement
                                           state <= SEND_RESP;                    -- advance to sending the response state
                                        else                                      -- not valid address
                                           send_error;                            -- Send ERR
                                           state <= SEND_RESP;                    -- advance to sending the response state
                                        end if;                                   -- end of error for bad RAM address
    
                                     when CMD_READ =>
                                        -- Initiate a read from the RAM if in range
                                        -- The first (and only) arg is the read address (in 15:0)
                                        int_address := to_integer(unsigned(arg_val(15 downto 0))); -- convert the 16 bits of address in the arg_list field into an integer for comparison                                        
                                        if (int_address <= RAM_MAX) then          -- Valid address
                                           cmd_samp_ram_addr <= arg_val(NSAMP_WIDTH-1 downto 0);    -- Initiate the read 
                                           state             <= READ_RAM;
                                        else                                      -- not valid address
                                           send_error;                            -- Send ERR
                                           state <= SEND_RESP;
                                        end if;
                                     
                                     when CMD_SET_NSAMPLES =>                     -- Update nsamp with the only arg, if in range
                                        int_value := to_integer(unsigned(arg_val(15 downto 0)));   -- convert the 16 bits of address in the arg_list field into an integer for comparison
                                        if ((int_value  >= NSAMP_MIN) and         -- if the argument is in the valid range,
                                            (int_value  <= NSAMP_MAX) ) then      -- then update nsamp
                                           nsamples     := to_integer(unsigned(arg_val(NSAMP_WIDTH-1 downto 0)));    -- update the number of samples in RAM value
                                           nsamp_clk_rx <= arg_val(NSAMP_WIDTH-1 downto 0);  -- make available outside the module
                                           nsamp_new_clk_rx  <= '1';              -- indicate that the nsamp value has just been assigned (and might be new)
                                           send_ok;                               -- Send OK
                                           state <= SEND_RESP; 
                                        else                                      -- not in range
                                           send_error;                            -- Send ERR
                                           state <= SEND_RESP;                    -- advance to send response state
                                        end if;                                   -- end of error for bad range
    
                                     when CMD_SET_PRESCALAR =>                    -- Update prescale with the only arg, if in range
                                        int_value := to_integer(unsigned(arg_val(15 downto 0)));   -- convert the 16 bits of address in the arg_list field into an integer for comparison                                     
                                        if (int_value >= PRESCALE_MIN) then       -- prescalar In range
                                           prescale := to_integer(unsigned(arg_val(15 downto 0)));
                                           pre_clk_rx     <= arg_val(15 downto 0);   -- update prescalar value
                                           pre_new_clk_rx <= '1';                 -- indicate that prescalar has just been assigned (and might be new)
                                           send_ok;                               -- send OK
                                           state          <= SEND_RESP;           -- advance to send response state
                                        else                                      -- prescalar not in valid range
                                           send_error;                            -- Send ERR
                                           state          <= SEND_RESP;           -- advance to send response state
                                        end if;                                   -- end of error for precalar out of range
    
                                     when CMD_SET_SPEED =>                        -- Update speed with the only arg, if in range
                                        int_value := to_integer(unsigned(arg_val(15 downto 0)));   -- convert the 16 bits of address in the arg_list field into an integer for comparison                                     
                                        if (int_value >= SPEED_MIN) then          -- if the arguemnt is in range, then update speed
                                           speed          := to_integer(unsigned(arg_val(15 downto 0)));
                                           spd_clk_rx     <= arg_val(15 downto 0); -- update the value of speed
                                           spd_new_clk_rx <= '1';                -- indicate that speed has just been assigned a new value and might have changed
                                           send_ok;                              -- Send OK
                                           state          <= SEND_RESP;          -- advance to send response state
                                        else                                     -- arguement not in valid range - Send ERR
                                           send_error;                           -- send the error
                                           state          <= SEND_RESP;          -- advance to the send response state
                                        end if;                                  -- end of range check for speed argument
                                        
                                     when others=>
                                        null;                                        
                                  
                                  end case;                                      -- decipher current command
    
                               end if;                                           -- end of counting the number of arguments
                            else                                                 -- improperly formed value
                               send_error;                                       -- respond by sending an error message                            
                            end if;                                              -- end of valid hex digit check

                         end if;                                                 -- end of test for arrival of new character
                      
                      when READ_RAM =>
                         -- The read request to the RAM is being issued this cycle
                         -- We need to wait for the data to be ready...
                         -- There is nothing to do other than wait one clock
                         state <= READ_RAM2;

                      when READ_RAM2 =>
                         -- The read request from the RAM is done, and the data is on the dout port of the RAM - initiate the response
                         send_data(cmd_samp_ram_dout);                                                       -- send the data
                         state <= SEND_RESP;                                                              -- advance to the send response state

                      when SEND_RESP =>
                         -- The response request has already been set - all we need to
                         -- do is keep the request asserted until the response is complete.
                         -- Once it is complete, we return to IDLE
                         if (send_resp_done = '1') then
                            send_resp_valid <= '0';
                            state           <= IDLE;
                         end if;

                      when others=>
                         state <= IDLE;
                   
                   end case;                  
                   
                end if;                                                  -- end of non-reset events					 
             end if;                                                     -- end of synchronous events
       end process procCmd;


       -- Now handle the control to the Sample Generator
       -- It has two functions
       --    - on receipt of a *G it asserts the output for PW clocks.
       --    - on receipt of a *C it asserts the output continuously.
       --    - on receipt of a *H it deasserts the output

       -- To assert for PW clocks, we use the one where the *G is detected
       -- and the PW-1 following clocks. To do that, we count down from PW-1 to 0, and
       -- keep the output asserted whenever the counter is not 0
       found_go <= '1' when ((data_here = '1') and (rx_data = CMD_GO) and (state = WAIT_FOR_CMD)) else '0';

       pulseWidener: process (clk_rx)
          begin
             if rising_edge(clk_rx) then                  -- on rising edge of clock			 
                if (rst_clk_rx = '1') then                -- if reset is asserted
                   samp_gen_go_ctr <= 0;                  -- disable the counter
                else                                      -- non reset events
                   if (samp_gen_go_ctr /= 0) then         -- If not zero then we're still stretching the pulse     
                      samp_gen_go_ctr <= samp_gen_go_ctr - 1; -- decrement the count
                   elsif (found_go = '1') then            -- if count was zero, but a request to start was made, then
                      samp_gen_go_ctr <= PW - 1;          -- reset the counter to generate the proper pulse width
                   end if;                                -- end of pulse width controls
                end if;                                   -- end of non reset events				 
             end if;                                      -- end of synchronous events
          end process pulseWidener;
       

       contCtrl: process (clk_rx)
          begin
             if rising_edge(clk_rx) then                  -- on rising edge of clock			 
                if (rst_clk_rx = '1') then                -- if reset is asserted
                   samp_gen_go_cont <= '0';               -- then tell the sample generator to not run in continuous mode
                else                                      -- non reset events
                   if ((state = WAIT_FOR_CMD) and (data_here = '1')) then -- check the new command for continuous operation or abort
                      if (rx_data = CMD_CONTINUOUS) then  -- request for continuous output
                         samp_gen_go_cont <= '1';         -- drive the request line to the sample generator high
                      elsif (rx_data = CMD_HALT) then     -- request to stop the continous output
                         samp_gen_go_cont <= '0';         -- drive the request line to the sample generator low
                      end if;                             --    end of check for commands that directly affect the sample generator on/off operation
                   end if;                                -- Have a new character in CMD_WAIT                
                end if;                                   -- end of non reset events					 
             end if;                                      -- end of synchronous events        
          end process contCtrl;

       --
       -- generate the control signal that governs the sample generator
       smplCtrl: process (clk_rx)
          begin
             if rising_edge(clk_rx) then                  -- on rising edge of clock				 
                if (rst_clk_rx = '1') then                -- if reset is asserted
                   samp_gen_go_clk_rx <= '0';             -- deassert the "go" signal (turn off the sample generator)             
                else                                      -- non reset events
                   samp_gen_go_clk_rx <= '0';             -- don't do a transfer unless...
                   if ((found_go = '1') or                -- if it was determined that data transfer was requested or
                       (samp_gen_go_ctr /= 0) or          -- the pulse width has not yet been fulfilled
                       (samp_gen_go_cont = '1')) then     -- or a continuous transfer was requested
                      samp_gen_go_clk_rx <= '1';          -- then assert the transfer "go" signal         
                   end if;                                -- end of determination that a transfer should occur						 
                end if;                                   -- end of non reset events				 
             end if;                                      -- end of synchronous events
          end process smplCtrl;
             

    end Behavioral;

