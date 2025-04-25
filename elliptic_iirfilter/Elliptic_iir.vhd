library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

Entity Elliptic_iir is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	STR : in std_logic;
	XIN : in std_logic_vector(15 downto 0);
	YOUT_FINAL : out std_logic_vector(47 downto 0)
);
end Elliptic_iir;

Architecture Structural of  Elliptic_iir is
---component declaration----
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
	Component ROM_a is
		port(
			SEL : in std_logic_vector(3 downto 0);
			QOUT : out std_logic_vector(31 downto 0)
			);
	end Component ROM_a; 
	
	Component ROM_b is
		port(
			SEL : in std_logic_vector(3 downto 0);
			QOUT : out std_logic_vector(31 downto 0)
			);
	end Component ROM_b;
	
	
	
----signal declaration 
signal dummy: std_logic;
signal ENA, EOC, RSS: std_logic;
signal SEL: std_logic_vector(3 downto 0); 
signal XK0, XK1, XK2, XK3, XK4, XK5, XK6, XK7, XK8, XK9, XK10: std_logic_vector(15 downto 0);
signal YK1, YK2,  YK3, YK4, YK5, YK6, YK7, YK8, YK9, YK10, YK11: std_logic_vector(47 downto 0);

signal XMUX: std_logic_vector(15 downto 0);
signal YMUX: std_logic_vector(47 downto 0);

signal QMUXA: std_logic_vector(31 downto 0);
signal QMUXB: std_logic_vector(31 downto 0);

signal ACCU, XMULT, RXSUM: std_logic_vector(47 downto 0);
signal YMULT, RYSUM: std_logic_vector(47 downto 0);	
signal YOUT: std_logic_vector(47 downto 0);
	

begin
	----component instantiation------
		
		U01: LatchSR port map(RST, CLK, STR, EOC, ENA);	  
		U02: FreeRunCounter generic map(4) port map(CLK, ENA, '1', SEL);
		U03: CountDown generic map(11) port map(CLK, ENA, '1', EOC);
		
		U04: LoadRegister generic map(16) port map(CLK, RST, STR, XIN, XK0);
		U05: LoadRegister generic map(16) port map(CLK, RST, STR, XK0, XK1);
		U06: LoadRegister generic map(16) port map(CLK, RST, STR, XK1, XK2);
		U07: LoadRegister generic map(16) port map(CLK, RST, STR, XK2, XK3);
		U08: LoadRegister generic map(16) port map(CLK, RST, STR, XK3, XK4);
		U09: LoadRegister generic map(16) port map(CLK, RST, STR, XK4, XK5);
		U10: LoadRegister generic map(16) port map(CLK, RST, STR, XK5, XK6);
		U11: LoadRegister generic map(16) port map(CLK, RST, STR, XK6, XK7);
		U12: LoadRegister generic map(16) port map(CLK, RST, STR, XK7, XK8);
		U13: LoadRegister generic map(16) port map(CLK, RST, STR, XK8, XK9);
		U14: LoadRegister generic map(16) port map(CLK, RST, STR, XK9, XK10);
		
		--seleccion de la muestra de acuerdo al valor de SEL
		with SEL Select XMUX <=
		XK0 when "0000",
		XK1 when "0001",
		XK2 when "0010",
		XK3 when "0011",
		XK4 when "0100",
		XK5 when "0101",
		XK6 when "0110",
		XK7 when "0111",
		XK8 when "1000",
		XK9 when "1001",
		XK10 when "1010",
		(others => '0') when others; 
		
		with SEL Select YMUX <=
		YK1 when "0000",
		YK2 when "0001",
		YK3 when "0010",
		YK4 when "0011",
		YK5 when "0100",
		YK6 when "0101",
		YK7 when "0110",
		YK8 when "0111",
		YK9 when "1000",
		YK10 when "1001",
		YK11 when "1010",
		(others => '0') when others; 
		
		--seleccion de coeficiente a, a traves de sel
		U15: ROM_a port map(SEL, QMUXA);
		--seleccion de coeficiente de b, a traves de sel
		U16: ROM_b port map(SEL, QMUXB);
		
		XMULT <= std_logic_vector(signed(XMUX) * signed(QMUXB)); --b_i * x[n] 
		RXSUM <= std_logic_vector(signed(XMULT) + signed(ACCU)); --sumas de coef_a*muestra x	 
		
		YMULT <= std_logic_vector(signed(YMUX) * signed(QMUXA)); --a_i*y[n]
		RYSUM <= std_logic_vector(signed(YMULT) * signed(ACCU));
		
		U17: LoadRegister generic map(48) port map(CLK, RSS, ENA, RXSUM, ACCU);
		U18: LoadRegister generic map(48) port map(CLK, RST, EOC, ACCU, YOUT);
		
		RSS <= RST AND (NOT(STR));
		
		
		
		
end Structural;	