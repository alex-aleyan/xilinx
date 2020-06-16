-----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:59:17 05/19/2011 
-- Design Name:   Wave_Gen Behavioral Model.
-- Module Name:    tb_wavegen_model - Behavioral 
-- Project Name:     wavegen_sim
-- Target Devices: xc7k325t-2ffg900  
-- Tool versions:  ISE 13.1
-- Description:    Refer to the Wavegen 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 

-- *W  aaaavvvv      -OK or -ERR If aaaa is between 0 and 1023, the value vvvv is written to the RAM at location aaaa and 
--                                   "-OK" is output. Otherwise the data is discarded and "-ERR" is output 
-- *R   aaaa    -hhhh ddddd      If aaaa is between 0 and 1023, the data at RAM location aaaa is output both in hexadecimal and in decimal.
--                    or -ERR        Otherwise "-ERR" is output
-- *N   vvvv    -OK or -ERR      If aaaa is between 1 and 1024, the number of samples (nsamp) is set to the value vvvv and
--                                  "-OK" is output. Otherwise "-ERR" is output
-- *P   vvvv    -OK or -ERR      If the vvvv is greater than or equal to the minimum allowable value for prescale (32), the prescaler (prescale)  
--                                  is set to vvvv and "-OK" is output. Otherwise the value is discarded and -ERR" is output
-- *S   vvvv    -OK or -ERR      If the vvvv is greater than or equal to the minimum allowable value for speed (0), the speed (speed) is set to 
--                                  vvvv and "-OK" is output. Otherwise the value is discarded and "-ERR" is output
-- *n           -hhhh ddddd      The current value of nsamp, prescale, or speed is output in both hexadecimal and decimal
-- *p
-- *s     
-- *G           -OK               Go: Trigger a single sweep through the samples
-- *C           -OK               Continuous: Turn on continuous looping through the samples 
-- *H           -OK               Halt: Turn off continuous looping. The output generation will stop at the end of the current pass through the samples
-- The Wavegen Model also implements a Sample RAM and three registers 
 ----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

LIBRARY utilities_lib;
use utilities_lib.time_utilities_pkg.all;
use utilities_lib.string_utilities_sim_pkg.all;
use utilities_lib.string_utilities_synth_pkg.all;
use WORK.tb_wave_gen_helper_pkg.all;

library STD;
use STD.textio.all;
use IEEE.std_logic_textio.all; 

entity tb_wavegen_model is
GENERIC (SAMP_DEPTH: integer := 1024;
         VAR_DEPTH: integer := 3;
         WIDTH : integer := 16
      );
   port(reset                   : in  std_logic;
        command_string          : in  string (1 to 32);
        fifo_full               : in boolean;
        response_valid          : out boolean;
        response                : out character
       ); 
end tb_wavegen_model;

