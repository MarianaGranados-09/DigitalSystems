Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL; 
Use IEEE.Numeric_std.all;

Entity Counter is 
	generic(
		BusWidth : integer := 7
	);
	port(
		CLK  : in  std_logic;  
        RST  : in  std_logic; 
        INC  : in  std_logic; 
        CNT  : out std_logic_vector(buswidth - 1 downto 0)
	);
end Counter;

Architecture Behavioral of Counter is 
Signal Cn, Cp : std_logic_vector ( BusWidth - 1 downto 0);
begin
	Combinational: process (Cp, INC)
	begin
		if (INC = '1') then
			Cn <= std_logic_vector(unsigned(Cp)+1);
		else
			Cn <= Cp; 
		end if;	
	end process Combinational;

				
	Sequential: process (RST, CLK)
	begin
		if RST = '0' then
			Cp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
			CNT <= Cn;
		end if;
	end process Sequential;	 
	
end Behavioral;