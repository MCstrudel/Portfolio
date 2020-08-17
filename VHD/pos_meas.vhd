library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pos_meas is
  port (
    -- System Clock and Reset
    rst      : in  std_logic;           -- Reset
    clk      : in  std_logic;           -- Clock
    sync_rst : in  std_logic;           -- Sync reset
    a        : in  std_logic;           -- From position sensor
    b        : in  std_logic;           -- From position sensor
    pos      : out signed(7 downto 0)   -- Measured position
    );      
end entity pos_meas;

architecture behave of pos_meas is
signal synced_reset, sync_rst_temp, synced_a, synced_b, a_temp, b_temp : std_logic := '0';
signal current_pos : signed(6 downto 0) := "0000000"; 
type state_type is (s, t, u, v, up, down);
	signal state : state_type := s;

begin 

syncAndState: process(clk, rst)
begin
	if rst = '1' then 
	current_pos <= "0000000";
	pos <= "00000000";
	synced_a <= '0';
	synced_b <= '0';
	a_temp <= '0';
	b_temp <= '0';
	sync_rst_temp <= '0';
	synced_reset <= '0';
	state <= s;
	
	elsif rising_edge(clk) then
	a_temp <= a;
	b_temp <= b;
	sync_rst_temp <= sync_rst;
	synced_a <= a_temp;
	synced_b <= b_temp;
	synced_reset <= sync_rst_temp;
	pos(6 downto 0) <= current_pos(6 downto 0);
	
		if synced_reset = '1' then
		current_pos <= "0000000";
		pos <= "00000000";
		synced_a <= '0';
		synced_b <= '0';
		a_temp <= '0';
		b_temp <= '0';
		sync_rst_temp <= '0';
		synced_reset <= '0';
		state <= s;
		end if;
	
	case state is
		when s =>
			if synced_a = '1' then
				state <= u;
			else 
				state <= t;
			end if;
		when t =>
			if synced_a = '1' then 
				state <= u;
			end if;
		when u => 
			if synced_a = '0' then
				state <= v;
			end if;
		when v => 
			if synced_b = '0' then 
				state <= up;
			else 
				state <= down;
			end if;
		when up =>
			if current_pos = 127 then 
			current_pos <= current_pos - 127;
			end if;
			current_pos <= current_pos + 1;
			state <= t;
		when down => 
			if current_pos = 0 then
			--do nothing
			else
				current_pos <= current_pos - 1;
			end if;
			state <= t;
		end case;
	end if;
end process syncAndState;
end architecture behave;