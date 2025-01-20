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
	Combinational: process(TOG, Qp)
	begin	   
		--Si TOG es igual a Qp, entonces xor gate es 0
		--Qn = 0
		if(TOG = Qp) then
			Qn <= '0';
		--Aqui, TOG es diferente de Qp entonces xor gate es 1
		--Qn = 1
		else 
			Qn <= '1';
		end if;
	end process Combinational;
	
	D_FlipF: process(CLK, RST)
	begin		 
		--si RST = 1, entonces resetea TGS y Qp
		if(RST = '0') then
			TGS <= '0';
			Qp <= '0'; 
		--Si hay un evento de reloj y esta en alto,
		--Haz el cambio de TGS asigna Qn
		--y Qp asigna Qn
		elsif CLK'event and CLK='1' then
			TGS <= Qn;	--value of Qn assigned to TGS
			Qp <= Qn;	--vale of Qp assigned to Qn
		end if;
	end process D_FlipF;
end Behav;
