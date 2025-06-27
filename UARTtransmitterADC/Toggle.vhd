library IEEE;
use IEEE.std_logic_1164.all;
Entity Toggle is
	port( 
		CLK	: in STD_LOGIC;
		RST	: in STD_LOGIC;	 
		TOG : in STD_LOGIC;
		TGS : out STD_LOGIC
		);
end Toggle;

Architecture Behavioral of Toggle is
	signal Qp, Qn : STD_LOGIC;
begin 
	
	Qn <= TOG XOR Qp;
	
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= '0';
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;	 
	end process Sequential;	  
	
	TGS <= Qp;
	
end Behavioral;		