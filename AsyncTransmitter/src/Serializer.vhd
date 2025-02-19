Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

Entity Serializer is
	generic(
		BusWidth : integer := 8
	);
	port( 
	CLK  : in std_logic;
	RST  : in std_logic;
	DIN  : in std_logic_vector ( BusWidth - 1 downto 0);
	LDR  : in std_logic;
	SHF  : in std_logic;
	DOUT : out std_logic
	);
end Serializer;

Architecture Behavioral of Serializer is 
Signal Qn, Qp : std_logic_vector ( BusWidth - 1 downto 0);
begin	 
	Combinational: process(LDR, SHF, DIN, Qp)
	begin
		if LDR = '1' then
			Qn <= DIN;
		elsif SHF = '1' then
			Qn <= '1' & Qp( BusWidth -1 downto 1);
		else
			Qn <= Qp;
		end if;
		DOUT <= Qp(0);
	end process Combinational; 
	
	Sequential: process(RST, CLK) 
	begin
		if RST = '0' then
			Qp <= (others =>'0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
	
end Behavioral;	



--un serializador es un circuito o modulo que convierte datos en paralelo en datos seriales
--es decir, toma multiples bits de informacion simultaneamente y los transmite uno por uno
--en secuencia a traves de una sola linea de comunicacion