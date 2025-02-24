Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity AsyncTrans is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	STR: in std_logic;
	DIN: in std_logic_vector(7 downto 0);
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

component RisingEdge is
	generic(
	n : integer := 4 ); 
	port(
	CLK: in std_logic;
	RST: in std_logic;
	XIN: in std_logic;
	XRE: out std_logic);
end	component;

--signal declaration----
signal dummy: std_logic := '0';

signal SYN : std_logic := '0';
signal ENA: std_logic := '0'; 
signal EOC: std_logic := '0';  
signal STR_signal: std_logic := '0';
signal STR_RE: std_logic := '0';	  
signal STR_signal_not: std_logic := '0';	
--signal DIN : std_logic_vector(7 downto 0) := "01111011";
signal din_not: std_logic_vector(7 downto 0);

signal DIN_signal : std_logic_vector(8 downto 0) := (others => '0');

signal rdy_signal: std_logic := '0';
begin
	rdy_signal <= not(ENA);
	RDY <= not(rdy_signal); --0 is busy, 1 is available
----Component Instantiation-----
	U01: LatchSR port map(CLK, RST, STR_signal, EOC, ENA);	 
	
	--ticks = clk/baud
	--434 ticks -> 115200 baud
	--5208 ticks -> 9600 baud
	U02: Timer generic map(ticks => 434) port map(CLK, ENA, SYN);
	U03: CountDown generic map(n => 10) port map(CLK, ENA, SYN, EOC);
	U03_1: Serializer generic map(BusWidth => 9) port map(CLK, RST, DIN_signal, STR_signal, SYN, TXD); 
	U04: RisingEdge generic map(n => 4) port map(CLK, RST, STR_signal_not, STR_RE);
	
	--DIN <= testdin;  
	din_not <= not(DIN);
	DIN_signal <= din_not & '0';
	--STR_signal <= not(STR_RE) and not(ENA);   
	STR_signal <= STR_RE and not(ENA);
	STR_signal_not <= not(STR);
end Structural;
	
