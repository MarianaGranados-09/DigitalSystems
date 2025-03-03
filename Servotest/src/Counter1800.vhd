 library IEEE; 
 use IEEE.Numeric_bit.all;  
  
entity Counter1800 is
	  generic(BusWidth : integer  := 11); --to get to 1800 2^11 = 2048
	  port(
	  CLK : in bit;
	  RST : in bit;
	  ENA : in bit;
	  CNT : out bit_vector(BusWidth -1 downto 0)
	  );  
end Counter1800; 

Architecture Behavioral of Counter1800 is	 
signal Cp, Cn : integer := 0;
begin
  
  
  Combinational : process(ENA)
  begin 
	  if Cp = 1800 then	
		  Cn <= 0;  
	  elsif ENA = '1'then
		  Cn <= Cp + 1 ;
	  else
		  Cn <= Cp;
	  end if; 
	  
	  CNT <= bit_vector(to_unsigned(Cp, busWidth));
	  
		  
  end process Combinational;
  
  Sequential : process(CLK, RST)
  begin 	   
	  if RST = '0' then
		  Cp <= 0;
	  elsif CLK 'event and CLK = '1' then
		  Cp <= Cn;	
	  end if;
	  
		  
  end process Sequential;
end Behavioral; 
  