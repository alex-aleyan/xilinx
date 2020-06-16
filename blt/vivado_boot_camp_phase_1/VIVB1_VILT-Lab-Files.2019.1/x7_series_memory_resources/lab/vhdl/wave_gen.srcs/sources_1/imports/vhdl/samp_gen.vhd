--<insert: c:\HW\releasedULD\headers\samp_gen.head>
-- -----------------------------------------------------------------------------
--
-- module:    samp_gen
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This generates the output samples of the wave  generator.
--   
-- When enabled via the samp_gen_go_clk_rx signal, which is either  pulsed
--   for 3 clocks or continuously asserted, it will cycle through all  nsamp
--   samples at a rate of one sample every 'speed' cycles of the  prescaled
--   clock (clk_samp), which is synchronous to clk_tx, but asserted only  one
--   out of every 'prescale'  cycles.
--   
-- The samp_gen_go_clk_rx signal must be synchronized to clk_tx, and  held
--   until the next rising edge of clk_samp (as indicated by the  en_clk_samp)
--   signal.
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


library WORK;
use work.wave_gen_pkg.ALL;


entity samp_gen is
    generic (NSAMP_WIDTH : integer := 10);
     Port ( clk_tx                   : in  std_logic;                       -- clock associated with the transmit clock
            rst_clk_tx               : in  std_logic;                       -- reset signal synchronized to the transmit clock
            clk_samp                 : in  std_logic;                       -- sample clock
            rst_clk_samp             : in  std_logic;                       -- reset signal synchronized to the clk_samp signal
            nsamp_clk_tx             : in  std_logic_vector (NSAMP_WIDTH-1 downto 0); -- number of samples to pull from memory (i.e. max address - 1)
            spd_clk_tx               : in  std_logic_vector (15 downto 0);  -- current value of speed - i.e. scalar to divide clk_samp with to generate output 
            en_clk_samp              : in  std_logic;                       -- indicates that the next rising edge of clk_tx will contain valid sample value
            samp_gen_go_clk_rx       : in  std_logic;                       -- asserted continuously betwen the receipt of a  *C and a *H command, or pulsed for PW clocks after *G
            samp                     : out std_logic_vector (15 downto 0);  -- the current sample being output. only valid when samp_val is asserted
            samp_valid               : out std_logic;                       -- indicates that the sample is valid
            samp_gen_samp_ram_addr   : out std_logic_vector(NSAMP_WIDTH-1 downto 0); -- address to the data RAM
            samp_gen_samp_ram_dout   : in  std_logic_vector(15 downto 0);   -- data from RAM
            led_out                  : out std_logic_vector (7 downto 0)    -- when enabled, these LEDs reflect the top 8 bits of the output sample
           );
end samp_gen;


