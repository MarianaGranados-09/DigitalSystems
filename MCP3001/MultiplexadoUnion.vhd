	  Library IEEE;	   
use IEEE.std_logic_1164.all;   
use IEEE.Numeric_std.all;

Entity MultiplexadoUnion is
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
end MultiplexadoUnion;
Architecture structural of MultiplexadoUnion is 

--//==============================================================================================================\\--

---------------------------------------------- COMPONENTS -------------------------------------------------------------


--// TIMER
	component Timer
	generic(
		TICKS : INTEGER := 10);
	port(
		CLK : in std_logic;
		RST : in std_logic;
		SYN : out std_logic);
	end component;
	for all: Timer use entity work.Timer(behavioral);

		
--// FREECOUNTER

	component Counter
	generic(
		busWidth : INTEGER := 2);
	port(
		CLK : in std_logic;
	  RST : in std_logic;
	  INC : in std_logic;
	  CNT  : out std_logic_vector(busWidth -1 downto 0));
	end component;
	for all: Counter use entity work.Counter(behavioral);

		
--// DISPLAYS

	component MultiplexadoDisplays
	port(
		SEG : out std_logic_vector(6 downto 0);
		DIG1 : in std_logic_vector(3 downto 0);
		DIG2 : in std_logic_vector(3 downto 0);
		DIG3 : in std_logic_vector(3 downto 0);
		DIG4 : in std_logic_vector(3 downto 0);
		SEL : in std_logic_vector(1 downto 0);
		ANO : out std_logic_vector(3 downto 0));
	end component;
	for all: MultiplexadoDisplays use entity work.MultiplexadoDisplays(behavioral);



		
--//==============================================================================================================\\--

---------------------------------------------- SIGNALS -------------------------------------------------------------

Signal Timer_Salida : std_logic;
Signal Contador_Salida : std_logic_vector(1 downto 0) :=(others => '0');
Signal Multiplexor_Salida : std_logic_vector(3 downto 0) :=(others => '0');	 
Signal Opcion3 : std_logic_vector(3 downto 0) :="0011";
Signal Opcion2 : std_logic_vector(3 downto 0) :="0010";	
Signal Opcion0 : std_logic_vector(3 downto 0) :="0000";
Signal Opcion1 : std_logic_vector(3 downto 0) :="0001";


Begin  	

--//==============================================================================================================\\--

---------------------------------------------- INSTANCES -------------------------------------------------------------


--// TIMER
				
	U1 : Timer
	generic map(
		TICKS => Cien_Us
	)
	port map(
		CLK => CLK,
		RST => RST,
		SYN => Timer_Salida
	);

	
--// FREECOUNTER	

	U2 : Counter
	generic map(
		busWidth => 2
	)
	port map(
		INC => Timer_Salida,
		CLK => CLK,
		RST => RST,
		CNT => Contador_Salida
	);
	
	
	
--// DISPLAYS

	
	U3 : MultiplexadoDisplays
	port map(
		SEG => SEG,
		DIG1 => DIG4,
		DIG2 => DIG3,
		DIG3 => DIG2,
		DIG4 => DIG1,
		SEL => Contador_Salida,
		ANO => ANO
	);
	
	
	

	
end structural;
