--<insert: c:\HW\releasedULD\headers\string_utilities_synth_pkg.head>
-- -----------------------------------------------------------------------------
--
-- module:    string_utilities_synth_pkg
-- project:   utilities
-- company:   Xilinx, Inc.
-- author:    WK, AW
-- 
-- comment:
--   This package provides a number of  string manipulation functions which are
--   synthesizable. 
--
-- test functions
--   ***tests if passed character is a valid (case insensitive) hexadecimal character
--   function isHexChar(c : in character) return boolean;    
--   *** tests if passed slv is a valid (case insensitive) hexadecimal
--   function isHexChar(slv : in std_logic_vector) return boolean;    
--
--   character conversion functions
--   *** converts the passed integer into the corresponding ASCII character
--   function intToChar(x : in integer)return character;  
--   function intToPrintableChar(x : in integer) return character
--   *** converts the passed integer into its corresponding Hexadecimal character. int 0<=x<=15
--   function intToHexChar(x : in integer) return character;
--   
--   *** converts the passed character into an integer;
--   function charToInt(c : in character) return integer;
--   function charToSlv(c : character) return std_logic_vector;
--   function charToString(c : character) return string;
--   *** converts passed character into a value between 0 and 15   
--   function charToHexValue(x : in character) return integer;  
--
--   function hexCharToSlv(c : character) return std_logic_vector;
--   function hexStringToSlv(s : String) return std_logic_vector;
--   function slToChar(x : std_logic) return Character;
--   function slvToChar(slv_value : std_logic_vector) return Character;
--   function slvToDecChar (x : std_logic_vector) return Character;
--   function slvToHexChar (x : std_logic_vector(3 downto 0)) return Character;
--   *** converts passed slv into a value between 0 and 15      
--   function slvToHexValue(x : in std_logic_vector) return integer;  
--   function slvToString(x:std_logic_vector) return String;
--   function slvToHexString(slv_value : std_logic_vector) return String;
--  
--   function strToInt(s : string) return integer;
--
--   Utility:
--   function areMetaChars (x : std_logic_vector) return boolean;
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
use IEEE.NUMERIC_STD.all;

