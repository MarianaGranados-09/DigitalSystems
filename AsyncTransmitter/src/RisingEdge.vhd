Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity RisingEdge is
	generic(
	n : integer := 4 ); 
	port(
	CLK: in std_logic;
	RST: in std_logic;
	XIN: in std_logic;
	XRE: out std_logic);
end RisingEdge;

Architecture Behavioral of RisingEdge is

signal Qp: std_logic_vector(n-1 downto 0);
signal Qn: std_logic_vector(n-1 downto 0);
begin
	Combinational: process(Qp, XIN)
	begin
		Qn <= XIN & Qp(n-1 downto 1);
		--detectar flanco asc, ultimos 3 flip flops
		if n >= 3 then
			XRE <= Qp(n-1) AND Qp(n-2) AND (NOT (Qp(n-3)) );
		else --sino hay por lo menos 3 flip flops, salida = 0
			XRE <= '0';
		end if;
	end process Combinational;
	
	Sequential: process(RST, CLK)
	begin
	if RST = '0' then
		Qp <= (others => '0');
	elsif CLK'event and CLK = '1' then
		Qp <= Qn;
	end if;
	end process Sequential;
end Behavioral;
			
			
			