library IEEE;
use IEEE.std_logic_1164.all;

entity SPI_MISO is
	generic(
		freq   : integer := 1000000;
		bWidth : integer := 8
		);
	port(
		CLK  : in STD_LOGIC;
		RST  : in STD_LOGIC;
		MISO : in STD_LOGIC;
		STR  : in STD_LOGIC;
		CSE  : out STD_LOGIC;
		RDY  : out STD_LOGIC;
		SCK  : out STD_LOGIC;
		DOUT : out STD_LOGIC_VECTOR(bWidth-1 downto 0)
		);
end SPI_MISO;


architecture Structural of SPI_MISO is 
	------------------Components Declaration------------------
	Component Timer is 
		generic(ticks : integer := 10);
		port( 
			CLK : in std_logic;
			RST : in std_logic;
			SYN : out std_logic
			);
	end Component Timer;	
	----------------------------------------------------------
	Component LatchSR is 
		port(
			
		CLK	: in std_logic;	
		RST	: in std_logic;
			SET	: in std_logic;  
			CLR	: in std_logic;  
			SOUT : out std_logic
			);
	end Component LatchSR;	 
	----------------------------------------------------------
	Component Toggle is 
		port(	  
			CLK	: in STD_LOGIC;	
			RST	: in STD_LOGIC; 
			TOG : in STD_LOGIC;
			TGS : out STD_LOGIC
			);
	end Component Toggle;	
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
	Component Deserializer is 
		generic(bWidth : integer := 8);
		port(
			CLK : in std_logic;
			RST : in std_logic;
			SHF : in std_logic;
			BIN : in std_logic;
			DOUT : out std_logic_vector(bWidth-1 downto 0)
			);
	end Component Deserializer;	
	-----------------Signals declarations---------------------
	Signal ENA, EOC, TOG, SYN, SHF : std_logic;
	
begin 
	
	U01 : LatchSR port map(CLK, RST, STR, EOC, ENA);
	U02 : Timer generic map(5e7/(2*freq)) port map(CLK, ENA, SYN);
	U03 : Toggle port map(CLK, ENA, SYN, TOG);
	U04 : CountDown generic map(bWidth*2) port map(CLK, ENA, SYN, EOC);
	U05 : Deserializer generic map(bWidth) port map(CLK, RST, SHF, MISO, DOUT);
	
	SHF <= SYN AND NOT TOG;
	--SCK <= NOT TOG;-- para leer dato en flanco subida
	SCK <= TOG;-- para leer dato en flanco bajada
	CSE <= NOT ENA;
	RDY <= NOT ENA;
	
end Structural;
