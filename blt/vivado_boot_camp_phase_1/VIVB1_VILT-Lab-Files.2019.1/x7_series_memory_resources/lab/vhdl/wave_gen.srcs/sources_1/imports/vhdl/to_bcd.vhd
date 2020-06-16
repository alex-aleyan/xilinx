--<insert: c:\HW\releasedULD\headers\to_bcd.head>
-- -----------------------------------------------------------------------------
--
-- module:    to_bcd
-- project:   wave_gen
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This module takes a 16 bit number and generates  the
--   Binary-Coded-Decimal version (5  digits).
--   
-- This is intentionally a PAINFULLY inefficient mechanism of doing  this
--   conversion, intended to illustrate the need for multi-cycle  paths.
--   There are many FAR more efficient ways (both in terms of area  and
--   performance) of doing this  conversion.
--   
-- Multicycle and False  Paths
--   This main calculation is structured as a two cycle multi-cycle path
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
use utilities_lib.string_utilities_synth_pkg.all;                  -- string manipulation utilities


LIBRARY STD;
USE STD.textio.all;


entity to_bcd is
    Port ( clk_rx        : in  std_logic;                          -- input clock
           rst_clk_rx    : in  std_logic;                          -- reset synchronized to input clock
           value_val     : in  std_logic;                          -- high when value is to be converted. may only assert every 2nd cycle max
           value         : in  std_logic_vector (15 downto 0);     -- value to be converted
           bcd_out       : out std_logic_vector (18 downto 0)      -- BCD output - 5 digits, 4 bits per digit
          );
end to_bcd;