architecture Behavioral of tb_wavegen_model is 

      type legal_state is (WAIT_FOR_RESET_TO_DEASSERT, WAIT_FOR_CMD, RSP_TO_CHARS, PROCESS_CMDS, REQ_NEXT_CMD, UNDEFINED);
      signal debug_state : legal_state := UNDEFINED;
    
      constant VAR_NSAMP        : integer:= 0;
      constant VAR_PRESCALE     : integer:= 1;
      constant VAR_SPEED        : integer:= 2;
    
      constant ACK_STR          : string := "-OK";
      constant ERR_STR          : string := "-ERR";
      constant carriage_return  : character := slvToChar(slvCR);
      constant linefeed         : character := slvToChar(slvLF);
      constant newline          : string(1 to 2) := carriage_return & linefeed;

      signal resp_sent_success  : boolean:= FALSE ;
      signal new_command        : boolean:= FALSE ;     
     
      ----------------------------------------------------------
      -- set up the two memories and their associated functions
      ----------------------------------------------------------
      type SAMPLE_RAM_CONFIGURATION   is array (0 to SAMP_DEPTH-1) of std_logic_vector(15 downto 0);
      type VARIABLE_RAM_CONFIGURATION is array (0 to   VAR_DEPTH-1) of std_logic_vector(15 downto 0);
      shared variable RAM_sample       : SAMPLE_RAM_CONFIGURATION   := (others=>(others=>'0'));
      shared variable RAM_variable     : VARIABLE_RAM_CONFIGURATION := (others=>(others=>'0'));
      shared variable max_RAM_variable : VARIABLE_RAM_CONFIGURATION := (others=>(others=>'0'));
      shared variable min_RAM_variable : VARIABLE_RAM_CONFIGURATION := (others=>(others=>'0'));
        
      procedure RAM_sample_write (address: integer; data : std_logic_vector) is
         begin
            RAM_sample(address) := data;
         end procedure RAM_sample_write;
             
      impure function RAM_sample_read (address: integer) return std_logic_vector is
         begin
            return RAM_sample(address);
         end function RAM_sample_read;
       
      impure function RAM_variable_write (address: integer; data : std_logic_vector) return boolean is
            variable return_status : boolean :=false;
         begin
            if((data >= min_RAM_variable(address)) and (data <= max_RAM_variable(address))) then
               report time2string(now) & " (waveGen model) Writing " & slvToHexString(data) & " to RAM location " & integer'image(address);
               RAM_variable(address) := data;
               return_status := true;
            else
               report time2string(now) & " (waveGen model) *NOT* writing " & slvToHexString(data) & " to RAM location " & integer'image(address);
               return_status := false;
            end if;
            return return_status;
         end function RAM_variable_write;
             
      impure function RAM_variable_read (address: integer) return std_logic_vector is
         begin
            return RAM_variable(address);
         end function RAM_variable_read;
             
      procedure initialize_samp_ram is
         begin
            for i in 0 to (SAMP_DEPTH-1) loop
               RAM_sample(i)     := (others =>'0');
            end loop;
         end procedure initialize_samp_ram;

      procedure initialize_var_ram is
         begin
            for i in 0 to (VAR_DEPTH-1) loop
               RAM_variable(i)     := (others =>'0');
               min_RAM_variable(i) := (others =>'0'); 
               max_RAM_variable(i) := (others =>'1'); 
            end loop;
         end procedure initialize_var_ram;

      procedure set_min_max(address : integer; minimum_value : integer;  maximum_value  : integer) is
         begin
            min_RAM_variable(address) := std_logic_vector(to_unsigned(minimum_value,WIDTH));
            max_RAM_variable(address) := std_logic_vector(to_unsigned(maximum_value,WIDTH));
         end procedure set_min_max;
              
      procedure show_command(cmd, cmd_fword, cmd_lword : string) is
         begin
            which_format: case cmd(2) is
               when 'W' => report "(waveGen model) Processing command: " & cmd & "(" & cmd_fword & "," & cmd_lword & ")";
               when 'R' => report "(waveGen model) Processing command: " & cmd & "(" & cmd_fword & ")";
               when 'N' => report "(waveGen model) Processing command: " & cmd & "(" & cmd_fword & ")";
               when 'S' => report "(waveGen model) Processing command: " & cmd & "(" & cmd_fword & ")";
               when 'P' => report "(waveGen model) Processing command: " & cmd & "(" & cmd_fword & ")";
               when 'n' => report "(waveGen model) Processing command: " & cmd & "(" & cmd_fword & ")";
               when 's' | 'p' => report "(waveGen model) Processing command: " & cmd & "(" & cmd_fword & ")";
               when others =>
                  report "(waveGen model) unknown command: " & cmd;
            end case which_format;        
         end procedure show_command;
       
             
      -- these functions must be defined below the signals as several are "impure" and require the signal definitions
      
      impure function process_command(signal cmd_string  : string) return string is
            variable dec_val       : string(1 to 32) ;
            variable ret           : boolean ;
            variable value         : std_logic_vector(15 downto 0) ;
            variable address       : integer;
            variable cmd           : string(1 to 2);
            variable cmd_fword     : string(1 to 4);
            variable cmd_lword     : string(1 to 4);
            variable resp_string   : string(1 to 32):= (others => NUL);
            variable l             : line;
         begin
            deallocate(l);
            cmd       := cmd_string(1 to 2);     --  The first two characters represent the start symbol and command character 
            cmd_fword := cmd_string(3 to 6);     --  The second four hex strings represent the address.
            cmd_lword := cmd_string(7 to 10);    --  The next four hex strings represent the data.               

            show_command(cmd, cmd_fword, cmd_lword);

            cmd_check: case cmd is 
               when "*W" =>                   -- When command is a write
                  cmd_in_range: if (hexStringToInt(cmd_fword) < SAMP_DEPTH) then
                     address  := hexStringToInt(cmd_fword);
                     value    := hexStringToSlv(cmd_lword);
                     RAM_sample_write(address,value);
                     report "(waveGen model) sample RAM.write: " & integer'image(address) & " <== " & integer'image(to_integer(unsigned(value)));
                     --Sending back the command typed with the response
                     resp_string:= cmd_string(1 to 10) & ACK_STR;
                  else                                 
                     report time2string(now) & " (waveGen model)  Writing to illegal sample address " & cmd_fword;                    
                     resp_string := cmd_string(1 to 10) & ERR_STR;
                  end if cmd_in_range;
             
               when "*R" =>                  -- When command is a read
                  if (hexStringToInt(cmd_fword) < SAMP_DEPTH) then
                    address := hexStringToInt(cmd_fword);
                    value   := RAM_sample_read(address);
                    dec_val := slvToIntString(value,5);
                    report "(waveGen model) sample RAM.read: " & integer'image(address) & " ==> " & resp_string;
                    --Sending back the command typed with the response
                    resp_string := cmd_string(1 to 6) & "-" & convSlvToHex(value) & " " & dec_val;                    
                  else 
                     report time2string(now) & " (waveGen model) Reading from illegal sample address " & cmd_fword;
                     resp_string := cmd_string(1 to 6) & ERR_STR;
                  end if;      
                  
               when "*N" =>        -- When command is to set Number of samples
                  address  := VAR_NSAMP;
                  value    := hexStringToSlv(cmd_fword);
                  ret :=  RAM_variable_write(address,value);
                  report "(waveGen model) Variable RAM activity (N): write: " & integer'image(address) & " <== " & integer'image(to_integer(unsigned(value)));
                  if (ret) then  -- success
                     --Sending back the command typed with the response
                     resp_string := "*N" & ACK_STR;
                  else
                     resp_string := ERR_STR; 
                  end if;          
                  
               when "*P" =>        -- When command is to set Prescale Value
                  address := VAR_PRESCALE;
                  value   := hexStringToSlv(cmd_fword);
                  ret    := RAM_variable_write(address,value);
                  report "(waveGen model) Variable RAM activity (P): write: " & integer'image(address) & " <== " & integer'image(to_integer(unsigned(value)));
                  if (ret) then -- success
                     --Sending back the command typed with the response
                     resp_string := "*P" & ACK_STR ;
                  else
                     resp_string := ERR_STR;  
                  end if;
                  
               when "*S" =>                -- When command is to set Speed
                  address := VAR_SPEED;
                  value   := hexStringToSlv(cmd_fword);
                  ret    := RAM_variable_write(address,value);
                  report "(waveGen model) Variable RAM activity (S): write: " & integer'image(address) & " <== " & integer'image(to_integer(unsigned(value)));
                  if (ret) then -- success
                    --Sending back the command typed with the response
                    resp_string := "*S" & ACK_STR;
                  else
                     resp_string := ERR_STR;  
                  end if;
                                         
            when "*n" => 
               address := VAR_NSAMP;
               value   := RAM_variable_read(address);
               dec_val := to_dec_str(value);
               report "(waveGen model) Variable RAM activity (n): read: " & integer'image(address) & " <== " & dec_val;
               resp_string := convSlvToHex(value) & dec_val;   
           
            when "*p" => 
               address := VAR_PRESCALE;
               value   := RAM_variable_read(address);
               dec_val := to_dec_str(value);
               report "(waveGen model) Variable RAM activity (p): read: " & integer'image(address) & " <== " & dec_val;
               resp_string := convSlvToHex(value) & dec_val;
                          
            when "*s" =>  
               address := VAR_SPEED;
               value   := RAM_variable_read(address);
               dec_val := to_dec_str(value);
               report "(waveGen model) Variable RAM activity (s): read: " & integer'image(address) & " <== " & dec_val;
               resp_string := convSlvToHex(value) & dec_val;   
                      
            when others => resp_string :=ERR_STR;
              
          end case cmd_check; 
          write (l, resp_string);
          return resp_string;
       end function process_command;
       
   begin
   
      -----------------------------------
      -- State Machine for Wavegen Model 
      -----------------------------------
      wavegen_model_sm: process 
            variable cmd_string      : string(1 to 32);
            variable response_string : string(1 to 32);
            variable char_rcvd       : character := '?';
            variable ret             : boolean:= false ;
            variable state           : legal_state := WAIT_FOR_RESET_TO_DEASSERT;         
         begin
            SM: case state is      
               when WAIT_FOR_RESET_TO_DEASSERT =>
                  -- Initailze the RAMS                 
                  initialize_var_ram;
                  initialize_samp_ram;
                  -- Set the min and max in the variable RAM
                  set_min_max(0,1,1024); -- set NSAMP min and max
                  set_min_max(1,32,65535);-- set PRESCALE min and max
                  set_min_max(2,1,65535); -- set SPEED min and max
                  -- Set the reset values in the variable RAM
                  ret:= RAM_variable_write(VAR_NSAMP,X"0001"); -- set NSAMP reset value
                  ret:= RAM_variable_write(VAR_PRESCALE,X"0020"); -- set PRESCALE reset value
                  ret:= RAM_variable_write(VAR_SPEED,X"0001"); -- set SPEED reset value
                  response <= '?';
                  wait until reset = '0';
                  state := WAIT_FOR_CMD;
                  
               when WAIT_FOR_CMD =>        
                  wait until command_string'event;
                  
                  -- issue fresh command                    
                  state := PROCESS_CMDS;
                      
               when PROCESS_CMDS => 
                  response_string := process_command(command_string);                                
                  state :=  RSP_TO_CHARS;

               when RSP_TO_CHARS => 
                  report "(waveGen model) responding: " & response_string;
                  each_char: for i in 1 to strlen(strAutoResize(response_string)) loop                             
                     if (not fifo_full) then               
                        char_rcvd := response_string(i);
                        response <= char_rcvd;
                        wait for 1 ns;
                        response_valid <= true;                         
                        wait for 500 ps;
                        response_valid <= false;                 
                     else 
                        report "(waveGen model) Waiting for space in the fifo";
                        wait until (not fifo_full); -- suspend the process until fifo is cleared.
                     end if;
                  end loop each_char;
                    
                  -- After the response has been sent, newline characters should be pushed in to the fifo
                  new_line: for i in 1 to 2 loop                             
                     if (not fifo_full) then               
                        --char_rcvd := ;
                        response <= newline(i);
                        wait for 1 ns;
                        response_valid <= true;                         
                        wait for 500 ps;
                        response_valid <= false;                 
                     else 
                        report "(waveGen model) Waiting for space in the fifo";
                        wait until (not fifo_full); -- suspend the process until fifo is cleared.
                     end if;
                  end loop new_line;
                  
                  -- Intialize signals         
                  state     := REQ_NEXT_CMD;
                    
               when REQ_NEXT_CMD =>                  
                  wait for CLOCK_PERIOD;
                  -- see if there is more data
                  state := WAIT_FOR_CMD;
                 
               when others =>
                  report "(waveGen model) Illegal state!";
                  state := WAIT_FOR_CMD;        
            end case SM;          
         end process wavegen_model_sm; 
          
end architecture Behavioral;                                    