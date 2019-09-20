library ieee;
use ieee.std_logic_1164.all;

entity Mux is
	port (	X1, X0: in std_logic;
			S0: in std_logic;
			Y: out std_logic );
end entity Mux;

architecture Struct of Mux is

begin

	Y <= (X0 and not(S0)) or
		(X1 and (S0));

end architecture ; -- Struct