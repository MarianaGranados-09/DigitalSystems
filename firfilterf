library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity FIR_Filter is
	port(
		CLK : in std_logic;
		RST : in std_logic;	
		STR : in std_logic;
		XIN : in std_logic_vector(15 downto 0);
		YOUT : out std_logic_vector(47 downto 0)
		);
end FIR_Filter;

architecture Structural of FIR_Filter is  
	-----------------Components Declaration------------------
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
	Component FreeRunCounter is
		generic (
			busWidth : integer := 10 
			);
		port (
			CLK : in std_logic;      
			RST : in std_logic;     
			INC : in std_logic;      
			CNT : out std_logic_vector(busWidth-1 downto 0) 
			);
	end Component FreeRunCounter; 
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
		generic(bWidth : integer := 8);	
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			LDR : in STD_LOGIC;
			DIN : in STD_LOGIC_vector(bWidth-1 downto 0);
			DOUT : out STD_LOGIC_vector(bWidth-1 downto 0)	
			);
	end Component LoadRegister;	
	----------------------------------------------------------
	Component CoefficientROM is
		port(
			SEL : in std_logic_vector(3 downto 0);
			QOUT : out std_logic_vector(31 downto 0)
			);
	end Component CoefficientROM;	
	-----------------Signals declarations---------------------
	signal ENA, EOC : std_logic; 
	signal SEL : std_logic_vector(3 downto 0);
	signal XK0, XK1, XK2, XK3, XK4, XK5, XK6, XK7, XK8, XK9, XK10, XK11, XK12, XK13, XK14 : std_logic_vector(15 downto 0);
	Signal XMUX : std_logic_vector(15 downto 0);
	Signal QMUX : std_logic_vector(31 downto 0);  
	Signal ACCU, MULT, RSUM : std_logic_vector(47 downto 0);
	Signal RSS : std_logic;
	--Signal MULT, RSUM : std_logic_vector(63 downto 0);
	
begin	 
	
	U01: LatchSR port map(RST, CLK, STR, EOC, ENA);
	U02: FreeRunCounter generic map(4) port map(CLK, ENA, '1', SEL);
	U03: CountDown generic map(15) port map(CLK, ENA, '1', EOC); --15 por el orden del filtro
	
	U04  : LoadRegister generic map(16) port map(CLK, RST, STR, XIN, XK0);
	U05  : LoadRegister generic map(16) port map(CLK, RST, STR, XK0, XK1);
	U06  : LoadRegister generic map(16) port map(CLK, RST, STR, XK1, XK2);
	U07  : LoadRegister generic map(16) port map(CLK, RST, STR, XK2, XK3);
	U08  : LoadRegister generic map(16) port map(CLK, RST, STR, XK3, XK4);
	U09  : LoadRegister generic map(16) port map(CLK, RST, STR, XK4, XK5);
	U010 : LoadRegister generic map(16) port map(CLK, RST, STR, XK5, XK6);
	U011 : LoadRegister generic map(16) port map(CLK, RST, STR, XK6, XK7);
	U012 : LoadRegister generic map(16) port map(CLK, RST, STR, XK7, XK8);
	U013 : LoadRegister generic map(16) port map(CLK, RST, STR, XK8, XK9);
	U014 : LoadRegister generic map(16) port map(CLK, RST, STR, XK9, XK10);
	U015 : LoadRegister generic map(16) port map(CLK, RST, STR, XK10, XK11);
	U016 : LoadRegister generic map(16) port map(CLK, RST, STR, XK11, XK12);
	U017 : LoadRegister generic map(16) port map(CLK, RST, STR, XK12, XK13);
	U018 : LoadRegister generic map(16) port map(CLK, RST, STR, XK13, XK14);
	
	with SEL Select XMUX <= 
	XK0  when "0000", 
	XK1  when "0001", 
	XK2  when "0010", 
	XK3  when "0011", 
	XK4  when "0100", 
	XK5  when "0101",
	XK6  when "0110", 
	XK7  when "0111", 
	XK8  when "1000", 
	XK9  when "1001", 
	XK10 when "1010", 
	XK11 when "1011",
	XK12 when "1100", 
	XK13 when "1101", 
	XK14 when "1110", 
	(others => '0') when others;	 	   
	
	U19: CoefficientROM port map(SEL, QMUX);
	
	MULT <= std_logic_vector(signed(XMUX) * signed(QMUX));
	--EMUL <= std_logic_vector(resize(signed(MULT), EMUL'length));
	RSUM <= std_logic_vector(signed(MULT) + signed(ACCU));	 
	
	RSS <= RST AND (NOT (STR));
	
	U20: LoadRegister generic map(48) port map(CLK, RSS, ENA, RSUM, ACCU); 		
	U21: LoadRegister generic map(48) port map(CLK, RST, EOC, ACCU, YOUT);	
	
end Structural;
