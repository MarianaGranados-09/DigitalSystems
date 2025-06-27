library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADC_to_Amp is
    Port (
        adc_in : in std_logic_vector(9 downto 0);
        A_amps : out std_logic_vector(15 downto 0)  -- Salida en mA
    );
end ADC_to_Amp;

architecture behavioral of ADC_to_Amp is 
    constant K : integer := 4870;  -- Multiplicador
    constant divisor : integer := 1000;
    constant offset : integer := 54;  -- Offset en mA
begin
    process(adc_in)
        variable adc_value : integer;
        variable amps_mA : integer;
    begin
        adc_value := to_integer(unsigned(adc_in));

        amps_mA := (adc_value * K) / divisor + offset;

        A_amps <= std_logic_vector(to_unsigned(amps_mA, 16));
    end process;
end behavioral;