architecture Behavioral of to_bcd is

       subtype nibble is std_logic_vector(3 downto 0);
       type    nibbleArray is array(3 downto 0) of nibble;
       signal  BCDdigit        : nibbleArray := (others=>(others=>'U'));
       signal  topBCDdigit     : std_logic_vector(2 downto 0) := (others=>'U');
       signal  rmn4            : integer range 0 to  9999 := 0;
       signal  rmn3            : integer range 0 to   999 := 0;
       signal  rmn2            : integer range 0 to    99 := 0;
       
       signal  old_value_valid : std_logic := 'U';
       signal  valid_delay1    : std_logic := 'U';
       
       signal  metaPresent     : boolean := false;

    begin
    
       TenK: process (value)
             variable intValue          : integer range 0 to 65535 := 0;
             variable digit             : std_logic_vector(3 downto 0) := (others=>'U');
             variable remainder         : integer range 0 to 65535 := 0;
             constant MAGNITUDE         : integer := 10_000;
             
          begin
          
             -- verify that all the positions in x are non-meta characters
             metaPresent <= false;
             checkForMeta: for i in 0 to value'length-1 loop
                if (value(i) /= '1') and (value(i) /= '0') then
                   metaPresent <= true;
                end if;
             end loop checkForMeta;
          
			    -- bail if any meta characters are present
             ifMetaPresent: if (metaPresent) then
                report "(to_bcd) Metacharacter present in input - cannot accurately process...";
             else
                 intValue := to_integer(unsigned(value));
                 if (intValue >= (6 * MAGNITUDE)) then
                    digit     := X"6";
                    remainder := intValue - (6 * MAGNITUDE);
                 elsif (intValue >= (5 * MAGNITUDE)) then
                    digit     := X"5";
                    remainder := intValue - (5 * MAGNITUDE);           
                 elsif (intValue >= (4 * MAGNITUDE)) then
                    digit     := X"4";
                    remainder := intValue - (4 * MAGNITUDE);           
                 elsif (intValue >= (3 * MAGNITUDE)) then
                    digit     := X"3";
                    remainder := intValue - (3 * MAGNITUDE);           
                 elsif (intValue >= (2 * MAGNITUDE)) then
                    digit     := X"2";
                    remainder := intValue - (2 * MAGNITUDE);              
                 elsif (intValue >= (1 * MAGNITUDE)) then
                    digit     := X"1";
                    remainder := intValue - (1 * MAGNITUDE);           
                 else
                    digit     := X"0";
                    remainder := intValue;           
                 end if;
                 topBCDdigit <= digit(2 downto 0);
                 rmn4 <= remainder;
             end if ifMetaPresent; 
          end process TenK;

       OneK: process (rmn4)
             variable intValue          : integer range 0 to 65535 := 0;
             variable digit             : std_logic_vector(3 downto 0) := (others=>'U');
             variable remainder         : integer range 0 to 65535 := 0;
             constant MAGNITUDE         : integer := 1_000;
          begin
          
             if (not metaPresent) then
                 intValue := rmn4;
                 if (intValue >= (9 * MAGNITUDE)) then
                    digit     := X"9";
                    remainder := intValue - (9 * MAGNITUDE);
                 elsif (intValue >= (8 * MAGNITUDE)) then
                    digit     := X"8";
                    remainder := intValue - (8 * MAGNITUDE);           
                 elsif (intValue >= (7 * MAGNITUDE)) then
                    digit     := X"7";
                    remainder := intValue - (7 * MAGNITUDE);           
                 elsif (intValue >= (6 * MAGNITUDE)) then           
                    digit     := X"6";
                    remainder := intValue - (6 * MAGNITUDE);
                 elsif (intValue >= (5 * MAGNITUDE)) then
                    digit     := X"5";
                    remainder := intValue - (5 * MAGNITUDE);           
                 elsif (intValue >= (4 * MAGNITUDE)) then
                    digit     := X"4";
                    remainder := intValue - (4 * MAGNITUDE);           
                 elsif (intValue >= (3 * MAGNITUDE)) then
                    digit     := X"3";
                    remainder := intValue - (3 * MAGNITUDE);           
                 elsif (intValue >= (2 * MAGNITUDE)) then
                    digit     := X"2";
                    remainder := intValue - (2 * MAGNITUDE);              
                 elsif (intValue >= (1 * MAGNITUDE)) then
                    digit     := X"1";
                    remainder := intValue - (1 * MAGNITUDE);           
                 else
                    digit     := X"0";
                    remainder := intValue;           
                 end if;
                 BCDdigit(3) <= digit;
                 rmn3 <= remainder;
              end if;
          end process OneK;
          
       Hundr: process (rmn3)
             variable intValue          : integer range 0 to 65535 := 0;
             variable digit             : std_logic_vector(3 downto 0) := (others=>'U');
             variable remainder         : integer range 0 to 65535 := 0;
             constant MAGNITUDE         : integer := 100;
          begin
              if (not metaPresent) then
                 intValue := rmn3;
                 if (intValue >= (9 * MAGNITUDE)) then
                    digit     := X"9";
                    remainder := intValue - (9 * MAGNITUDE);
                 elsif (intValue >= (8 * MAGNITUDE)) then
                    digit     := X"8";
                    remainder := intValue - (8 * MAGNITUDE);           
                 elsif (intValue >= (7 * MAGNITUDE)) then
                    digit     := X"7";
                    remainder := intValue - (7 * MAGNITUDE);           
                 elsif (intValue >= (6 * MAGNITUDE)) then           
                    digit     := X"6";
                    remainder := intValue - (6 * MAGNITUDE);
                 elsif (intValue >= (5 * MAGNITUDE)) then
                    digit     := X"5";
                    remainder := intValue - (5 * MAGNITUDE);           
                 elsif (intValue >= (4 * MAGNITUDE)) then
                    digit     := X"4";
                    remainder := intValue - (4 * MAGNITUDE);           
                 elsif (intValue >= (3 * MAGNITUDE)) then
                    digit     := X"3";
                    remainder := intValue - (3 * MAGNITUDE);           
                 elsif (intValue >= (2 * MAGNITUDE)) then
                    digit     := X"2";
                    remainder := intValue - (2 * MAGNITUDE);              
                 elsif (intValue >= (1 * MAGNITUDE)) then
                    digit     := X"1";
                    remainder := intValue - (1 * MAGNITUDE);           
                 else
                    digit     := X"0";
                    remainder := intValue;           
                 end if;
                 BCDdigit(2) <= digit;
                 rmn2 <= remainder;
              end if;
          end process Hundr;

       TensOnes: process (rmn2)
             variable intValue          : integer range 0 to 65535 := 0;
             variable digit             : std_logic_vector(3 downto 0) := (others=>'U');
             variable remainder         : integer range 0 to 65535 := 0;
             constant MAGNITUDE         : integer := 10;
          begin
              if (not metaPresent) then
                 intValue := rmn2;
                 if (intValue >= (9 * MAGNITUDE)) then
                    digit     := X"9";
                    remainder := intValue - (9 * MAGNITUDE);
                 elsif (intValue >= (8 * MAGNITUDE)) then
                    digit     := X"8";
                    remainder := intValue - (8 * MAGNITUDE);           
                 elsif (intValue >= (7 * MAGNITUDE)) then
                    digit     := X"7";
                    remainder := intValue - (7 * MAGNITUDE);           
                 elsif (intValue >= (6 * MAGNITUDE)) then           
                    digit     := X"6";
                    remainder := intValue - (6 * MAGNITUDE);
                 elsif (intValue >= (5 * MAGNITUDE)) then
                    digit     := X"5";
                    remainder := intValue - (5 * MAGNITUDE);           
                 elsif (intValue >= (4 * MAGNITUDE)) then
                    digit     := X"4";
                    remainder := intValue - (4 * MAGNITUDE);           
                 elsif (intValue >= (3 * MAGNITUDE)) then
                    digit     := X"3";
                    remainder := intValue - (3 * MAGNITUDE);           
                 elsif (intValue >= (2 * MAGNITUDE)) then
                    digit     := X"2";
                    remainder := intValue - (2 * MAGNITUDE);              
                 elsif (intValue >= (1 * MAGNITUDE)) then
                    digit     := X"1";
                    remainder := intValue - (1 * MAGNITUDE);           
                 else
                    digit     := X"0";
                    remainder := intValue;           
                 end if;
                 BCDdigit(1) <= digit;
                 BCDdigit(0) <= std_logic_vector(to_unsigned(remainder,4));
              end if;
          end process TensOnes;
    
       -- assert val_d1 only on the clock after value_val is first asserted
       genDly1: process (clk_rx)
          begin
             if rising_edge(clk_rx) then                              -- test for synchronous events
                if (rst_clk_rx = '1') then                            -- if reset is asserted
                   old_value_valid <= '0';
                   valid_delay1    <= '0';
                else                                                  -- reset not asserted
                   old_value_valid <= value_val;
                   valid_delay1    <= value_val and not old_value_valid;                
                end if;                                               -- end of non-reset activities            
             end if;                                                  -- end of synchronous events        
          end process genDly1;
          
       -- "latch" and drive the BCD output
       drvBCD: process (clk_rx)
          begin
             if rising_edge(clk_rx) then                              -- test for synchronous events
                if (rst_clk_rx = '1') then                            -- if reset is asserted
                   bcd_out <= (others=>'0');                          -- drive all lines to zero
                elsif (valid_delay1 = '1') then                       -- reset not asserted and valid has propogated thru
                   bcd_out <=  topBCDdigit & BCDdigit(3) & BCDdigit(2) & BCDdigit(1) & BCDdigit(0);
                end if;                                               -- end of non-reset activities            
             end if;                                                  -- end of synchronous events        
          end process drvBCD;
          
    end Behavioral;

