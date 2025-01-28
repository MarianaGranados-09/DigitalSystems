library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity LatchSR is 
	port (
	RST: in bit;
	CLK: in bit;
	CLR:  in bit;
	SET: in bit;
	SOUT: out bit);
end LatchSR;

Architecture Behavioral of LatchSR is 
signal Qp, Qn: bit;
begin 
	
	Combinational:process(Qp,SET,CLR)
	begin 						 
		if SET ='1' then 
			Qn<= '1';
		elsif CLR ='1' then 
			Qn <='0';
		else 
			Qn <=Qp;
		end if ;
		SOUT <=Qp;
		
	end process Combinational;		 
	
    Sequential :process(RST,CLK)	 
	begin 		  
		if RST='0' then 
			Qp<='0';
		elsif CLK'event and CLK='1' then 
			Qp<= Qn;
		end if;
		
		end process Sequential;
		
	end Behavioral;
