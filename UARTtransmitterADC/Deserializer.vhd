library IEEE;
use IEEE.std_logic_1164.all;
entity Deserializer is
	generic(bWidth : integer := 8);
	port(
		CLK : in std_logic;
		RST : in std_logic;
		SHF : in std_logic;
		BIN : in std_logic;
		DOUT : out std_logic_vector(bWidth-1 downto 0)
		);
end Deserializer;

architecture Behavioral of Deserializer is
	Signal Qp, Qn : std_logic_vector(bWidth-1 downto 0);
begin 
	
	Combinational : process(SHF, Qp, BIN)
	begin
		if SHF = '1' then
			--Qn <= BIN & Qp(bWidth-1 downto 1);
			Qn <= Qp(bWidth - 2 downto 0) & BIN;
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