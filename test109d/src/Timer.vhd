Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.Numeric_bit.all;

Entity Timer is
	Generic(
		TICKS: integer:= 9  --Constante de la tarjeta.
		);
	port(
		CLK : in bit;
		RST : in bit;
		EOT : out bit
		);
end Timer;

Architecture Behavioral of Timer is 
Signal Cn, Cp : integer:=0;
Signal Fin : bit:= '0';
Begin  
	EOT <= Fin;
	Comparador: process (Cp)
	begin
		if Cp = TICKS then
			Fin <= '1';
			Cn <= 0;
		else
			Cn <= Cp + 1;
			Fin <= '0';
		end if;
	end process Comparador;

Sequential: process (RST, CLK)
	begin
		if RST = '0' then
			Cp <= 0;
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;
	end process Sequential;
	
end Behavioral;
