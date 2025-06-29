library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM is
  port (
    clk     : in  std_logic;        -- Reloj de entrada
    rst     : in  std_logic;        -- Reset asíncrono, activo en alto
    pwm_out : out std_logic         -- Salida PWM
  );
end entity;

architecture Behavioral of PWM is

  -- Constante del ciclo de trabajo al 40%
  constant DUTY_C : unsigned(9 downto 0) := to_unsigned(410, 10);

  -- Contador de 10 bits
  signal counter : unsigned(9 downto 0) := (others => '0');

begin

  process(clk, rst)
  begin
    if rst = '0' then
      counter <= (others => '0');
      pwm_out <= '0';

    elsif rising_edge(clk) then
      -- Incrementa el contador
      if counter = 1023 then
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;

      -- Comparación para generar PWM al 40%
      if counter < DUTY_C then
        pwm_out <= '1';
      else
        pwm_out <= '0';
      end if;
    end if;
  end process;

end architecture;
