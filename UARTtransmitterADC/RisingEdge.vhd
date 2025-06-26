 library IEEE;
use IEEE.std_logic_1164.all;

Entity RisingEdge is
	port(
		RST : in std_logic;
		CLK : in std_logic;
		XIN : in std_logic;
		XRE : out std_logic
		);
	end RisingEdge;
	
	Architecture Behavioral of RisingEdge is 
	Signal Qn : std_logic_vector(1 downto 0);
	signal Qp : std_logic_vector(1 downto 0);
	begin
	
	Combinational : process (Qp, XIN)
	begin  
		--Qn <= XIN & Qp(3 downto 1);
		--XRE <= Qp(3) AND Qp(2) AND Qp(1) AND NOT (Qp(0));
		
		Qn <= XIN & Qp(1 downto 1);
		XRE <= Qp(1) AND NOT Qp(0);
		
	end process Combinational;	 
	
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then 
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
	
end Behavioral;

--entity RisingEdge is
--	generic(
--		n : integer := 2  -- N�mero de flip-flops que define cu�ntos ciclos '0' deben verse antes de detectar el flanco 0->1
--		);
--	port(
--		RST : in std_logic;
--		CLK : in std_logic;      -- Reset as�ncrono activo en '0'
--		XIN : in std_logic;      -- Se�al en la que deseamos detectar el flanco de subida
--		XRE : out std_logic      -- Pulso que indica "rising edge" tras n ciclos en bajo
--		);
--end RisingEdge;	 
--
--architecture Behavioral of RisingEdge is
--	signal Qp : std_logic_vector((n+1)-1 downto 0);
--	signal Qn : std_logic_vector((n+1)-1 downto 0);
--begin
--	
--	------------------------------------------------------------------
--	-- 1) L�gica Combinacional
--	------------------------------------------------------------------
--	Combinational : process(Qp, XIN)
--		variable temp : std_logic := '1';
--	begin
--		-- a) La posici�n 0 del registro toma el valor actual de XIN
--		Qn(0) <= XIN;
--		
--		-- b) Desplazar el resto de los flip-flops
--		for i in 1 to (n+1)-1 loop
--			Qn(i) <= Qp(i-1);
--		end loop;
--		
--		-- c) Verificar que Qp(1..n-1) sean todos '0' (la se�al estuvo en bajo)
--		temp := '1';
--		for i in 1 to (n+1)-1 loop
--			temp := temp AND (not Qp(i));  -- si Qp(i) es '1', esto se vuelve '0'
--		end loop;
--		
--		-- d) Para que se dispare XRE: todas muestras antiguas en '0' y la m�s reciente en '1'
--		XRE <= temp AND Qp(0);
--	end process Combinational;
--	
--	
--	------------------------------------------------------------------
--	-- 2) L�gica Secuencial (Flip-Flops)
--	------------------------------------------------------------------
--	Sequential : process(RST, CLK)
--	begin
--		if RST = '0' then
--			Qp <= (others => '0');
--		elsif rising_edge(CLK) then
--			Qp <= Qn;
--		end if;
--	end process Sequential;
--	
--end Behavioral;	









