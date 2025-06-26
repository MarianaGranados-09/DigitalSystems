library IEEE;
use IEEE.std_logic_1164.all;
entity TimerCircuit is 
	generic(Ticks : integer := 10);
	port(
		RST : in std_logic;
		CLK : in std_logic;
		EOT : out std_logic
		);
end TimerCircuit;

architecture Behavioral of TimerCircuit is 
signal Cp, Cn : integer; 
begin	 
	
	Combinational : process(Cp)
	begin				   
		if Cp = (Ticks - 1) then
			Cn <= 0;
			EOT <= '1';
		else
			Cn <= Cp + 1;
			EOT <= '0';
		end if;
	end process Combinational;
				   
	Sequential : process(RST, CLK)
	begin		
		if RST = '0' then
			Cp <= 0;
		elsif CLK' event and CLK = '1' then
			Cp <= Cn;
		end if;
	end process Sequential;
	
end Behavioral;
