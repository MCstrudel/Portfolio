library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity hextest is

end hextest;

architecture archimedes of hextest is
	component pos_seg7_ctrl is
	  port (
		-- System Clock and Reset
		arst         : in  std_logic;       -- Reset
		sync_rst     : in  std_logic;       -- Synchronous reset 
		refclk       : in  std_logic;       -- Clock
		sp           : in  std_logic_vector(7 downto 0);  -- Set Point
		a            : in  std_logic;       -- From position sensor
		b            : in  std_logic;       -- From position sensor
		force_cw     : in  std_logic;       -- Force motor clock wise motion
		force_ccw    : in  std_logic;  -- Force motor counter clock wise motion
		motor_cw     : out std_logic;       -- Motor clock wise motion
		motor_ccw    : out std_logic;       -- Motor counter clock wise motion
		-- Interface to seven segments
		abcdefgdec_n : out std_logic_vector(7 downto 0);
		a_n          : out std_logic_vector(3 downto 0)
		);
	end component;
	
	component motor is 
	  port (
		motor_cw  : in  std_logic;
		motor_ccw : in  std_logic;
		a         : out std_logic;
		b         : out std_logic
		);      
	end component motor;

    signal arst         : std_logic := '1';      
    signal sync_rst     : std_logic := '1';      
    signal refclk       : std_logic := '0';     
    signal sp           : std_logic_vector(7 downto 0);
    signal a            : std_logic := '0';      
    signal b            : std_logic := '0';      
    signal force_cw     : std_logic := '0';     
    signal force_ccw    : std_logic := '0'; 
    signal motor_cw     : std_logic := '0';   
    signal motor_ccw    : std_logic := '0'; 
    signal abcdefgdec_n : std_logic_vector(7 downto 0) := "00000000";
    signal a_n          : std_logic_vector(3 downto 0) := "0000";

	
	constant Half_Period : time := 5 ns;
	
	
	begin
	UUT : pos_seg7_ctrl
	    port map(
		arst         => arst,
		sync_rst     => sync_rst,
		refclk       => refclk,
		sp           => sp,
		a            => a,
		b            => b,
		force_cw     => force_cw,
		force_ccw    => force_ccw,
		motor_cw     => motor_cw,
		motor_ccw    => motor_ccw,
		abcdefgdec_n => abcdefgdec_n,
		a_n          => a_n
	  );
	
	MTR : motor
	port map(
		motor_cw => motor_cw,
		motor_ccw => motor_ccw,
		a => a,
		b => b
	);
	
	refclk     <= not refclk after Half_Period;
	
  STIMULI : process
  begin
	arst  <= '0' after Half_Period*6;
	wait for 100 ns;
	sp <= "00110111" after Half_Period;
	wait for 100 ns;
	force_ccw <= '1';
	force_cw  <= '1' after Half_Period*3;
	wait for Half_Period*6;
	sp <= "01011100";
	sync_rst <= '0' after Half_Period*6;
	wait for 100 ns;
	force_ccw <= '0';
	force_cw  <= '0' after Half_Period*6;
	wAIT for 100 ns;
	waiT;
  end process;           
  
end archimedes;