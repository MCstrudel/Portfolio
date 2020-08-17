library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity pos_seg7_ctrl is
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
end pos_seg7_ctrl;

architecture archduke of pos_seg7_ctrl is
	signal rst       : std_logic;
	signal rst_div   : std_logic;
	signal mclk      : std_logic;
	signal mclk_div  : std_logic;
	signal pos_i       : std_logic_vector(7 downto 0);
	
	Component pos_ctrl is
		port
		 (
		rst       : in  std_logic;          
		rst_div   : in  std_logic;         
		mclk      : in  std_logic;       
		mclk_div  : in  std_logic;        
		sync_rst  : in  std_logic;          
		sp        : in  std_logic_vector(7 downto 0);  
		a         : in  std_logic;          
		b         : in  std_logic;          
		pos       : out std_logic_vector(7 downto 0);  
		force_cw  : in  std_logic;         
		force_ccw : in  std_logic;  
		motor_cw  : out std_logic;        
		motor_ccw : out std_logic         
		 );
	end Component;
	
	component seg7ctrl is
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
	end component;
	
	component cru is
		port(
		arst     : in  std_logic;
		refclk   : in  std_logic;
		mclk     : out std_logic;
		mclk_div : out std_logic;
		rst      : out std_logic;
		rst_div  : out std_logic
		);
	end component;

	
	begin
	POSCTRL : pos_ctrl
		port map
		 (
		rst       => rst,          
		rst_div   => rst_div,
		mclk      => mclk,     
		mclk_div  => mclk,        
		sync_rst  => sync_rst, 
		sp		  => sp,
		pos 	  => pos_i,
		a         => a,
		b         => b,   
		force_cw  => force_cw,         
		force_ccw => force_ccw,  
		motor_cw  => motor_cw,        
		motor_ccw => motor_ccw       
		 );
	
	HEX : seg7ctrl
		 port map
		 (
		 mclk         => mclk,
		 reset        => rst,
		 d0           => pos_i(7 downto 4),
		 d1           => pos_i(3 downto 0),
		 d2           => sp(7 downto 4),
		 d3           => sp(3 downto 0),
		 dec          => sp(3 downto 0),
		 abcdefgdec_n => abcdefgdec_n,
		 a_n          => a_n
		 );
	
	RCU : cru
		port map(
		arst     => arst,
		refclk   => refclk,
		mclk     => mclk,
		mclk_div => mclk_div,
		rst      => rst,
		rst_div  => rst_div
		);
	
	
end archduke;