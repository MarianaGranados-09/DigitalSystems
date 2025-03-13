Library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity CountDown is		
	generic(
	   	n : integer := 10
	);
	
	port(	 
		CLK : in STD_LOGIC;	--	Clock
		RST : in STD_LOGIC;	--	Reset
		DEC : in STD_LOGIC;	--	Increment
		RDY  : out STD_LOGIC	--	Count done
	 );
end CountDown;

Architecture Behavioral of CountDown is
signal Cp, Cn: INTEGER := 0;

begin				

	Combinational : process(Cp, DEC)
	begin
		if Cp = 0 then
			Cn <= Cp;
			RDY <= '1';
		elsif DEC = '1' then
			Cn <= Cp - 1;
			RDY <= '0';
		else
			Cn <= Cp;
			RDY <= '0';
		end if;
	end process Combinational;
	
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Cp <= n;
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;
	end process Sequential;
	
end Behavioral;