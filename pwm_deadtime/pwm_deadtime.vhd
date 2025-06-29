library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity PWM_deadtime is

    generic(n : integer := 3000);

    port(

        CLK : in std_logic;

        RST : in std_logic;

       -- PWM : in std_logic;
		 SD: out std_logic;

        OUH : out std_logic;

        OUL : out std_logic

    );

end PWM_deadtime;


architecture Behavioral of PWM_deadtime is

component PWM is
  port (
    clk     : in  std_logic;                               -- Reloj de entrada
    rst     : in  std_logic;                               -- Reset asíncrono, activo en alto
    --duty    : in  unsigned(9 downto 0);                    -- Ciclo de trabajo (0 a 1023)
    pwm_out : out std_logic                                -- Salida PWM
  );
end component;

    signal pwm_delayed_rise : std_logic_vector(n-1 downto 0);

    signal pwm_delayed_fall : std_logic_vector(n-1 downto 0);

    signal ouh_internal : std_logic := '0';

    signal oul_internal : std_logic := '0';
	 signal PWM11: std_logic;

begin
	
		
	U00: PWM port map(CLK, RST, PWM11);	
	SD <=  RST;
		
    process(CLK, RST)

    begin

        if RST = '0' then

            pwm_delayed_rise <= (others => '0');

            pwm_delayed_fall <= (others => '0');

            ouh_internal <= '0';

            oul_internal <= '0';

        elsif rising_edge(CLK) then

            pwm_delayed_rise <= pwm_delayed_rise(n-2 downto 0) & PWM11;

            pwm_delayed_fall <= pwm_delayed_fall(n-2 downto 0) & (not PWM11);


            if (PWM11 = '1' and pwm_delayed_fall(n-1) = '0') then

                ouh_internal <= '1';

            else

                ouh_internal <= '0';

            end if;


            if ((not PWM11) = '1' and pwm_delayed_rise(n-1) = '0') then

                oul_internal <= '1';

            else

                oul_internal <= '0';

            end if;

        end if;

    end process;


    OUH <= ouh_internal;

    OUL <= oul_internal;


end Behavioral; 
