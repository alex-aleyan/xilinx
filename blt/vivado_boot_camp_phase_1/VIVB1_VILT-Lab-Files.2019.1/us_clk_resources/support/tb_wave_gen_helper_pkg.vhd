--
-- -------------------------------------------------------------------------------------------------
--
-- Project: waveGenTestBench
-- Description: provides a working simulation environment using the principles of a time-agnostic
--              test bench and that of the "client/server" approach for the waveGen design. This 
--              design mimics the test fixture for the waveGen design (done in Verilog).
--
-- File: tb_wave_gen_helper_pkg
-- Description: contains various constants, functions, procedures, constants, and types for 
--              the waveGenTestBench
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

LIBRARY utilities_lib;
use utilities_lib.string_utilities_synth_pkg.all;

package tb_wave_gen_helper_pkg is
   
   -- sysem constants - clock
   constant CLOCK_RATE       : integer :=    50_000_000;
   constant CLOCK_PERIOD     : time    := 1_000_000_000 / CLOCK_RATE * 1 ns; -- Clock period
   
   -- communication frequency
   constant BAUD_RATE        : integer :=       115_200;  
   constant BAUD_PERIOD      : time    := 1_000_000_000 / BAUD_RATE * 1 ns; -- BAUD period
  
   constant DATA_WID     : integer := 16;
   
   -- reset holdoff
   constant RESET_HOLDOFF_CLOCKS  : integer :=           10;

   -- memory mapped locations
   constant NSAMP    : integer := 0;
   constant PRESCALE : integer := 1;
   constant SPEED    : integer := 2;
   
   -- modules
   component tb_resetgen is
      generic(holdoff : integer := 10);
      port (clk    : in  std_logic;
            reset  : out std_logic
           );
   end component tb_resetgen;   
   
   component tb_cmd_gen is
      generic (fileName                : string;
               endSimulationAt         : time
              );
      port    (reset                   : in  std_logic;
               next_command_request   : in  boolean;
               more_commands_available: out boolean; 
               command_string          : out String
              );
   end component tb_cmd_gen;
      
   component tb_uart_driver is
      generic (BAUD_PERIOD             : time
              );
      port    (reset                   : in  std_logic;
               next_command_request    : out boolean;
               more_commands_available : in  boolean;  
               command_string          : in  string;
               serial_data_out         : out std_logic
              );
   end component tb_uart_driver; 
  
   component tb_wavegen_model is
      GENERIC(SAMP_DEPTH           : integer := 1024;
              VAR_DEPTH            : integer := 3;
              WIDTH                : integer := 16
             );
      port(reset                   : in  std_logic;
           command_string          : in  string;
           response_valid          : out boolean;
           fifo_full               : in boolean;
           response                : out character        
          ); 
   end component tb_wavegen_model;
  
   component tb_ram is
      generic (WIDTH : integer := 16;
               DEPTH : integer := 1024
              );
      port  (reset   : in  std_logic;    
             addr    : in integer;
             value   : inout std_logic_vector((WIDTH-1) downto 0);
             success : out boolean;
             wr      : in std_logic;
             rd      : in std_logic
          );
   end component tb_ram;
  
   component tb_var_ram is
      generic (WIDTH : integer := 16;
               DEPTH : integer := 3
              );
      port  (reset   : in  std_logic;    
             addr    : in integer;
             value   : inout std_logic_vector((WIDTH-1) downto 0);
             success : out boolean;
             wr      : in std_logic;
             rd      : in std_logic
            );
   end component tb_var_ram;

   component tb_samp_ram is
      generic (WIDTH : integer := 16;
               DEPTH : integer := 1024
              );
      port  (reset   : in  std_logic;    
             addr    : in integer;
             value   : inout std_logic_vector((WIDTH-1) downto 0);
             wr      : in std_logic;
             rd      : in std_logic
            );
   end component tb_samp_ram;
   
   component tb_fifo is
       generic (VERBOSE_MODE : boolean := true;
                DEPTH        : integer := 256
               );
       port (character_in        : in  character;       -- data to push into the FIFO
             character_in_valid  : in  boolean;         -- equivalent to write strobe - data is captured on the rising edge
             full                : out boolean;         -- indicates that the FIFO is full
             character_out       : out character;       -- data popped from the FIFO
             character_req       : in  boolean;         -- equivalent to read strobe - new data is "popped" on the transition from false to true
             empty               : out boolean          -- indicates that the FIFO has no more data available
            );
         end component tb_fifo;   
         
      component wave_gen is
         generic (CLOCK_RATE_RX : integer :=  200_000_000;
                  CLOCK_RATE_TX : integer :=  193_750_000;
                  PW            : integer :=           3;
                  BAUD_RATE     : integer :=     115_200;
                  LED_USE       : string  :=      "TXDR"     -- other choice is "RXFB"
                 );
         port (  
               -- system signals
               clk_pin_p         : in  std_logic;
               clk_pin_n         : in  std_logic;
               rst_pin           : in  std_logic;
              
               -- LED signals
               led_pins          : out std_logic_vector (7 downto 0);
                  
               -- SPI related signals
               spi_clk_pin       : out std_logic;        -- SPI clock
               spi_mosi_pin      : out std_logic;        -- SPI master-out-slave-in datum
               dac_cs_n_pin      : out std_logic;        -- DAC SPI chip select (active low)
               dac_clr_n_pin     : out std_logic;        -- DAC clear
                  
               -- serial communications signals
               rxd_pin           : in  std_logic;
               txd_pin           : out std_logic;
               lb_sel_pin        : in  std_logic         -- loop-back control pin
              );
      end component wave_gen;
        
      component tb_resp_checker
         port (data_from_fifo         : in  character;
               data_from_uut          : in  character;
               data_ready             : in boolean;
               fifo_empty             : in boolean;
               start_response_checker : in boolean;
               read_fifo              : out  boolean
              );
      end component tb_resp_checker;
      
      component tb_uart_monitor
         generic(BIT_PERIOD   : time:= 8681 ns);  
         port(start_monitor   : in  boolean;
              data_in         : in  std_logic;
              character_out   : out  character;
              character_valid : out  boolean
             );
      end component tb_uart_monitor;         
  
  impure function to_dec_str(val : in std_logic_vector) return string;
  
end package tb_wave_gen_helper_pkg;


package body tb_wave_gen_helper_pkg is

  impure function to_dec_str(val : in std_logic_vector) return string is
     variable str_val  : string(1 to 5) := "00000";
     variable char_val : character := '?';
     variable int_val  : integer range 0 to 65535 := 0;
     begin
        int_val:= to_integer(unsigned(val));
        str_val:= integer'image(int_val);
        for i in 1 to 5 loop
           char_val :=str_val(i);
           if (str_val(i)= ' ') then
              str_val(i):= '0';
           end if;
        end loop;
     return str_val;
  end function to_dec_str;

end tb_wave_gen_helper_pkg;
