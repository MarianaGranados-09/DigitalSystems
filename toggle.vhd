   Entity Toggle is 
	port(
	TOG: in bit;
	CLK: in bit;
	RST: in bit;
	TGS: out bit
	);
end Toggle;

Architecture Behav of Toggle is	
Signal Qn, Qp : bit;
begin
	Combinational: process(TOG, Qp)	--el proceso combinational depende de TOG y Qp
	begin	   
		--Si TOG es igual a Qp, entonces xor gate es 0
		--Qn = 0		  
		
		--Si TOG es diferente a Qp, entonces xor gate 1	
		--Qn = 1
		
		Qn <= TOG xor Qp;
		--Asignar Qp a TGS
		TGS <= Qp;
	end process Combinational;
	
	Sequential: process(CLK, RST)
	begin		 
		--si RST = 0, entonces resetea Qp
		if(RST = '0') then
			Qp <= '0'; 
		--Si hay un evento de reloj y esta en alto,
		--Haz el cambio de TGS asigna Qn
		--y Qp asigna Qn
		elsif CLK'event and CLK='1' then
			Qp <= Qn;	--vale of Qp assigned to Qn
		end if;
	end process Sequential;
end Behav;
