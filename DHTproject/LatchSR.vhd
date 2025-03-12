Library IEEE;	   
use IEEE.std_logic_1164.all;
use IEEE.Numeric_std.all;

--Definicion de las entradas, salidas y otros
Entity LatchSR is 
	port( 
	RST: 	 in std_logic;
	CLK: 	 in std_logic;
	SET:     in std_logic;	
	CLR:     in std_logic; 	
	Salida:    out std_logic 
		
	);
end LatchSR;

architecture behavioral of LatchSR is 
---Inicializando las senales en 0
signal Qp, Qn:std_logic:='0';
begin 
	combinational: process( Qp, CLR, SET)
	begin
		if SET = '1' then	
			Qn <= '1';	
		elsif CLR = '1' then
			Qn <= '0';
		else 
			Qn <= Qp;
		end if;	   
		Salida <= Qp;
	end process combinational;
	
	sequential: process(CLK, RST)
	begin 
		if RST = '0' then
			Qp <= '0';
		elsif (rising_edge(CLK)) then	
			Qp <= Qn;			
		end if;	
	end process sequential;
end behavioral;