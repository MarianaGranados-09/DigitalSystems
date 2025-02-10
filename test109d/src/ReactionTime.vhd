library IEEE;

Entity ReactionTime is
	generic( WIDTH: integer := 16);
	port(
	CLK: in bit;
	RST: in bit;
	BTN: in bit;
	LED: out bit;
	TIMECOUT: out bit_vector(WIDTH-1 downto 0)
	);
end ReactionTime;

Architecture Structural of ReactionTime is

----------Component Declaration--------
Component LatchSR is
	port(	
	CLK : in bit;
	RST : in bit;
	SET : in bit; 
	CLR : in bit; 
	SOUT : out bit
	);
end Component;

Component Timer is
	generic(
		TICKS: integer:= 9 );
	port(
		CLK : in bit;
		RST : in bit;
		EOT : out bit
		);
end Component;

Component FreeCounter is
    generic (
        WIDTH : integer := 16 );
    port (		  
		CLK : in bit;  -- Reloj
        RST : in bit;  -- Reset
        ENA : in bit;  -- Habilitaci�n
        COUT : out bit_VECTOR(WIDTH-1 downto 0)  -- Salida del contador
    );
end	Component;

-----Signal Declaration------------
signal dummy_signal: bit := '0';  
signal timer1_eot, timer3_eot: bit := '0';
signal outputLatch: bit := '0';
signal ResetCounter: bit := '0';
signal btnneg : bit := '0';
signal timecout_neg : bit_vector(15 downto 0);
begin
	--------Component Instantiation------
		btnneg <= (not BTN);
		TIMECOUT <= (not timecout_neg);
		U01: Timer generic map(TICKS => 500000000) port map(CLK, RST, timer1_eot);
		U02: LatchSR port map(CLK, RST, timer1_eot, btnneg, outputLatch);	
		LED <= outputLatch;
		U03: Timer generic map(TICKS => 50000) port map(CLK, outputLatch, timer3_eot);  
		ResetCounter <= RST and (not timer1_eot);
		U04: FreeCounter generic map(WIDTH => 16) port map(CLK, ResetCounter, timer3_eot, timecout_neg);		
end Structural;