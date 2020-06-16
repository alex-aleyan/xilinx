--<insert: c:\HW\releasedULD\headers\wave_gen.head>
-- -----------------------------------------------------------------------------
--
-- module:    wave_gen
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This is the top level of the wave  generator.
--   It directly instantiates the I/O pads and all the submodules  required
--   to implement the  design.
--   
-- Multicycle and False  Paths
--   Some exist, embedded within the submodules. See the  submodule
--   descriptions.
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;                         -- load buffer primitive descriptions

library work;
use work.wave_gen_pkg.all;                          -- load component definitions


entity wave_gen is
    Generic (CLOCK_RATE_RX : integer := 200_000_000;
             CLOCK_RATE_TX : integer := 193_750_000;
             PW            : integer :=          3;
             BAUD_RATE     : integer :=    115_200;
             LED_USE       : string  :=     "TXDR"     -- other choice is "RXFB"
           );
    Port (  
          -- system signals
          clk_pin_p         : in  std_logic;
          clk_pin_n         : in  std_logic;
          rst_pin           : in  std_logic;
          
          -- LED signals
          led_pins          : out std_logic_vector (7 downto 0);
            
          -- SPI related signals
          spi_clk_pin      : out std_logic;        -- SPI clock
          spi_mosi_pin     : out std_logic;        -- SPI master-out-slave-in datum
          dac_cs_n_pin     : out std_logic;        -- DAC SPI chip select (active low)
          dac_clr_n_pin    : out std_logic;        -- DAC clear
            
           -- serial communications signals
          rxd_pin          : in  std_logic;
          txd_pin          : out std_logic;
          lb_sel_pin       : in  std_logic         -- loop-back control pin
         );
end wave_gen;


architecture Behavioral of wave_gen is

       --
       -- note: component definitions and constants are located in wave_gen_pkg.vhd
       --
       

       
       --
       -- Signals
       --
       
       -- clock signals
       signal clk_rx                 : std_logic := 'U';                          -- clock for rx clock domain
       signal clk_tx                 : std_logic := 'U';                          -- clock for tx clock domain
       signal clk_samp               : std_logic := 'U';                          -- clock for sampling (waveform output) domain
       
       -- reset signals
       signal rst_i                  : std_logic := 'U';                          -- asynchronous reset between the pin and the reset module
       signal rst_clk_tx             : std_logic := 'U';                          -- synchronous reset for the clk_tx domain
       signal rst_clk_rx             : std_logic := 'U';                          -- synchronous reset for the clk_rx domain
       signal rst_clk_samp           : std_logic := 'U';                          -- synchronous reset for the clk_samp domain    
       
       -- signals between the state machine parser and the clock generator modules
       signal en_clk_samp            : std_logic := 'U';
       
       -- signals associated with serial data transmission/reception
       signal lb_sel_async           : std_logic := 'U';                          -- buffered, but unsynchronized loopback control signal
       signal rxd_i                  : std_logic := 'U';                          -- buffered, but unsynchronized received data signal
       signal rxd_clk_rx             : std_logic := 'U';                          -- RXD synchronized to clk_rx
