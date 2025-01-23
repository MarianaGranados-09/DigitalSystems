Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;


Entity timer is
	generic(
	ticks : integer := 10 --10 ticks
	);
	port(
	CLK: in bit;
	RST: in bit;
	EOT: out bit);
end timer;

Architecture Behavioral of timer is
signal Cn, Cp: integer;
begin

	Sequential: process(CLK, RST)
	begin
		if RST = '0' then
			Cp <= 0;
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;	--port Cn assigned to Cp
		end if;
	end process Sequential;

	Combinational: process(Cp)
	begin
		if Cp = (ticks - 1) then
			Cn <= 0;
            EOT <= '1';
		else
			Cn <= Cp + 1;
            EOT <= '0';
		end if;
	end process Combinational;
end Behavioral;


