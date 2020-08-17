library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity pos_ctrl is
  port (
    -- System Clock and Reset
    rst       : in  std_logic;          -- Reset
    rst_div   : in  std_logic;          -- Reset
    mclk      : in  std_logic;          -- Clock
    mclk_div  : in  std_logic;          -- Clock to p_reg
    sync_rst  : in  std_logic;          -- Synchronous reset
    sp        : in  std_logic_vector(7 downto 0);  -- Setpoint (wanted position)
    a         : in  std_logic;          -- From position sensor
    b         : in  std_logic;          -- From position sensor
    pos       : out std_logic_vector(7 downto 0);  -- Measured Position
    force_cw  : in  std_logic;          -- Force motor clock wise motion
    force_ccw : in  std_logic;          -- Force motor counter clock wise motion
    motor_cw  : out std_logic;          -- Motor clock wise motion
    motor_ccw : out std_logic           -- Motor counter clock wise motion
    );      
end pos_ctrl;

architecture str of pos_ctrl is

component p_ctrl

port (
    -- System Clock and Reset
    rst       : in  std_logic;           -- Reset
    clk       : in  std_logic;           -- Clock
    sp        : in  signed(7 downto 0);  -- Set Point
    pos       : in  signed(7 downto 0);  -- Measured position
    motor_cw  : out std_logic;           --Motor Clock Wise direction
    motor_ccw : out std_logic            --Motor Counter Clock Wise direction
    );      
end component;

component pos_meas
port (
    -- System Clock and Reset
    rst      : in  std_logic;           -- Reset
    clk      : in  std_logic;           -- Clock
    sync_rst : in  std_logic;           -- Sync reset
    a        : in  std_logic;           -- From position sensor
    b        : in  std_logic;           -- From position sensor
    pos      : out signed(7 downto 0)   -- Measured position
    );      
end component;

--signal force_cw  : std_logic;     
--signal force_ccw : std_logic;
signal cw        : std_logic;         
signal ccw       : std_logic;
signal poss      : signed(7 downto 0);

begin

	  
I_q1 : pos_meas
	port map(
    rst      			  => rst,
    clk    			      => mclk,
    sync_rst  			  => sync_rst,
    a         			  => a,
    b         			  => b,
	pos                   => poss
    );     
	

I_r1 : p_ctrl
  port map(
    rst       => rst_div,
    clk       => mclk_div,
    sp        => signed('0'& sp(6 downto 0)), 
    pos       => poss,
	motor_cw  => cw,
	motor_ccw => ccw
  );
  
  pos <= std_logic_vector(poss);
  
  Sonic_Forces : process(force_cw,force_ccw,cw,ccw)
	begin
		
		if (force_cw xor force_ccw)='1' then
			motor_cw  <= force_cw;
			motor_ccw <= force_ccw;
		else	
			motor_cw  <= cw;
			motor_ccw <= ccw;
		end if;
	end process;
	
end str;