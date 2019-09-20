library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity gpc is
	port (	A, B: in std_logic_vector(7 downto 0);
			Z: out std_logic_vector(15 downto 0) );
end entity gpc;

architecture Behave of gpc is

	component alu is
	port (	A, B: in std_logic_vector(15 downto 0);
			C: out std_logic_vector(15 downto 0);
			S: in  std_logic_vector(1 downto 0);
			Z: out std_logic);
	end component alu;

	component Memory_asyncread_syncwrite is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wrbar: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0));
	end component;

	component reg is
	port (	inp: in std_logic_vector(15 downto 0);
			outp: out std_logic_vector(15 downto 0);
			en, clk: in std_logic);
	end component reg;

	type FsmState is (St0, St1, St2, St3);
	signal fsm_state: FsmState := St0;

	signal IP, IR: std_logic_vector(15 downto 0);
	
	signal T1_in, T2_in, T3_in: std_logic_vector(15 downto 0);
	signal T1_out, T2_out, T3_out: std_logic_vector(15 downto 0);
	signal T1_en, T2_en, T3_en: std_logic_vector(15 downto 0);

	signal C_flag, Z_flag: std_logic;

begin

	T1:	reg
		port map (inp => T1_in, outp => T1_out, en => T1_en, clk => clk);
	T2:	reg
		port map (inp => T2_in, outp => T2_out, en => T2_en, clk => clk);
	T3:	reg
		port map (inp => T3_in, outp => T3_out, en => T3_en, clk => clk);

	process (clk)

	begin

		case fsm_state is
			when St0 =>
				
			when others =>
				NULL;
		end case;

	end process;
	

end architecture; -- Behave