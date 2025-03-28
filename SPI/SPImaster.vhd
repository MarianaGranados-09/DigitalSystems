library IEEE;
use IEEE.std_logic_1164.all;

Entity SPImaster is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	MISO: in std_logic;
	CSE: out std_logic;	
	SCK: out std_logic;
	DIG: out std_logic_vector(3 downto 0);
	SEG: out std_logic_vector(6 downto 0)
);
end SPImaster;

Architecture Structural of SPImaster is
----Component Declaration----
component Timer is
	generic(ticks:integer:= 19);
	port( 
	CLK:     in std_logic;	
	RST:     in std_logic; 	
	SYN:     out std_logic
	);
end	  component;

component MAX6675 is
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
end component;

component BinaryToDecimal is
	generic(busWidth : integer := 8);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	STR: in std_logic;
	DIN: in std_logic_vector(busWidth-1 downto 0); 
	--CNT: in std_logic_vector(3 downto 0);
	UNI: out std_logic_vector(3 downto 0);
	DEC: out std_logic_vector(3 downto 0);
	CEN: out std_logic_vector(3 downto 0);
	MIL: out std_logic_vector(3 downto 0)
	);									 
end component;

component LoadRegister is
	generic(bWidth : integer := 8);	
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		LDR : in STD_LOGIC;
		DIN : in STD_LOGIC_vector(bWidth-1 downto 0);
		DOUT : out STD_LOGIC_vector(bWidth-1 downto 0)	
		);
end component;

component MultiplexadoUnion is
	generic(
		Cien_Us : integer := 5000
		);	
	port(
		DIG1 : in std_logic_vector(3 downto 0);
		DIG2 : in std_logic_vector (3 downto 0);
		DIG3 : in std_logic_vector (3 downto 0);
		DIG4 : in std_logic_vector (3 downto 0);
		CLK  : in std_logic;
		RST  : in std_logic;
		SEG  : out std_logic_vector (6 downto 0);
		ANO  : out std_logic_vector (3 downto 0)
		);
end component;

---signals declaration----
signal dummy: std_logic;
signal SYN: std_logic;
signal db, da: std_logic_vector(15 downto 0);
signal one, ten, hun, thou: std_logic_vector(3 downto 0);
signal temp: std_logic_vector(9 downto 0);
begin
	----Component instantiation----
		U00: Timer generic map(5e7) port map(CLK, RST, SYN);
		U01: MAX6675 port map(CLK, RST, SYN,OPEN, MISO,CSE, SCK, db);
		U02: BinaryToDecimal generic map(10) port map(CLK, RST, SYN, temp, ONE, TEN, HUN, THOU);
		U03: LoadRegister generic map(16) port map(CLK, RST, SYN, db, da);
		U04: MultiplexadoUnion generic map(10000) port map(THOU, HUN, TEN, ONE, CLK, RST, SEG, DIG);   
		temp <= da(14 downto 5);
end Structural;
		