package string_utilities_synth_pkg is
                 
    -- test functions
    function isHexChar(c : in character) return boolean;                 -- tests if passed character is a valid (case insensitive) hexadecimal character
    function isHexChar(slv : in std_logic_vector) return boolean;        -- tests if passed slv is a valid (case insensitive) hexadecimal character
       
    -- conversion functions
    function intToChar(x : in integer) return character;                 -- converts the passed integer into the corresponding ASCII character
    function intToHexChar(x : in integer) return character;              -- converts the passed integer into its corresponding Hexadecimal character. int 0<=x<=15
    
    function charToInt(c : in character) return integer;                 -- converts the passed character into an integer (ASCII equivalent)  
    function charToValue(x : in character) return integer;               -- converts the passed character into an integer value (0-9)
    function charToSlv(c : character) return std_logic_vector;
    function charToString(c : character) return string;    
    --function charToSlv(constant x: character) return std_logic_vector;
    --procedure charToSlv(variable x: in character; variable y: out std_logic_vector);
    function charToHexValue(x : in character) return integer;            -- converts passed character into a value between 0 and 15  
    
    function hexCharToSlv(c : character) return std_logic_vector;
    function hexStringToSlv(s : String) return std_logic_vector;
    function hexStringToInt(s : string) return integer;
    function hexCharToInt(c : character) return integer;
    
    function slToChar(x : std_logic) return Character;
    function slvToChar(slv_value : std_logic_vector) return Character;
    function slvCharToSlv(x : std_logic_vector) return std_logic_vector;
    function slvPrintableCharToSlv(x : std_logic_vector) return std_logic_vector;
    function slvToDecChar (x : std_logic_vector) return Character;
    function slvToHexChar (x : std_logic_vector(3 downto 0)) return Character;    
    function slvToHexValue(x : in std_logic_vector) return integer;      -- converts passed slv into a value between 0 and 15  
    function slvToString(x:std_logic_vector) return String; 
    function slvToHexString(slv_value : std_logic_vector) return String;
    function slvToInt(slv_value : std_logic_vector) return integer;
    function slvToIntString (slv_value : std_logic_vector; size : integer) return string;
    
    function strToInt(s : string) return integer;
   
    function convSlvToHex (slv: std_logic_vector) return string;
    
    function areMetaChars (x : std_logic_vector) return boolean;
    
    -- Declare constants
    type hexLengthArray is array(0 to 15) of character;
    
   -- remove metacharacters
   function softenMeta(slv_value : std_logic_vector) return std_logic_vector;    

    -- Declare constants
    constant hexDigitCharacters : hexLengthArray := ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
    
    constant slvNUL               : std_logic_vector(7 downto 0) := X"00";        -- null
    constant slvSOH               : std_logic_vector(7 downto 0) := X"01";        -- start of heading
    constant slvSTX               : std_logic_vector(7 downto 0) := X"02";        -- start of text
    constant slvETX               : std_logic_vector(7 downto 0) := X"03";        -- end of text
    constant slvEOT               : std_logic_vector(7 downto 0) := X"04";        -- end of transmission
    constant slvENQ               : std_logic_vector(7 downto 0) := X"05";        -- enquiry
    constant slvACK               : std_logic_vector(7 downto 0) := X"06";        -- acknowledge
    constant slvBEL               : std_logic_vector(7 downto 0) := X"07";        -- bell
    constant slvBS                : std_logic_vector(7 downto 0) := X"08";        -- backspace
    constant slvTAB               : std_logic_vector(7 downto 0) := X"09";        -- horizontal tab
    constant slvLF                : std_logic_vector(7 downto 0) := X"0A";        -- line feed
    constant slvVT                : std_logic_vector(7 downto 0) := X"0B";        -- vertical tab
    constant slvFF                : std_logic_vector(7 downto 0) := X"0C";        -- form feed
    constant slvCR                : std_logic_vector(7 downto 0) := X"0D";        -- carriage return
    constant slvSO                : std_logic_vector(7 downto 0) := X"0E";        -- shift out
    constant slvSI                : std_logic_vector(7 downto 0) := X"0F";        -- shift in

    constant slvDLE               : std_logic_vector(7 downto 0) := X"10";        -- data link escape
    constant slvDC1               : std_logic_vector(7 downto 0) := X"11";        -- device control 1 
    constant slvDC2               : std_logic_vector(7 downto 0) := X"12";        -- device control 2 
    constant slvDC3               : std_logic_vector(7 downto 0) := X"13";        -- device control 3 
    constant slvDC4               : std_logic_vector(7 downto 0) := X"14";        -- device control 4
    constant slvNAK               : std_logic_vector(7 downto 0) := X"15";        -- negative acknowledge
    constant slvSYN               : std_logic_vector(7 downto 0) := X"16";        -- synchronous idle
    constant slvETB               : std_logic_vector(7 downto 0) := X"17";        -- end of transmission block
    constant slvCAN               : std_logic_vector(7 downto 0) := X"18";        -- cancel
    constant slvEM                : std_logic_vector(7 downto 0) := X"19";        -- end of medium
    constant slvSUB               : std_logic_vector(7 downto 0) := X"1A";        -- substitute
    constant slvESC               : std_logic_vector(7 downto 0) := X"1B";        -- escape
    constant slvFS                : std_logic_vector(7 downto 0) := X"1C";        -- file separator
    constant slvGS                : std_logic_vector(7 downto 0) := X"1D";        -- group separator
    constant slvRS                : std_logic_vector(7 downto 0) := X"1E";        -- record separator
    constant slvUS                : std_logic_vector(7 downto 0) := X"1F";        -- unit separator

    constant slvSPACE             : std_logic_vector(7 downto 0) := X"20";        -- space character
    constant slvEXCLAMATION       : std_logic_vector(7 downto 0) := X"21";        -- ! - exclamation point
    constant slvDOUBLEQUOTE       : std_logic_vector(7 downto 0) := X"22";        -- " - double quote
    constant slvHASH              : std_logic_vector(7 downto 0) := X"23";        -- # - hash or pound 
    constant slvDOLLAR            : std_logic_vector(7 downto 0) := X"24";        -- $ - dollar symbol
    constant slvPERCENT           : std_logic_vector(7 downto 0) := X"25";        -- % - percent symbol
    constant slvAMPERSAND         : std_logic_vector(7 downto 0) := X"26";        -- & - ampersand symbol
    constant slvSINGLEQUOTE       : std_logic_vector(7 downto 0) := X"27";        -- ' - single quote
    constant slvTIC               : std_logic_vector(7 downto 0) := X"27";        -- ' - single quote (tic mark)
    constant slvOPENPARENTHESIS   : std_logic_vector(7 downto 0) := X"28";        -- ( - opening parenthasis
    constant slvCLOSEPARENTHESIS  : std_logic_vector(7 downto 0) := X"29";        -- ) - closing parenthasis
    constant slvASTERISK          : std_logic_vector(7 downto 0) := X"2A";        -- * - asterisk
    constant slvPLUS              : std_logic_vector(7 downto 0) := X"2B";        -- + - plus sign
    constant slvCOMMA             : std_logic_vector(7 downto 0) := X"2C";        -- , - comma
    constant slvMINUS             : std_logic_vector(7 downto 0) := X"2D";        -- - - minus sign
    constant slvDASH              : std_logic_vector(7 downto 0) := X"2D";        -- - - minus sign (dash)  
    constant slvHYPHEN            : std_logic_vector(7 downto 0) := X"2D";        -- - - minus sign (hyphen)
    constant slvPERIOD            : std_logic_vector(7 downto 0) := X"2E";        -- . - period symbol
    constant slvDOT               : std_logic_vector(7 downto 0) := X"2E";        -- . - period symbol  
    constant slvPOINT             : std_logic_vector(7 downto 0) := X"2E";        -- . - period symbol  
    constant slvFORWARDSLASH      : std_logic_vector(7 downto 0) := X"2F";        -- / - forward slash

    constant slvZERO              : std_logic_vector(7 downto 0) := X"30";        -- 0 - zero character
    constant slvONE               : std_logic_vector(7 downto 0) := X"31";        -- 1 - one character
    constant slvTWO               : std_logic_vector(7 downto 0) := X"32";        -- 2 - two character
    constant slvTHREE             : std_logic_vector(7 downto 0) := X"33";        -- 3 - three character
    constant slvFOUR              : std_logic_vector(7 downto 0) := X"34";        -- 4 - four character
    constant slvFIVE              : std_logic_vector(7 downto 0) := X"35";        -- 5 - five character
    constant slvSIX               : std_logic_vector(7 downto 0) := X"36";        -- 6 - six character
    constant slvSEVEN             : std_logic_vector(7 downto 0) := X"37";        -- 7 - seven character
    constant slvEIGHT             : std_logic_vector(7 downto 0) := X"38";        -- 8 - eight character
    constant slvNINE              : std_logic_vector(7 downto 0) := X"39";        -- 9 - nine character
    constant slvCOLON             : std_logic_vector(7 downto 0) := X"3A";        -- : - colon character
    constant slvSEMICOLON         : std_logic_vector(7 downto 0) := X"3B";        -- ; - semi-colon character
    constant slvLESSTHAN          : std_logic_vector(7 downto 0) := X"3C";        -- < - less than character
    constant slvEQUAL             : std_logic_vector(7 downto 0) := X"3D";        -- = - equal character
    constant slvEQUALS            : std_logic_vector(7 downto 0) := X"3D";        -- = - equal character  
    constant slvGREATERTHAN       : std_logic_vector(7 downto 0) := X"3E";        -- > - greater than character
    constant slvQUESTIONMARK      : std_logic_vector(7 downto 0) := X"3F";        -- ? - question mark

    constant slvATSIGN            : std_logic_vector(7 downto 0) := X"40";        -- @ - at sign
    constant slvUpperA            : std_logic_vector(7 downto 0) := X"41";        -- A - Upper case (capital) A
    constant slvUpperB            : std_logic_vector(7 downto 0) := X"42";        -- B - Upper case (capital) B
    constant slvUpperC            : std_logic_vector(7 downto 0) := X"43";        -- C - Upper case (capital) C
    constant slvUpperD            : std_logic_vector(7 downto 0) := X"44";        -- D - Upper case (capital) D
    constant slvUpperE            : std_logic_vector(7 downto 0) := X"45";        -- E - Upper case (capital) E
    constant slvUpperF            : std_logic_vector(7 downto 0) := X"46";        -- F - Upper case (capital) F
    constant slvUpperG            : std_logic_vector(7 downto 0) := X"47";        -- G - Upper case (capital) G
    constant slvUpperH            : std_logic_vector(7 downto 0) := X"48";        -- H - Upper case (capital) H
    constant slvUpperI            : std_logic_vector(7 downto 0) := X"49";        -- I - Upper case (capital) I
    constant slvUpperJ            : std_logic_vector(7 downto 0) := X"4A";        -- J - Upper case (capital) J
    constant slvUpperK            : std_logic_vector(7 downto 0) := X"4B";        -- K - Upper case (capital) K
    constant slvUpperL            : std_logic_vector(7 downto 0) := X"4C";        -- L - Upper case (capital) L
    constant slvUpperM            : std_logic_vector(7 downto 0) := X"4D";        -- M - Upper case (capital) M
    constant slvUpperN            : std_logic_vector(7 downto 0) := X"4E";        -- N - Upper case (capital) N
    constant slvUpperO            : std_logic_vector(7 downto 0) := X"4F";        -- O - Upper case (capital) O

    constant slvUpperP            : std_logic_vector(7 downto 0) := X"50";        -- P - Upper case (captial) P
    constant slvUpperQ            : std_logic_vector(7 downto 0) := X"51";        -- Q - Upper case (capital) Q
    constant slvUpperR            : std_logic_vector(7 downto 0) := X"52";        -- R - Upper case (capital) R
    constant slvUpperS            : std_logic_vector(7 downto 0) := X"53";        -- S - Upper case (capital) S
    constant slvUpperT            : std_logic_vector(7 downto 0) := X"54";        -- T - Upper case (capital) T
    constant slvUpperU            : std_logic_vector(7 downto 0) := X"55";        -- U - Upper case (capital) U
    constant slvUpperV            : std_logic_vector(7 downto 0) := X"56";        -- V - Upper case (capital) V
    constant slvUpperW            : std_logic_vector(7 downto 0) := X"57";        -- W - Upper case (capital) W
    constant slvUpperX            : std_logic_vector(7 downto 0) := X"58";        -- X - Upper case (capital) X
    constant slvUpperY            : std_logic_vector(7 downto 0) := X"59";        -- Y - Upper case (capital) Y
    constant slvUpperZ            : std_logic_vector(7 downto 0) := X"5A";        -- Z - Upper case (capital) Z
    constant slvOPENSQUAREBRACKET : std_logic_vector(7 downto 0) := X"5B";        -- [ - opening square bracket
    constant slvBACKSLASH         : std_logic_vector(7 downto 0) := X"5C";        -- \ - backslash
    constant slvCLOSEQUAREBRACKET : std_logic_vector(7 downto 0) := X"5D";        -- ] - closing square bracket
    constant slvCARET             : std_logic_vector(7 downto 0) := X"5E";        -- ^ - caret
    constant slvCARAT             : std_logic_vector(7 downto 0) := X"5E";        -- ^ - caret  
    constant slvUNDERSCORE        : std_logic_vector(7 downto 0) := X"5F";        -- _ - underscore symbol

    constant slvOPENSIGNLEQUOTE   : std_logic_vector(7 downto 0) := X"60";        -- ` - backward single qoute
    constant slvLowerA            : std_logic_vector(7 downto 0) := X"61";        -- a - Lower case a
    constant slvLowerB            : std_logic_vector(7 downto 0) := X"62";        -- b - Lower case b
    constant slvLowerC            : std_logic_vector(7 downto 0) := X"63";        -- c - Lower case c
    constant slvLowerD            : std_logic_vector(7 downto 0) := X"64";        -- d - Lower case d
    constant slvLowerE            : std_logic_vector(7 downto 0) := X"65";        -- e - Lower case e
    constant slvLowerF            : std_logic_vector(7 downto 0) := X"66";        -- f - Lower case f
    constant slvLowerG            : std_logic_vector(7 downto 0) := X"67";        -- g - Lower case g
    constant slvLowerH            : std_logic_vector(7 downto 0) := X"68";        -- h - Lower case h
    constant slvLowerI            : std_logic_vector(7 downto 0) := X"69";        -- i - Lower case i
    constant slvLowerJ            : std_logic_vector(7 downto 0) := X"6A";        -- j - Lower case j
    constant slvLowerK            : std_logic_vector(7 downto 0) := X"6B";        -- k - Lower case k
    constant slvLowerL            : std_logic_vector(7 downto 0) := X"6C";        -- l - Lower case l
    constant slvLowerM            : std_logic_vector(7 downto 0) := X"6D";        -- m - Lower case m
    constant slvLowerN            : std_logic_vector(7 downto 0) := X"6E";        -- n - Lower case n
    constant slvLowerO            : std_logic_vector(7 downto 0) := X"6F";        -- o - Lower case o

    constant slvLowerP            : std_logic_vector(7 downto 0) := X"70";        -- p - Lower case p
    constant slvLowerQ            : std_logic_vector(7 downto 0) := X"71";        -- q - Lower case q
    constant slvLowerR            : std_logic_vector(7 downto 0) := X"72";        -- r - Lower case r
    constant slvLowerS            : std_logic_vector(7 downto 0) := X"73";        -- s - Lower case s
    constant slvLowerT            : std_logic_vector(7 downto 0) := X"74";        -- t - Lower case t
    constant slvLowerU            : std_logic_vector(7 downto 0) := X"75";        -- u - Lower case u
    constant slvLowerV            : std_logic_vector(7 downto 0) := X"76";        -- v - Lower case v
    constant slvLowerW            : std_logic_vector(7 downto 0) := X"77";        -- w - Lower case w
    constant slvLowerX            : std_logic_vector(7 downto 0) := X"78";        -- x - Lower case x
    constant slvLowerY            : std_logic_vector(7 downto 0) := X"79";        -- y - Lower case y
    constant slvLowerZ            : std_logic_vector(7 downto 0) := X"7A";        -- z - Lower case z
    constant slvOPENBRACE         : std_logic_vector(7 downto 0) := X"7B";        -- { - open brace
    constant slvOPENCURLYBRACE    : std_logic_vector(7 downto 0) := X"7B";        -- { - open brace  
    constant slvPIPE              : std_logic_vector(7 downto 0) := X"7C";        -- | - pipe symbol
    constant slvCLOSEBRACE        : std_logic_vector(7 downto 0) := X"7D";        -- } - close brace
    constant slvCLOSECURLYBRACE   : std_logic_vector(7 downto 0) := X"7D";        -- } - close brace  
    constant slvTILDE             : std_logic_vector(7 downto 0) := X"7E";        -- ~ - tilde
    constant slvDEL               : std_logic_vector(7 downto 0) := X"7F";        -- DEL 
    
    -- this character array returns a printable character corresponding to the index. 
    -- All special function characters return as a space
    type cArray is array(0 to 255) of character;    
    constant asciiToChar : cArray := (NUL,SOH,STX,ETX,EOT,ENQ,ACK,BEL,BS,HT,LF,VT,FF,CR,SO,SI,
                                      DLE,DC1,DC2,DC3,DC4,NAK,SYN,ETB,CAN,EM,SUB,ESC,FSP,GSP,RSP,USP,
                                      ' ','!','\','#','$','%','&',''','(',')','*','+',',','-','.','/',
                                      '0','1','2','3','4','5','6','7','8','9',':',';','<','=','>','?',
                                      '@','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',
                                      'P','Q','R','S','T','U','V','W','X','Y','Z','[','\',']','^','_',
                                      '`','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
                                      'p','q','r','s','t','u','v','w','x','y','z','{','|','}','~',DEL,
                                      C128,   C129,   C130,   C131,   C132,   C133,   C134,   C135,
                                      C136,   C137,   C138,   C139,   C140,   C141,   C142,   C143,
                                      C144,   C145,   C146,   C147,   C148,   C149,   C150,   C151,
                                      C152,   C153,   C154,   C155,   C156,   C157,   C158,   C159,
                                      ' ','¡','¢','£','¤','¥','¦','§','¨','©','ª','«','¬','­','®', '¯',
                                      '°','±','²','³','´','µ','¶','·','¸','¹','º','»','¼','½','¾','¿',  
                                      'À','Á','Â','Ã','Ä','Å','Æ','Ç','È','É','Ê','Ë','Ì','Í','Î','Ï',
                                      'Ð','Ñ','Ò','Ó','Ô','Õ','Ö','×','Ø','Ù','Ú','Û','Ü','Ý','Þ','ß',
                                      'à','á','â','ã','ä','å','æ','ç','è','é','ê','ë','ì','í','î','ï',
                                      'ð','ñ','ò','ó','ô','õ','ö','÷','ø','ù','ú','û','ü','ý','þ','ÿ'
                                     );
    type cpArray is array(0 to 127) of character;                                       
    constant asciiToPrintableChar : cpArray := (NUL,SOH,STX,ETX,EOT,ENQ,ACK,BEL,BS,HT,LF,VT,FF,CR,SO,SI,
                                      DLE,DC1,DC2,DC3,DC4,NAK,SYN,ETB,CAN,EM,SUB,ESC,FSP,GSP,RSP,USP,
                                      ' ','!','\','#','$','%','&',''','(',')','*','+',',','-','.','/',
                                      '0','1','2','3','4','5','6','7','8','9',':',';','<','=','>','?',
                                      '@','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',
                                      'P','Q','R','S','T','U','V','W','X','Y','Z','[','\',']','^','_',
                                      '`','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
                                      'p','q','r','s','t','u','v','w','x','y','z','{','|','}','~',DEL
                                     );                                     
    