--     signal txd_clk_tx             : std_logic := 'U';                          -- transmit data from the UART to the mux
       signal txd_o                  : std_logic := 'U';                          -- outbound transmit data signal from the mux to the output buffer
       
       -- signals associated with the UART receiver and transmitter
       signal rx_data                : std_logic_vector(7 downto 0) := (others=>'U');
       signal rx_data_rdy            : std_logic := 'U';
       signal txd_tx                 : std_logic := 'U';
       
       -- signals associated with the command parser and the response generator                  
       signal send_char_valid        : std_logic := 'U';                          -- pulses for 1 clk_rx when a new character on send_char is ready to send
       signal send_char              : std_logic_vector(7 downto 0);              -- character to send to user
       signal send_resp_valid        : std_logic := 'U';                          -- asserted when a new response is required. Type of response indicated with send_resp_type
       signal send_resp_type         : RESPONSE_TYPE;                             -- indicates type of response required. Vaild whn send_resp_type is asserted (00: ack; 01: error; 10: data; 11: not used)
       signal send_resp_data         : std_logic_vector(15 downto 0);             -- data to send
       signal send_resp_done         : std_logic := 'U';                          -- pusled for 1 click when requested response is complete. Send_resp_val must be deasserted on next clock
               
       -- signals associated with the command parser and the sample generator
       signal nsamp_clk_rx           : std_logic_vector(NSAMP_WIDTH-1 downto 0);  -- current value of nsamp  
       signal nsamp_new_clk_rx       : std_logic := 'U';                          -- pulsed for one clock when nsamp is changed
       signal prescale_clk_rx        : std_logic_vector(15 downto 0);             -- current value of prescale
       signal prescale_new_clk_rx    : std_logic := 'U';                          -- pulsed "capture" for new prescale value
       signal spd_clk_rx             : std_logic_vector(15 downto 0);             -- current value of speed parameter
       signal spd_new_clk_rx         : std_logic := 'U';                          -- pulsed "capture" for new speed value
       signal samp_gen_go_clk_rx     : std_logic := 'U';                          -- asserted continuously between receipt of *C and *H command or pulsed for a PW clocks when *G received

       signal cmd_samp_ram_din       : std_logic_vector(15 downto 0);             -- write data to Data RAM
       signal cmd_samp_ram_addr      : std_logic_vector(NSAMP_WIDTH-1 downto 0) := (others=>'U');   -- address to Data RAM
       signal cmd_samp_ram_we        : std_logic := 'U';                         -- write enable to Data RAM
       signal cmd_samp_ram_we_vec    : std_logic_vector(0 downto 0) := (others=>'0'); -- vectorized form of cmd_samp_ram_we
       signal cmd_samp_ram_dout      : std_logic_vector(15 downto 0);             -- read data from Data RAM
       
       -- signals associated with the sampling generator
       signal samp                   : std_logic_vector(15 downto 0) := (others=>'U');
       signal samp_valid             : std_logic := 'U';
       signal samp_gen_samp_ram_addr : std_logic_vector( 9 downto 0) := (others=>'U');
       signal samp_gen_samp_ram_data : std_logic_vector(15 downto 0) := (others=>'U');
       signal led_out_samp_gen       : std_logic_vector( 7 downto 0) := (others=>'U');
       
       -- signals associated with the SPI module
       signal spi_clk_o              : std_logic := 'U';                          -- SPI clock
       signal spi_MOSI_o             : std_logic := 'U';                          -- SPI master-out-slave-in datum
       signal DAC_cs_n_o             : std_logic := 'U';                          -- DAC SPI chip select (active low)
       signal DAC_clr_n_o            : std_logic := 'U';                          -- DAC clear (active low)
       signal SPI_ss_b_o             : std_logic := 'U';                          -- SPI serial flash chip select - tied to 1 (disabled)

       -- signals between the response generator and the cross-domain FIFO
       signal char_fifo_rd_en        : std_logic := 'U';
       signal char_fifo_wr_en        : std_logic := 'U';
       signal char_fifo_empty        : std_logic := 'U';
       signal char_fifo_full         : std_logic := 'U';                          -- high when character FIFO is full - new input cannot be accepted when FIFO is full
       signal char_fifo_din          : std_logic_vector(7 downto 0) := (others=>'U');
       signal char_fifo_dout         : std_logic_vector(7 downto 0) := (others=>'U');   
       
       -- signals crossing the clock domain boundary for the sample generator
       signal spd_clk_tx             : std_logic_vector(15 downto 0) := (others=>'U');
       signal nsamp_clk_tx           : std_logic_vector(NSAMP_WIDTH-1 downto 0) := (others=>'U');
       signal prescale_clk_tx        : std_logic_vector(15 downto 0) := (others=>'U');
       signal led_out_o              : std_logic_vector( 7 downto 0) := (others=>'U');      
