library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    component rom
    port(clk        : in std_logic;
         endereco   : in unsigned(6 downto 0);
         dado       : out unsigned(15 downto 0)
    );   
    end component;

    signal clk : std_logic;
    signal dado : unsigned (15 downto 0);
    signal endereco : unsigned (6 downto 0);
    signal finished		 	 : std_logic := '0';
    constant period_time 	 : time		:= 50 ns;

begin
    uut: rom port map(endereco => endereco,
                      dado => dado,
                      clk => clk);


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
        wait for 100 ns;
        endereco <= "0000000";
        wait for 50 ns;
        endereco <= "0000001";
        wait for 50 ns;
        endereco <= "0000010";
        wait for 50 ns;
        endereco <= "0000011";
        wait for 50 ns;
        endereco <= "0000100";
        wait for 50 ns;
        endereco <= "0000101";
        wait for 50 ns;
        endereco <= "0000110";
        wait for 50 ns;
        endereco <= "0000111";
        wait for 50 ns;
        endereco <= "0001000";
        wait for 50 ns;
        endereco <= "0001001";
        wait for 50 ns;
        endereco <= "0001010";
        wait for 50 ns;
        wait;
    end process;
end architecture a_rom_tb;