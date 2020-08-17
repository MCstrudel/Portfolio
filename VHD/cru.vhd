library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.all;

entity cru is 
	port(
	arst     : in  std_logic;
	refclk   : in  std_logic;
	mclk     : out std_logic;
	mclk_div : out std_logic;
	rst      : out std_logic;
	rst_div  : out std_logic
	);
end cru;

architecture archway of cru is
	component bufg is
		port(
		i : in  std_logic;
		o : out std_logic
		);
	end component;
	
	component ru is
	port(
	arst     : in  std_logic;
	mclk     : in  std_logic;
	mclk_div : in  std_logic;
	rst      : out std_logic;
	rst_div  : out std_logic
	);
	end component ru;
	
	component cu is
	port(
	rst      : in  std_logic;
	mclk     : in  std_logic;
	mclk_div : out  std_logic
	);
	end component cu;
	
	signal rst_i          : std_logic;
	signal rst_local      : std_logic;
	signal rst_div_local  : std_logic;
	signal rst_div_i      : std_logic;
	signal mclk_i         : std_logic;
	signal mclk_div_local : std_logic;
	signal mclk_div_i     : std_logic;
	
	begin
	bufg_0: bufg
	port map(
	i => refclk,
	o => mclk_i
	);
	
	ru_0: ru
	port map(
	arst      => arst,
	mclk      => mclk_i,
	mclk_div  => mclk_div_i,
	rst 	  => rst_local,
	rst_div   => rst_div_local
	);
	
	bufg_1: bufg
	port map(
	i => rst_local,
	o => rst_i
	);
	
	bufg_2: bufg
	port map(
	i => rst_div_local,
	o => rst_div_i
	);
	
	cu_0: cu
	port map(
	rst       => rst_i,
	mclk      => mclk_i,
	mclk_div  => mclk_div_local
	);
	
	bufg_3: bufg
	port map(
	i => mclk_div_local,
	o => mclk_div_i
	);
	
	rst       <= rst_i;
	rst_div   <= rst_div_i;
	mclk      <= mclk_i;
	mclk_div  <= mclk_div_i;
	
end archway;