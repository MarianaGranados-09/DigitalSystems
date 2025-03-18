   library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter is
	generic (
		busWidth : integer := 8 
		);
	port (
		CLK : in std_logic;      
		RST : in std_logic;     
		INC : in std_logic;      
		CNT : out std_logic_vector(busWidth-1 downto 0) 
		);
end Counter;

architecture Behavioral of Counter is
	signal Cp : integer := 0; -- Valor actual del contador
	signal Cn : integer := 0; -- Valor pr?ximo del contador
	signal Cp_unsigned : unsigned(busWidth-1 downto 0);
begin
	
	Combinational : process(Cp, INC)
	begin
		if INC = '1' then
			Cn <= Cp + 1; -- Incrementa el contador
		else
			Cn <= Cp; 
		end if;	  
		--Cp_unsigned <= to_unsigned(Cp, busWidth); -- Conversi?n de integer a unsigned
         CNT <= std_logic_vector( to_unsigned(Cp, busWidth) );
	end process Combinational;
	
	Sequential : process(CLK, RST)
	begin
		if RST = '0' then
			Cp <= 0; -- Reinicia el contador a cero
		elsif CLK' event and CLK = '1' then
			Cp <= Cn; -- Actualiza con el valor calculado
		end if;
	end process Sequential;	
	
end Behavioral;