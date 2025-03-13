library IEEE;
use IEEE.std_logic_1164.all;
entity LoadRegister is
	generic(bWidth : integer := 8);	
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		LDR : in STD_LOGIC;
		DIN : in STD_LOGIC_vector(bWidth-1 downto 0);
		DOUT : out STD_LOGIC_vector(bWidth-1 downto 0)	
		);
end LoadRegister;

architecture Behavioral of LoadRegister is
	Signal Qp, Qn : STD_LOGIC_vector(bWidth-1 downto 0);
begin
	
	Combinational : process(LDR, Qp, DIN)
	begin
		if LDR = '1' then
			Qn <= DIN;
		else
			Qn <= Qp;
		end if;
		DOUT <= Qp;
	end process Combinational;
	
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= (others => '0');
		elsif CLK' event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;

end Behavioral;
