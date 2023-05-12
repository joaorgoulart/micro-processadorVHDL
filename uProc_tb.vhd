library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uProc_tb is
end;

architecture a_uProc_tb of uProc_tb is
    component uProc
        port(
            clock           : in std_logic;
            reset           : in std_logic
            );
    end component;
    
	--signal finished         : std_logic := '0';
    signal clock, reset, finished : std_logic;
    constant period_time 	: time		:= 10 ns;

begin
    uut: uProc port map(clock => clock,           
                        reset => reset
                    );

    reset_global: process
	begin	
		reset <= '1';
		wait for period_time;
		reset <= '0';
		wait;
	end process reset_global;

    sim_time_proc: process
	begin 
		wait for period_time * 100;
		finished <= '1';
		wait;
	end process sim_time_proc;

    clk_proc: process
	begin 
		while finished /= '1' loop
			clock <= '0';
			wait for period_time/2;
			clock <= '1';
			wait for period_time/2;
		end loop;
		wait;
	end process clk_proc;
	
end architecture;    