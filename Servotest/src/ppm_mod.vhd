library IEEE; 
use IEEE.Numeric_bit.all;

Entity ppm_mod is
	generic(width : integer := 11);
	port(
	CLK: in bit;
	RST: in bit;
	PWM: out bit
	);
end ppm_mod;

Architecture Structural of ppm_mod is

--Component Declaration----
Component Timer is
	generic(TICKS : integer := 16);
	port( 
	CLK:     in bit;	
	RST:     in bit; 	
	EOT:     out bit
	);
end component;

Component Counter180 is
	  generic(BusWidth : integer  := 8);
	  port(
	  CLK : in bit;
	  RST : in bit;
	  ENA : in bit;
	  CNT : out bit_vector(BusWidth -1 downto 0)
	  );  
end component;

Component Counter1800 is
	  generic(BusWidth : integer  := 11); --to get to 1800 2^11 = 2048
	  port(
	  CLK : in bit;
	  RST : in bit;
	  ENA : in bit;
	  CNT : out bit_vector(BusWidth -1 downto 0)
	  );  
end component; 


--------Signals-----
signal dummy : bit := '0';
signal eot1_signal: bit := '0';

signal newdut : bit_vector(7 downto 0);	
signal newdut_and_zeros : bit_vector(10 downto 0);

signal finaldut_to_int: integer := 0;  
signal finaldut_plus_45: integer := 0; 
signal finalduty : bit_vector(10 downto 0);

signal CNT_1800 : bit_vector(10 downto 0); --output cnt of counter1800 
signal CNT_180 : bit_vector(7 downto 0);	 --output cnt of counter180
signal ftfive : integer := 45;	 

signal eot2_signal: bit := '0';
begin
----------Component Instantiation-----------
	U01: Timer generic map(554) port map(CLK, RST, eot1_signal); --50MHz/180, increments angle of servo 180 times per second
	
	U02: Counter1800 generic map(BusWidth => 11) port map(CLK, RST, eot1_signal, CNT_1800);
	U03: Timer generic map(277777) port map(CLK, RST, eot2_signal);
	U04: Counter180 generic map(BusWidth => 8) port map(CLK, RST, eot2_signal, CNT_180);
	
	newdut <= CNT_180;	
	newdut_and_zeros <= "000" & newdut;	  
	finaldut_to_int <= to_integer(unsigned(newdut_and_zeros));
	finaldut_plus_45 <= finaldut_to_int + ftfive; 
	finalduty <= bit_vector(to_unsigned(finaldut_plus_45, 11));
	
PWM <= '1' when finalduty > CNT_1800 else '0';
end Structural;
	
	
	
	
