library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity DecimalCount is
	port(  
		CLK : in std_logic;
		RST : in std_logic;
		ENI : in std_logic;
		ONES : out std_logic_vector(3 downto 0); 
		TENS : out std_logic_vector(3 downto 0);
		HUND : out std_logic_vector(3 downto 0);
		THOU : out std_logic_vector(3 downto 0)
		); 
end DecimalCount;

Architecture Structural of DecimalCount is  
	--Components Declaration--
	Component CounterM10 is port(
			CLK	: in std_logic;
			RST : in std_logic;
			ENI : in std_logic;
			ENO : out std_logic;
			CNT : out std_logic_vector(3 downto 0));
	end Component;
	--Signals declarations--
Signal EN1, EN2, EN3 : std_logic;
begin			   
	--Component instances--
	U01 : CounterM10 port map(CLK, RST, ENI, EN1, ONES);
	U02 : CounterM10 port map(CLK, RST, EN1, EN2, TENS);
	U03 : CounterM10 port map(CLK, RST, EN2, EN3, HUND);
	U04 : CounterM10 port map(CLK, RST, EN3, OPEN, THOU);  --Se pone de tipo OPEN para indicar al 
	--												sintetizador que esa señal no lleva ninguna conexión
	
end Architecture Structural;  
