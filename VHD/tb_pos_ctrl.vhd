library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity poshtest is

end poshtest;

architecture archimedes of poshtest is
  Component pos_ctrl
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

	component motor is 
	  port (
		motor_cw  : in  std_logic;
		motor_ccw : in  std_logic;
		a         : out std_logic;
		b         : out std_logic
		);      
	end component motor;

	signal rst   	 : std_logic := '1';
	signal rst_div   : std_logic := '1';
	signal mclk      : std_logic := '0';
	signal mclk_div  : std_logic := '0';
	signal sync_rst  : std_logic := '1';
	signal sp        : signed(7 downto 0);
	signal a         : std_logic := '0';    
	signal b         : std_logic := '0';     
	signal pos       : signed(7 downto 0);  
	signal force_cw  : std_logic := '0';     
	signal force_ccw : std_logic := '0';
	signal motor_ccw : std_logic := '0';
	signal motor_cw  : std_logic := '0';
	signal post      : std_logic_vector(7 downto 0);
	
	constant Half_Period : time := 5 ns;
	
	
	begin
	UUT : pos_ctrl
	port map
	  (  
		mclk           =>  mclk,       
		Rst            =>  Rst,  
		mclk_div       =>  mclk_div,
		Rst_div        =>  Rst_div,
		sp             =>  std_logic_vector(sp),
		b              =>  b,
		a              =>  a,       
		sync_rst       =>  sync_rst,     
		force_cw       =>  force_cw,
		force_ccw      =>  force_ccw,
		pos            =>  post
	  );

    MTR : motor
	port map(
		motor_cw => motor_cw,
		motor_ccw => motor_ccw,
		a => a,
		b => b
	);
	mclk     <= not mclk after Half_Period;
	mclk_div <= not mclk_div after Half_Period*2;	
	pos      <= signed(post);
	
  STIMULI :
  process
  begin
	rst_div  <= '0' after Half_Period*6;
	rst      <= '0' after Half_Period*6;
	sync_rst <= '0' after Half_Period*6;
	wait for 100 ns;
	sp <= "00110111" after Half_Period;
	wait for 100 ns;
	motor_cw <= '1';
	motor_ccw <= '1' after Half_Period*2;
	wait for 100 ns;
	motor_cw <= '0';
	force_ccw <= '1';
	force_cw  <= '1' after Half_Period*3;
	wait for Half_Period*6;
	force_ccw <= '0';
	force_cw  <= '1' after Half_Period*6;
	wait for Half_Period*6;
	sync_rst <= '1';
	wAIT;
  end process;           
  
end archimedes;