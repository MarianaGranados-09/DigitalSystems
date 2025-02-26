Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;


Entity Timer is
	generic(
	ticks : integer := 500000000 --500 000 000 for a pulse each 10 s ticks
	);
	port(
	CLK: in std_logic;
	RST: in std_logic;
	EOT: out std_logic);
end Timer;

Architecture Behavioral of Timer is
signal Cn, Cp: integer := 0;
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