--<insert: c:\HW\releasedULD\headers\string_utilities_sim_pkg.head>
-- -----------------------------------------------------------------------------
--
-- module:    string_utilities_sim_pkg
-- project:   utilities
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This package provides a number of  'C'-like string manipulation functions
--   which are NOT synthesizable. This package makes significant use of the
--   TEXTIO package.
--   Included in this package  are:
--     function strAutoResize(s: String) return  String;
--     function substr(str: String; startingPoint, endingPoint : integer)
--                                                             return  String;
--     function strlen(s : String) return  integer;
--     function strdel(str: String; startingPoint, endingPoint : integer)
--                                                             return  String;
--     function strins(str1, str2 : String; startingPoint : integer) 
--                                                            return String;   
--     function strcat(s1, s2: String) return  String;
--     function strpos(s : String; c : character) return  integer;
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

library STD;
use STD.TEXTIO.all;

use work.string_utilities_synth_pkg.all;

package string_utilities_sim_pkg is

       -- 'C'-like string manipulation functions
       function strAutoResize(s: String) return String;
       function substr(str: String; startingPoint, endingPoint : integer) return String;
       function strlen(s : String) return integer;
       function strdel(str: String; startingPoint, endingPoint : integer) return String;
       function strins(str1, str2 : String; startingPoint : integer) return String;
       function strcat(s1, s2: String) return String;
       function strpos(s : String; c : character) return integer;
     function strposnext(s : String; c : character; pos : integer) return integer;
       function strposlast(s : String; c : character) return integer;
       function strdup(c : character; n : integer) return String;
       function realToString (r : real) return String;
       function strcmp(s1, s2 : String) return integer;

end string_utilities_sim_pkg;