architecture Behavioral of samp_gen is

       signal samp_gen_go_clk_tx     : std_logic := 'U';
       signal do_transfer            : std_logic := 'U';
       signal transfer_in_progress   : std_logic := 'U';
       signal transfer_complete      : std_logic := 'U';
       signal count_done             : std_logic := 'U';
       signal clear_transfer_request : std_logic := 'U';
       signal sample_enable          : std_logic := 'U';     -- signal occurs once every speed_clk_tx occurance of clk_samp
       signal led_clk_samp           : std_logic_vector(7 downto 0);
       signal led_clk_tx             : std_logic_vector(7 downto 0);

    begin
    
       -- bring the start signal for the generator into the tx clock domain
       meta_harden_samp_gen_go_i0: meta_harden port map(clk_dst=>clk_tx, rst_dst=>rst_clk_tx, signal_src=>samp_gen_go_clk_rx, signal_dst=>samp_gen_go_clk_tx);
       
       -- construct a one-shot to capture the "go" signal and hold until either "go" signal is dropped (as a result of *H) or
       -- the transfer completes
       oneSht: process (clk_tx)
          begin
             if rising_edge(clk_tx) then                     -- synchronize with the transmit clock
                if (rst_clk_tx = '1') then                   -- is the reset asserted?
                   do_transfer <= '0';                       -- stop the transfer where it is
                else                                         -- reset is off, do non-reset tasks
                   if ((en_clk_samp = '1') and (samp_gen_go_clk_tx = '1')) then -- was a transfer requested?
                      do_transfer <= '1';                    -- enable the transfer
                   elsif (clear_transfer_request = '1') then -- the do_transfer request is being processed. clear for future requests
                      do_transfer <= '0';                    -- clear the transfer
                   elsif (transfer_complete = '1') then      -- if the "go" signal has been deasserted, then only 1 pass through is expected
                      do_transfer <= '0';                    -- discontinue the transfer at the end of the single pass
                   end if;                                   -- end of transfer control
                end if;                                      -- end of reset/non-reset events
             end if;                                         -- end of synchronous events
          end process oneSht;
          
       --
       -- the xfer process 
       -- note: signals from the clk_tx domain do not need to be synchronized as clk_samp is directly derived from
       --       the clk_tx signal
       xfer: process(clk_samp) 
             type VALID_STATES is (IDLE, XFER);
             variable state    : VALID_STATES  := IDLE;      
          begin
             if rising_edge(clk_samp) then                   -- run at the clk_samp rate
                if (rst_clk_samp = '1') then                 -- is the reset asserted?
                   state := IDLE;                            -- return to the idle state
                else                                         -- reset is NOT asserted - do "normal" tasks
                   clear_transfer_request <= '0';            -- leave the transfer request alone unless...
                   case (state) is                           -- what are we doing?
                      when IDLE =>                           -- stay here and wait for a new transfer request
                         transfer_in_progress <= '0';        -- transfer has not yet begun
                         transfer_complete <= '0';           -- since transfer has begun, it cannot yet be complete
                         if (do_transfer = '1') then         -- has a new transfer been requested?
                            clear_transfer_request <= '1';   -- since we've now taken action on the signal, clear it for future requests
                            state := XFER;                   -- advance to the transfer state
                         end if;                             -- end of check for start of transfer
                         
                      when XFER =>                           -- do the transfer
                         transfer_in_progress <= '1';        -- indicate that we're doing the transfer
                         transfer_complete <= '0';           -- therefore, by definition, the transfer is NOT complete
                         if (count_done = '1') then          -- if one full pass through the data RAM is complete and
                            transfer_complete <= '1';        -- raise the transfer complete flag
                            if (do_transfer = '0') then      -- no more transfers are requested
                               transfer_in_progress <= '0';  -- indicate that the transfer is complete
                               state := IDLE;                -- return to the idle state
                            else                             -- otherwise more transfers requested
                               state := XFER;                -- remain in this state (this line is superfluous)
                            end if;                          -- end of check for transfer condition
                         end if;                             -- end of check for competion
                            
                      when others =>
                         state := IDLE;                      -- for clean recovery
                         
                   end case;
                end if;                                      -- end of reset/non-reset events
             end if;                                         -- end of clk_samp synchronous events
          end process xfer;
          
       --
       -- sample enable
       -- since we don't necessarily read from the RAM on every clk_samp, but rather, every speed_clk_tx, we need
       -- to generate an internal RAM access enable. 
       smpEn: process (clk_samp)
             variable terminal_value    : integer range 0 to 65535 := 0;
             variable sub_sample_count  : integer range 0 to 65535 := 0;
          begin
             if rising_edge(clk_samp) then                   -- do events that are synch to the clk_samp domain
                if (rst_clk_samp = '1') then                 -- is a reset active?
                   sub_sample_count := 0;                    -- zero the counter
                   sample_enable    <= '0';                  -- disable the sample enable
                else                                         -- no reset, do "normal" activities
                   terminal_value := to_integer(unsigned(spd_clk_tx))-1;    -- we'll work in integer domain
                   if (transfer_in_progress = '1') then      -- only need to generate samples when a transfer is in progress
                      if (sub_sample_count = terminal_value) then  -- are we done counting?
                         sub_sample_count := 0;              -- reset the count
                         sample_enable    <= '1';            -- take a sample
                      else                                   -- still counting
                         sample_enable       <= '0';         -- don't sample now
                         sub_sample_count := sub_sample_count + 1; -- increment the count
                      end if;                                -- end of determining enable for addrGen process
                   end if;                                   -- end of transfer in progress check
                end if;                                      -- end of reset/"normal" activities
             end if;                                         -- end of synchronous events
          end process smpEn;
       --
       -- address generator (counter)
       -- inputs: enable, value to count to, reset
       -- outputs: count done, address
       -- a shift register is used to select the number of clock cycles of delay between the time that the valid address
       -- is presented to the data RAM and the time the data is received.
       addrGen: process (clk_samp)
             variable internal_count       : integer range 0 to 1024 := 0;  -- max range of addresses  
             variable address_limit        : integer range 0 to 1024 := 0;  -- latched value of address endpoint
             variable valid_data_status    : std_logic := 'U';
             variable valid_data_delay_sr  : std_logic_vector(3 downto 0) := (others=>'0');      -- mechanism for variable delay to adjust to read cycle
          begin
             if rising_edge(clk_samp) then                         -- this process operates synchonously to the clk_samp
                if (rst_clk_samp = '1') then                       -- is a reset active?
                   internal_count := 0;
                   valid_data_status := '0';
                   valid_data_delay_sr := (others=>'0');
                   count_done <= '0';
                   samp_valid <= '0';
                   samp_gen_samp_ram_addr <= (others=>'0');
                else                                            -- no reset, do "normal" activities             
                   address_limit := to_integer(unsigned(nsamp_clk_tx))-1;   -- figure out where to stop
                   if (transfer_in_progress = '1') then            -- if we're in the process of transferring data
                      valid_data_status := '0';                    -- data isn't valid unless...
                      if (sample_enable = '1') then                -- only do this every once in a while
                         valid_data_status := '1';                 -- data will become valid
                         internal_count := internal_count + 1;     -- increment the current count
                         count_done <= '0';                        -- count isn't done unless..
                         if (internal_count > address_limit) then  -- are we done counting?
