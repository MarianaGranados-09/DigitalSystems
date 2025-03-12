Library IEEE;	   
use IEEE.std_logic_1164.all; 
use IEEE.Numeric_std.all;

Entity RisingEdge is
	port(
		RST : in std_logic;
		CLK : in std_logic;
		XIN : in std_logic;
		XRE : out std_logic
		);
	end RisingEdge;
	
	Architecture Behavioral of RisingEdge is 
	Signal Qn : std_logic_vector(1 downto 0);
	signal Qp : std_logic_vector(1 downto 0);
	begin
	
	Combinational : process (Qp, XIN)
	begin  
		Qn <= XIN & Qp(1);
		XRE <=  Qp(1) AND not (Qp(0));
		
	end process Combinational;	 
	
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then 
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
	
end Behavioral;