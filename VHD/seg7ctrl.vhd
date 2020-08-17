library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity seg7ctrl is
 port
 (
 mclk         : in  std_logic; --100MHz, positive flank
 reset        : in  std_logic; --Asynchronous reset, active h
 d0           : in  std_logic_vector(3 downto 0);
 d1           : in  std_logic_vector(3 downto 0);
 d2           : in  std_logic_vector(3 downto 0);
 d3           : in  std_logic_vector(3 downto 0);
 dec          : in  std_logic_vector(3 downto 0);
 abcdefgdec_n : out std_logic_vector(7 downto 0);
 a_n          : out std_logic_vector(3 downto 0)
 );
end entity seg7ctrl;


architecture archibald of seg7ctrl is

signal count : unsigned(17 downto 0) := (others => '0');

impure function hex27seg(
	indata       : in std_logic_vector(3 downto 0);
	decim        : in std_logic)
	return std_logic_vector is
	
	variable seg : std_logic_vector(6 downto 0) := "1111111";
	begin
		case indata is
			when "0000" => seg := "0000001";
			when "0001" => seg := "1001111";
			when "0010" => seg := "0010010";
			when "0011" => seg := "0000110";
			when "0100" => seg := "1001100";
			when "0101" => seg := "0100100";
			when "0110" => seg := "0100000";
			when "0111" => seg := "0001111";
			when "1000" => seg := "0000000";
			when "1001" => seg := "0001100";
			when "1010" => seg := "0001000";
			when "1011" => seg := "1100000";
			when "1100" => seg := "0110001";
			when "1101" => seg := "1000010";
			when "1110" => seg := "0110000";
			when "1111" => seg := "0111000";
			when others => seg := "XXXXXXX";
		end case;
	
	return (seg & not decim);
	end function hex27seg;
begin

HEXTECH:
process(mclk,reset)
	begin
	
	if(reset  = '1') then
        count <= (others => '0');
		a_n   <= "1111";
    elsif rising_edge(MCLK) then
		case count(17 downto 16) is
			when "00" => 
			abcdefgdec_n <= hex27seg(d0,dec(0));
			a_n <= "1110";
			when "01" => 
			abcdefgdec_n <= hex27seg(d1,dec(1));
			a_n <= "1101";
			when "10" => abcdefgdec_n <= hex27seg(d2,dec(2));
			a_n <= "1011";
			when "11" => abcdefgdec_n <= hex27seg(d3,dec(3));
			a_n <= "0111";
			when others => null;
		end case;
		count <= count + 1;
    end if; 
	
end process HEXTECH;

end archibald;