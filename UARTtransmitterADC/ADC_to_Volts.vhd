library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADC_to_Volts is
    Port (
        adc_in : in std_logic_vector(9 downto 0);   -- Entrada ADC 10 bits
        V_volts : out std_logic_vector(15 downto 0) -- Salida en mV
    );
end ADC_to_Volts;

architecture behavioral of ADC_to_Volts is
    constant x : integer := 22;   -- Factor de voltaje (Ej: 22V máximo)
    constant y : integer := 1023; -- ADC de 10 bits
    constant z : integer := 1000; -- Para convertir a milivoltios
begin
    process(adc_in)
        variable adc_value : integer;
        variable volts_mV : integer;
    begin
        adc_value := to_integer(unsigned(adc_in));
        volts_mV := (adc_value * x * z) / y;
		volts_mV := volts_mV + 100;
        
        V_volts <= std_logic_vector(to_unsigned(volts_mV, 16));
    end process;
end behavioral;
