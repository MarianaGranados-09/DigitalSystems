library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ServoS_SamplerFSM  is
	port(
		CLK	: in std_logic;
		RST	: in std_logic;
		SYN	: in std_logic;
		ECV	: in std_logic;
		EOT : in std_logic;

		STC	: out std_logic;
		STT	: out std_logic;
		SEL	: out std_logic_vector(2 downto 0)
	);
end ServoS_SamplerFSM;

architecture Behavioral of ServoS_SamplerFSM	IS
	signal Sp, Sn : std_logic_vector(3 downto 0);
begin
	
	Combinational : process(Sp, ECV, EOT, SYN)
	begin  
		case Sp is
			when "0000" => -- Espera de solicitud de muestreo
				STC <= '0';
				STT <= '0';
				SEL <= "000";
				if SYN = '1' then
					Sn <= "0001";
				else
					Sn <= "0000";
				end if;

			when "0001" => -- Inicia conversiÃ³n binario a decimal
				STC <= '1';
				STT <= '0';
				SEL <= "000";
				Sn <= "0010";

			when "0010" => -- Espera a que finalice conversiÃ³n
				STC <= '0';
				STT <= '0';
				SEL <= "000";
				if ECV = '1' then
					Sn <= "0011";
				else
					Sn <= "0010";
				end if;

			when "0011" => -- Transmitir millares
				STC <= '0';
				STT <= '1';
				SEL <= "001";
				Sn <= "0100";

			when "0100" => -- Esperar fin de transmisiÃ³n
				STC <= '0';
				STT <= '0';
				SEL <= "001";
				if EOT = '1' then
					Sn <= "0101";
				else
					Sn <= "0100";
				end if;

			when "0101" => -- Transmitir centenas
				STC <= '0';
				STT <= '1';
				SEL <= "010";
				Sn <= "0110";

			when "0110" => -- Esperar fin de transmisiÃ³n
				STC <= '0';
				STT <= '0';
				SEL <= "010";
				if EOT = '1' then
					Sn <= "0111";
				else
					Sn <= "0110";
				end if;

			when "0111" => -- Transmitir decenas
				STC <= '0';
				STT <= '1';
				SEL <= "011";
				Sn <= "1000";

			when "1000" => -- Esperar fin de transmisiÃ³n
				STC <= '0';
				STT <= '0';
				SEL <= "011";
				if EOT = '1' then
					Sn <= "1001";
				else
					Sn <= "1000";
				end if;

			when "1001" => -- Transmitir unidades
				STC <= '0';
				STT <= '1';
				SEL <= "100";
				Sn <= "1010";

			when "1010" => -- Esperar fin de transmisiÃ³n
				STC <= '0';
				STT <= '0';
				SEL <= "100";
				if EOT = '1' then
					Sn <= "1011";
				else
					Sn <= "1010";
				end if;

			when "1011" => -- Transmitir salto de lÃ­nea
				STC <= '0';
				STT <= '1';
				SEL <= "101";
				Sn <= "1100";

			when others => -- Esperar fin de transmisiÃ³n y reiniciar
				STC <= '0';
				STT <= '0';
				SEL <= "101";
				if EOT = '1' then
					Sn <= "0000";
				else
					Sn <= "1100";
				end if;
		end case;
	end process;

	Sequential : process(CLK, RST)
	begin
		if RST = '0' then
			Sp <= (others => '0');
		elsif rising_edge(CLK) then
			Sp <= Sn;
		end if;
	end process;

end Behavioral;