end string_utilities_synth_pkg;


package body string_utilities_synth_pkg is

    -- ************************************************************
    --   Proc : intToChar
    --   Inputs : integer 
    --   Outputs : character
    --   Description : returns the ASCII character corresponding to 
    --          the passed integer
    -- *************************************************************  
    function intToChar(x : in integer) return character is
       begin
          --return(Character'VAL(x));
          return(asciiToChar(to_integer(to_unsigned(x,7))));
       end function intToChar;
       
    -- ************************************************************
    --   Proc : intToPrintableChar
    --   Inputs : integer 
    --   Outputs : character
    --   Description : returns the ASCII character corresponding to 
    --          the passed integer
    -- *************************************************************  
    function intToPrintableChar(x : in integer) return character is
       begin
          return(asciiToPrintableChar(to_integer(to_unsigned(x,7))));
       end function intToPrintableChar;       
       
    -- ************************************************************
    --   Proc : intToHexChar
    --   Inputs : integer 
    --   Outputs : character
    --   Description : returns the ASCII character corresponding to 
    --          the value of the passed integer only values '0'-'9','A'-'F'
    -- *************************************************************        
    function intToHexChar(x : in integer) return character is
       begin
          if ((x >= 0) and (x <= 15)) then
             return(hexDigitCharacters(x));
          else
             return('?');
          end if;
       end function intToHexChar;
       
    -- ************************************************************
    --   Proc : charToInt
    --   Inputs : character 
    --   Outputs : integer
    --   Description : returns the ASCII integer value of the passed character 
    -- *************************************************************        
    function charToInt(c : in character) return integer is
       begin
          return(Character'POS(c));
       end function charToInt;
       
    -- ************************************************************
    --   Proc : charToString
    --   Inputs : character 
    --   Outputs : string
    --   Description : returns a string of length 1 containing the character 
    -- *************************************************************           
    function charToString(c : character) return string is
          variable s : string (1 to 1);
       begin
          s(1) := c;
          return s;
       end function charToString;
       
    -- ************************************************************
    --   Proc : isHexChar
    --   Inputs : character 
    --   Outputs : boolean
    --   Description : returns true if the passed character is a
    --          hexadecimal character ('0' to '9', 'A' to 'F', 'a' to 'f')
    -- *************************************************************        
    function isHexChar(c : in character) return boolean is               -- tests if passed character is a valid hex character (case insensitive)
       begin
          case (c) is                                                    -- test the character (x) against...
             when '0' to '9' | 'A' to 'F' | 'a' to 'f' => return true;
             when others => return false;
          end case;                                                      -- end of possible values of x
       end function isHexChar;
    
    -- ************************************************************
    --   Proc : isHexChar
    --   Inputs : std_logic_vector 
    --   Outputs : boolean
    --   Description : returns true if the passed character equivalent is a
    --          hexadecimal character ('0' to '9', 'A' to 'F', 'a' to 'f')
    --          in this case X"30" to X"39", etc.
    -- *************************************************************              
    function isHexChar(slv : in std_logic_vector) return boolean is      -- tests if passed slv is a valid hex character (case insensitive)
          variable c : character := NUL;
          variable intVal : integer range 0 to 255 := 0;
       begin
          intVal := to_integer(unsigned(slv));                           -- convert to integer
          --c := character'val(intVal);                                  -- find the corresponding character for this integer  
          c := intToChar(intVal);
          case (c) is                                                    -- test the character (x) against...
             --when X"30" | X"31to X"39" => return true;
             when '0' to '9' | 'A' to 'F' | 'a' to 'f' => return true;
             when others => return false;
          end case;                                                      -- end of possible values of x
       end function isHexChar;       
    
    -- ************************************************************
    --   Proc : charToHexValue
    --   Inputs : character
    --   Outputs : integer
    --   Description : Converts a signal hexadecimal character into
    --   its equivalent representation as an integer (0-15), 
    --   -1 returned on failure
    -- *************************************************************        
    function charToHexValue(x : in character) return integer is          -- converts passed character into a value between 0 and 15
       begin
          case (x) is                                                    -- test the character (x) against...
             when '0' to '9' => return(CHARACTER'POS(x)-48);             -- return a value between 0 and 9 for decimal digit input
             when 'A' to 'F' => return(CHARACTER'POS(x)-65+10);          -- return a value between 10 and 15 for upper case input
             when 'a' to 'f' => return(CHARACTER'POS(x)-97+10);          -- return a value between 10 and 15 for lower case input
             when others => return (-1);                                 -- illegal value passed in - so return a value outside the valid range
          end case;                                                      -- end of possible values of x         
       end function charToHexValue;
    
    -- ************************************************************
    --   Proc : charToValue
    --   Inputs : character
    --   Outputs : integer
    --   Description : Converts a signal decimal character into
    --   its equivalent representation as an integer (0-9), 
    --   -1 returned on failure
    -- *************************************************************        
    function charToValue(x : in character) return integer is          -- converts passed character into a value between 0 and 15
       begin
          case (x) is                                                    -- test the character (x) against...
             when '0' to '9' => return(CHARACTER'POS(x)-48);             -- return a value between 0 and 9 for decimal digit input
             when others => return (-1);                                 -- illegal value passed in - so return a value outside the valid range
          end case;                                                      -- end of possible values of x         
       end function charToValue;
      
    -- ************************************************************
    --   Proc : hexCharToSlv
    --   Inputs : character
    --   Outputs : std_logic_vector
    --   Description : Converts a signal hexadecimal character into
    --   its equivalent representation as a 4 bit std_logic_vector
    --       e.g. "A" --> "1010"  
    -- *************************************************************        
    function hexCharToSlv(c : character) return std_logic_vector is
       begin
          case (c) is
             when '0' => return X"0";
             when '1' => return X"1";
             when '2' => return X"2";
             when '3' => return X"3";
             when '4' => return X"4";
             when '5' => return X"5";
             when '6' => return X"6";
             when '7' => return X"7";   
             when '8' => return X"8";
             when '9' => return X"9";
             when 'A' => return X"A";
             when 'B' => return X"B";
             when 'C' => return X"C";
             when 'D' => return X"D";
             when 'E' => return X"E";
             when 'F' => return X"F";            
             when 'a' => return X"A";
             when 'b' => return X"B";
             when 'c' => return X"C";
             when 'd' => return X"D";
             when 'e' => return X"E";
             when 'f' => return X"F";
             when others => return X"0";            
          end case;
       end function hexCharToSlv;
        
    -- ************************************************************
    --   Proc: slvCharToSlv
    --   Inputs:  std_logic_vector (<8 bits)
    --   Outputs: std_logic_vector (4 bits)
    --   Description : Converts a character represented in hexadecimal into
    --   its equivalent representation as a 4 bit std_logic_vector
    --       e.g. X"41" ('A') --> "1010"  
    --   if any meta-characters are present then the return slv is "UUUU"
    -- *************************************************************        
    function slvPrintableCharToSlv(x : std_logic_vector) return std_logic_vector is
          variable c           : character := NUL;
          variable intVal      : integer range 0 to 255 := 0;
          variable metaPresent : boolean := false;
       begin
          -- verify that all the positions in x are non-meta characters
          metaPresent := false;
          checkForMeta: for i in 0 to x'length-1 loop
             if (x(i) /= '1') and (x(i) /= '0') then
                metaPresent := true;
             end if;
          end loop checkForMeta;
          
			 -- bail if any meta characters are present
          if (metaPresent) then
             return "UUUU";
          end if;
          
          -- assume that everything else is a '0' or a '1' and convert
          intVal := to_integer(unsigned(x));                                -- convert to integer
          c := asciiToPrintableChar(intVal);                                -- find the corresponding character for this integer
          case (c) is                                                       -- test the character (x) against...
             when '0' to '9' => intVal := CHARACTER'POS(c)-48;              -- convert to an integer value between 0 and 9 for decimal digit input
             when 'A' to 'F' => intVal := CHARACTER'POS(c)-65+10;           -- convert to an integer value between 10 and 15 for upper case input
             when 'a' to 'f' => intVal := CHARACTER'POS(c)-97+10;           -- convert to an integer value between 10 and 15 for lower case input
             when others => intVal := 0;                                    -- illegal value passed in - so return a value outside the valid range
          end case; 
          return std_logic_vector(to_unsigned(intVal,4));
       end function slvPrintableCharToSlv;  
              
    -- ************************************************************
    --   Proc: slvCharToSlv
    --   Inputs:  std_logic_vector (<8 bits)
    --   Outputs: std_logic_vector (4 bits)
    --   Description : Converts a character represented in hexadecimal into
    --   its equivalent representation as a 4 bit std_logic_vector
    --       e.g. X"41" ('A') --> "1010"  
    --   if any meta-characters are present then the return slv is "UUUU"
    -- *************************************************************        
    function slvCharToSlv(x : std_logic_vector) return std_logic_vector is
          variable c           : character := NUL;
          variable intVal      : integer range 0 to 255 := 0;
          variable metaPresent : boolean := false;
       begin
          -- verify that all the positions in x are non-meta characters
          metaPresent := false;
          checkForMeta: for i in 0 to x'length-1 loop
             if (x(i) /= '1') and (x(i) /= '0') then
                metaPresent := true;
             end if;
          end loop checkForMeta;
          
			 -- bail if any meta characters are present
          if (metaPresent) then
             return "UUUU";
          end if;
          
          -- assume that everything else is a '0' or a '1' and convert
          intVal := to_integer(unsigned(x));                                -- convert to integer
          c := asciiToChar(intVal);                                         -- find the corresponding character for this integer
          case (c) is                                                       -- test the character (x) against...
             when '0' to '9' => intVal := CHARACTER'POS(c)-48;              -- convert to an integer value between 0 and 9 for decimal digit input
             when 'A' to 'F' => intVal := CHARACTER'POS(c)-65+10;           -- convert to an integer value between 10 and 15 for upper case input
             when 'a' to 'f' => intVal := CHARACTER'POS(c)-97+10;           -- convert to an integer value between 10 and 15 for lower case input
             when others => intVal := 0;                                    -- illegal value passed in - so return a value outside the valid range
          end case; 
          return std_logic_vector(to_unsigned(intVal,4));
       end function slvCharToSlv;        
    
    
    -- ************************************************************
    --   Proc : hexStringToSlv
    --   Inputs : String
    --   Outputs : std_logic_vector
    --   Description : Converts a hexadecimal set of characters into
    --   its equivalent representation as a std_logic_vector
    --       e.g. "A5" --> "10100101"
    --   *** limited to 8 character output string      
    -- *************************************************************     
    function hexStringToSlv(s : String) return std_logic_vector    is
          variable returnSlv : std_logic_vector(31 downto 0) := (others=>'U');
       begin
          for i in 1 to s'length loop
             returnSlv := returnSlv(27 downto 0) & hexCharToSlv(s(i));
          end loop;
          return returnSlv((s'length*4)-1 downto 0);
       end function hexStringToSlv;
    
    
    -- ************************************************************
    --   Proc : slvToHexValue
    --   Inputs : std_logic_vector
    --   Outputs : integer
    --   Description : Converts an ASCII character into its
    --      equivalent integer value
    --       e.g. "41" ('A') --> 10
    -- ************************************************************* 
    function slvToHexValue(x : in std_logic_vector) return integer is       -- converts passed slv into a value between 0 and 15  
          variable c : character := NUL;
          variable intVal : integer range 0 to 255 := 0;
       begin
          intVal := to_integer(unsigned(x));                                -- convert to integer
          c := character'val(intVal);                                       -- find the corresponding character for this integer
          case (c) is                                                       -- test the character (x) against...
             when '0' to '9' => return(CHARACTER'POS(c)-48);                -- return a value between 0 and 9 for decimal digit input
             when 'A' to 'F' => return(CHARACTER'POS(c)-65+10);             -- return a value between 10 and 15 for upper case input
             when 'a' to 'f' => return(CHARACTER'POS(c)-97+10);             -- return a value between 10 and 15 for lower case input
             when others => return (-1);                                    -- illegal value passed in - so return a value outside the valid range
          end case;                                                         -- end of possible values of x            
       end function slvToHexValue;      
    
    -- ************************************************************
    --   Proc : slToChar
    --   Inputs : std_logic
    --   Outputs : character
    --   Description : Converts a single std_logic value to its corresponding
    --   Multi-Valued logic character
    -- *************************************************************  
    function slToChar(x : std_logic) return Character is
          variable value : Character := '?';
       begin
          case (x) is
             when '1' => value := '1';
             when '0' => value := '0';
             when 'H' => value := 'H';
             when 'L' => value := 'L';
             when 'U' => value := 'U';
             when 'X' => value := 'X';
             when 'Z' => value := 'Z';
             when '-' => value := '-';
             when 'W' => value := 'W';
          end case;
          return value;
       end function slToChar;
       
--  -- ************************************************************
--  --   Funct : slvToChar
--  --   Inputs : std_logic_vector
--  --   Outputs : character
--  --   Description : Converts a std_logic_vector value to its corresponding
--  --   ASCII equivalent character i.e. 0x41->'A'
--  -- *************************************************************  
--  function slvToChar(x : std_logic) return Character is
--        variable value : Character := '?';
--     begin
--        case (x) is
--           when '1' => value := '1';
--           when '0' => value := '0';
--           when 'H' => value := 'H';
--           when 'L' => value := 'L';
--           when 'U' => value := 'U';
--           when 'X' => value := 'X';
--           when 'Z' => value := 'Z';
--           when '-' => value := '-';
--           when 'W' => value := 'W';
--        end case;
--        return value;
--     end function slvToChar;       
       
    -- ************************************************************
    --   Proc : slvToString
    --   Inputs : std_logic_vector 
    --   Outputs : String
    --   Description : Convert each std_logic value to its corresponding
    --   character and returns the corresponding collection as a string
    -- *************************************************************           
    function slvToString(x : std_logic_vector) return String is
          variable value : String(1 to x'length) := (others=>'?');
       begin
          allOfIt: for i in 0 to x'length-1 loop
             value(i+1) := slToChar(x(x'length-i-1));
          end loop;
          return value;
       end function slvToString;
       
    -- ************************************************************
    --   Proc : slvToHexString
    --   Inputs : up to 32 bit std_logic_vector 
    --   Outputs : String
    --   Description : Convert a slv to a hexadecimal string
    -- *************************************************************  
    function slvToHexString(slv_value : std_logic_vector) return String is
          variable finalHexWidth  : integer;
          variable retString      : string(1 to 13);
          variable digitValue     : integer range 0 to 15;
          variable top            : integer range 0 to 31;
          variable bottom         : integer range 0 to 28;
          variable adj_slv_value  : std_logic_vector(31 downto 0);
          variable offset         : integer range 0 to 15;
          variable metaValue      : boolean := false;
          
       begin 
       
          retString := "#16#????_????";                                              -- final form of string to return
          
          finalHexWidth := (slv_value'length + 3) / 4;                               -- determine the maximum width that the passed slv can produce
          if (finalHexWidth > 8) then                                                -- code can currently only handle a maximum of 32 bits
             return("[slv2hex: slv2hex limited to 32 bits. std_logic_vector too long!]");  -- return an error messag 
          end if;                                                                    -- end of max length check                
          
          adj_slv_value := (others=>'0');
          adj_slv_value(slv_value'length-1 downto 0) := slv_value;                   -- force the incoming slv to be 32 bits wide
          --adj_slv_value := resize(slv_value,32);

          -- loop through all 8 hex digits and place the character in the proper location in the string
          for i in 7 downto 0 loop
             top        := (i+1)*4-1;
             bottom     := i*4;      
             offset     := 2 - i/4;                                                  -- accounts for underscore (2 is the number of 4 hex chars possible)                
             
             -- make certain that every value that was passed in was a 1 or a 0 and not a meta-value (X, Z, W, ...)
             metaValue := false;                                                     -- each nibble gets a clean start
             for j in bottom to top loop                                             -- check each digit within the nibble
                if ((adj_slv_value(j) /= '1') and (adj_slv_value(j) /= '0')) then    -- if it's not a '1' or a '0' then it
                   metaValue := true;                                                -- must be a meta character
                end if;                                                              -- end '1'/'0' check
             end loop;                                                               -- end of each digit in nibble check
             
             -- place the proper digit in the return string
             if (not metaValue) then                                                 -- was one of the 4 characters in this nibble a meta value?
                digitValue := to_integer(unsigned(adj_slv_value(top downto bottom)));-- get the integer value of this nibble
                retString(7-i+4+offset) := hexDigitCharacters(digitValue);           -- 7-i is the position within the slv, + 4 to offset into the string                      
             else                                                                    -- one of the 4 characters found in this group is a meta value
                retString(7-i+4+offset) := '?';                                      -- 7-i is the position within the slv, + 4 to offset into the string                   
             end if;                                                                 -- end of meta value check
          end loop;               
          
          return(retString);
          
       end function slvToHexString;
      
--    -- ************************************************************
--    --   Proc : slvToHexString
--    --   Inputs : up to 32 bit std_logic_vector , boolean to indicate prefix use
--    --   Outputs : String
--    --   Description : Convert a slv to a hexadecimal string
--    -- *************************************************************  
--    function slvToHexString(slv_value : std_logic_vector; use_prefix : boolean) return String is
--          variable finalHexWidth  : integer;
--          variable retString      : string(1 to 13);
--          variable digitValue     : integer range 0 to 15;
--          variable top            : integer range 0 to 31;
--          variable bottom         : integer range 0 to 28;
--          variable adj_slv_value  : std_logic_vector(31 downto 0);
--          variable offset         : integer range 0 to 15;
--          variable metaValue      : boolean := false;
--          variable prefix_offset  : integer range 0 to 4 := 0;
--       begin 
--       
--         prefixUse: if (use_prefix) then
--             retString := "#16#????_????";                                              -- final form of string to return
--         prefix_offset := 4;
--          else
--             retString := "????_????";
--         prefix_offset := 0;
--          end if prefixUse;           
--          
--          finalHexWidth := (slv_value'length + 3) / 4;                               -- determine the maximum width that the passed slv can produce
--          if (finalHexWidth > 8) then                                                -- code can currently only handle a maximum of 32 bits
--             return("[slv2hex: slv2hex limited to 32 bits. std_logic_vector too long!]");  -- return an error messag 
--          end if;                                                                    -- end of max length check                
--          
--          adj_slv_value := (others=>'0');
--          adj_slv_value(slv_value'length-1 downto 0) := slv_value;                   -- force the incoming slv to be 32 bits wide
--
--          -- loop through all 8 hex digits and place the character in the proper location in the string
--          for i in 7 downto 0 loop
--             top        := (i+1)*4-1;
--             bottom     := i*4;      
--             offset     := 2 - i/4;                                                  -- accounts for underscore (2 is the number of 4 hex chars possible)                
--             
--             -- make certain that every value that was passed in was a 1 or a 0 and not a meta-value (X, Z, W, ...)
--             metaValue := false;                                                     -- each nibble gets a clean start
--             for j in bottom to top loop                                             -- check each digit within the nibble
--                if ((adj_slv_value(j) /= '1') and (adj_slv_value(j) /= '0')) then    -- if it's not a '1' or a '0' then it
--                   metaValue := true;                                                -- must be a meta character
--                end if;                                                              -- end '1'/'0' check
--             end loop;                                                               -- end of each digit in nibble check
--             
--             -- place the proper digit in the return string
--             if (not metaValue) then                                                 -- was one of the 4 characters in this nibble a meta value?
--                digitValue := to_integer(unsigned(adj_slv_value(top downto bottom)));-- get the integer value of this nibble
--                retString(7-i+offset+prefix_offset) := hexDigitCharacters(digitValue); -- 7-i is the position within the slv, + 4 to offset into the string                      
--             else                                                                    -- one of the 4 characters found in this group is a meta value
--                retString(7-i+offset+prefix_offset) := '?';                          -- 7-i is the position within the slv, + 4 to offset into the string                   
--             end if;                                                                 -- end of meta value check
--          end loop;               
--          
--          return(retString);
--          
--       end function slvToHexString;   
       
    -- ************************************************************
    --   Proc : slvToInt
    --   Inputs : std_logic_vector
    --   Outputs : integer
    --   Description : Convert a slv to an integer using numeric_std conversions/casting
    -- *************************************************************       
    function slvToInt(slv_value : std_logic_vector) return integer is
      begin
         return to_integer(unsigned(slv_value));
      end function slvToInt;
      
    -- ************************************************************
    --   Proc : slvToIntString
    --   Inputs : std_logic_vector
    --   Outputs : string
    --   Description : Convert a slv to an integer string using numeric_std conversions/casting
    -- *************************************************************         
    function slvToIntString (slv_value : std_logic_vector; size : integer) return string is
          variable return_string : string(1 to 32);
          type scale_array is array(7 downto 0) of integer;
          variable scale         : scale_array := (10_000_000, 1_000_000, 100_000, 10_000, 1000, 100, 10, 1);
          variable intValue      : integer := 0;
          variable thisDigit     : integer := 0;
       begin
          intValue := to_integer(unsigned(slv_value));
--         report "slvToIntString args: " & integer'image(intValue) & " : " & integer'image(size);
          eachDigit: for i in size downto 1 loop
             thisDigit := intValue/scale(i-1);
--           report "scale is " & integer'image(scale(i-1));
--           report integer'image(i) & ": " & integer'image(thisDigit);
             if (thisDigit > 9) then
                report "value too large to convert in slvToIntString in string_utilities_synth_pkg";
                thisDigit := character'pos('?');                         -- get the ASCII value of the digit
             else
                intValue := intValue - thisDigit*scale(i-1);
             end if;
             return_string(size-i+1) := character'val(thisDigit + 48);   -- convert to ASCII character from digit value             
          end loop eachDigit;
          return return_string;
       end function slvToIntString;
      
      
    -- ************************************************************
    --   Proc : slvToChar
    --   Inputs : up to 8 bits of std_logic_vector 
    --   Outputs : Character
    --   Description : Convert a slv to a character
    --    Note: no range checking is performed!
    -- *************************************************************           
    function slvToChar(slv_value : std_logic_vector) return Character is
          variable int_value      : integer range 0 to 255;
          variable char_value     : character;
       begin    
          int_value  := to_integer(unsigned(slv_value));
          char_value := intToChar(int_value);
          return(char_value);
       end function slvToChar;    

    -- ************************************************************
    --   Proc : charToSlv
    --   Inputs : Character 
    --   Outputs : 8 bits of std_logic_vector
    --   Description : Convert a character to an 8 bit slv
    --    Note: no range checking is performed!
    -- *************************************************************     
    function charToSlv(c : character) return std_logic_vector is
          variable value : integer range 0 to 255 := 0;
       begin
          value := character'pos(c);                                                 -- convert to integer
          return(std_logic_vector(to_unsigned(value,8)));
       end function chartoSlv;
       
    -- ************************************************************
    --   Proc : slvToDecChar
    --   Inputs : up to 8 bits of std_logic_vector 
    --   Outputs : Character
    --   Description : Convert a slv value to a decimal character
    --    Note: no range checking is performed!
    -- *************************************************************           
    function slvToDecChar (x : std_logic_vector) return Character is
          variable internal_x : std_logic_vector(3 downto 0) := (others=>'U');
       begin
          if (x'length >= 3) then
             internal_x := x(3 downto 0);
          else
             internal_x := (others=>'0');
             internal_x(x'length-1 downto 0) := x(x'length-1 downto 0) ;
          end if;
          
          case (internal_x) is
             when X"0" => return('0');
             when X"1" => return('1');
             when X"2" => return('2');
             when X"3" => return('3');
             when X"4" => return('4');
             when X"5" => return('5');
             when X"6" => return('6');
             when X"7" => return('7');
             when X"8" => return('8');
             when X"9" => return('9');
             when others=> return('?');
          end case;
       end function slvToDecChar;
       
    function slvToHexChar (x : std_logic_vector(3 downto 0)) return Character is
          variable internal_x : std_logic_vector(3 downto 0) := (others=>'U');
       begin
          internal_x := x;
          case (internal_x) is
             when X"0" => return('0');
             when X"1" => return('1');
             when X"2" => return('2');
             when X"3" => return('3');
             when X"4" => return('4');
             when X"5" => return('5');
             when X"6" => return('6');
             when X"7" => return('7');
             when X"8" => return('8');
             when X"9" => return('9');
             when X"A" => return('A');
             when X"B" => return('B');
             when X"C" => return('C');
             when X"D" => return('D');
             when X"E" => return('E');
             when X"F" => return('F');           
             when others=> return('?');          -- tools think that this is exhaustive and not needed, however, other cases using 'X', 'Z', etc. could occur
          end case;      
       
       end function slvToHexChar;          
       
    function strToInt(s : string) return integer is
       begin
          return 0;
       end function strToInt;
       
    -- ************************************************************
    --   Proc : softenMeta
    --   Inputs : std_logic_vector 
    --   Outputs : std_logic_vector
    --   Description : replaces meta-values with '0's
    -- *************************************************************     
  function softenMeta(slv_value : std_logic_vector) return std_logic_vector is 
        variable return_value : std_logic_vector(slv_value'length-1 downto 0);
     begin
        for i in 0 to slv_value'length-1 loop
          if (slv_value(i) = '1') or (slv_value(i) = '0') then
             return_value(i) := slv_value(i);
          else
             return_value(i) := '0';
          end if;
       end loop;
       return return_value;
     end function softenMeta;            
     
    -- ************************************************************
    --   Proc : hexCharToInt
    --   Inputs : character 
    --   Outputs : integer
    --   Description : returns a value between 0 and 15 corresoponding
   --                 to the value of the hex character
    -- *************************************************************    
     function hexCharToInt(c : character) return integer is 
        begin
          case (c) is
             when '0' => return  0;
            when '1' => return  1;
             when '2' => return  2;
            when '3' => return  3;  
             when '4' => return  4;
            when '5' => return  5;
             when '6' => return  6;
            when '7' => return  7;
             when '8' => return  8;
            when '9' => return  9;
             when 'A' => return 10;
            when 'B' => return 11;
             when 'C' => return 12;
            when 'D' => return 13;
             when 'E' => return 14;
            when 'F' => return 15;            
             when 'a' => return 10;
            when 'b' => return 11;
             when 'c' => return 12;
            when 'd' => return 13;
             when 'e' => return 14;
            when 'f' => return 15;
            when others=> return -1;
          end case;
       end function hexCharToInt;
     
    -- ************************************************************
    --   Proc : hexStringToInt
    --   Inputs : string 
    --   Outputs : integer
    --   Description : returns the integer equivalent of the hex string
--     *************************************************************    
     function hexStringToInt(s : string) return integer is
           variable value : integer;
        begin
          value := 0;
          for i in 1 to s'length loop
             value := value * 16 + hexCharToInt(s(i));
          end loop;
          return value;
       end function hexStringToInt;     

       
     
   -- ************************************************************
   --   Function : convSlvToHex
   --   Inputs : standard_logic_vector
   --   Outputs : hexadecimal string
   --   Description : returns the integer equivalent of the hex string
   --  *************************************************************  
   function convSlvToHex (slv: std_logic_vector) return string is
         variable slength: integer;
         variable maxslv : std_logic_vector(67 downto 0) := (others => '0');
         variable nibble : std_logic_vector(3 downto 0);
         variable returnstring  : string(1 to 16); 
      begin
         -- check for length
        slength := slv'length / 4; 
        if (slv'length mod 4 /= 0) then  --what if the std_logic vector is not a multple of  4
           slength := slength + 1;
        end if;
        maxslv(slv'left downto 0) := slv;
        for i in slength-1 downto 0 loop
           nibble := maxslv(((i*4)+3) downto (i*4));
           returnstring(slength-i):= slvToHexChar(nibble);
        end loop;
        return returnstring(1 to slength);
   end convSlvToHex;      

   function areMetaChars (x : std_logic_vector) return boolean is
         variable metaPresent : boolean := false;
      begin
          metaPresent := false;
          checkForMeta: for i in 0 to x'length-1 loop
             if (x(i) /= '1') and (x(i) /= '0') then
                metaPresent := true;
             end if;
          end loop checkForMeta;
          return metaPresent;
      end function areMetaChars;
      
end string_utilities_synth_pkg;