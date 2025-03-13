Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity LatchSR is
	port(
	CLK : in std_logic;
	RST : in std_logic;
	SET : in std_logic;
	CLR : in std_logic;
	SOUT : out std_logic
	);
end LatchSR;

Architecture Behavioral of LatchSR is 
Signal Qn, Qp : std_logic;
begin
	Combinational: process(SET, CLR, Qp)
	begin
		if SET = '1' then
			Qn <= '1';
		elsif CLR = '1'then
			Qn <= '0';
		else
			Qn <= Qp;
		end if;
		SOUT <= Qp;
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