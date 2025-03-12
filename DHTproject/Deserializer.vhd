						 Library IEEE;	   
use IEEE.std_logic_1164.all; 
use IEEE.Numeric_std.all;

--Definicion de las entradas, salidas y otros
Entity Deserializer is 
	generic(buswidth: integer := 41);
	port( 
	RST: 	in std_logic;
	CLK: 	in std_logic; 													  
	SHF:   in std_logic;	
	BIN:   in std_logic;	 
	DOUT:	 out std_logic_vector(buswidth - 1 downto 0)
	);
end Deserializer;


architecture behavioral of Deserializer is 	
signal Qp, Qn : std_logic_vector(buswidth - 1 downto 0) := (others => '0');

begin 
	combinational: process(Qp, BIN, SHF)		 
	begin
		if (SHF = '1') then	
			 Qn <= Qp(buswidth - 2 downto 0) & bin;
		else
			Qn <= Qp;	
		end if;
		DOUT <= Qp;
		
	end process combinational; 
	
	sequential: process( CLK, RST)
	begin 
		if RST = '0' then
			Qp <= (others => '0');
		elsif (rising_edge(CLK)) then	
			Qp <= Qn;			
		end if;	
	end process sequential;
end behavioral;