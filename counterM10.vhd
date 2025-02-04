library IEEE;
use IEEE.numeric_bit.all;  
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;


Entity CounterM10 is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	ENI: in std_logic; --input enable
	CNT: out std_logic_vector(3 downto 0); --4 bits to keep count
	ENO: out std_logic  --bit to keep count state	 --output enable
	);
end CounterM10;

Architecture Behavioral of CounterM10 is
signal Cp, Cn: integer := 0;
begin
	
	Sequential: process(CLK, RST)
	begin
		if RST = '0' then
			Cp <= 0; --restart count to 0
		elsif CLK'event and CLK = '1' then
			Cp <= Cn; --port Cn assigned to Cp
		end if;	  
	end process Sequential;
	
	Combinational: process(Cp, ENI) 
	begin
		if ENI = '1' then
			if Cp = 9  then
				Cn <= 0;
				ENO <= '1';
			else
				Cn <= Cp + 1;  
				ENO <= '0';
			end if;
		else 
			Cn <= Cp;
			ENO <= '0';
		end if;		 
		CNT <= std_logic_vector(to_unsigned(Cp, 4)); --add output vector of count
	end process Combinational;
end Behavioral;
	
			
