# Multi-Cycle-Processor-Design

Designed a multi-cycle processor using VHDL that could successfully execute 14 different 16-bit
instructions which together can perform any general task regardless of complexity.

Implemented the instructions in the form of a finite state machine with several overlapping states
between instructions, helping lower the complexity of the design and simulated it on Quartus

Finite State Machine :
<h>ALU: </h>
port (A, B: in std_logic_vector(15 downto 0); 
      C: out std_logic_vector(15 downto 0); 
      carry, iszero: out std_logic;
      S: in std_logic_vector(1 downto 0);
      Z: out std_logic);
signal S1: std_logic_vector(15 downto 0); signal S0: std_logic_vector(15 downto 0); signal sum: std_logic_vector(16 downto 0); signal eq: std_logic_vector(15 downto 0); signal temp: std_logic_vector(15 downto 0);
A & B are 16 bit inputs. C is 16 bit output. ‘Carry’ is carry of when the ALU performs addition. S is 2 bit input.
If S=00, then ALU should perform addition
If S=01, then ALU should perform subtraction
If S=10, then ALU should perform as a NAND gate.
‘iszero’ is a signal indicates when the result C is equal to zero.
eq is output of (A xnor B). We have used this signal to check equality of A and B. ‘Z’ is 1 when A and B are equal.
