library IEEE;
use IEEE.std_logic_1164.all;

entity CountDown is 
	generic(n : integer:= 10);
	port(
		CLK: in std_logic;
		RST: in std_logic;
		DEC: in std_logic;
		RDY: out std_logic 
		);				 
end CountDown;

Architecture Behavioral of CountDown is
	signal Cp, Cn: integer := 0;	
begin
	Combinational: process(Cp, DEC) is
	begin
		if(Cp = 0) then
			Cn <= Cp; 
			RDY <= '1';
		elsif (DEC = '0')then
			Cn <= Cp;
			RDY <= '0';
		else 
			Cn <= Cp - 1;
			RDY <= '0';
		end if;	
	end process Combinational; 
	
	
	Sequential: process (RST, CLK) is
	begin
		if RST = '0' then 
			Cp <= n;
		elsif (CLK' event and CLK = '1')then
			Cp <= Cn;
		end if;
	end process Sequential;
end architecture Behavioral;
