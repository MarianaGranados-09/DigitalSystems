library IEEE;  
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;

Entity BinaryToDecimal is 
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
end BinaryToDecimal;

Architecture Structural of BinaryToDecimal is

------------Components Declaration----------
Component LatchSR is 
	port(  	 
	CLK: in std_logic;
	RST: in std_logic;
	SET: in std_logic; 
	CLR: in std_logic;
	SOUT: out std_logic
	);
end Component;	

Component DecimalCounter is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	ENI: in std_logic;
	ONES: out std_logic_vector(3 downto 0);
	TENS: out std_logic_vector(3 downto 0);
	HUND: out std_logic_vector(3 downto 0);
	THOU: out std_logic_vector(3 downto 0)
	);
end Component;

Component Counter is
	generic(
	busWidth : integer := 10
	);
	port(		   
	CLK: in std_logic;
	RST: in std_logic;
	INC: in std_logic;
	CNT: out std_logic_vector(busWidth-1 downto 0));
end Component;

---------Signals Declaration------
signal ENA, GTE, INC_FINAL, RSS, CLR : std_logic := '0';
signal CNT_signal: std_logic_vector(busWidth-1 downto 0);	 
signal DIN_unsigned : unsigned(busWidth-1 downto 0);
begin	 					
	DIN_unsigned <= unsigned(DIN);
	U01: LatchSR port map(CLK, RST, STR, CLR, ENA);
	U02: Counter generic map(busWidth) port map(CLK, ENA, '1', CNT_signal); 
	--CNT_signal <= CNT;  
	CLR <= not(GTE);
	GTE <= '1' when DIN_unsigned > unsigned(CNT_signal) else '0';
	INC_FINAL <= GTE AND ENA;
	RSS <= RST AND NOT(STR);   
	U03: DecimalCounter port map(CLK, RSS, INC_FINAL, UNI, DEC, CEN, MIL);
end Structural;
	

							 
	