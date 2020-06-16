--<insert: c:\HW\releasedULD\headers\wave_gen_pkg.head>
-- -----------------------------------------------------------------------------
--
-- module:    wave_gen_pkg
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This package provides a convenient mechanism for encapsulating all of the
--   modules used in the wave_gen project. To access these module definitions,
--   all one must do is name the library where the package is
--   stored and implement a  use  statement. Typically, this module may reside
--   where all the other VHDL sources exist and, by default, this file will
--   appear in the  WORK  library. The  WORK  library is accessed by default so
--   the  library work;  statement is optional. The next line should read  use
--   WORK.wave_gen.pkg.all; which will make all of the contents of this package
--   available to the file in which this statement exists.
--
--   Note that only modules that make use of any of the contents in this package 
--   are required to explicitly connect to it.
--
--   The package also includes a number of constants and user defined enumerated 
--   types. 
--
--   As a rule of thumb, I place all the component instantiations in a package 
--   to reduce the  clutter 
--   within a file.
--
--   Types, subtypes, functions, procedures, and constant are included if they are 
--   used by more than one module. This reduces errors due to inconsistant usage.
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
use IEEE.STD_LOGIC_1164.all;


package wave_gen_pkg is

    -- 
    -- Device constants
    --
    
    -- Number of bits of address for the Sample RAM - RAM can hold 2^NSAMP_WID
    -- Since NSAMP is coded "naturally" (from 1 to 2**NSAMP_WID, rather than
    -- from 0 to 2**(NSAMP_WID)-1), an extra bit is required in things that
    -- carry the actual value of nsamp. However, the RAM address is coded
    -- 0 to 2**NSAMP_WID-1
    constant NSAMP_WIDTH             : integer := 10;        

    --
    -- specialized types
    --
    type RESPONSE_TYPE is (ACK, ERR, DATA, UNKNOWN);
    
    
    --
    -- component definitions
    --
    
    
    component clk_gen is
        Port (rst_i            : in  std_logic;                       -- external reset
              clk_pin_p        : in  std_logic;                       -- primary un-buffered clock input
              clk_pin_n        : in  std_logic;                       --  - and differential input
              clk_rx           : out std_logic;                       -- clock for UART receiver and parser portion of the design
              clk_tx           : out std_logic;                       -- clock for UART transmitter and output portion of the design
              prescale_clk_tx  : in  std_logic_vector(15 downto 0);   -- current prescalar value synchronized to clk_tx
              en_clk_samp      : out std_logic;                       -- indication that the next rising edge of clk_tx will coincide with the rising edge of clk_samp
              clk_samp         : out std_logic                        -- clock for the sampling portion of the design (waveform output)
             );
    end component clk_gen;
    
    component clk_div
       port (clk_tx            : IN  std_logic;
             rst_clk_tx        : IN  std_logic;
             prescale_clk_tx   : IN  std_logic_vector(15 downto 0);          
             en_clk_samp       : OUT std_logic
          );
    end component clk_div;  
       
    component rst_gen is
        Port (clk_tx           : in  std_logic;                       -- transmitter clock
              clk_rx           : in  std_logic;                       -- receiver clock
              clk_samp         : in  std_logic;                       -- sample clock
              rst_i            : in  std_logic;                       -- asynchronous reset input
              rst_clk_tx       : out std_logic;                       -- reset synchronized to clk_tx
              rst_clk_rx       : out std_logic;                       -- reset synchronized to clk_rx
              rst_clk_samp     : out std_logic                        -- reset synchronized to clk_samp
            );
    end component rst_gen;   
    
    component reset_bridge is
        Port ( clk_dst         : in  std_logic;                       -- destination clock
              rst_in           : in  std_logic;                       -- async reset signal
              rst_dst          : out std_logic                        -- sync'd reset signal
             );
    end component reset_bridge;   
    
    component lb_ctl is
        Port (clk_tx           : in  std_logic;
              rst_clk_tx       : in  std_logic;
              lb_sel_async     : in  std_logic;
              txd_clk_tx       : in  std_logic;
              rxd_async        : in  std_logic;
              txd_o            : out std_logic
             );
    end component lb_ctl;   
    
    component uart_rx is
       generic (
                BAUD_RATE   : integer :=     115_200;                 -- serves as clock divisor
                CLOCK_RATE  : integer := 100_000_000                  -- freq of clk
             );
        Port ( rst_clk_rx      : in  std_logic;                       -- active high, managed synchronously
               clk_rx          : in  std_logic;                       -- operational clock
               rxd_i           : in  std_logic;                       -- directly from pad - not yet associated with any time domain
               rxd_clk_rx      : out std_logic;                       -- RXD synchronized to clk_rx
               rx_data         : out std_logic_vector (7 downto 0);   -- 8 bit data output valid when rx_data_rdy is asserted
               rx_data_rdy     : out std_logic;                       -- active high signal indicating rx_data is valid
               frm_err         : out std_logic                        -- framing error - active high when STOP bit not detected
              );
    end component uart_rx;  
    
    component uart_tx is
       Generic( CLOCK_RATE     : integer := 50_000_000;
                BAUD_RATE      : integer :=    115_200
               );
        Port ( clk_tx          : in  std_logic;
               rst_clk_tx      : in  std_logic;
               char_fifo_empty : in  std_logic;
               char_fifo_dout  : in  std_logic_vector (7 downto 0);
               char_fifo_rd_en : out std_logic;
               txd_tx          : out std_logic
             );
    end component uart_tx;  
    
    component DAC_SPI is
        Port (clk_tx           : in  std_logic;                    -- transmitter clock
              rst_clk_tx       : in  std_logic;                    -- reset signal synchronized to clk_tx
              en_clk_samp      : in  std_logic;                    -- indication that the next rising edge of clk_tx will coincide with the rising edge of clk_smap
              samp             : in  std_logic_vector(15 downto 0);-- the current sample being output. Only valid when samp_val is asserted
              samp_val         : in  std_logic;                    -- a vaild sample is being output. Asserted for one clk_samp period for each sample
              SPI_ss_b_o       : out std_logic;                    -- SPI serial flash chip select - tied to 1 (disabled)
              spi_clk_o        : out std_logic;                    -- SPI clock
              SPI_MOSI_o       : out std_logic;                    -- SPI master-out-slave-in datum
              DAC_cs_n_o       : out std_logic;                    -- DAC SPI chip select (active low)
              DAC_clr_n_o      : out std_logic                     -- DAC clear
             );
    end component DAC_SPI;  
    
    component debouncer
       generic ( FILTER  : integer := 2_000_000                    -- number of clocks required to acknowledge a valid change in switch state
                );       
       port (
          clk            : IN  std_logic;
          rst            : IN  std_logic;
          signal_in      : IN  std_logic;          
          signal_out     : OUT std_logic
       );
    end component debouncer;   
    
    component meta_harden is
        port ( clk_dst      : in  std_logic;
               rst_dst      : in  std_logic;
               signal_src   : in  std_logic;
               signal_dst   : out std_logic);
    end component meta_harden;    
    
    component clkx_bus is
       generic (PW          : in  integer :=  3;                         -- pulse width
                WIDTH       : in  integer := 16                          -- bus width
             );
        port ( 
               clk_src      : in  std_logic;                             -- source clock
               rst_clk_src  : in  std_logic;                             -- reset - synchronous to source clock
               clk_dst      : in  std_logic;                             -- destination clock
               rst_clk_dst  : in  std_logic;                             -- reset - synchronous to destination clock
               bus_src      : in  std_logic_vector (WIDTH-1 downto 0);   -- bus input - synchronous to source clock
               bus_new_src  : in  std_logic;                             -- active high indicator that bus_src has changed this source clock
               bus_dst      : out std_logic_vector (WIDTH-1 downto 0);   -- bus output - synchronous to destination clock
               bus_new_dst  : out std_logic                              -- active high indicator that bus_dst has changed this destination clock
             );
    end component clkx_bus;    

    component uart_baud_gen is
        Generic (CLOCK_RATE       : integer := 100_000_000;              -- clock rate
                 BAUD_RATE        : integer :=     115_200               -- desired baud rate
                );                   
        Port ( rst                : in  std_logic;                       -- external reset in
               clk                : in  std_logic;                       -- clock 
               baud_x16_en        : out std_logic
              );
    end component uart_baud_gen;
    
    component uart_rx_ctl
       PORT(
             clk_rx      : IN  std_logic;
             rst_clk_rx  : IN  std_logic;
             baud_x16_en : IN  std_logic;
             rxd_clk_rx  : IN  std_logic;          
             rx_data     : OUT std_logic_vector(7 downto 0);
             rx_data_rdy : OUT std_logic;
             frm_err     : OUT std_logic
          );
    END component uart_rx_ctl;    
    
    component cmd_parse is
       generic (PW                : integer := 3;                        -- Number of clks to assert pulses going to the clk_tx domain. Must be enough to guarantee that the resulting signal is asserted for at least 2 full clk_tx periods (for calid
                NSAMP_WIDTH       : integer := 10
             );
       Port (clk_rx               : in  std_logic;                       -- receiver clock
             rst_clk_rx           : in  std_logic;                       -- reset signal synchronized with receiver clock
             rx_data              : in  std_logic_vector(7 downto 0);    -- received character valid when rx_data_rdy is asserted
             rx_data_rdy          : in  std_logic;                       -- indicates that the character presented on rx_data is valid - is asserted for one clock cycle of clk_rx (debug)
           
             char_fifo_full       : in  std_logic;                       -- high when character FIFO is full - new input cannot be accepted when FIFO is full
             send_char_valid      : out std_logic;                       -- pulses for 1 clk_rx when a new character on send_char is ready to send
             send_char            : out std_logic_vector(7 downto 0);    -- character to send to user
             send_resp_valid      : out std_logic;                       -- asserted when a new response is required. Type of response indicated with send_resp_type
             send_resp_type       : out RESPONSE_TYPE;                   -- indicates type of response required. Vaild whn send_resp_type is asserted (00: ack; 01: error; 10: data; 11: not used)
             send_resp_data       : out std_logic_vector(15 downto 0);   -- data to send
             send_resp_done       : in  std_logic;                       -- pusled for 1 click when requested response is complete. Send_resp_val must be deasserted on next clock
            
             nsamp_clk_rx         : out std_logic_vector(NSAMP_WIDTH-1 downto 0); -- current value of nsamp  
             nsamp_new_clk_rx     : out std_logic;                       -- pulsed for one clock when nsamp is changed
             pre_clk_rx           : out std_logic_vector(15 downto 0);   -- current value of prescale
             pre_new_clk_rx       : out std_logic;                       -- pulsed "capture" for new prescale value
             spd_clk_rx           : out std_logic_vector(15 downto 0);   -- current value of speed parameter
             spd_new_clk_rx       : out std_logic;                       -- pulsed "capture" for new speed value
             samp_gen_go_clk_rx   : out std_logic;                       -- asserted continuously between receipt of *C and *H command or pulsed for a PW clocks when *G received
             
             cmd_samp_ram_din     : out std_logic_vector(15 downto 0);   -- write data to Data RAM
             cmd_samp_ram_addr    : out std_logic_vector( 9 downto 0);   -- address to Data RAM
             cmd_samp_ram_we      : out std_logic;                       -- write enable to Data RAM
             cmd_samp_ram_dout    : in  std_logic_vector(15 downto 0)    -- read data from Data RAM
           );
    end component cmd_parse;   
    
    component resp_gen is
        Port ( clk_rx          : in  std_logic;                       -- receiver clock
               rst_clk_rx      : in  std_logic;                       -- reset signal synchronized to clk_rx
               send_char_valid : in  std_logic;                       -- single pulse asserted to show valid send_char
               send_char       : in  std_logic_vector (7 downto 0);   -- character to return to user. valid when send_char_val asserted
               send_resp_valid : in  std_logic;                       -- asserted when new response reqd. Type indicated by send_resp_typ and remains asserted until send_resp_done asserted
               send_resp_type  : in  RESPONSE_TYPE;                   -- indicates type of response required. Vaild whn send_resp_type is asserted (00: ack; 01: error; 10: data; 11: not used)
               send_resp_data  : in  std_logic_vector (15 downto 0);  -- data to send. only valid when send_resp_val is asserted and send_resp_type is "10"
               send_resp_done  : out std_logic;                       -- pulsed for 1 clock when requestd response is complete. Send_resp_val must be deasserted on the next clock
               char_fifo_din   : out std_logic_vector (7 downto 0);   -- character to push to FIFO - not from a F/F
               char_fifo_wr_en : out std_logic;                       -- write enable to the FIFO
               char_fifo_full  : in  std_logic                        -- indicates full FIFO. data should NOT be presented to the FIFO when this signal is asserted (high)
              );
    end component resp_gen;    
    
    component to_bcd
       port (clk_rx      : IN  std_logic;
             rst_clk_rx  : IN  std_logic;
             value_val   : IN  std_logic;
             value       : IN  std_logic_vector(15 downto 0);          
             bcd_out     : OUT std_logic_vector(18 downto 0)
          );
    end component to_bcd;   
    
    component char_fifo
       port (din      : IN  std_logic_VECTOR(7 downto 0);
             rd_clk   : IN  std_logic;
             rd_en    : IN  std_logic;
             rst      : IN  std_logic;
             wr_clk   : IN  std_logic;
             wr_en    : IN  std_logic;
             dout     : OUT std_logic_VECTOR(7 downto 0);
             empty    : OUT std_logic;
             full     : OUT std_logic
          );
    end component;

    -- Synplicity black box declaration
    attribute syn_black_box : boolean;
    attribute syn_black_box of char_fifo: component is true;    
    
    component samp_ram
       port (
       clka           : IN  std_logic;
       wea            : IN  std_logic_VECTOR(0 downto 0);
       addra          : IN  std_logic_VECTOR(9 downto 0);
       dina           : IN  std_logic_VECTOR(15 downto 0);
       douta          : OUT std_logic_VECTOR(15 downto 0);
       clkb           : IN  std_logic;
       web            : IN  std_logic_VECTOR(0 downto 0);
       addrb          : IN  std_logic_VECTOR(9 downto 0);
       dinb           : IN  std_logic_VECTOR(15 downto 0);
       doutb          : OUT std_logic_VECTOR(15 downto 0));
    end component;

    
    component samp_gen is
       generic (NSAMP_WIDTH : integer := 10);
        Port ( clk_tx                   : in  std_logic;                       -- clock associated with the transmit clock
               rst_clk_tx               : in  std_logic;                       -- reset signal synchronized to the transmit clock
               clk_samp                 : in  std_logic;                       -- sample clock
               rst_clk_samp             : in  std_logic;                       -- reset signal synchronized to the clk_samp signal
               nsamp_clk_tx             : in  std_logic_vector (NSAMP_WIDTH-1 downto 0);   -- number of samples to pull from memory (i.e. max address - 1)
               spd_clk_tx               : in  std_logic_vector (15 downto 0);  -- current value of speed - i.e. scalar to divide clk_samp with to generate output 
               en_clk_samp              : in  std_logic;                       -- indicates that the next rising edge of clk_tx will contain valid sample value
               samp_gen_go_clk_rx       : in  std_logic;                       -- asserted continuously betwen the receipt of a  *C and a *H command, or pulsed for PW clocks after *G
               samp                     : out std_logic_vector (15 downto 0);  -- the current sample being output. only valid when samp_val is asserted
               samp_valid               : out std_logic;                       -- indicates that the sample is valid
               samp_gen_samp_ram_addr   : out std_logic_vector(NSAMP_WIDTH-1 downto 0);    -- address to the data RAM
               samp_gen_samp_ram_dout   : in  std_logic_vector(15 downto 0);   -- data from RAM
               led_out                  : out std_logic_vector (7 downto 0)    -- when enabled, these LEDs reflect the top 8 bits of the output sample
              );
    end component samp_gen;    
    
    component uart_tx_ctl is
        Port ( clk_tx          : in  std_logic;
               rst_clk_tx      : in  std_logic;
               baud_x16_en     : in  std_logic;
               char_fifo_empty : in  std_logic;
               char_fifo_rd_en : out std_logic;
               char_fifo_dout  : in  std_logic_vector (7 downto 0);
               txd_tx          : out std_logic
              );
    end component uart_tx_ctl;
    

    component out_ddr_flop is
        Port ( clk       : in  std_logic;
               rst       : in  std_logic;
               d_rise    : in  std_logic;
               d_fall    : in  std_logic;
               q         : out std_logic
          );
    end component out_ddr_flop;   


    --
    -- command codes
    constant CMD_WRITE         : std_logic_vector(7 downto 0) := X"57"; -- 'W'
    constant CMD_READ          : std_logic_vector(7 downto 0) := X"52"; -- 'R'
    constant CMD_SET_NSAMPLES  : std_logic_vector(7 downto 0) := X"4E"; -- 'N'
    constant CMD_GET_NSAMPLES  : std_logic_vector(7 downto 0) := X"6E"; -- 'n'
    constant CMD_SET_PRESCALAR : std_logic_vector(7 downto 0) := X"50"; -- 'P'
    constant CMD_GET_PRESCALAR : std_logic_vector(7 downto 0) := X"70"; -- 'p'
    constant CMD_SET_SPEED     : std_logic_vector(7 downto 0) := X"53"; -- 'S'
    constant CMD_GET_SPEED     : std_logic_vector(7 downto 0) := X"73"; -- 's'
    constant CMD_GO            : std_logic_vector(7 downto 0) := X"47"; -- 'G'
    constant CMD_CONTINUOUS    : std_logic_vector(7 downto 0) := X"43"; -- 'C'
    constant CMD_HALT          : std_logic_vector(7 downto 0) := X"48"; -- 'H'       
    
    -- 
    -- states for state machine used by both the command parser and the response generator
    type LEGAL_COMMAND_STATES is (IDLE, WAIT_FOR_CMD, GET_ARG, READ_RAM, READ_RAM2, SEND_RESP);
    
    --
    -- handy constants
    constant vcc               : std_logic_vector(31 downto 0) := (others=>'1');
    constant gnd               : std_logic_vector(31 downto 0) := (others=>'0');


end wave_gen_pkg;


package body wave_gen_pkg is

end wave_gen_pkg;
