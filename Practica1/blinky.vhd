library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Blinky is
    generic(
        ticks : integer := 25000 -- 
    );
    port(
        CLK : in bit;
        RST : in bit;
        LED : out bit -- Salida conectada al LED
    );
end Blinky;

architecture Structural of Blinky is
    -- Senial interna para conectar EOT y TOG
    signal EOT : bit;
    signal TGS : bit;
begin
    -- Instancia del Timer
    Timer_Inst : entity work.timer
        generic map (
            ticks => ticks -- Pasar el valor de los ticks
        )
        port map (
            CLK => CLK,
            RST => RST,
            EOT => EOT
        );

    -- Instancia del Toggle
    Toggle_Inst : entity work.toggle
        port map (
            TOG => EOT, -- Conectar la salida EOT del Timer al TOG del Toggle
            CLK => CLK,
            RST => RST,
            TGS => LED -- Conectar la salida TGS al LED
        );
end Structural;
