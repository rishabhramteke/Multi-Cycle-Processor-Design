library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity memory_unit is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0); clk,write_signal: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0);
				Mem0, Mem1, Mem2, Mem3, Mem4, Mem5, Mem6, Mem7, Mem31: out std_logic_vector(15 downto 0));
end entity;

architecture Form of memory_unit is 
type regarray is array(255 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type (65535)
signal Memory: regarray:=(
0 => x"3001", 1 => x"60aa", 2 => x"0038", 3 => x"03fa", 4 => x"0079", 5 => x"5f9f", 6 => x"13fb", 7 => x"2038",
	8 => x"233a", 9 => x"2079", 10 => x"4f86",11 => x"4f9f", 12 => x"c9c2", 13 => x"abcd", 14 => x"8e02", 15 => x"1234", 16 => x"7caa", 17 => x"91c0",
	128 => x"ffff", 129 => x"0002", 130 => x"0000", 131 => x"0000", 132 => x"0001", 133 => x"0000",
	others => x"0000");
-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
begin
Mem0 <= Memory(0);
Mem1 <= Memory(1);
Mem2 <= Memory(2);
Mem3 <= Memory(3);
Mem4 <= Memory(4);
Mem5 <= Memory(5);
Mem6 <= Memory(6);
Mem7 <= Memory(7);
Mem31 <= Memory(31);

Mem_dataout <= Memory(conv_integer(address));
Mem_write:
process (write_signal,Mem_datain,address,clk)
	begin
	if(write_signal = '0') then
		if(rising_edge(clk)) then
			Memory(conv_integer(address)) <= Mem_datain;
		end if;
	end if;
	end process;
end Form;
