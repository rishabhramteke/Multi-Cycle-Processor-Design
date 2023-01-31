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
A & B are 16 bit inputs. C is 16 bit output. ‘Carry’ is carry of when the ALU performs addition. S is 2 bit input.<br>
If S=00, then ALU should perform addition<br>
If S=01, then ALU should perform subtraction<br>
If S=10, then ALU should perform as a NAND gate.<br>

‘iszero’ is a signal indicates when the result C is equal to zero.<br>
eq is output of (A xnor B). We have used this signal to check equality of A and B. ‘Z’ is 1 when A and B are equal.<br>