--                          valid_data_status := '0';              -- data will no longer be valid
                            internal_count := 0;                   -- reset the count
                            count_done <= '1';                     -- indicate that the count completed
                         end if;                                   -- done checking count limit
                      else                                         -- not transferring data - hold in the equivalent of a reset
                         --internal_count := 0;                    -- always start at address 0 when coming out of reset
                         count_done <= '0';                        -- count is not done (mostly because it hasn't started!)                      
                      end if;                                      -- done with transferring data
                      valid_data_delay_sr := valid_data_delay_sr(valid_data_delay_sr'length-2 downto 0) & valid_data_status; -- begin to shift in the valid data marker              
                      samp_valid    <= valid_data_delay_sr(0);     -- the proper "tap" to align the valid data marker with the data from RAM              
                      samp_gen_samp_ram_addr <= std_logic_vector(to_unsigned(internal_count,10));   -- convert the integer internal count to a slv address for the data BRAM
                   end if;                                         -- end of enable
                end if;                                            -- end of "normal activities"
             end if;                                               -- end of synchronous events
          end process addrGen;
       samp <= samp_gen_samp_ram_dout;                             -- pass the data through. Alignment with samp_valid is managed in the addrGen process
          
       -- drive the LED array with the most significant byte of data from the RAM - on the clk_samp domain
        ltchLEDs: process (clk_samp)
          begin
             if rising_edge(clk_samp) then
                if (rst_clk_samp = '1') then
                   led_clk_samp <= (others=>'0');
                elsif (transfer_in_progress = '1') then
                   led_clk_samp <= samp_gen_samp_ram_dout(15 downto 8);
                end if;
             end if;
          end process ltchLEDs;

        -- resynchronize the LEDs onto the clk_tx domain, which is a global clock. The clock crossing between these domains is synchronous
        -- pipeline once more to allow for routing across the chip
        resyncLEDs: process (clk_tx)
          begin
             if rising_edge(clk_tx) then
                if (rst_clk_tx = '1') then
                   led_clk_tx  <= (others=>'0');
                   led_out     <= (others=>'0');
                else
                   led_clk_tx  <= led_clk_samp;
                   led_out     <= led_clk_tx;
                end if;
             end if;
          end process resyncLEDs;
       
    end Behavioral;

