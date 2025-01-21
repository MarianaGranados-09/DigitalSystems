Entity Rising_EdgeDetec is
	port(
	XIN: in bit;
	CLK: in bit;
	RST: in bit;
	XRE: out bit);
end Rising_EdgeDetec;

Architecture Behavioral of RisingEdge is

signal Qp: bit_vector(2 downto 0);
signal Qn: bit_vector(2 downto 0);
begin
	Combinational: process(Qp, Xin)
	begin
		Qn <= XIN & Qp(2 downto 1);
		XRE <= Qp(2) AND Qp(1) AND (NOT (Qp(0)) );
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
			
			
			
