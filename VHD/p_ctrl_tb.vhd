library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity p_ctrl_tb is
end p_ctrl_tb;

architecture motor_instr of p_ctrl_tb is

signal clk : std_logic;
signal rst : std_logic := '1';
signal sp : signed(7 downto 0);
signal pos : signed(7 downto 0);
signal motor_cw : std_logic;
signal motor_ccw : std_logic;
signal a : std_logic;
signal b : std_logic;
signal sync_rst : std_logic := '0';

component p_ctrl is
port (
   rst       : in  std_logic;           -- Reset
   clk       : in  std_logic;           -- Clock
   sp        : in  signed(7 downto 0);  -- Set Point
   pos       : in  signed(7 downto 0);  -- Measured position
   motor_cw  : out std_logic;           --Motor Clock Wise direction
   motor_ccw : out std_logic            --Motor Counter Clock Wise direction
  );
end component p_ctrl;

component motor is 
  port (
    motor_cw  : in  std_logic;
    motor_ccw : in  std_logic;
    a         : out std_logic;
    b         : out std_logic
    );      
end component motor;

component pos_meas is
port (
  rst      : in  std_logic;           -- Reset
  clk      : in  std_logic;           -- Clock
  sync_rst : in  std_logic;           -- Sync reset
  a        : in  std_logic;           -- From position sensor
  b        : in  std_logic;           -- From position sensor
  pos      : out signed(7 downto 0)   -- Measured position
  );
end component pos_meas;

begin

  UUT : p_ctrl
    port map (
      clk => clk,
      rst => rst,
      motor_cw => motor_cw,
      motor_ccw => motor_ccw,
      pos => pos,
	  sp => sp);

  MTR : motor
	port map(
		motor_cw => motor_cw,
		motor_ccw => motor_ccw,
		a => a,
		b => b);
		
  PME : pos_meas
    port map (
      clk => clk,
      rst => rst,
      sync_rst => sync_rst,
      a => a,
      b => b,
      pos => pos);

  P_CLK_0: process
  begin
    clk <= '0';
    wait for 50 ns;
    clk <= '1';
    wait for 50 ns;
  end process P_CLK_0;
  
  setpoint : process
  begin 
	sp <= "01111111";
	wait for 2 us;
	sp <= "00011001";
	wait for 2 us;
  end process;
  
  start : process
  begin
	wait for 5 ns;
	rst <= '0';
  end process;
	

end architecture motor_instr;