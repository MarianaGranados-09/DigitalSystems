Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity AsyncTrans is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	STR: in std_logic;
	DIN: in std_logic_vector(3 downto 0);
	RDY: out std_logic;
	TXD: out std_logic
	);
end AsyncTrans;

Architecture Structural of AsyncTrans is
---Component declaration----
component LatchSR is
	port (
	CLK: in std_logic;
	RST: in std_logic;
	SET: in std_logic;
	CLR:  in std_logic;
	SOUT: out std_logic);
end component;

component Timer is
	generic(
	ticks : integer := 500000000 --500 000 000 for a pulse each 10 s ticks
	);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	EOT: out std_logic);
end component;

component CountDown is
	generic( n: integer := 10);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	DEC: in std_logic;
	EOC: out std_logic
	);		 
end component;

component Serializer is
	generic(
		BusWidth : integer := 8
	);
	port(  
	CLK  : in std_logic;
	RST  : in std_logic;
	DIN  : in std_logic_vector(BusWidth - 1 downto 0);
	LDR  : in std_logic;
	SHF  : in std_logic;
	DOUT : out std_logic
	);
end component;

--signal declaration----
signal dummy: std_logic := '0';

signal SYN : std_logic := '0';
signal ENA: std_logic := '0'; 
signal EOC: std_logic := '0';

signal rdy_signal: std_logic := '0';
begin
	rdy_signal <= not(ENA);
	RDY <= rdy_signal; --0 is busy, 1 is available
----Component Instantiation-----
	U01: LatchSR port map(CLK, RST, STR, EOC, ENA);
	U02: Timer generic map(ticks => 1000) port map(CLK, ENA, SYN);
	U03: CountDown generic map(8) port map(CLK, ENA, SYN, EOC);
	U03_1: Serializer generic map(BusWidth => 7) port map(CLK, RST, DIN, STR, SYN, TXD);
end Structural;
	
