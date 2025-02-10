Library IEEE;
Use IEEE.NUMERIC_STD.ALL;
use IEEE.Numeric_bit.all;

entity LatchSR is 
	port(	
	CLK : in bit;
	RST : in bit;
	SET : in bit; 
	CLR : in bit; 
	SOUT : out bit
	);
end LatchSR;

architecture Behavioral of LatchSR is 
signal Qn, Qp : bit; 
begin 
	Combinational : process (SET, CLR)
	begin 
		if SET = '1' then 
			Qn <= '1';
		elsif CLR = '1' then 
			Qn <= '0';
		else
			Qn<= Qp;  
		end if;	 
		SOUT <= Qp;
			
	end process Combinational; 
	
	Sequential : process (CLK , RST)
	begin 			
		if RST = '0' then 
			Qp <= '0';
		elsif CLK 'Event and CLK = '1' then
			Qp <= Qn;  
			
		end if;		
			
	end process Sequential; 
	
	
end Behavioral;