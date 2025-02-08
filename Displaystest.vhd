library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Displaysprueba is
    port (
		decimal_in : in std_logic_vector(3 downto 0);	
	   	dout: out std_logic;
        segments_out : out std_logic_vector(6 downto 0) -- 7 segmentos (a-g)
    );
end Displaysprueba;


architecture Behavioral of Displaysprueba is	  
signal douthigh : std_logic := '0';
begin
    process (decimal_in)
    begin
        case decimal_in is
            when "0000" => segments_out <= "1000000"; -- 0 (Adaptado para �nodo com�n)
            when "0001" => segments_out <= "1111001"; -- 1 (Adaptado para �nodo com�n)
            when "0010" => segments_out <= "0100100"; -- 2 (Adaptado para �nodo com�n)
				when "0011" => segments_out <= "0110000"; -- 3 (Adaptado para �nodo com�n)
				when "0100" => segments_out <= "0011001"; -- 4 (Adaptado para �nodo com�n)
				when "0101" => segments_out <= "0010010"; -- 5 (Adaptado para �nodo com�n)
				when "0110" => segments_out <= "0000010"; -- 6 (Adaptado para �nodo com�n)
				when "0111" => segments_out <= "1111000"; -- 7 (Adaptado para �nodo com�n)
				when "1000" => segments_out <= "0000000"; -- 8 (Adaptado para �nodo com�n)
				when "1001" => segments_out <= "0010000"; -- 9 (Adaptado para �nodo com�n)
				--when "1000" => segments_out <= "0100100"; -- 10 (Adaptado para �nodo com�n)
            -- ... (resto de casos)
            when others => segments_out <= "0000110"; -- Mostrar una "E" en caso de error (Adaptado para �nodo com�n)
        end case;
    end process; 
	dout <= douthigh;
end architecture;
