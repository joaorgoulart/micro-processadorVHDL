library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
end entity;

architecture a_PC_tb of PC_tb is
    component PC
        port(
            clock:       in std_logic;
            reset:       in std_logic;
            write_en:     in std_logic;
            data_out:  out unsigned(15 downto 0)
        );
    end component;

    signal clock, reset, write_en, finished: std_logic := '0';
    signal data_in, data_out: unsigned(15 downto 0);
    
    constant period_time : time := 1 ns;
begin
    uut: PC port map(
        clock => clock,
        reset => reset,
        write_en => write_en,
        data_out => data_out
    );

    -- Must reset and continue counting
    reset_global: process
    begin
        write_en <= '1';
        reset <= '1';
        wait for period_time * 2;
        reset <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait;
    end process reset_global;
   
    sim_time_proc: process
        begin
        wait for 1700 ns;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clock_proc: process
    begin 
        while finished /= '1' loop
        clock <= '0';
        wait for period_time/2;
        clock <= '1';
        wait for period_time/2;
        end loop;
        wait;
    end process clock_proc;

end architecture a_PC_tb;