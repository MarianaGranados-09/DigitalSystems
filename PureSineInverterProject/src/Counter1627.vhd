library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.Numeric_std.all;		  
use IEEE.std_logic_unsigned.all;

Entity Counter1627 is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	INC: in std_logic;
	COUT: out std_logic_vector(10 downto 0)
);
end Counter1627;
--0110 0101 1010

Architecture Behavioral of Counter1627 is
signal Qp, Qn: std_logic_vector(10 downto 0);
begin
	Combinational: process(Qp, INC)
	begin
		if INC = '1' then 
			if Qp = "11001011010" then
				Qn <= (others => '0');
			else
				Qn <= Qp + 1; 
			end if;
		else
			Qn <= Qp;
		end if;
	end process Combinational;
	
	Sequential: process(CLK, RST)
	begin
		if RST = '0' then 
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;	
	COUT <= Qp;
end Behavioral;