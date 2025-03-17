library IEEE;
use IEEE.std_logic_1164.all;

Entity MAX6675 is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	STR: in std_logic;
	RDY: out std_logic;
	MISO: in std_logic;
	CSE: out std_logic;
	SCK: out std_logic;
	DOUT: out std_logic_vector(15 downto 0)
);
end MAX6675;

Architecture Structural of MAX6675 is
--Component Declaration----
	component Timer is
 	generic(ticks:integer:= 19);
	port( 
	CLK:     in std_logic;	
	RST:     in std_logic; 	
	SYN:     out std_logic
	);
end component;	

component LatchSR is
	port(	
		CLK	: in std_logic;
		RST	: in std_logic;	 
		SET	: in std_logic;  
		CLR	: in std_logic;  
		SOUT : out std_logic
		);
end component;

component Toggle is
	port( 
		CLK	: in STD_LOGIC;
		RST	: in STD_LOGIC;	 
		TOG : in STD_LOGIC;
		TGS : out STD_LOGIC
		);
end component;

component CountDown is 
	generic(n : integer:= 10);
	port(
		CLK: in std_logic;
		RST: in std_logic;
		DEC: in std_logic;
		RDY: out std_logic 
		);				 
end component;

component Deserializer is
	generic(bWidth : integer := 8);
	port(
		CLK : in std_logic;
		RST : in std_logic;
		SHF : in std_logic;
		BIN : in std_logic;
		DOUT : out std_logic_vector(bWidth-1 downto 0)
		);
end component;
----Signals---
signal dummy: std_logic;
signal ENA, EOC, TOG, SYN, SHF: std_logic;
begin
	---Component Instantiation----
		U00: LatchSR port map(CLK, RST, STR, EOC, ENA);
		U01: Timer generic map(25) port map(CLK, ENA, SYN);
		U02: Toggle port map(CLK, ENA, SYN, TOG);
		U03: CountDown generic map(16) port map(CLK, ENA, SYN, EOC);
		U04: Deserializer generic map(16) port map(CLK, RST, SHF, MISO, DOUT);
		
		SHF <= SYN AND NOT TOG;
		SCK <= TOG;
		CSE <= NOT ENA;
		RDY <= NOT ENA;
end Structural;




	