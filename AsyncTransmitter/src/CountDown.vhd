Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity CountDown is	 
	generic( n: integer := 10);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	DEC: in std_logic;
	EOC: out std_logic
	);		 
end CountDown;

Architecture Behavioral of CountDown is
signal Cp, Cn: integer;
begin
	Combinational: process(Cp, DEC)
	begin			  
		if Cp = 0  then
			EOC <= '1';
			Cn <= 0;
		elsif DEC = '1' then
			EOC <= '0';
			Cn <= Cp - 1; 
		else
			EOC <= '0';
			Cn <= Cp;
		end if;
	end process Combinational;
	
	Sequential: process(RST, CLK)
	begin	
		if RST = '0' then
			Cp <= n;
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;
	end process Sequential;
end Behavioral;
		
	
	