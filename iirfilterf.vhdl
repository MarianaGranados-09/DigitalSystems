library IEEE;
use IEEE.std_logic_1164.all;
Use IEEE.Numeric_std.all;

entity LowpassFilter is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	STR: in std_logic;
	XIN: in std_logic_vector(18 downto 0);
	YOUT: out std_logic_vector(42 downto 0)
	);
end LowpassFilter;

Architecture Structural of LowpassFilter is
---component declaration---	   
	component CountDown is	 
	generic( n: integer := 10);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	DEC: in std_logic;
	RDY: out std_logic
	);		 
end component CountDown;

component FreeRunCounter is 
	generic(
		BusWidth : integer := 7
	);
	port(
		CLK  : in  std_logic;  
        RST  : in  std_logic; 
        INC  : in  std_logic; 
        CNT  : out std_logic_vector(buswidth - 1 downto 0)
	);
end component FreeRunCounter;	  

component LatchSR is 
	port(
			RST	: in std_logic;
			CLK	: in std_logic;	 
			SET	: in std_logic;  
			CLR	: in std_logic;  
			SOUT : out std_logic
		
	);
end component LatchSR; 

component LoadRegister is
	generic(bWidth : integer := 8);	
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		LDR : in STD_LOGIC;
		DIN : in STD_LOGIC_vector(bWidth-1 downto 0);
		DOUT : out STD_LOGIC_vector(bWidth-1 downto 0)	
		);
end component LoadRegister;

----signals----
signal dummy: std_logic; 

signal ENA, EOC, RSS: std_logic;
signal SEL: std_logic_vector(1 downto 0);
signal b0: std_logic_vector(24 downto 0):= "0000000000010110000011000";
signal b1: std_logic_vector(24 downto 0):= "1111111111101001111101000";
signal a1: std_logic_vector(17 downto 0):= "111010011111001111";
signal XK0: std_logic_vector(17 downto 0);
signal XK1: std_logic_vector(17 downto 0);
signal YK1: std_logic_vector(24 downto 0);

signal XXX: std_logic_vector(17 downto 0);

signal XMUX: std_logic_vector(17 downto 0);
signal QMUX: std_logic_vector(23 downto 0);
signal MULT: std_logic_vector(42 downto 0);
signal ACCU: std_logic_vector(42 downto 0);
signal RSUM: std_logic_vector(42 downto 0);

signal YAUX: std_logic_vector(42 downto 0);

---component instantiation---
begin	
	
	RSS <= RST AND NOT(STR);
	
	U01: LatchSR port map(RST, CLK, STR, EOC, ENA);
	U02: FreeRunCounter generic map(2) port map(ENA, CLK, '1', SEL);
	U03: CountDown generic map(3) port map(ENA, CLK, '1', EOC);
	
	XXX <= std_logic_vector(resize(signed(XIN,18)));
	U04: LoadRegister generic map(18) port map(RST, CLK, STR, XXX, XK0); 
	U05: LoadRegister generic map(18) port map(RST, CLK, STR, XK0, XK1);
	U06: LoadRegister generic map(25) port map(RST, CLK, STR, YAUX(42 downto 18), YK1);
	
	
	With SEL select XMUX <= XK0 when "00", XK1 when "01", a1 when "10", (others => '0') when others;
	With SEL select QMUX <= b0 when "00", b1 when "01", YK1 when "11", (others => '0') when others;
	
	MULT <= std_logic_vector(signed(XMUX) * signed(QMUX));
	RSUM <= std_logic_vector(signed(MULT) + signed(ACCU));
	
	
	U07: LoadRegister generic map(42) port map(RSS, CLK, '1', RSUM, ACCU);
	U08: LoadRegister generic map(42) port map(RST, CLK, EOC, ACCU, YOUT);
	YOUT <= YAUX;

end Structural;
