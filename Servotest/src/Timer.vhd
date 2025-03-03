Library IEEE;	   
use IEEE.std_logic_1164.all;   
use IEEE.Numeric_bit.all;

Entity Timer is
	generic(TICKS : integer := 16);
	port( 
	CLK:     in bit;	
	RST:     in bit; 	
	EOT:     out bit
	);
end Timer;

architecture Behavioral of Timer is 
signal Cp, Cn:integer:= 0; 
begin 
	Combinational: process( Cp)
	begin	
		if Cp = TICKS then  
			EOT <= '1'; 
			Cn <= 0;
		else 
			EOT <= '0';
			Cn <= Cp + 1;
			
		end if;	
	end process Combinational;
	
	Sequential: process(CLK, RST)
	begin 
		if RST = '0' then
			Cp <= 0;
		elsif rising_edge(CLK) then	
			Cp <= Cn;			
		end if;	
	end process sequential;
end Behavioral;