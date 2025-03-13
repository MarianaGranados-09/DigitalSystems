library IEEE;
use IEEE.numeric_bit.all;  
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;

Entity SPI1 is
	generic(n : integer := 8);
	port(
	CLK: in std_logic; --clock 50MHz
	RST: in std_logic;	 --reset btn
	STR: in std_logic;	 --start com btn
	MISO: in std_logic;	--MISO in pin
	CSE: out std_logic;	--chip select out pin, active low
	SCK: out std_logic;	--source clk spi <4.3MHz
	RDY: out std_logic;	 --com finished
	DOUT: out std_logic_vector(n-1 downto 0) 
);
end SPI1;

Architecture Structural of SPI1 is
---Component declaration------
	component LatchSR is
	port(
	CLK : in std_logic;
	RST : in std_logic;
	SET : in std_logic;
	CLR : in std_logic;
	SOUT : out std_logic
	);
end component;

component Timer
	generic(
		TICKS: integer:=9  --Constante de la tarjeta.
		);
	
	port(
		CLK : in std_logic;
		RST : in std_logic;
		SYN : out std_logic
		);
end component;

component Toggle is
	port(	
		CLK : in std_logic;
		RST : in std_logic;
		XIN : in std_logic;
		XOUT : out std_logic
		);
end component; 

component CountDown is
	generic(
	   	n : integer := 10);
	port(	 
		CLK : in STD_LOGIC;	--	Clock
		RST : in STD_LOGIC;	--	Reset
		DEC : in STD_LOGIC;	--	Increment
		RDY  : out STD_LOGIC	--	Count done
	 );
end component;

component Deserializer is
	generic(busWidth : integer := 8);
	port(
		CLK : in std_logic;
		RST : in std_logic;
		SHF : in std_logic;
		BIN : in std_logic;
		DOUT : out std_logic_vector(busWidth-1 downto 0)
		);
end component;	

----signal declaration----
signal dummy: std_logic := '0';

signal STR_neg: std_logic := '0';

signal EOC: std_logic := '0';
signal ENA: std_logic := '0';
signal SYN: std_logic := '0'; 
signal TOG: std_logic := '0';
signal SHF: std_logic := '0'; 
--signal SCK: std_logic := '0';  
--signal CSE: std_logic := '0';
--signal RDY: std_logic := '0';

begin

---component instantiation-----
	STR_neg <= not(STR);
	
	SCK <= (TOG); --read at rising edge?
	SHF <= SYN and not(TOG);	
	
	CSE <= not(ENA);
	RDY <= not(ENA);
	
	U01: LatchSR port map(CLK, RST, STR_neg, EOC, ENA);
	U02: Timer generic map(ticks => 2e7) port map(CLK, ENA, SYN);
	U03: Toggle port map(CLK, ENA, SYN, TOG);
	U04: CountDown generic map(n => 16) port map(CLK, ENA, SHF, EOC);	 
	U05: Deserializer generic map(8) port map(CLK, RST, SHF, MISO, DOUT);
	--U05: Serializer port map(CLK, RST, SHF, )		
	
end Structural;