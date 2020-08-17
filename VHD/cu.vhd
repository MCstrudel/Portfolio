library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.all;

entity cu is 
	port(
	rst      : in  std_logic;
	mclk     : in  std_logic;
	mclk_div : out  std_logic
	);
end cu;

architecture archangel of cu is
	signal mclk_cnt : unsigned(6 downto 0);
	begin
		bless: process(rst,mclk)
		begin
			if rst='1' then
				mclk_cnt <= (others => '0');
			elsif rising_edge(mclk) then
				mclk_cnt <= mclk_cnt+1;
			end if;
		end process bless;
		
		mclk_div <= std_logic(mclk_cnt(6));
		
end archangel;