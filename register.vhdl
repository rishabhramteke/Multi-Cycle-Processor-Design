library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity reg is
	port (	inp: in std_logic_vector(15 downto 0);
			outp: out std_logic_vector(15 downto 0);
			en, clk: in std_logic);
end entity reg;

architecture Behave of reg is

	signal storage: std_logic_vector(15 downto 0);

begin

	outp <= storage;

	process (en, clk)

	variable var: std_logic_vector(15 downto 0);

	begin
		var := storage;

		if (en = '1' and rising_edge(clk)) then
			storage <= inp;
		else
			storage <= var;
		end if;

	end process;

end architecture; -- Behave