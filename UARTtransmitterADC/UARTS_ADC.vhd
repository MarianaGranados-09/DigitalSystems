library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UARTS_ADC is 
	port(
		CLK : in std_logic;	  
		RST : in std_logic;
		STR : in std_logic;
		--	 : in std_logic_vector(15 downto 0);
		TXD : out std_logic
		);
end UARTS_ADC;

architecture Structural of UARTS_ADC is
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
	Component LoadRegister is
		generic(bWidth : integer := 16);	
		port(
			CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		LDR : in STD_LOGIC;
		DIN : in STD_LOGIC_vector(bWidth-1 downto 0);
		DOUT : out STD_LOGIC_vector(bWidth-1 downto 0)		
			);
	end Component LoadRegister;	  
	----------------------------------------------------------
	Component BinaryToDecimal is
		generic( n : integer := 16);
		port(
			CLK : in std_logic;
			RST : in std_logic;
			STR : in std_logic;
			DIN	: in std_logic_vector(n-1 downto 0);
			EOC : out std_logic;
			ONE : out std_logic_vector(3 downto 0);
			TEN : out std_logic_vector(3 downto 0);
			HUN : out std_logic_vector(3 downto 0);
			THO : out std_logic_vector(3 downto 0) 
			); 
	end Component BinaryToDecimal; 		  
	----------------------------------------------------------
	Component ServoS_SamplerFSM is
		port(
			CLK	: in std_logic;
			RST	: in std_logic;
			SYN	: in std_logic;
			ECV	: in std_logic;
			EOT : in std_logic;
			--SGN : in std_logic;
			
			STC	: out std_logic;
			STT	: out std_logic;
			SEL	: out std_logic_vector(2 downto 0)
			);
	end Component ServoS_SamplerFSM;
	----------------------------------------------------------
	Component Decimal_to_ASCII is
		port(
			U  : in  std_logic_vector(3 downto 0); 
			D  : in  std_logic_vector(3 downto 0); 
			C  : in  std_logic_vector(3 downto 0); 
			M  : in  std_logic_vector(3 downto 0); 
			
			AU : out std_logic_vector(7 downto 0); 
			AD : out std_logic_vector(7 downto 0); 
			AC : out std_logic_vector(7 downto 0); 
			AM : out std_logic_vector(7 downto 0)  
			);
	end Component Decimal_to_ASCII;	
	----------------------------------------------------------
	Component AsyncTX is
		generic(
			--bWidth : integer := 8;
			--CD : integer := 10
			baudRate : integer := 115200
			);	
		port( 
			CLK : in std_logic;
			RST : in std_logic;
			STR : in std_logic;
			DIN	: in std_logic_vector(7 downto 0);
			TXD : out std_logic;
			RDY : out std_logic
			);
	end Component AsyncTX;
	-----------------Signals declarations--------------------- 
	Signal EOC, ENA, SYN, ECV, SGN, EOT, STC, STT: std_logic; 
	Signal SEL : std_logic_vector(2 downto 0);
	Signal ONE, TEN, HUN, THO : std_logic_vector(3 downto 0);
	Signal AUX : std_logic_vector(11 downto 0);	
	Signal VAL : std_logic_vector(11 downto 0);
	Signal BTS, DIG3, DIG2, DIG1, DIG0 : std_logic_vector(7 downto 0); 
	SIGNAL STR_N: std_logic := '0';
	SIGNAL DIN: std_logic_vector(11 downto 0);
begin
	DIN <= "011000011111"; --1,567
	STR_N <= not(STR);
	U01 : LatchSR port map(RST, CLK, STR_N, EOC, ENA);
	U02 : TimerCircuit generic map(50000000) port map(ENA, CLK, SYN); --1ms
	U03 : CountDown generic map(1) port map(CLK, ENA, SYN, EOC);
	U04 : LoadRegister generic map(12) port map(CLK, RST, SYN, 	DIN, AUX);
	
	--SGN <= AUX(15); --Signo del vector
	SGN <= '0';
	VAL <= AUX;
	
	U05 : ServoS_SamplerFSM port map (CLK, RST, SYN, ECV, EOT, STC, STT, SEL);
	U06 : BinaryToDecimal generic map(12) port map(CLK, RST, STC, VAL, ECV, ONE, TEN, HUN, THO); 
	
	U07 : Decimal_to_ASCII port map(ONE, TEN, HUN, THO, DIG0, DIG1, DIG2, DIG3);
	
	with SEL Select
	BTS <= 
	"00101101" when "000", --Sign
	DIG3 when "001",	   --Millares
	DIG2 when "010",	   --Centenas
	DIG1 when "011",	   --Decenas
	DIG0 when "100", 	   --Unidades
	"00001010" when others;--Salto l�nea
	
	U08 : AsyncTX generic map(115200) port map(CLK, RST, STT, BTS, TXD, EOT);
	
end Structural;