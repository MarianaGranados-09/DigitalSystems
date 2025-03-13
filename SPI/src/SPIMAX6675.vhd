library IEEE;
use IEEE.numeric_bit.all;  
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;	

Entity SPIMAX6675 is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	--STR: in std_logic;
	MISO: in std_logic;
	CSE: out std_logic;
	SCK: out std_logic;
	RDY: out std_logic;
	ANO: out std_logic_vector(3 downto 0);
	SEG: out std_logic_vector(6 downto 0)
);

end SPIMAX6675;

Architecture Structural of SPIMAX6675 is 
----Component declaration----
component Timer is
	Generic(
		TICKS: integer:=9  --Constante de la tarjeta.
		);
	
	port(
		CLK : in std_logic;
		RST : in std_logic;
		SYN : out std_logic
		);
end	component;

component BinaryToDecimal is
	generic(BusWidth:integer:= 4; 
	numero: integer:= 10);
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
end component;

component LoadRegister is
	generic(bWidth : integer := 8);	
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		LDR : in STD_LOGIC;
		DIN : in STD_LOGIC_vector(bWidth-1 downto 0);
		DOUT : out STD_LOGIC_vector(bWidth-1 downto 0)	
		);
end component;

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

component SPI1 is
	generic(n: integer := 8);
	port(
	CLK: in std_logic; --clock 50MHz
	RST: in std_logic;	 --reset btn
	STR: in std_logic;	 --start com btn
	MISO: in std_logic;	--MISO in pin
	CSE: out std_logic;	--chip select out pin, active low
	SCK: out std_logic;	--source clk spi <4.3MHz
	RDY: out std_logic;	 --com finished
	DOUT: out std_logic_vector(n-1 downto 0) 
);
end component;

---signals---
signal dummy : std_logic := '0';
signal str_spi: std_logic := '0';
signal rdy_neg: std_logic := '0'; 
signal spi_dout: std_logic_vector(15 downto 0);	
signal loadr_dout: std_logic_vector(15 downto 0); 
signal rtemp: std_logic_vector(9 downto 0);	

signal un,dec,cen,mil: std_logic_vector(3 downto 0);


begin  
	RDY <= not(rdy_neg); 
	rtemp <= loadr_dout(14 downto 5);
	
	
	U01: Timer generic map(ticks => 5e7) port map(CLK, RST, str_spi);
	U02: SPI1 generic map(n => 16) port map(CLK, RST, str_spi, MISO, CSE, SCK, rdy_neg, spi_dout);
	U03: LoadRegister generic map(16) port map(CLK, RST, str_spi, spi_dout, loadr_dout);
	U04: BinaryToDecimal generic map(4, 10) port map(CLK, RST, str_spi, rtemp, un, dec, cen, mil);
	U05: MultiplexadoUnion generic map(5000) port map(un, dec, cen, mil, CLK, RST, SEG, ANO);  
	
end Structural; 



	
