library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

----------------------------------------------------

entity my_and_gate is
generic(
        INPUT_WIDTH: natural :=2
    ); port (	
        clock_in:   in  std_logic;
	reset_n_in: in  std_logic;
	a_in:       in  std_logic_vector(INPUT_WIDTH-1 downto 0);
	b_in:       in  std_logic_vector(INPUT_WIDTH-1 downto 0);
	c_out:      out std_logic_vector(INPUT_WIDTH-1 downto 0)
);
end my_and_gate;

----------------------------------------------------

architecture behv of my_and_gate is		 	  
	
    signal c : std_logic_vector(INPUT_WIDTH downto 0);

begin

    -- behavior describe the my_and_gate
    process(clock_in)
    begin
	if reset_n_in = '0' then
 	    c <= (others => '0');
	elsif (clock_in='1' and clock_in'event) then
            c <= ( a_in AND b_in );
	end if;
    end process;	
    -- concurrent assignment statement
    c_out <= c;

end behv;
