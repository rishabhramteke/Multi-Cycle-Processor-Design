# Multi-Cycle-Processor-Design

Designed a multi-cycle processor using VHDL that could successfully execute 14 different 16-bit instructions which together can perform any general task regardless of complexity.<br>
Implemented the instructions in the form of a finite state machine with several overlapping states between instructions, helping lower the complexity of the design and simulated it on Quartus<br>

Finite State Machine :<br>
<h3>ALU: </h3>
port ( A, B: in std_logic_vector(15 downto 0); <br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; C: out std_logic_vector(15 downto 0); <br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; carry, iszero: out std_logic;<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; S: in std_logic_vector(1 downto 0);<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Z: out std_logic);<br>
signal S1: std_logic_vector(15 downto 0); <br>
signal S0: std_logic_vector(15 downto 0); <br>
signal sum: std_logic_vector(16 downto 0); <br>
signal eq: std_logic_vector(15 downto 0); <br>
signal temp: std_logic_vector(15 downto 0);<br>
<br>
A & B are 16 bit inputs. C is 16 bit output. ‘Carry’ is carry of when the ALU performs addition. S is 2 bit input.<br>
If S=00, then ALU should perform addition<br>
If S=01, then ALU should perform subtraction<br>
If S=10, then ALU should perform as a NAND gate.<br>
<br>
‘iszero’ is a signal indicates when the result C is equal to zero.<br>
eq is output of (A xnor B). We have used this signal to check equality of A and B. ‘Z’ is 1 when A and B are equal.<br>
<br>
<h3>register_file: </h3>
port ( A1, A2: in std_logic_vector(2 downto 0);<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; D1, D2: out std_logic_vector(15 downto 0);<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; A3: in std_logic_vector(2 downto 0);<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; D3: in std_logic_vector(15 downto 0);<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; en, clk: in std_logic);<br>
signal reg_file: rfarray := (others => "0000000000000000");<br>
<br>
A1,A2 are 3 bit inputs and D1,D2 are 16 bit outputs.<br>
A1, A2 are address and when we provide them as input, we get the data D1,D2 respectively, that these addresses stored, as output.<br>
Thus, in this case we are using register_file to extract the data that is stored at a particular address.<br>
A3 is 3 bit input and D3 is 16 bit input. In this case, we have to store D3 data at an address A3.
