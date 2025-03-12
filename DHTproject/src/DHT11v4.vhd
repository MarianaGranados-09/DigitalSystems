Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_std.all;

Entity DHT11v4 is  
    generic(n: integer := 41;
	 BusWidth:integer:= 4;
	 numero: integer:= 8);
    port( 
        CLK:   in std_logic;
        RST:   in std_logic;
        STR:   in std_logic;
        DIO:   inout std_logic;	
		TXD: out std_logic;
		RDY: out std_logic;
		TEMPS:    out std_logic_VECTOR(6 downto 0);
		ANO: out std_logic_vector(3 downto 0);
		TMPO: out std_logic_vector(7 downto 0);
		TMP1: out std_logic;
		TMP2: out std_logic
   
    );
end DHT11v4;

architecture Structural of DHT11v4 is 

-- LatchSR Component
component LatchSR is 
    port( 
        RST:   in std_logic;
        CLK:   in std_logic;
        SET:   in std_logic;
        CLR:   in std_logic;
        Salida: out std_logic
    );
end component;

-- Timer Component
component Timer is
    generic(ticks: integer := 19);
    port( 
        CLK: in std_logic;
        RST: in std_logic;
        SYN: out std_logic
    );
end component;

-- RisingEdge Component
component RisingEdge is
    port(
        RST : in std_logic;
        CLK : in std_logic;
        XIN : in std_logic;
        XRE : out std_logic
    );
end component;

-- Deserializer Component
Component Deserializer is 
	generic(buswidth: integer := 41 );
	port( 
	RST: 	in std_logic;
	CLK: 	in std_logic; 													  
	SHF:   in std_logic;	
	BIN:   in std_logic;	 
	DOUT:	 out std_logic_vector(40 downto 0)
	);
end Component;
----------------Para display------:)-----
-----BinatyToDecimal
Component BinaryToDecimal is  
	generic(BusWidth:integer:= 4; numero: integer:= 10);
	port( 
	RST:     in std_logic;	
	CLK:     in std_logic;
	STR:     in std_logic; 
	DIN : 	in std_logic_vector(numero-1 downto 0);
	ONES:    out std_logic_vector ( BusWidth - 1 downto 0); 
	TENS:    out std_logic_vector ( BusWidth - 1 downto 0);
	HUND:    out std_logic_vector  ( BusWidth - 1 downto 0); 
	THO:     out std_logic_vector ( BusWidth - 1 downto 0) 
	);
end component;

Component Display is
    Port (
        nib:       in std_logic_vector(3 downto 0); 
        seg:       out std_logic_vector(6 downto 0) 
    );
end Component; 

component AsyncTrans is
	port(
	CLK: in std_logic;
	RST: in std_logic;
	STR: in std_logic;
	DIN: in std_logic_vector(7 downto 0);
	RDY: out std_logic;
	TXD: out std_logic
	);
end component;

component MultiplexadoUnion is
	generic(
		Cien_Us : integer := 5000
		);	
	port(
		DIG1 : in std_logic_vector(3 downto 0);
		DIG2 : in std_logic_vector (3 downto 0);
		DIG3 : in std_logic_vector (3 downto 0);
		DIG4 : in std_logic_vector (3 downto 0);
		CLK  : in std_logic;
		RST  : in std_logic;
		SEG  : out std_logic_vector (6 downto 0);
		ANO  : out std_logic_vector (3 downto 0)
		);
end	 component;


-- Se�ales internas
signal ENO, x,y, EOT, RED, ENI, SYN, notSTR: std_logic;
signal Salida: std_logic_vector(40 downto 0);
signal TEMP_aux: std_logic_vector(7 downto 0);
Signal TMP:    std_logic_vector(7 downto 0);
Signal HUM:    std_logic_vector(7 downto 0);
Signal CHK:   std_logic_vector(7 downto 0);
Signal ONE_TEMP,TEN_TEMP,HUN_TEMP,THO_TEMP: std_logic_vector(3 downto 0);
signal HUM_aux: std_logic_vector(7 downto 0);
Signal ONE_HUM,TEN_HUM,HUN_HUM,THO_HUM: std_logic_vector(3 downto 0);
begin 

   ---Intancias
    U07: Timer generic map (50000000) port map (CLK, RST, x);
    U01: LatchSR port map (RST, CLK, x, EOT, ENO);
    U02: Timer generic map (1500000) port map (CLK, ENO, EOT);
    U03: RisingEdge port map (RST, CLK, DIO, RED);
    U04: LatchSR port map (RST, CLK, RED, SYN, ENI);
    U05: Timer generic map (3500) port map (CLK, ENI, SYN);
    U06: Deserializer generic map (41) port map (RST, CLK, SYN, DIO, Salida);
---------------------------------Displays---------------------------------------

    U08: BinaryToDecimal generic map(4, 8) port map (RST, CLK, y, TMP, ONE_TEMP, TEN_TEMP, HUN_TEMP , THO_TEMP); 
	 U09: BinaryToDecimal generic map(4, 8) port map (RST, CLK,  y, HUM, ONE_HUM, TEN_HUM , HUN_HUM  , THO_HUM); 
	 
	 U015: Timer generic map (50000000) port map (CLK, RST, y);	 
	 
	--U016: AsyncTrans port map(CLK, RST, y, TMP, RDY, TXD);
	 
    DIO <= '0' when ENO = '1' else 'Z';  
    notSTR <= not STR;
	
	TMPO <= not(TMP);
	TMP1 <= TMP(4);
	TMP2 <= TMP(5);

    TMP <= Salida(24 downto 17);
    HUM <= Salida(40 downto 33);
    CHK <= Salida(7 downto 0);
	
	U013 : MultiplexadoUnion
	generic map(
		Cien_Us => 10000
	)
	port map(
		DIG1 => TEN_TEMP,
		DIG2 => ONE_TEMP,
		DIG3 => TEN_HUM,
		DIG4 => ONE_HUM,
		CLK => CLK,
		RST => RST,
		SEG => TEMPS,
		ANO => ANO
	);

end Structural;
