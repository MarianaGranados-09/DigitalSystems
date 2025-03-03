library IEEE; 
use IEEE.Numeric_bit.all;  
  
entity Counter180 is
	  generic(BusWidth : integer  := 8);
	  port(
	  CLK : in bit;
	  RST : in bit;
	  ENA : in bit;
	  CNT : out bit_vector(BusWidth -1 downto 0)
	  );  
end Counter180;

architecture Behavioral of Counter180 is	 
signal Cp, Cn : integer := 0;
signal FLAG:  bit := '0';
begin
  
  
  Combinational : process(ENA)
  begin 
	  if Cp = 200 then
		  FLAG <= '1'; 	
		  Cn <= Cp - 1 ;
	  elsif ENA = '1' and FLAG = '0' then
		  Cn <= Cp + 1 ; 
		  FLAG <= '0'; 
	  elsif ENA = '1' and FLAG = '1' then
		  if Cp = 0 then 
			Cn <= Cp; 
			FLAG <= '0';  
		  else
			Cn <= Cp - 1 ; 
		    FLAG <= '1'; 
		  end if; 
	  else
		  Cn <= Cp;
		  FLAG <= FLAG;
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
  