library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity p_ctrl is
  port (
    -- System Clock and Reset
    rst       : in  std_logic;           -- Reset
    clk       : in  std_logic;           -- Clock
    sp        : in  signed(7 downto 0);  -- Set Point
    pos       : in  signed(7 downto 0);  -- Measured position
    motor_cw  : out std_logic;           --Motor Clock Wise direction
    motor_ccw : out std_logic            --Motor Counter Clock Wise direction
    );      
end p_ctrl;

architecture behave of p_ctrl is
	signal synced_sp, synced_pos, temp_sp, temp_pos, err : signed(7 downto 0) := "00000000";
	type state_type is (idle, sample, motor);
		signal state : state_type := idle;
	
	begin 
	resetAndState : process(rst, clk)
	begin
	if rst = '1' then
		motor_cw <= '0';
		motor_ccw <= '0';
		synced_pos <= "00000000";
		temp_pos <= "00000000";
		synced_sp <= "00000000";
		temp_sp <= "00000000";
		state <= idle;
	
	elsif rising_edge(clk) then
		synced_sp <= temp_sp;
		synced_pos <= temp_pos;
		temp_pos <= pos;
		temp_sp <= sp;
		
		case state is
			when idle => 
				motor_cw <= '0';
				state <= sample;
			when sample => 
				err <= synced_sp - synced_pos;
				state <= motor;
			when motor =>
				if(err > 0) then
					motor_cw <= '1';
					motor_ccw <= '0';
				elsif (err < 0) then 
					motor_cw <= '0';
					motor_ccw <= '1';
				else 
					motor_cw <= '0';
					motor_ccw <= '0';
				end if;
				state <= sample;
		end case;
	end if;
	end process resetAndState;
end behave;	
	
					
			
		
	
	