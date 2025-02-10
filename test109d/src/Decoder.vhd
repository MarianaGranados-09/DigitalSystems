library IEEE;	 
use IEEE.STD_LOGIC_1164.ALL;	
Use IEEE.STD_LOGIC_ARITH.ALL;

Entity Decoder is
	port(
	BIN: in bit_vector(3 downto 0);
	SEG: out bit_vector(6 downto 0)
	);
end Decoder;

Architecture Behavioral of Decoder is
begin
	Combinational: process(BIN) is
	begin
		Case BIN is
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
			When others => SEG <= "1111111"; -- F
		End Case;
	End Process Combinational;
End Architecture Behavioral;
		