Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;


Entity Counter is
	generic(
	n : integer := 8
	);
	port(  
	CLK: in std_logic;
	RST: in std_logic;
	INC: in std_logic;
	CNT: out std_logic_vector(n-1 downto 0));
end Counter;

Architecture Behavioral of Counter is
signal Cn, Cp: integer;
begin

	Sequential: process(CLK, RST)
	begin
		if RST = '1' then
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
        CNT <= std_logic_vector(to_unsigned(Cp, n));
	end process Combinational;
end Behavioral;