package body string_utilities_sim_pkg is


    -- ***********************************************************
    --  Function: strAutoResize
    --  Inputs  : Text String
    --  Outputs : String
    --  Description : trims the string size to the proper length
    --       and returns a string of the exact length (nulls removed)
    -- *************************************************************
    function strAutoResize(s: String) return String is
          variable l : line;
          variable c : character;
       begin
          deallocate(l);                      -- cleanup from the last pass
          for i in 1 to s'length loop
             c := s(i);
             if (c /= character'val(0)) then  -- if it's not a null character
                write(l,c);                   -- place it into the pointer space
             end if;
          end loop;
          return(l.all);
       end function strAutoResize;
      
    -- ***********************************************************
    --  Function: strdup
    --  Inputs  : char int
    --  Outputs : String
    --  Description : returns a string comprised of n occurrences of c
    -- *************************************************************      
   function strdup(c : character; n : integer) return String is
         variable l : line;
      begin
         for i in 1 to n loop
           write(l,c);                   -- place it into the pointer space
        end loop;
        return(l.all);
      end function strdup;
          
    -- ***********************************************************
    --  Function: substr
    --  Inputs  : Text String, start from, end at positions
    --  Outputs : String
    --  Description : returns the portion of the string between the 
    --       specified starting and ending points
    -- *************************************************************
    function substr(str: String; startingPoint, endingPoint : integer) return String is
       begin
          if ((startingPoint <= endingPoint) and (endingPoint <= str'length)) then
             return (str(startingPoint to endingPoint));
          else 
             return ("substr: bad starting/ending points");
          end if;
       end function substr;
       
    -- ***********************************************************
    --  Function: strlen
    --  Inputs  : Text String, start from, end at positions
    --  Outputs : String
    --  Description : 
    -- strlen differs from string'length as it only reports the length of the printable characters
    -- in the field. That is, any non-defined spaces in the string are filled with null. This routine
    -- counts the non-null characters
    -- *************************************************************
    function strlen(s : String) return integer is
          variable count : integer range 0 to 1023 := 0;
       begin
          for i in 1 to s'length loop
             if (s(i) /= nul) then
                count := count + 1;
             end if;        
          end loop;
          return count;
       end function strlen;       

    -- ***********************************************************
    --  Function: strcat
    --  Inputs  : Text String1, String2
    --  Outputs : String
    --  Description : catonates string1 with string 2
    -- *************************************************************
    function strcat(s1, s2: String) return String is
       begin
          return (s1 & s2);
       end function strcat;
          
    -- ***********************************************************
    --  Function: strdel
    --  Inputs  : Text String, start from, end at positions
    --  Outputs : String
    --  Description : 
    --    conjugate function of substr.
    --       returns the passed string minus the characters between 
    --       starting point to ending point
    -- *************************************************************        
    function strdel(str: String; startingPoint, endingPoint : integer) return String is
          variable l  : line;
       begin       
          if ((startingPoint <= endingPoint) and (endingPoint <= str'length)) then
             -- copy from the beginning of the string to the starting point
             for i in str'left to startingPoint-1 loop
                write(l,str(i));
             end loop;
             -- copy from the ending point to the end of the passed length
             for i in endingPoint+1 to str'length loop
                write(l,str(i));
             end loop;
             -- since characters have been removed, we have garbage at the end of the string
             for i in (endingPoint-startingPoint-1) to str'length loop
                write(l,NUL);
             end loop;
             return (l.all);
          else
             return("strdel: starting/ending position error");
          end if;
       end function strdel;
          
    -- ***********************************************************
    --  Function: strins
    --  Inputs  : String1, String2, insertion point
    --  Outputs : String
    --  Description : inserts str2 into str1 at startingPoint
    --    return length of 64 characters max.
    -- *************************************************************           
    function strins(str1, str2 : String; startingPoint : integer) return String is
        variable l : line;
       begin
         -- early termination
        if (str1'length = 0) then
           return str2;
        elsif (str1'length < startingPoint) then
           return strcat(str1,str2);
        end if;
        
        if (str2'length = 0) then
           return str1;
        end if;
        
        -- generate the line
          for i in 1 to startingPoint loop
             write(l,str1(i));
          end loop;
        
          for i in 1 to str2'length loop       
             write(l,str2(i));
          end loop;
        
          for i in startingPoint+1 to str1'length loop
             write(l,str1(i));
          end loop;
        
          return (l.all);
          -- or
          --return(substr(str1,1,startingPoint) & str2 & substr(str1,startingPoint+1,strlen(str1)));
       end function strins;
       
    -- ***********************************************************
    --  Function: strpos
    --  Inputs  : String, character
    --  Outputs : integer
    --  Description : finds the first occurances of character in
    --    string and returns its integer position. 0 if character
    --    not found
    -- *************************************************************        
    function strpos(s : String; c : character) return integer is
       begin
          spos: for i in 1 to s'length loop
             if (s(i) = c) then
                return i;
             end if;
          end loop;
          return 0;
       end function strpos;
      
    -- ***********************************************************
    --  Function: strposnext
    --  Inputs  : String, character, integer
    --  Outputs : integer
    --  Description : finds the first occurances after the pos position
   --    of character in string and returns its integer position. 
   --    0 if character not found
    -- *************************************************************          
    function strposnext (s   : string;
                         c   : character;
                     pos : integer) return integer is
      begin
          spos: for i in pos to s'length loop
             if (s(i) = c) then
                return i;
             end if;
          end loop;
          return 0;
      end strposnext;

    -- ***********************************************************
    --  Function: strposlast
    --  Inputs  : String, character
    --  Outputs : integer
    --  Description : finds the last occurances 
   --    of character in string and returns its integer position. 
   --    0 if character not found
    -- *************************************************************     
    function strposlast (s   : string;
                         c   : character) return integer is
     begin
          spos: for i in s'length downto 1 loop
             if (s(i) = c) then
                return i;
             end if;
          end loop;
          return 0;
     end strposlast;  

    -- ***********************************************************
    --  Function: realToString
    --  Inputs  : real
    --  Outputs : String
    --  Description : returns a "normal" view of a real instead 
   --    of a exponential form 
    -- *************************************************************  
  -- future - write out in engineering notation
     function realToString (r : real) return String is
           variable x            : string(1 to 13);
           variable sign         : string(1 to 1);
          variable offset       : integer range 0 to 1;
          variable numberString : string(1 to 7);
          variable exp          : string(1 to 2);
          variable expPos       : boolean;
          variable expValue     : integer range 0 to 32;
          variable radixPosition: integer range 0 to 32;
          variable padding      : string(1 to 32);
          variable returnString : string(1 to 32);
        begin        
       
            -- convert the real number into a string
            x := real'image(r);  
            
            -- pull the sign
            if (x(1) = '-') then
               offset := 1;
              sign   := "-";
              -- zero sometimesnonIO returned as a negative - handle this special case
              if (strcmp("-0.000000e+00",x) = 0) then      
                 sign := "+";
              end if;
            else 
               offset := 0;
              sign   := "+";
            end if;
            
            -- build the mantissa without the decimal point
            numberString(1) := x(1+offset);
            for i in 3 to 8 loop
               numberString(i-1) := x(i+offset);
            end loop;
            
            -- extract the exponent
            if (x(10+offset) = '+') then
               expPos := true;
            else 
               expPos := false;
            end if;
            exp(1) := x(11+offset);
            exp(2) := x(12+offset);
            
            -- write as a reasonable number
            if (not expPos) then
               expValue := charToValue(exp(1)) * 10 + charToValue(exp(2));
              returnString := "0."&strdup('0',expValue)&numberString;               
            else            
               expValue := charToValue(exp(1)) * 10 + charToValue(exp(2));
              if (expValue > 6) then
                 returnString := numberString&strdup('0',expValue);
              else
                 returnString := numberString;
              end if;
              -- insert the radix point in the right place
              radixPosition := 1 + expValue;       
              returnString := strins(returnString,".",radixPosition);
            end if;
            returnString := strcat(sign,returnString);
            return strAutoResize(returnString);
       end function realToString;
       
     function strcmp(s1, s2 : String) return integer is
           variable compareLength : integer;
        begin        
          if (s1'length <= s2'length) then
             compareLength := s1'length;
          else
             compareLength := s2'length;
          end if;
          
          for i in 1 to compareLength loop
             if (s1(i) < s2(i)) then
               return -1;
            elsif (s1(i) > s2(i)) then
               return +1;
            else
              -- no action
            end if;
          end loop;
          
          -- see if there is anything left over
          if (s1'length = s2'length) then
             return 0;            -- exact match
          elsif (s1'length < s2'length) then
             return -1;
          else
             return +1;
          end if;
          
       end function strcmp;
             

end string_utilities_sim_pkg;
