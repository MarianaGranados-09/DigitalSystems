Library IEEE;	   
use IEEE.std_logic_1164.all;   
use IEEE.Numeric_std.all;

--Definicion de las entradas, salidas y otros
Entity BinaryToDecimal is  
	generic(BusWidth:integer:= 4; numero: integer:= 10);
	port(
	CLK:     in std_logic;
	RST:     in std_logic;	
	STR:     in std_logic; 
	DIN : 	in std_logic_vector(numero-1 downto 0);
	ONES:    out std_logic_vector ( BusWidth - 1 downto 0); 
	TENS:    out std_logic_vector ( BusWidth - 1 downto 0);
	HUND:    out std_logic_vector  ( BusWidth - 1 downto 0); 
	THO:     out std_logic_vector ( BusWidth - 1 downto 0) 
	);
end BinaryToDecimal;

architecture Structural of BinaryToDecimal is 
-----Counter
Component Counter is
	  generic(n : integer  := 2);
	  port(
	  CLK : in std_logic;
	  RST : in std_logic;
	  INC : in std_logic;
	  CNT  : out std_logic_vector(n -1 downto 0)
	  );  
  end Component;
 ------LatchSR
Component LatchSR is 
	port( 	 
	CLK: 	 in std_logic;
	RST: 	 in std_logic;
	SET:     in std_logic;	
	CLR:     in std_logic; 	
	SOUT:    out std_logic 
		
	);
end Component;
------DecimalCounter

Component DecimalCounter is
	port(  
		CLK : in std_logic;
		RST : in std_logic;
		ENI : in std_logic;
		ONES : out std_logic_vector(3 downto 0); 
		TENS : out std_logic_vector(3 downto 0);
		HUND : out std_logic_vector(3 downto 0);
		THOU : out std_logic_vector(3 downto 0)
		); 
end Component;
--------------Display

		
---signals
signal ENA:     std_logic;
signal GTE:     std_logic;
signal notGTE:     std_logic;
signal INC:     std_logic;
signal RSS:     std_logic;
signal CNT: std_logic_vector( numero - 1  downto 0);


begin 														 
	U01: LatchSR port map(CLK, RST, STR, notGTE, ENA);	  
	U02: Counter generic map(n => 8) port map(CLK, ENA, '1', CNT);    
	U03 : DecimalCounter port map(CLK, RSS, INC, ONES, TENS,HUND,THO);	 
	notGTE <= (not GTE);	
	INC <= GTE and ENA;
	RSS <= RST and (not STR);	
	GTE <= '1' when DIN > CNT else '0';
end Structural;