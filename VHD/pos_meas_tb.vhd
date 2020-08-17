library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pos_meas_tb is
end pos_meas_tb;

architecture motor_beh of pos_meas_tb is

signal clk : std_logic;
signal a : std_logic;
signal b : std_logic;
signal rst : std_logic := '0';
signal sync_rst : std_logic := '0';
signal pos : signed(7 downto 0);

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

  UUT : pos_meas
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

  motor_moving : process
  begin

    a <= '0';
    b <= '0';
      -- move clockwise
        a <= '0';
        wait for 200 ns;
        b <= '1';
        wait for 200 ns;
        a <= '1';
        wait for 200 ns;
        b <= '0';
        wait for 200 ns;
    -- move counterclockwise
        a <= '1';
        wait for 200 ns;
        b <= '1';
        wait for 200 ns;
        a <= '0';
        wait for 200 ns;
        b <= '0';

  end process;

end architecture motor_beh;