--     signal samp_gen_go_clk_tx     : std_logic := 'U';
--     signal nsamp_new_clk_tx       : std_logic := 'U';
--     signal spd_new_clk_tx         : std_logic := 'U';
--     signal prescale_new_clk_tx    : std_logic := 'U';      
       
       -- handy constants
       constant gnd                  : std_logic_vector(31 downto 0) := (others=>'0');  
       
       
    begin

       -- instantiate the clock control sub-system
       clk_gen_i0: clk_gen 
           port map ( 
                rst_i                => rst_i,                        -- raw external reset
                clk_pin_p            => clk_pin_p,                    -- unbuffered input into module
                clk_pin_n            => clk_pin_n,                    --   - and differential signal
                clk_rx               => clk_rx,                       -- clock for UART receiver and parser portion of the design
                clk_tx               => clk_tx,                       -- clock for UART transmitter and output portion of the design
                prescale_clk_tx      => prescale_clk_tx,              -- current prescalar value synchronized to clk_tx
                en_clk_samp          => en_clk_samp,                  -- indication that the next rising edge of clk_tx will coincide with the rising edge of clk_samp
                clk_samp             => clk_samp                      -- clock for the sampling portion of the design (waveform output)
             );
                
       -- instantiate the input buffer for the reset
       rstBuf: IBUF port map (I=>rst_pin, O=>rst_i);
       
       -- instantiate the reset control module
       rst_gen_i0: rst_gen
           port map ( clk_tx         => clk_tx,                       -- transmitter clock
                      clk_rx         => clk_rx,                       -- receiver clock
                      clk_samp       => clk_samp,                     -- sample clock
                      rst_i          => rst_i,                        -- asynchronous reset input
                      rst_clk_tx     => rst_clk_tx,                   -- reset synchronized to clk_tx
                      rst_clk_rx     => rst_clk_rx,                   -- reset synchronized to clk_rx
                      rst_clk_samp   => rst_clk_samp                  -- reset synchronized to clk_samp
                   );
                   
       -- instantiate the input buffer for the loopback control switch
       lbBuf: IBUF port map (I=>lb_sel_pin, O=>lb_sel_async);
       
       -- instantiate the input and output buffer for the serial communications
       rxBuf: IBUF port map (I=>rxd_pin, O=>rxd_i);
       txBuf: OBUF port map (I=>txd_o, O=>txd_pin);
       
       -- instantiate the loopback control module
       lb_ctl_i0: lb_ctl 
           port map ( clk_tx         => clk_tx,                       -- transmitter clock
                      rst_clk_tx     => rst_clk_tx,                   -- reset
                      lb_sel_async   => lb_sel_async,                 -- switch input
                      txd_clk_tx     => txd_tx,                       -- transmitter data from the UART
                      rxd_async      => rxd_clk_rx,                   -- RXD signal on clk_rx
                      txd_o          => txd_o                         -- multiplexed transmit signal
                   );    
                   
       -- instantiate the receiver portion of the UART
       uart_rx_i0: uart_rx 
          generic map (
                   BAUD_RATE      =>  BAUD_RATE,    
                   CLOCK_RATE     => CLOCK_RATE_RX           
                )
           port map (rst_clk_rx   => rst_clk_rx,                      -- active high, managed synchronously
                     clk_rx       => clk_rx,                          -- operational clock
                     rxd_i        => rxd_i,                           -- directly from pad - not yet associated with any time domain
                     rxd_clk_rx   => rxd_clk_rx,                      -- RXD synchronized to clk_rx
                     rx_data      => rx_data,                         -- 8 bit data output valid when rx_data_rdy is asserted
                     rx_data_rdy  => rx_data_rdy,                     -- active high signal indicating rx_data is valid
                     frm_err      => open                             -- framing error - active high when STOP bit not detected
                    );      
                    
       -- instantiate the command parser
       cmd_parse_i0: cmd_parse
          generic map (PW            =>  PW,                           -- Number of clks to assert pulses going to the clk_tx domain.
                       NSAMP_WIDTH   => NSAMP_WIDTH
                      )
          port map (  clk_rx               => clk_rx,                 -- receiver clock
                      rst_clk_rx           => rst_clk_rx,             -- reset signal synchronized with receiver clock
                      rx_data              => rx_data,                -- received character valid when rx_data_rdy is asserted
                      rx_data_rdy          => rx_data_rdy,            -- indicates that the character presented on rx_data is valid - is asserted for one clock cycle of clk_rx (debug)
                  
                      char_fifo_full       => char_fifo_full,         -- high when character FIFO is full - new input cannot be accepted when FIFO is full
                      send_char_valid      => send_char_valid,        -- pulses for 1 clk_rx when a new character on send_char is ready to send
                      send_char            => send_char,              -- character to send to user
                      send_resp_valid      => send_resp_valid,        -- asserted when a new response is required. Type of response indicated with send_resp_type
                      send_resp_type       => send_resp_type,         -- indicates type of response required. Vaild whn send_resp_type is asserted (00: ack; 01: error; 10: data; 11: not used)
                      send_resp_data       => send_resp_data,         -- data to send
                      send_resp_done       => send_resp_done,         -- pusled for 1 click when requested response is complete. Send_resp_val must be deasserted on next clock
                  
                      nsamp_clk_rx         => nsamp_clk_rx,           -- current value of nsamp  
                      nsamp_new_clk_rx     => nsamp_new_clk_rx,       -- pulsed for one clock when nsamp is changed
                      pre_clk_rx           => prescale_clk_rx,        -- current value of prescale
                      pre_new_clk_rx       => prescale_new_clk_rx,    -- pulsed "capture" for new prescale value
                      spd_clk_rx           => spd_clk_rx,             -- current value of speed parameter
                      spd_new_clk_rx       => spd_new_clk_rx,         -- pulsed "capture" for new speed value
                      samp_gen_go_clk_rx   => samp_gen_go_clk_rx,     -- asserted continuously between receipt of *C and *H command or pulsed for a PW clocks when *G received
                  
                      cmd_samp_ram_din     => cmd_samp_ram_din,       -- write data to Data RAM
                      cmd_samp_ram_addr    => cmd_samp_ram_addr,      -- address to Data RAM
                      cmd_samp_ram_we      => cmd_samp_ram_we,        -- write enable to Data RAM
                      cmd_samp_ram_dout    => cmd_samp_ram_dout       -- read data from Data RAM
                   );
                   
       -- instantiate the Block RAM (Dual Port, Async) for conveying user loaded data to the waveform output generator
       cmd_samp_ram_we_vec(0) <= cmd_samp_ram_we;

       -- Instantiate Sample RAM
       samp_ram_i0: samp_ram
             port map (
                clka     => clk_rx,
                wea   => cmd_samp_ram_we_vec,
                addra => cmd_samp_ram_addr,
                dina     => cmd_samp_ram_din,
                douta => cmd_samp_ram_dout,
                clkb  => clk_tx,
                web   => gnd(0 downto 0),
                addrb => samp_gen_samp_ram_addr,
                dinb     => gnd(15 downto 0),
                doutb => samp_gen_samp_ram_data
             );    
       
       -- instantiate the response generator
       resp_gen_i0: resp_gen
          port map (clk_rx           => clk_rx,                       -- receiver clock
                    rst_clk_rx       => rst_clk_rx,                   -- reset signal synchronized to clk_rx
                    send_char_valid  => send_char_valid,              -- single pulse asserted to show valid send_char
                    send_char        => send_char,                    -- character to return to user. valid when send_char_val asserted
                    send_resp_valid  => send_resp_valid,              -- asserted when new response reqd. Type indicated by send_resp_typ and remains asserted until send_resp_done asserted
                    send_resp_type   => send_resp_type,               -- indicates type of response required. Vaild whn send_resp_type is asserted (00: ack; 01: error; 10: data; 11: not used)
                    send_resp_data   => send_resp_data,               -- data to send. only valid when send_resp_val is asserted and send_resp_type is "10"
                    send_resp_done   => send_resp_done,               -- pulsed for 1 clock when requestd response is complete. Send_resp_val must be deasserted on the next clock
                    char_fifo_din    => char_fifo_din,                -- character to push to FIFO - not from a F/F
                    char_fifo_wr_en  => char_fifo_wr_en,              -- write enable to the FIFO
                    char_fifo_full   => char_fifo_full                -- indicates full FIFO. data should NOT be presented to the FIFO when this signal is asserted (high)
                   );
                   
       -- instantiate the FIFO to carry the character data to be transmitted from the receiver clock domain to the transmitter clock domain
       char_fifo_i0: char_fifo
          port map (
             din      => char_fifo_din,
             rd_clk   => clk_tx,
             rd_en    => char_fifo_rd_en,
             rst      => rst_i,                     -- async reset to both sides
             wr_clk   => clk_rx,
             wr_en    => char_fifo_wr_en,
             dout     => char_fifo_dout,
             empty    => char_fifo_empty,
             full     => char_fifo_full
          );    
          
       -- instantiate the transmitter portion of the UART
       uart_tx_i0: uart_tx
          generic map (CLOCK_RATE => CLOCK_RATE_TX,
                       BAUD_RATE  => BAUD_RATE)
          port map ( clk_tx          => clk_tx,
                     rst_clk_tx      => rst_clk_tx,
                     char_fifo_empty => char_fifo_empty,
                     char_fifo_dout  => char_fifo_dout,
                     char_fifo_rd_en => char_fifo_rd_en,
                     txd_tx          => txd_tx
                   );    

       -- cross time domains
       clkx_nsamp_i0: clkx_bus
          generic map (PW      => PW,                                       -- pulse width
                       WIDTH   => NSAMP_WIDTH                               -- bus width
                )
           port map ( 
                  clk_src      => clk_rx,                                   -- source clock
                  rst_clk_src  => rst_clk_rx,                               -- reset - synchronous to source clock
                  clk_dst      => clk_tx,                                   -- destination clock
                  rst_clk_dst  => rst_clk_tx,                               -- reset - synchronous to destination clock
                  bus_src      => nsamp_clk_rx,                             -- bus input - synchronous to source clock
                  bus_new_src  => nsamp_new_clk_rx,                         -- active high indicator that bus_src has changed this source clock
                  bus_dst      => nsamp_clk_tx,                             -- bus output - synchronous to destination clock
                  bus_new_dst  => open                                      -- active high indicator that bus_dst has changed this destination clock
                );
                
       clkx_pre_i0: clkx_bus
          generic map (PW      => PW,                                       -- pulse width
                       WIDTH   => 16                                        -- bus width
                )
           port map ( 
                  clk_src      => clk_rx,                                   -- source clock
                  rst_clk_src  => rst_clk_rx,                               -- reset - synchronous to source clock
                  clk_dst      => clk_tx,                                   -- destination clock
                  rst_clk_dst  => rst_clk_tx,                               -- reset - synchronous to destination clock
                  bus_src      => prescale_clk_rx,                          -- bus input - synchronous to source clock
                  bus_new_src  => prescale_new_clk_rx,                      -- active high indicator that bus_src has changed this source clock
                  bus_dst      => prescale_clk_tx,                          -- bus output - synchronous to destination clock
                  bus_new_dst  => open                                      -- active high indicator that bus_dst has changed this destination clock
                );
                
       clkx_spd_i0: clkx_bus 
          generic map (PW      => PW,                                       -- pulse width
                       WIDTH   => 16                                        -- bus width
                )
           port map ( 
                  clk_src      => clk_rx,                                   -- source clock
                  rst_clk_src  => rst_clk_rx,                               -- reset - synchronous to source clock
                  clk_dst      => clk_tx,                                   -- destination clock
                  rst_clk_dst  => rst_clk_tx,                               -- reset - synchronous to destination clock
                  bus_src      => spd_clk_rx,                               -- bus input - synchronous to source clock
                  bus_new_src  => spd_new_clk_rx,                           -- active high indicator that bus_src has changed this source clock
                  bus_dst      => spd_clk_tx,                               -- bus output - synchronous to destination clock
                  bus_new_dst  => open                                      -- active high indicator that bus_dst has changed this destination clock
                );             

       -- pull the sample from the memory and send to the DAC
       samp_gen_i0: samp_gen 
          generic map (NSAMP_WIDTH => 10)
           port map ( clk_tx                  => clk_tx,                    -- clock associated with the transmit clock
                      rst_clk_tx              => rst_clk_tx,                -- reset signal synchronized to the transmit clock
                      clk_samp                => clk_samp,                  -- sample clock
                      rst_clk_samp            => rst_clk_samp,              -- reset signal synchronized to the clk_samp signal
                      nsamp_clk_tx            => nsamp_clk_tx,              -- number of samples to pull from memory (i.e. max address - 1)
                      spd_clk_tx              => spd_clk_tx,                -- current value of speed - i.e. scalar to divide clk_samp with to generate output 
                      en_clk_samp             => en_clk_samp,               -- indicates that the next rising edge of clk_tx will contain valid sample value
                      samp_gen_go_clk_rx      => samp_gen_go_clk_rx,        -- asserted continuously betwen the receipt of a  *C and a *H command, or pulsed for PW clocks after *G
                      samp                    => samp,                      -- the current sample being output. only valid when samp_val is asserted
                      samp_valid              => samp_valid,                -- indicates that the sample is valid
                      samp_gen_samp_ram_addr  => samp_gen_samp_ram_addr,
                      samp_gen_samp_ram_dout  => samp_gen_samp_ram_data,                   
                      led_out                 => led_out_samp_gen           -- when enabled, these LEDs reflect the top 8 bits of the output sample
                   );    
                   
       -- depending on the value of "LED_USE" (selected at the time of synthesis) the LEDs will either display the output of the UART_recvr or the value of the sample generator
       led_use_1: if (LED_USE = String'("RXFB")) generate
          led_out_o <= rx_data when ((rx_data_rdy = '1') and rising_edge(clk_rx));
       end generate;
       led_use_2: if (LED_USE = String'("TXDR")) generate
          led_out_o <= led_out_samp_gen;
       end generate;
                   
       -- instantiate the output buffers for the LEDs
       mkLEDBuf: for i in 0 to 7 generate
          ledBuf: OBUF port map (I=>led_out_o(i), O=>led_pins(i));
       end generate;
                   
       -- instantiate the SPI controller for the DAC
       spiclkBuf:  OBUF port map (I=>spi_clk_o,     O=>spi_clk_pin);
       spimosiBuf: OBUF port map (I=>SPI_MOSI_o,    O=>spi_mosi_pin);
       DACcsBuf:   OBUF port map (I=>DAC_cs_n_o,    O=>dac_cs_n_pin);
       DACclrBuf:  OBUF port map (I=>DAC_clr_n_o,   O=>dac_clr_n_pin);

       -- instantiate the SPI controller for the DAC
       dac_spi_i0: DAC_SPI
          port map ( clk_tx       => clk_tx,              -- transmitter clock
                    rst_clk_tx    => rst_clk_tx,          -- reset signal synchronized to clk_tx
                    en_clk_samp   => en_clk_samp,         -- indication that the next rising edge of clk_tx will coincide with the rising edge of clk_smap
                    samp          => samp,                -- the current sample being output. Only valid when samp_val is asserted
                    samp_val      => samp_valid,          -- a vaild sample is being output. Asserted for one clk_samp period for each sample
                    SPI_ss_b_o    => SPI_ss_b_o,          -- SPI serial flash chip select - tied to 1 (disabled)
                    spi_clk_o     => spi_clk_o,           -- SPI clock
                    SPI_MOSI_o    => SPI_MOSI_o,          -- SPI master-out-slave-in datum
                    DAC_cs_n_o    => DAC_cs_n_o,          -- DAC SPI chip select (active low)
                    DAC_clr_n_o   => DAC_clr_n_o          -- DAC clear
                   );


    end Behavioral;

