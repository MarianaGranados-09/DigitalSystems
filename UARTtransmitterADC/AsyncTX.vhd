library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AsyncTX is
	generic(
		--bWidth : integer := 8;
		--CD : integer := 10
		baudRate : integer := 115200
		);	
	port( 
		CLK : in std_logic;
		RST : in std_logic;
		STR : in std_logic;
		DIN : in std_logic_vector(7 downto 0);
		TXD : out std_logic;
		RDY : out std_logic
		);
end AsyncTX;

architecture Structural of AsyncTX is
	------------------Components Declaration------------------ 
	Component LatchSR is 
		port(
			RST	: in std_logic;
			CLK	: in std_logic;	 
			SET	: in std_logic;  
			CLR	: in std_logic;  
			SOUT : out std_logic
			);
	end Component LatchSR;
	----------------------------------------------------------
	Component TimerCircuit is
		generic(Ticks : integer := 10);
		port(
			RST : in std_logic;
			CLK : in std_logic;
			EOT : out std_logic
			);
	end Component TimerCircuit;		   
	----------------------------------------------------------	
	Component Serializer is
		generic(bWidth : integer := 8);
		port(
			CLK : in std_logic;
			RST : in std_logic;
			LDR : in std_logic;
			SHF : in std_logic;
			DIN : in std_logic_vector(bWidth-1 downto 0);
			DOUT : out std_logic	
			);
	end Component Serializer;		
	----------------------------------------------------------
	Component CountDown is
		generic(n : integer:= 10);
		port(
			CLK: in std_logic;
			RST: in std_logic;
			DEC: in std_logic;
			RDY: out std_logic 
			);			
	end Component CountDown;
	----------------------------------------------------------
	Component RisingEdge is
		port(
			RST : in std_logic;
			CLK : in std_logic;
			XIN : in std_logic;
			XRE : out std_logic
			);
	end Component RisingEdge;
	-----------------Signals declarations---------------------
	Signal XRE : std_logic; 
	Signal EOC : std_logic; 
	Signal ENA : std_logic;
	Signal SYN : std_logic; 
	Signal DATA : std_logic_vector(8 downto 0);
	Signal STR_AUX : std_logic;
begin
	
	--U01 : RisingEdge port map(RST, CLK, STR, XRE);
	U02 : LatchSR port map(RST, CLK, STR, EOC, ENA);
	U03 : TimerCircuit generic map(5e7/baudRate) port map(ENA, CLK, SYN);
	U04 : Serializer generic map(9) port map(CLK, RST, STR, SYN, DATA, TXD);	--bWidth + 1
	U05 : CountDown generic map(10) port map(CLK, ENA, SYN, EOC); --CD
	
	DATA <= DIN & '0';
	RDY <= NOT ENA;	
	--STR_AUX <= NOT STR;
	
end architecture Structural;
