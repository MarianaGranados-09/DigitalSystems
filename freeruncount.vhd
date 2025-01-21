Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;


Entity free_run_counter is
	generic(
	n : integer := 8
	);
	port(
	INC: in bit;
	CLK: in bit;
	RST: in bit;
	CNT: out bit_vector(n-1 downto 0));
end free_run_counter;

Architecture Behavioral of free_run_counter is
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

	Combinational: process(Cp, INC)
	begin
		if(INC = '1') then
			Cn <= Cp + 1;	
		else
			Cn <= Cp;
		end if;
        CNT <= bit_vector(to_unsigned(Cp, n));
	end process Combinational;
end Behavioral;


