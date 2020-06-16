--
-- -------------------------------------------------------------------------------------------------
--
-- Project: waveGenTestBench
-- Description: provides a working simulation environment using the principles of a time-agnostic
--              test bench and that of the "client/server" approach for the waveGen design. This 
--              design mimics the test fixture for the waveGen design (done in Verilog).
--
-- File: tb_wave_gen
-- Description: implements the "top" of the project test bench
-- Written:     WK  8/10/11
--
-- Notes:
-- Issues:
--
-- --------------------------------------------------------------------------------------------------
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library WORK;
use WORK.tb_wave_gen_helper_pkg.all;

entity tb_wave_gen is
     generic (fileName      : string  := "wavegen_commands.txt";
              CLOCK_RATE_RX : integer := 200_000_000;
              CLOCK_RATE_TX : integer := 193_750_000;
              BAUD_RATE     : integer := 115200;
              BIT_PERIOD    : time    := 8681 ns        -- corresponds to 115200 baud
             );
end entity tb_wave_gen;

architecture BEHAVIORAL of tb_wave_gen is

     -- signals of the UUT
     signal clk_pin_p           : std_logic := '0';     -- positive polarity for clock pin
     signal clk_pin_n           : std_logic := '1';     -- negative polarity for clock pin
     signal rst_pin             : std_logic := 'U';     -- reset pin, initialized in the body of the testbench

--     signal frm_err             : std_logic := 'U';     -- UUT RS-232 frame error

     signal serial_data_from_design: std_logic ;   -- UUT RS-232 transmitter pin driving the uart_monitor
     signal serial_data_from_user  : std_logic;       -- UUT RS-232 receiver pin driven by uart_driver
     
     signal led_o  : std_logic_vector(7 downto 0) := (others=>'U');     
     
     --signals sourcing the cmd gen
     signal more_commands_available : boolean := false; -- Indicator from tb_cmd_gen that there are more commands to be processed
     signal next_command_request    :  boolean := false; -- Indicator from tb_uart_driver that the last complete command was processed and is ready for more
     signal command_string          : string (1 to 32); -- Contains the command string from the file as read by tb_cmd_gen
     
     -- signals source the wave_gen model
     signal wave_resp_to_fifo       : character;      -- Contains the response character genertaed by tb_wavegen_model; should be connected to char fifo
     
     -- signals source the char fifo model
     signal character_fifo_full     : boolean ;
     signal valid_for_fifo          : boolean ; 
     
     signal character_req           : boolean ;
     signal character_out_from_fifo : character;
      
     signal character_fifo_empty    : boolean;
           
     -- signals source the uart_monitor
     signal character_from_monitor  : character;
     signal char_from_monitor_valid : boolean ;
     
     signal start_uart_monitor      : boolean:= false ;
     
     -- signals source the uart_monitor
     signal start_response_checker : boolean:= false ;
     
     --
     -- Define constants here
     constant FIFO_DEPTH           : integer :=          256;
     constant RESET_HOLDOFF        : integer :=       10_000;
     constant CLOCK_PERIOD         : time    :=         5 ns;

   begin
         
      -- generate the clock
     clk_gen: process
         begin
            clk_pin_p <= not clk_pin_p;
            clk_pin_n <= not clk_pin_n;
            wait for CLOCK_PERIOD / 2;
         end process clk_gen;
            
      -- generate the reset signal      
      genReset: tb_resetgen 
         generic map (holdoff => RESET_HOLDOFF_CLOCKS)
         port    map (clk     => clk_pin_p,
                      reset   => rst_pin
                     );      
      
      -- get the commands from a text file
      tb_cmd_gen_i0: tb_cmd_gen 
         generic map (fileName        => fileName,
                      endSimulationAt => 50 ns)
         port    map (reset                   => rst_pin,
                      more_commands_available => more_commands_available,
                      next_command_request    => next_command_request,
                      command_string          => command_string
                     );                      
      
      -- feed the command string into the tb_uart_driver so that it is converted into a serial stream (RS-232)
      -- the uart driver also stimulates the cmd generator to produce new commands
      tb_uart_driver_i0: tb_uart_driver
          generic map (BAUD_PERIOD          => BIT_PERIOD)
          port map (reset                   => rst_pin,
                    next_command_request    => next_command_request,  
                    more_commands_available => more_commands_available,   
                    command_string          => command_string,
                    serial_data_out         => serial_data_from_user
                   );      

                       
    -- feed the command string into the wavegen behavioral model
     tb_wavegen_model_i0 : tb_wavegen_model
          port map(reset          => rst_pin,               -- sets the reset values of the wavegen model 
                   command_string => command_string,        -- command string input from the commnad generator                     
                   fifo_full      => character_fifo_full,   -- FIFO full signal from the FIFO model 
                   response_valid => valid_for_fifo,        -- Valid signal to enable write to FIFO
                   response       => wave_resp_to_fifo      -- Valid data to be pushed to be pushed into FIFO
                  ); 
     
     -- FIFO provides output synchronization with the UUT
     tb_char_fifo_i0: tb_fifo 
          generic map (VERBOSE_MODE => false,
                       DEPTH        =>  FIFO_DEPTH
                      )
          port map (character_in        => wave_resp_to_fifo,       -- data to push into the FIFO
                    character_in_valid  => valid_for_fifo,         -- equivalent to write strobe - data is captured on the rising edge
                    full                => character_fifo_full,     -- indicates that the FIFO is full
                    character_out       => character_out_from_fifo, -- data popped from the FIFO
                    character_req       => character_req,           -- equivalent to read strobe - new data is "popped" on the transition from false to true
                    empty               => character_fifo_empty     -- indicates that the FIFO has no more data available
                   );         
                      
      -- convert the serial output of the UUT into characters 
     tb_uart_monitor_i0: tb_uart_monitor 
          generic map (BIT_PERIOD =>BIT_PERIOD)
          port map (start_monitor  => start_uart_monitor,
                    data_in       => serial_data_from_design,
                    character_out  => character_from_monitor,
                    character_valid=> char_from_monitor_valid
                   );
      
      -- compare the responses between the UUT and the Behavioral Model of the UUT     
     tb_resp_checker_i0: tb_resp_checker 
          PORT MAP (data_from_fifo         => character_out_from_fifo,
                    data_from_uut          => character_from_monitor,
                    data_ready             => char_from_monitor_valid,
                    fifo_empty             => character_fifo_empty,
                    start_response_checker => start_response_checker,
                    read_fifo              => character_req
                   );
                 
     -- instantiate the UUT
     inst_wave_gen: wave_gen 
          port map(clk_pin_p      => clk_pin_p,
                   clk_pin_n      => clk_pin_n,
                   rst_pin        => rst_pin,
                   led_pins       => led_o,
                   spi_clk_pin    => open,
                   spi_mosi_pin   => open,
                   dac_cs_n_pin   => open,
                   dac_clr_n_pin  => open,
                   rxd_pin        => serial_data_from_user ,
                   txd_pin        => serial_data_from_design,
                   lb_sel_pin     => '0'
                  );

     start_validation_sequence: process
          begin
            wait for 6 us;
               start_uart_monitor <= true;
               start_response_checker <= true;
            wait;
     end process start_validation_sequence;             
          

   end architecture BEHAVIORAL;
