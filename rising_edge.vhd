Entity Rising_EdgeDetec is
	port(
	XIN: in bit;
	CLK: in bit;
	RST: in bit;
	XRE: out bit);
end Rising_EdgeDetec;

Architecture Behav of Rising_EdgeDetec is 
Signal flipf1, flipf2, flipf3: bit; 
begin						  
	Sequential: process(CLK, RST)	  
	begin		  
		--reseteo de entradas de los flip flops
		if(RST = '0') 
			flipf1 <= '0';
			flipf2 <= '0';
			flipf3 <= '0';
		elsif 	CLK'event and CLK = '1' then
			--mover xin a traves de los flip flops
			--en cada ciclo de reloj ___/----\_____
			flipf1 <= XIN;
			flipf2 <= flipf1;
			flipf3 <= flipf2;
		end if;
	end process Sequential;
	
	Combinational: process(XIN)
	begin			  
		XRE <= flipf1 AND flipf2 AND (NOT flipf3);
	end Combinational
end Architecture Behav;
			
			
			
