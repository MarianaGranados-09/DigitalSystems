library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CounterM10 is 
	port(
		CLK	: in std_logic;
		RST : in std_logic;
		ENI : in std_logic;
		ENO : out std_logic;
		CNT : out std_logic_vector(3 downto 0)
		);
end CounterM10;		  

Architecture Behavioral of CounterM10 is 
	signal Cp, Cn : integer := 0;
begin
	Combinational : process (ENI, Cp) is
	begin
		if ENI = '1' then
			if cp = 9 then
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
		CNT <= std_logic_vector( to_unsigned(Cp, 4) );
	end process Combinational;
	
	Sequential : process (RST, CLK) is
	begin		   
		if RST = '0' then  
			Cp <= 0;
		elsif CLK'event and CLK = '1' then 
			Cp <= Cn;
		end if;	
	end process Sequential;
	
end Architecture Behavioral;
