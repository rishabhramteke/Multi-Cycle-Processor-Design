library ieee;
use ieee.std_logic_1164.all;

entity Mux8 is
	port (	X7, X6, X5, X4, X3, X2, X1, X0: in std_logic;
			S2, S1, S0: in std_logic;
			Y: out std_logic );
end entity Mux8;

architecture Struct of Mux8 is

begin

	Y <= (X0 and not(S2) and not(S1) and not(S0)) or
		(X1 and not(S2) and not(S1) and (S0)) or
		(X2 and not(S2) and (S1) and not(S0)) or
		(X3 and not(S2) and (S1) and (S0)) or
		(X4 and (S2) and not(S1) and not(S0)) or
		(X5 and (S2) and not(S1) and (S0)) or
		(X6 and (S2) and (S1) and not(S0)) or
		(X7 and (S2) and (S1) and (S0));

end architecture ; -- Struct