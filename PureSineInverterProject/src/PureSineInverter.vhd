library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.Numeric_std.all;		  
use IEEE.std_logic_unsigned.all;

Entity PureSineInverter is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	--PWM: out std_logic;
	PWMA: out std_logic;
	PWMB: out std_logic
	--DIR: out std_logic
);
end PureSineInverter;

Architecture Structural of PureSineInverter is
---Component definition----
	component Timer is
 	generic(ticks:integer:= 10);
	port( 
	CLK:     in std_logic;	
	RST:     in std_logic; 	
	SYN:     out std_logic
	);
end component;

component Counter is
	generic (
		busWidth : integer := 8 
		);
	port (
		CLK : in std_logic;      
		RST : in std_logic;     
		INC : in std_logic;      
		CNT : out std_logic_vector(busWidth-1 downto 0) 
		);
end component;

component SineLUT is 
	port(
	ANG: in std_logic_vector(6 downto 0);
	SIN: out std_logic_vector(10 downto 0)
);
end component;

component Counter1627 is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	INC: in std_logic;
	COUT: out std_logic_vector(10 downto 0)
);
end component;

--signal definition---
signal dummy: std_logic;
signal SYN: std_logic; 
signal ANG: std_logic_vector(6 downto 0) := (others => '0');  
signal SIN : std_logic_vector(10 downto 0) := (others => '0');
signal CNT : std_logic_vector(10 downto 0) := (others => '0'); 
signal PWM: std_logic;
--signal SINprueba: std_logic_vector(10 downto 0) := "00010010011";

begin
	---Component instantiation--- 
		--6510 ticks for 60 Hz
		U01: Timer generic map(6510) port map(CLK, RST, SYN); 									   
		--contador de 7 bits, para 128 valores en la onda senoidal, es decir, 7 bits de resolucion 
		--su salida ANG es la direccion para la LUT
		U02: Counter generic map(7) port map(CLK, RST, SYN, ANG);
		U03: SineLUT port map(ANG, SIN); 
		U04: Counter1627 port map(CLK, RST, '1', CNT); --genera una señal triangular o rampa
		--spwm se obtiene de comparar la onda seno con una onda triangular
		
		--DIR <= ANG(6);	
		PWMA <= PWM when ANG(6) = '0' else '0';
		PWMB <= PWM when ANG(6) = '1' else '0';
		PWM <= '1' when SIN > CNT else '0';
end Structural;
		 