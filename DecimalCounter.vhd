library IEEE;
use IEEE.numeric_bit.all;  
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;

Entity DecimalCounter is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	ENI: in std_logic;
	ENO: out std_logic;
	ONES: out std_logic_vector(3 downto 0);
	TENS: out std_logic_vector(3 downto 0);
	HUND: out std_logic_vector(3 downto 0);
	THOU: out std_logic_vector(3 downto 0)
	);
end DecimalCounter;

Architecture Structural of DecimalCounter is 
------Components Declaration ----------------
Component CounterM10 is port
	(
	RST: in std_logic;
	CLK: in std_logic;
	ENI: in std_logic; --input enable	
	ENO: out std_logic;  --bit to keep count state	 --output enable
	CNT: out std_logic_vector(3 downto 0) --4 bits to keep count
	);
end Component;

------Signals Declaration--------------
signal EN1, EN2, EN3: std_logic;
begin					  
	-------------Component Instances--------
	U01: CounterM10 port map(RST,CLK, ENI, EN1, ONES); --fed by ENI, feeds EN1
	U02: CounterM10 port map(RST,CLK, EN1, EN2, TENS); --fed by EN1, feeds EN2
	U03: CounterM10 port map(RST,CLK, EN2, EN3, HUND); --fed by EN2, feeds EN3
	U04: CounterM10 port map(RST,CLK, EN3, OPEN, THOU); --fed by EN3, feeds -(open output)
end Structural;
	
	
