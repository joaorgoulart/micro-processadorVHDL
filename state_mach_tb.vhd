library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_mach_tb is
end;

architecture a_state_mach_tb of state_mach_tb is
	component state_mach
		port(clk	: in std_logic;
			 rst 	: in std_logic;
			 state 	: out std_logic
			 ); 
	end component;
	
	constant period_time	: time		:= 100 ns;
	signal finished		 	: std_logic := '0';
	signal clk, rst, state 	: std_logic;
begin
	uut: state_mach port map(clk => clk,
							rst => rst,
							state => state);
	rst_global: process
	begin	
		rst <= '1';
		wait for period_time*2;
		rst <= '0';
		wait;
	end process;
	
	sim_time_proc: process
	begin 
		wait for 10 us;
		finished <= '1';
		wait;
	end process sim_time_proc;
	
	clk_proc: process
	begin 
		while finished /= '1' loop
			clk <= '0';
			wait for period_time/2;
			clk <= '1';
			wait for period_time/2;
		end loop;
		wait;
	end process;
	
	process 
	begin
		wait for 200 ns;
		--primeiro clk '1'
        wait for 100 ns;
        --segundo clk '0'
		wait for 100 ns;
        --terceiro clk '1'
		wait for 100 ns;
		--quarto clk '0'
		wait;
		
	end process;
end architecture a_state_mach_tb;