Library IEEE;	   
use IEEE.std_logic_1164.all;   
use IEEE.Numeric_std.all;

--Definicion de las entradas, salidas y otros

Entity Timer is
 	generic(ticks:integer:= 10);
	port( 
	CLK:     in std_logic;	
	RST:     in std_logic; 	
	SYN:     out std_logic
	);
end Timer;

architecture behavioral of Timer is 
---Inicializando las senales en 0
signal Cp, Cn:integer:= 0; 
begin 
	combinational: process( Cp)
	begin	
		if Cp = ticks then  
			syn <= '1'; 
			Cn <= 0;
		else 
			syn <= '0';
			Cn <= Cp + 1;
			
		end if;	
	end process combinational;
	
	sequential: process( clk, rst)
	begin 
		if rst = '0' then
			Cp <= 0;
		elsif (rising_edge(clk)) then	
			Cp <= Cn;			
		end if;	
	end process sequential;
end behavioral;