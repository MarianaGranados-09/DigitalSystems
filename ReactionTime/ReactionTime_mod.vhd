 library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


Entity ReactionTime is	 
	generic( m: integer := 4);
	port(
	CLK : in std_logic;
	RST: in std_logic;	
	BTN: in std_logic;
	--LED: out std_logic;
	ALRM: out std_logic;
	TIME_vec: out std_logic_vector(m-1 downto 0)
	);
end ReactionTime;

Architecture Structural of ReactionTime is
-------Component Declaration------
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

------Signals Declaration------
signal TIMERU01_EOT: std_logic := '0';
signal TIMERU03_EOT: std_logic := '0';
signal LatchSR_SOUT: std_logic := '0';
signal RST_FreeCounter : std_logic := '0';
begin 
------Component instances------	 
	
	--TimerU01 emmits a pulse each 10s and turns on an LED
	--500 000 000 ticks for a pulse each 10 s
	U01: Timer generic map(ticks => 500000000) port map(CLK, RST, TIMERU01_EOT);
	--LED <= TIMERU01_EOT; --LED	
	
	--LatchSR is activated by TimerU01 output, so SET -> TIMERU01_EOT
	U02: LatchSR port map(CLK, RST, BTN, TIMERU01_EOT, LatchSR_SOUT);
	
	--output of LatchSR goes to ALRM physical output and to the RST on TimerU03
	
	--LatchSR_SOUT -> ALRM, LatchSR_SOUT -> RST on TimerU03 
	ALRM <= LatchSR_SOUT;  
	U03: Timer generic map(ticks => 250000) port map(CLK, LatchSR_SOUT, TIMERU03_EOT); 	
	
	--RST of FreeCounter is =  not(output of TimerU01) and general RST
	RST_FreeCounter <= not(TIMERU01_EOT) AND RST; 
	--output of TimerU03 activates FreeCounterU04
	--ouput of FreeCounter goes to physical output (TIME_vec)
	U04: FreeCounter port map(CLK, RST_FreeCounter, TIMERU03_EOT, TIME_vec); 
	
end Structural;
	


	
	
