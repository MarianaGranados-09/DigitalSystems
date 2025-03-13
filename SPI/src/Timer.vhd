Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;

Entity Timer is
	Generic(
		TICKS: integer:=9  --Constante de la tarjeta.
		);
	
	port(
		CLK : in std_logic;
		RST : in std_logic;
		SYN : out std_logic
		);
end Timer;

Architecture Behavioral of Timer is 
Signal Cn, Cp : integer:=0;
Signal Fin : std_logic:= '0';
Begin  
	SYN <= Fin;
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

Sequential: process (RST, CLK) --En la lista de sensitividad se agregan las entradas o señales que provoquen un cambio en las salidas. 
	begin
		if RST = '0' then
			Cp <= 0;
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;
	end process Sequential;
	
end Behavioral;

