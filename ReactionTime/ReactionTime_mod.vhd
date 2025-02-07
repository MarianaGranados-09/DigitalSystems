library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

Entity ReactionTime is
	generic(n: integer := 10);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	BTN: in std_logic;
	LED_ALRM: out std_logic;
	TIME_vec: out std_logic_vector(n-1 downto 0)
);
end ReactionTime;

Architecture Structural of ReactionTime is
-------Component Declaration------------
Component FreeCounter is
	generic(
	n : integer := 10
	);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	INC: in std_logic;
	CNT: out std_logic_vector(n-1 downto 0));
end Component;


Component LatchSR is 
	port (
	CLK: in std_logic;
	RST: in std_logic;
	CLR:  in std_logic;
	SET: in std_logic;
	SOUT: out std_logic);
end Component;	

Component Timer is
	generic(
	ticks : integer := 500000000 --500 000 000 ticks for a pulse each 10 s
	);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	EOT: out std_logic);
end Component;

Component Blinky_test is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	LED: out std_logic
	);
end Component;	

-------------Signals declaration------------- 
signal blinky_output: std_logic := '0';
signal LatchSR_SOUT : std_logic := '0';	   
signal TIMERU03_EOT: std_logic := '0'; 
signal RST_FreeCounter: std_logic := '0';
begin
	------------Component Instances-----------
		
	U01: Blinky_test port map(CLK, RST, blinky_output);	
	LED_ALRM <= blinky_output;
	U02: LatchSR port map(CLK, RST, BTN, blinky_output, LatchSR_SOUT);
	U03: Timer generic map(ticks => 250000) port map(CLK, LatchSR_SOUT, TIMERU03_EOT); 
	RST_FreeCounter <= not(blinky_output) and RST;
	U04: FreeCounter port map(CLK, RST_FreeCounter, TIMERU03_EOT, TIME_vec);  
	
end Structural;
	


