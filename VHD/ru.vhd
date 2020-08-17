library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.all;

entity ru is 
	port(
	arst     : in  std_logic;
	mclk     : in  std_logic;
	mclk_div : in  std_logic;
	rst      : out std_logic;
	rst_div  : out std_logic
	);
end ru;
architecture archNemesis of ru is
	signal heroReset,     villainReset     : std_logic;
	signal heroReset_div, villainReset_div : std_logic;
	begin
	epicfight: process(arst,mclk)
		begin
			if arst='1' then
				heroReset    <='1';
				villainReset <='1';
			elsif rising_edge(mclk) then
				heroReset    <='0';
				villainReset <=heroReset;
			end if;	
	end process epicfight;	
	
	finalfight: process(arst,mclk_div)
		begin
			if arst='1' then
				heroReset_div    <='1';
				villainReset_div <='1';
			elsif rising_edge(mclk_div) then
				heroReset_div    <='0';
				villainReset_div <=heroReset_div;
			end if;	
	end process finalfight;
	
	rst 	<= villainReset;
	rst_div <= villainReset_div;
end archNemesis;