library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port (	A, B: in std_logic_vector(15 downto 0);
			C: out std_logic_vector(15 downto 0);
			carry, iszero: out std_logic;
			S: in std_logic_vector(1 downto 0);
			Z: out std_logic);
end entity alu;

architecture Behave of alu is

signal S1: std_logic_vector(15 downto 0);
signal S0: std_logic_vector(15 downto 0);
signal sum: std_logic_vector(16 downto 0);
signal eq: std_logic_vector(15 downto 0);
signal temp: std_logic_vector(15 downto 0);

begin

	S1(15) <= S(1); S1(14) <= S(1); S1(13) <= S(1); S1(12) <= S(1); S1(11) <= S(1); S1(10) <= S(1); S1(9) <= S(1); S1(8) <= S(1);
	S1(7) <= S(1); S1(6) <= S(1); S1(5) <= S(1); S1(4) <= S(1); S1(3) <= S(1); S1(2) <= S(1); S1(1) <= S(1); S1(0) <= S(1);

	S0(15) <= S(0); S0(14) <= S(0); S0(13) <= S(0); S0(12) <= S(0); S0(11) <= S(0); S0(10) <= S(0); S0(9) <= S(0); S0(8) <= S(0);
	S0(7) <= S(0); S0(6) <= S(0); S0(5) <= S(0); S0(4) <= S(0); S0(3) <= S(0); S0(2) <= S(0); S0(1) <= S(0); S0(0) <= S(0);

	sum <= std_logic_vector(unsigned('0' & A)+unsigned('0' & B));

	temp <= (sum(15 downto 0) and (not S1) and (not S0))
	 or (std_logic_vector(unsigned(A)-unsigned(B)) and (not S1) and S0)
	 or ((A nand B) and S1 and (not S0)); 
	    	
	eq <= A xnor B;

	-- indicates when the result C is equal to zero
	iszero <= not(temp(0) or temp(1) or temp(2) or temp(3) or temp(4) or temp(5) or temp(6) or temp(7) or
				temp(8) or temp(9) or temp(10) or temp(11) or temp(12) or temp(13) or temp(14) or temp(15));
	C <= temp;				
	carry <= sum(16);

	-- Z is 1 when A and B are equal
	Z <= eq(0) and eq(1) and eq(2) and eq(3) and eq(4) and eq(5) and eq(6) and eq(7)
	 	and eq(8) and eq(9) and eq(10) and eq(11) and eq(12) and eq(13) and eq(14) and eq(15);

end architecture; -- Behave