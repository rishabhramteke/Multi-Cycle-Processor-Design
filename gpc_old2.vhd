library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

entity gpc is
	port (	clk: in std_logic );
end entity gpc;

architecture Behave of gpc is

	component register_file is
	port (	A1, A2: in std_logic_vector(2 downto 0);
			D1, D2: out std_logic_vector(15 downto 0);
			A3: in std_logic_vector(2 downto 0);
			D3: in std_logic_vector(15 downto 0);
			en, clk: in std_logic);
	end component register_file;

	component alu is
	port (	A, B: in std_logic_vector(15 downto 0);
			C: out std_logic_vector(15 downto 0);
			carry, iszero: out std_logic;
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

	type FsmState is (St3, St1, St2, St0, St8, St9, St11, St12, St13, St14, St18, St19, St20, St21, St22, St23);
	signal fsm_state: FsmState := St3;

	signal IP, IR: std_logic_vector(15 downto 0) := "0000000000000000";
	
	signal T1, T2, T3: std_logic_vector(15 downto 0);

	signal C_flag, Z_flag: std_logic;

	signal RF_A1, RF_A2, RF_A3: std_logic_vector(2 downto 0);
	signal RF_D1, RF_D2, RF_D3: std_logic_vector(15 downto 0);
	signal RF_en: std_logic;

	signal ALU_A, ALU_B, ALU_C: std_logic_vector(15 downto 0);
	signal ALU_carr, ALU_isz: std_logic;
	signal ALU_S: std_logic_vector(1 downto 0);
	signal ALU_Z: std_logic;

	signal MEM_A: std_logic_vector(15 downto 0) := "0000000000000001";
	signal MEM_D_in, MEM_D_out: std_logic_vector(15 downto 0);
	signal MEM_en_L: std_logic;

begin
	
	alu_unit: alu
				port map (A => ALU_A, B => ALU_B, C => ALU_C, carry => ALU_carr,
				iszero => ALU_isz, S => ALU_S, Z => ALU_Z);

	mem_unit: Memory_asyncread_syncwrite
				port map (address => MEM_A,
						Mem_datain => MEM_D_in,
						clk => clk,
						Mem_wrbar => MEM_en_L,
						Mem_dataout => MEM_D_out);

	rf_unit: register_file
				port map (A1 => RF_A1, A2 => RF_A2, D1 => RF_D1, D2 => RF_D2,
					A3 => RF_A3, D3 => RF_D3, en => RF_en, clk => clk);

	process (clk)

	variable next_fsm_var: FsmState;
	variable RF_en_var: std_logic;

	begin

		if(rising_edge(clk)) then
			case fsm_state is
				when St3 =>
					fsm_state <= St0;
					RF_en <= '0';
					MEM_A <= IP;
					ALU_A <= IP;
					ALU_B <= "0000000000000001";
					ALU_S <= "00";
					MEM_en_L <= '1';
				when St0 =>
					mem_en_L <= '1';
					IP <= ALU_C;
					IR <= MEM_D_out;
					RF_A1 <= IR(11 downto 9);
					RF_A2 <= IR(8 downto 6);

					case IR(15 downto 12) is
					when "0000" =>
						if ((IR(1 downto 0) = "10" and C_flag = '0')
							or (IR(1 downto 0) = "01" and Z_flag = '0')) then
								fsm_state <= St3;
						else
							fsm_state <= St1;
						end if;
					when "0010" =>
						if ((IR(1 downto 0) = "10" and C_flag = '0')
							or (IR(1 downto 0) = "01" and Z_flag = '0')) then
								fsm_state <= St3;
						else
							fsm_state <= St1;
						end if;
					when "0011" =>
						RF_D3 <= IR(8 downto 0) & "0000000";
						RF_A3 <= IR(11 downto 9);
						RF_en <= '1';
						fsm_state <= St3;
					when "0100" =>
						fsm_state <= St1;
					when "0101" =>
						fsm_state <= St1;
					when "1000" =>
						ALU_A <= T1;
						ALU_B <= T2;
						ALU_S <= "01";
						fsm_state <= St13;
					when "0110" =>
						T1 <= "0000000000000000";
						RF_A2 <= IR(11 downto 9);
						fsm_state <= St18;
					when "0111" =>
						T1 <= "0000000000000000";
						RF_A2 <= IR(11 downto 9);
						fsm_state <= St18;
					when others =>
						fsm_state <= St1;
					end case;
				when St1 =>
					T1 <= RF_D1;
					T2 <= RF_D2;
					
					case IR(15 downto 12) is
					when "0000" =>
						ALU_A <= T1;
						ALU_B <= T2;
						ALU_S <= "00";
						fsm_state <= St2;
					when "0001" =>
						ALU_A <= T1;
						ALU_B <= IR(5) & IR(5) & IR(5) & IR(5) & IR(5) & 
								IR(5) & IR(5) & IR(5) & IR(5) & IR(5) & IR(5 downto 0);
					when "0010" =>
						ALU_A <= T1;
						ALU_B <= T2; 
						ALU_S <= "10";
						fsm_state <= St2;
					when "0100" =>
						ALU_A <= T2;
						ALU_B <= "0000000000" & IR(5 downto 0);
						ALU_S <= "00";
						fsm_state <= St8;
					when "0101" =>
						ALU_A <= T2;
						ALU_B <= "0000000000" & IR(5 downto 0);
						ALU_S <= "00";
						fsm_state <= St8;
					when "1100" =>
						ALU_A <= T1;
						ALU_B <= T2;
						ALU_S <= "01";
						fsm_state <= St12;
					when "1001" =>
						ALU_A <= IP;
						ALU_B <= "0000000000000001";
						ALU_S <= "01";
						fsm_state <= St13;
					when others =>
						fsm_state <= St2;
					end case;
				when St2 =>
					T1 <= ALU_C;
					C_flag <= ALU_carr;
					Z_flag <= ALU_isz;
					case IR(15 downto 12) is
						when "0000" =>
							RF_A3 <= IR(5 downto 3);
						when "0001" =>
							RF_A3 <= IR(8 downto 6);
						when others =>
							RF_A3 <= IR(5 downto 3);
					end case ;
					RF_D3 <= T1;
					RF_en <= '1';
					fsm_state <= St3;
				when St8 =>
					case IR(15 downto 12) is
						when "0100" =>
							T2 <= ALU_C;
							MEM_A <= T2;
							fsm_state <= St9;
						when "0101" =>
							MEM_A <= T2;
							MEM_D_in <= T1;
							MEM_en_L <= '0';
							fsm_state <= St3;
						when others =>
							fsm_state <= St3;
					end case ;
				when St9 =>
					T2 <= MEM_D_out;
					Z_flag <= not(T2(15) or T2(14) or T2(13) or T2(12) or T2(11) or T2(10) or T2(9) or T2(8)
						or T2(7) or T2(6) or T2(5) or T2(4) or T2(3) or T2(2) or T2(1) or T2(0));
					RF_A3 <= IR(11 downto 9);
					RF_D3 <= T2;
					RF_en <= '1';
					fsm_state <= St3;
				when St12 =>
					if (ALU_Z = '1') then
						ALU_A <= IP;
						ALU_B <= "0000000000000010";
						ALU_S <= "01";
						fsm_state <= St13;
					else
						fsm_state <= St3;
					end if;
				when St13 =>
					T1 <= ALU_C;
					case( IR(15 downto 12) ) is
						when "1100" =>
							ALU_A <= T1;
							ALU_B <= "0000000000" & IR(5 downto 0);
							ALU_S <= "00";
							fsm_state <= St14;
						when "1000" =>
							RF_D3 <= T1;
							RF_A3 <= IR(11 downto 9);
							RF_en <= '1';
							ALU_A <= T1;
							ALU_B <= "0000000" & IR(8 downto 0);
							ALU_S <= "00";
							fsm_state <= St14;
						when "1001" =>
							T1 <= ALU_C;
							RF_D3 <= T1;
							RF_A3 <= IR(11 downto 9);
							RF_en <= '1';
							IP <= T2;
							fsm_state <= St3; 
						when others =>
							fsm_state <= St3;
					end case;
				when St14 =>
					IP <= ALU_C;
					MEM_A <= IP;
					fsm_state <= St0;
				when St18 =>
					T2 <= RF_D2;
					case( IR(15 downto 12) ) is
						when "0110" =>
							MEM_A <= T2;
							MEM_en_L <= '0';
							ALU_A <= T2;
							ALU_B <=  "0000000000000001";
							ALU_S <= "00";
							fsm_state <= St22;
						when "0111" =>
							RF_A1 <= T1(2 downto 0);
							ALU_A <= T1;
							ALU_B <= "0000000000000001";
							ALU_S <= "00";
							fsm_state <= St19;	
						when others =>
							fsm_state <= St3;
					end case ;
				when St19 =>
					T3 <= RF_D1;
					T1 <= ALU_C;
					MEM_A <= T2;
					MEM_D_in <= T3;
					MEM_en_L <= '0';
					ALU_A <= T2;
					ALU_B <= "0000000000000001";
					ALU_S <= "00";
				when St20 =>
					MEM_en_L <= '1';
					T2 <= ALU_C;
					ALU_A <= T1;
					ALU_B <= "0000000000001000";
					ALU_S <= "00";
				when St22 =>
					T3 <= MEM_D_out;
					T2 <= ALU_C;
					RF_A3 <= T1(2 downto 0);
					RF_D3 <= T3;
					RF_en <= '1';
					ALU_A <= T1;
					ALU_B <= "0000000000000001";
					ALU_S <= "00";
					fsm_state <= St23;
				when St23 =>
					RF_en <= '0';
					T1 <= ALU_C;
					ALU_A <= T1;
					ALU_B <= "0000000000001000";
					ALU_S <= "00";
					fsm_state <= St21;
				when St21 =>
					case( ALU_Z ) is
						when '1' =>
							fsm_state <= St3;
						when '0' =>
							if (IR(15 downto 12) = "0110") then
								MEM_A <= T2;
								ALU_A <= T2;
								ALU_B <= "0000000000000001";
								ALU_S <= "00";
								fsm_state <= St22;
							elsif (IR(15 downto 12) = "0111") then
								RF_A1 <= T1(2 downto 0);
								ALU_A <= T1;
								ALU_B <= "0000000000000001";
								ALU_S <= "00";
								fsm_state <= St19;
							else
								fsm_state <= St3;
							end if;
						when others =>
							NULL;
					end case ;
				when others =>
					NULL;
			end case;
		end if;

	end process;
	

end architecture; -- Behave