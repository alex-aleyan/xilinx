----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:59:17 05/19/2011 
-- Design Name: 
-- Module Name:    tb_fifo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library utilities_lib;
use utilities_lib.string_utilities_synth_pkg.all;


entity tb_fifo is
   generic (VERBOSE_MODE : boolean := true;        -- prints out diagnostic messages
            DEPTH        : integer := 256
           );
   port(character_in        : in  character;       -- data to push into the FIFO
        character_in_valid  : in  boolean;         -- equivalent to write strobe - data is captured on the rising edge
        full                : out boolean;         -- indicates that the FIFO is full
        character_out       : out character;       -- data popped from the FIFO
        character_req       : in  boolean;         -- equivalent to read strobe - new data is "popped" on the transition from false to true
        empty               : out boolean          -- indicates that the FIFO has no more data available
       );
end entity tb_fifo;

architecture Behavioral of tb_fifo is

      type data_storage is array(0 to DEPTH-1) of character;
      shared variable data      : data_storage := (others=>'?');   -- contains the actual contents of the FIFO
      shared variable head      : integer range 0 to DEPTH := 0;           -- points to the head of the FIFO (managed as a circular buffer)
      shared variable tail      : integer range 0 to DEPTH := 0;           -- points to the tail of the FIFO (managed as a circular buffer)

     function next_ptr(ptr : integer) return integer is   
         begin
            return (ptr + 1) mod DEPTH;
         end function next_ptr;
         
      impure function is_full return boolean is          -- designated "impure" since it modifies a "global" variable
         begin
            return (next_ptr(head) = tail);              -- if the next pointer location is the tail, then there is no more space in the FIFO
         end function is_full;
         
      impure function is_empty return boolean is         -- designated "impure" since it modifies a "global" variable
         begin
            return (head = tail);                        -- if the head and tail point to the same place, then there is no data in the FIFO 
         end function is_empty;       
         
      procedure push(new_data : in character) is  
         begin
            assert not is_full                           -- if there is no space in the FIFO... 
            report "ERROR: Attempt to push data into a full FIFO. This data will overwrite un-read data in the FIFO" -- debug: add time_pkg and display the time, module, and datum
            severity WARNING;
            
            -- perform the push regardless...
            if (VERBOSE_MODE) then
               report "attempting to push " & character'image(new_data) & " to the buffer at position " & integer'image(head);
            end if;
            data(head) := new_data;                      -- add the new data to the circular buffer and
            head := next_ptr(head);                      -- advance the head pointer
         end procedure push;
         
      impure function pop return character is     -- although this function is "pure", it calls an "impure" function thus making this function "impure"
            variable popped_value : character := character'val(0);
         begin
            data_present_check: if (is_empty) then
               assert false
               report "ERROR: Popping an empty FIFO"     -- debug: add time_pkg and display the time at which this occurred, and, if possible, from which module the call was made
               severity WARNING;
               popped_value := character'val(0);
            else
               popped_value := data(tail);               -- pull the value from the circular buffer's tail position
               tail := next_ptr(tail);                   -- advance the tail pointer
            end if data_present_check;
            return popped_value;                         -- return the popped value
         end function pop;
         
      impure function volume return integer is
         begin
            if (tail > head) then
               return tail - head;
            else
               return DEPTH - 1 - tail + head;
            end if;
         end function volume;

      signal push_action_occurred : boolean := false;      
      signal pop_action_occurred  : boolean := false;

   begin 
        
      writing_to_fifo: process
         begin
            wait until character_in_valid;                -- wait until data is present until pushing into FIFO
            push(character_in);                           -- push the data into the FIFO
            if (VERBOSE_MODE) then
               report "fifo received: " & character_in;
               report "volume after push is now: " & integer'image(volume);
            end if;
            push_action_occurred <= true;
            wait until not character_in_valid;            -- hang out here until character_in_valid is deasserted
            push_action_occurred <= false;
          end process writing_to_fifo;
          
      read_from_fifo: process
         begin
             wait until character_req;                      -- wait until something wants data
             character_out <= pop;                          -- get the next character from the FIFO
             if (VERBOSE_MODE) then
                report "volume after pop is now: " & integer'image(volume);
             end if;
             pop_action_occurred <= true;
             wait until not character_req;                  -- hang out here until character_req is deasserted           
             pop_action_occurred <= false;
         end process read_from_fifo;     

      manage_ctrl_signals: process
         begin
            wait until push_action_occurred or pop_action_occurred;
            empty <= is_empty;                             -- now that the pop MAY HAVE occurred, is the FIFO empty?        
            full  <= is_full;                              -- now that the FIFO MAY HAVE an additional piece of data, is it full?    
         end process manage_ctrl_signals;

   end architecture behavioral;