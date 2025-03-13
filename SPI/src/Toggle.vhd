Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity Toggle is
	Port(	
		CLK : in std_logic;
		RST : in std_logic;
		XIN : in std_logic;
		XOUT : out std_logic
		);
end Toggle;
Architecture Behavioral of Toggle is
Signal Qn, Qp : std_logic;
begin
	Combinational: process(Qp, XIN)
	begin
		Qn <= Qp xor XIN;
		XOUT <= Qp;
	end process Combinational;
	
	Sequential: process(RST, CLK) --En la lista de sensitividad se agregan las entradas o señales que provoquen un cambio en las salidas. 
	begin
		if RST = '0' then
			Qp <= '0';
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
	
end Behavioral;