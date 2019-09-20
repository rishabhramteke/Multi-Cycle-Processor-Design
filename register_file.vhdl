library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity register_file is
	port (	A1, A2: in std_logic_vector(2 downto 0);
			D1, D2: out std_logic_vector(15 downto 0);
			A3: in std_logic_vector(2 downto 0);
			D3: in std_logic_vector(15 downto 0);
			en, clk: in std_logic;
			R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0));
end entity register_file;

architecture Behave of register_file is

	type rfarray is array(7 downto 0) of std_logic_vector(15 downto 0);

	signal reg_file: rfarray := (others => "0000000000000000");



begin

	R0 <= reg_file(0);
	R1 <= reg_file(1);
	R2 <= reg_file(2);
	R3 <= reg_file(3);
	R4 <= reg_file(4);
	R5 <= reg_file(5);
	R6 <= reg_file(6);
	R7 <= reg_file(7);

	D1 <= reg_file(conv_integer(A1));
	D2 <= reg_file(conv_integer(A2));

	process (A3, D3, en, clk)
	begin
		if (en = '1' and rising_edge(clk)) then
			reg_file(conv_integer(A3)) <= D3;
		end if;
	end process;

end architecture; -- Behave