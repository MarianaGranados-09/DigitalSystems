Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Serializer is
	generic(
		busWidth : integer := 8
	);
	
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SHF : in std_logic;
	LDR : in std_logic;
	DIN : in std_logic_vector (busWidth - 1 downto 0);
	BOUT: out std_logic
	);
end Serializer;

architecture Behavioral of Serializer is
signal Qp, Qn : std_logic_vector (busWidth - 1 downto 0) := (others => '1');
begin
	
	Combinational : process(LDR, DIN, SHF, Qp)
	begin
		if LDR = '1' then
			Qn <= DIN;
		elsif SHF = '1' then 
			--Qn <= Qp(busWidth - 2 downto 0) & '1';
			Qn <= '1' & Qp(busWidth - 1 downto 1);
		else
			Qn <= Qp;
		end if;
		--BOUT <= Qp(busWidth - 1);
		BOUT <= Qp(0);
	end process;

	Sequential : process(RST, CLK)
	begin	   
		if RST = '0' then
			Qp <= (others => '1');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;	
	end process;
	
end architecture;
