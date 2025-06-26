library IEEE;
use IEEE.std_logic_1164.all;
Entity LatchSR is
	port(
		RST	: in std_logic;
		CLK	: in std_logic;	 
		SET	: in std_logic;  
		CLR	: in std_logic;  
		SOUT : out std_logic
		);
end LatchSR;

Architecture Behavioral of LatchSR is
	signal Qp, Qn : std_logic;
begin
	Combinational : process(SET, CLR, Qp) --Las señales que provocan un cambio o actualización de un estado
	begin	  
		if SET = '1' then
			Qn <= '1';
		elsif CLR = '1' then
			Qn <= '0';
		else 
			Qn <= Qp; 
		end if;
		SOUT <= Qp;
	end process	Combinational;	  
	
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= '0';
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;	 
	end process Sequential;
end Behavioral;		

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--
---- Entidad
--entity latch_sr is
--	Port (
--		SET : in STD_LOGIC;  -- Señal de set
--		CLR : in STD_LOGIC;  -- Señal de clear
--		CLK : in STD_LOGIC;  -- Señal de reloj
--		RST : in STD_LOGIC;  -- Señal de reset
--		SOUT : out STD_LOGIC -- Salida del flip-flop
--		);
--end latch_sr;
--
---- Arquitectura
--architecture Behavioral of latch_sr is
--	signal mux_out : STD_LOGIC; -- Salida del MUX
--	signal Qp : STD_LOGIC := '0'; -- Estado actual del flip-flop
--begin
--	-- Multiplexor
--	mux_out <= 
--	'1' when SET = '1' else -- Prioridad a SET
--	'0' when CLR = '1' else -- Luego CLR
--	Qp; -- Si no, mantener el estado actual
--	
--	-- Flip-flop con reset asíncrono
--	process(CLK, RST)
--	begin
--		if RST = '0' then
--			Qp <= '0'; -- Reinicia el flip-flop
--		elsif rising_edge(CLK) then
--			Qp <= mux_out; -- Captura la salida del MUX
--		end if;
--	end process;
--	
--	-- Asignación de salida
--	SOUT <= Qp;
--	
--end Behavioral;
--