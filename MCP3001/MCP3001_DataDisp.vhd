library IEEE;
use IEEE.std_logic_1164.all;
entity MCP3001_DataDisp is
	port(
		CLK  : in STD_LOGIC;
		RST  : in STD_LOGIC;
		MISO : in STD_LOGIC;
		CSE  : out STD_LOGIC;
		SCK  : out STD_LOGIC;
		TEMPS: out std_logic_vector(6 downto 0);
		ANO: out std_logic_vector(3 downto 0)	
		);	
end MCP3001_DataDisp;

architecture Structural of MCP3001_DataDisp is	
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
	Component SPI_MISO is 
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
	end Component SPI_MISO;	
	----------------------------------------------------------
	Component BinaryToDecimal is 
		generic( busWidth : integer := 10);
		port(
			CLK : in std_logic;
			RST : in std_logic;
			STR : in std_logic;
			DIN : in std_logic_vector(busWidth-1 downto 0);
			UNI : out std_logic_vector(3 downto 0);
			DEC : out std_logic_vector(3 downto 0);
			CEN : out std_logic_vector(3 downto 0);
			MIL : out std_logic_vector(3 downto 0) 
			); 
	end Component BinaryToDecimal;	
	----------------------------------------------------------
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
	
	----------------------------------------------------------
	Component LoadRegister is 
		generic(bWidth : integer := 8);	
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			LDR : in STD_LOGIC;
			DIN : in STD_LOGIC_vector(bWidth-1 downto 0);
			DOUT : out STD_LOGIC_vector(bWidth-1 downto 0)	
			);
	end Component LoadRegister;
	-----------------Signals declarations---------------------
	Signal SYN, SYN2 : std_logic;
	Signal RAW_DATA : std_logic_vector(12 downto 0);
	Signal DATA : std_logic_vector(12 downto 0);
	Signal ONE, TEN, HUN, THO : std_logic_vector(3 downto 0);
	Signal ADC : std_logic_vector(9 downto 0);
	
begin	 
	
	U01 : Timer generic map(5000) port map(CLK, RST, SYN);
	U02 : SPI_MISO generic map(2000000, 13)	port map(CLK, RST, MISO, SYN, CSE, OPEN, SCK, RAW_DATA);
	U09 : Timer generic map(5000000) port map(CLK, RST, SYN2);
	U03 : BinaryToDecimal generic map(10) port map(CLK, RST, SYN2, ADC, ONE, TEN, HUN, THO);
	U08 : LoadRegister generic map(13) port map(CLK, RST, SYN2, RAW_DATA, DATA);
	--U04 : BinToDisp port map(ONE, D1);
--	U05 : BinToDisp port map(TEN, D2);
--	U06 : BinToDisp port map(HUN, D3); 
--	U07 : BinToDisp port map(THO, D4);
	
ADC <= DATA(9 downto 0);	

U013 : MultiplexadoUnion
	generic map(
		Cien_Us => 10000
	)
	port map(
		DIG1 => THO,
		DIG2 => HUN,
		DIG3 => TEN,
		DIG4 => ONE,
		CLK => CLK,
		RST => RST,
		SEG => TEMPS,
		ANO => ANO
	);
	
end Structural;
