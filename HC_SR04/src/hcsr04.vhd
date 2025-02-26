Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;


Entity hcsr04 is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	STR: in std_logic;
	ECH: in std_logic;
	TRG: out std_logic;
	DIST: out std_logic_vector(31 downto 0)
);
end hcsr04;

Architecture Structural of hcsr04 is
----Component Declaration----

component LatchSR is
	port (
	CLK: in std_logic;
	RST: in std_logic;
	SET: in std_logic;
	CLR:  in std_logic;
	SOUT: out std_logic);
end	component;

component Counter is
	generic(
	n : integer := 8
	);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	INC: in std_logic;
	CNT: out std_logic_vector(n-1 downto 0));
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

---signal definition---
signal dummy: std_logic := '0';	   

signal eot_timer02: std_logic := '0';
signal eot_timer03: std_logic := '0'; 

signal STR_neg: std_logic := '0';
signal SOUT_signal: std_logic := '0'; 

signal RST_counter : std_logic := '0'; 

signal CNT_signal: std_logic_vector(15 downto 0);

constant c17 : unsigned(7 downto 0) := "00010001";
signal CNT_unsigned: unsigned(15 downto 0);	
signal CNTx017: unsigned(23 downto 0);

---Component Instantiation---
begin
	U01: LatchSR port map(CLK, RST, eot_timer02, STR_neg, SOUT_signal);
	U02: Timer generic map(ticks => 500) port map(CLK, SOUT_signal, eot_timer02);
	U03: Timer generic map(ticks => 50) port map(CLK, ECH, eot_timer03);
	U04: Counter generic map(n => 16) port map(CLK, RST_counter, eot_timer03, CNT_signal);
	
	
----code for hcsr04 entity----
	STR_neg <= not(STR); 
	TRG <= SOUT_signal;	
	RST_counter <= not(eot_timer02)	and RST;
	CNT_unsigned <= unsigned(CNT_signal);
	
	--mult x0.17
	CNTx017 <= CNT_unsigned * c17;
	DIST <= std_logic_vector(resize(CNTx017, 32)); --adjust size to 32 bits
	
	
	
end Structural;
	