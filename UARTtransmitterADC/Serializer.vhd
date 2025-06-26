library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Serializer is
	generic(bWidth : integer := 8);
	port(
		CLK : in std_logic;
		RST : in std_logic;
		LDR : in std_logic;
		SHF : in std_logic;
		DIN : in std_logic_vector(bWidth-1 downto 0);
		DOUT : out std_logic	
		);
end Serializer;

architecture Behavioral of Serializer is
	signal Qp, Qn: std_logic_vector(BWidth-1 downto 0);
begin 			 
	
	Combinational : process(Qp, LDR, DIN, SHF)
	begin
		if LDR = '1' then
			Qn <= DIN;
		elsif SHF = '1' then
			Qn <= '1' & Qp(bWidth-1 downto 1);
		else  
			Qn <= Qp;
		end if;			
		DOUT <= Qp(0);		
	end process Combinational; 
	
	Sequential : process (RST, CLK)
	begin 
		if RST = '0' then
			Qp <= (others => '1');
		elsif CLK' event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
	
end Behavioral;
