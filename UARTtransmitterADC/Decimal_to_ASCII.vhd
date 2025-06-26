library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decimal_to_ASCII is
	port(
		U  : in  std_logic_vector(3 downto 0);  -- Unidades
		D  : in  std_logic_vector(3 downto 0);  -- Decenas
		C  : in  std_logic_vector(3 downto 0);  -- Centenas
		M  : in  std_logic_vector(3 downto 0);  -- Millar
		
		-- Salidas: códigos ASCII de cada dígito (8 bits)
		AU : out std_logic_vector(7 downto 0);  -- ASCII unidades
		AD : out std_logic_vector(7 downto 0);  -- ASCII decenas
		AC : out std_logic_vector(7 downto 0);  -- ASCII centenas
		AM : out std_logic_vector(7 downto 0)   -- ASCII millar
		);
end entity Decimal_to_ASCII;

architecture DataFlow of Decimal_to_ASCII is  
	
	constant ASCII_0 : unsigned(7 downto 0) := to_unsigned(48, 8); 
	
begin
	
	-- Cada salida = dígito + 0x30
	AU <= std_logic_vector( resize(unsigned(U), 8) + ASCII_0 );
	AD <= std_logic_vector( resize(unsigned(D), 8) + ASCII_0 );
	AC <= std_logic_vector( resize(unsigned(C), 8) + ASCII_0 );
	AM <= std_logic_vector( resize(unsigned(M), 8) + ASCII_0 );	
	
end architecture DataFlow;

