library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity BinaryToDecimal is
	generic( n : integer := 16);
	port(
		CLK : in std_logic;
		RST : in std_logic;
		STR : in std_logic;
		DIN : in std_logic_vector(n-1 downto 0);
		EOC : out std_logic;
		ONE : out std_logic_vector(3 downto 0);
		TEN : out std_logic_vector(3 downto 0);
		HUN : out std_logic_vector(3 downto 0);
		THO : out std_logic_vector(3 downto 0) 
		); 
end BinaryToDecimal; 

Architecture Structural of BinaryToDecimal is 
------------------Components Declaration------------------
	Component LatchSR is port(---
			RST	 : in std_logic;
			CLK	 : in std_logic;	 
			SET	 : in std_logic;  
			CLR	 : in std_logic;  
			SOUT : out std_logic);
	end Component LatchSR;	  
	-----------------------------------------------------
	Component FreeRunCounter is generic(busWidth : integer := 16);----
		port(
			CLK : in std_logic;      
			RST : in std_logic;     
			INC : in std_logic;      
			CNT : out std_logic_vector(busWidth-1 downto 0));
	end Component FreeRunCounter;
	-----------------------------------------------------
	Component DecimalCount is port(---
			CLK  : in std_logic;
			RST  : in std_logic;
			ENI  : in std_logic;
			ONES : out std_logic_vector(3 downto 0); 
			TENS : out std_logic_vector(3 downto 0);
			HUND : out std_logic_vector(3 downto 0);
			THOU : out std_logic_vector(3 downto 0));
	end Component DecimalCount;
	-----------------------------------------------------
	--Signals declarations--
	signal ENA, GTE, INC, RSS, CLR : std_logic;
	signal CNT : std_logic_vector(n-1 downto 0);
begin					
	
	--Component instances--
	U01 : LatchSR port map(RST, CLK, STR, CLR, ENA);
	U02 : FreeRunCounter generic map (n) port map(CLK, ENA, '1', CNT); 
	GTE <= '1' when DIN > CNT else '0';
	CLR <= NOT(GTE);
	INC <= GTE AND ENA;
	RSS <= RST AND NOT (STR); 
	EOC <= NOT (ENA);
	U03 : DecimalCount port map(CLK, RSS, INC, ONE, TEN, HUN, THO);
	
end Architecture Structural;

