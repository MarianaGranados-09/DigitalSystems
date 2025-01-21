Entity Rising_EdgeDetec is
	generic(
	n : integer := 4 ); 
	port(
	XIN: in bit;
	CLK: in bit;
	RST: in bit;
	XRE: out bit);
end Rising_EdgeDetec;

Architecture Behavioral of RisingEdge is

signal Qp: bit_vector(n-1 downto 0);
signal Qn: bit_vector(n-1 downto 0);
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
			
			
			
