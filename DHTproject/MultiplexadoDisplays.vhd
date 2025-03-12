Library IEEE;	   
use IEEE.std_logic_1164.all;   
use IEEE.Numeric_std.all;


Entity MultiplexadoDisplays is 
	port(
		--//Decoder
		--NIB	: in std_logic_vector (3 downto 0);
		SEG	: out std_logic_vector (6 downto 0); 
		--// Multiplexado 
 		DIG1  : in std_logic_vector (3 downto 0);
		DIG2  : in std_logic_vector (3 downto 0);
		DIG3  : in std_logic_vector (3 downto 0);
		DIG4  : in std_logic_vector (3 downto 0);
		SEL   : in std_logic_vector (1 downto 0);
		--NIB	: out std_logic_vector (3 downto 0);
		--//Anodo 	
		ANO	: out std_logic_vector (3 downto 0)
		);
end MultiplexadoDisplays;  
Architecture Behavioral of MultiplexadoDisplays is
Signal Numero1, Numero2, Numero3, Numero4 : std_logic_vector(3 downto 0); 
signal NIB : std_logic_vector(3 downto 0);
Begin
	Numero1 <= DIG1; 
	Numero2 <= DIG2; 
	Numero3 <= DIG3; 
	Numero4 <= DIG4; 
	
	Multiplexor: Process(SEL, Numero1, Numero2, Numero3, Numero4) is
	
	Begin
		Case SEL is
			When "00" => NIB <= Numero1;
			When "01" => NIB <= Numero2;
			When "10" => NIB <= Numero3;
			When others => NIB <= Numero4;
		End Case;
	End Process Multiplexor; 
	
	
	
	Anodo: Process(SEL)is
	Begin
		Case SEL is
			When "00" => ANO <= "1110";
			When "01" => ANO <= "1101";
			When "10" => ANO <= "1011";
			When others => ANO <= "0111";
		End Case;
	End Process Anodo;	
	
	
	Decoder: Process(NIB)is
	Begin
		Case NIB is
			When "0000" => SEG <= "1000000"; -- 0
			When "0001" => SEG <= "1111001"; -- 1
			When "0010" => SEG <= "0100100"; -- 2
			When "0011" => SEG <= "0110000"; -- 3
			When "0100" => SEG <= "0011001"; -- 4
			When "0101" => SEG <= "0010010"; -- 5
			When "0110" => SEG <= "0000010"; -- 6
			When "0111" => SEG <= "1111000"; -- 7
			When "1000" => SEG <= "0000000"; -- 8
			When "1001" => SEG <= "0010000"; -- 9  
			When others => SEG <= "1000111"; -- F
		End Case;
	End Process Decoder;
	
	
	
End Architecture Behavioral; 