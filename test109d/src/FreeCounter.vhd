Library IEEE;	   
use IEEE.std_logic_1164.all; 
use IEEE.Numeric_bit.all;
use IEEE.Numeric_bit.all;


entity FreeCounter is
    generic (
        WIDTH : integer := 16-- Ancho del contador (por defecto 8 bits)
    );
    Port (	 
		CLK : in bit;  -- Reloj
        RST : in bit;  -- Reset
        ENA : in bit;  -- Habilitaci�n
        COUT : out bit_VECTOR(WIDTH-1 downto 0)  -- Salida del contador
    );
end FreeCounter;

architecture Behavioral of FreeCounter is
signal Cp , Cn : bit_vector(WIDTH-1 downto 0):=(others => '0'); 
    begin	 
			Combinational : process (ENA , CLK)	  
	begin
	if  ENA = '1' then 
		Cn <= bit_vector (unsigned(Cp) + 1); 
	elsif ENA = '0' then
		Cn <= Cp;	 
	end if;
	
	end Process Combinational;

	Secuential : process(CLK, RST)
	Begin
	if RST = '0' then
		--Count <= "00000000";
		Cp <= (others => '0');

	elsif CLK 'Event and CLK = '1' then
		Cp <= Cn; 
		COUT <= Cn;
	end if;
	
	
	end process Secuential; 
end Behavioral;
