library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FiltroPromedio is
    Port (
        CLK     : in  std_logic;
        RST     : in  std_logic;
        STR     : in  std_logic; -- Trigger para tomar muestra
        ADC_IN  : in  std_logic_vector(9 downto 0);
        OUT_AVG : out std_logic_vector(9 downto 0)
    );
end FiltroPromedio;

architecture Behavioral of FiltroPromedio is
    constant N : integer := 10; -- Número de muestras para el promedio
    signal sum : integer range 0 to N * 1023 := 0;
    signal count : integer range 0 to N := 0;
    signal avg : integer := 0;
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                sum <= 0;
                count <= 0;
                avg <= 0;
            elsif STR = '1' then
                sum <= sum + to_integer(unsigned(ADC_IN));
                count <= count + 1;

                if count = N then
                    avg <= sum / N; -- Promedio exacto
                    sum <= 0;
                    count <= 0;
                end if;
            end if;
        end if;
    end process;

    OUT_AVG <= std_logic_vector(to_unsigned(avg, 10));
end Behavioral;
