library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_8reg_tb is
end entity;

architecture a_banco_8reg_tb of banco_8reg_tb is
    component banco_8reg
        port(
            data_input		: in unsigned(15 downto 0);
		    selec_regA		: in unsigned(2 downto 0);
		    selec_regB		: in unsigned(2 downto 0);
		    selec_regWrite  : in unsigned(2 downto 0);
		    regA_out		: out unsigned(15 downto 0);
		    regB_out		: out unsigned(15 downto 0);
		    write_en		: in std_logic;
		    clock			: in std_logic;
		    reset			: in std_logic
        );
    end component;

    constant period_time 	: time		:= 100 ns;
	signal finished         : std_logic := '0';

    signal reset, clock, write_en : std_logic;
    signal selec_regA, selec_regB, selec_regWrite: unsigned(2 downto 0);
    signal data_input: unsigned(15 downto 0);
    signal regA_out, regB_out: unsigned(15 downto 0);

begin
    uut: banco_8reg port map(
        clock => clock,
        reset => reset,
        write_en => write_en,
        selec_regA => selec_regA,
        selec_regB => selec_regB,
        selec_regWrite => selec_regWrite,
        data_input => data_input,
        regA_out => regA_out,
        regB_out => regB_out
    );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time * 2;
        reset <= '0';
        wait for 500 ns;
        reset <= '1';
        wait;
    end process reset_global;
   
    sim_time_proc: process
        begin
        wait for 700 ns;
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

    process
    begin
        -- 
        selec_regA <= "000";
        selec_regB <= "000";
        wait for 200 ns;
        write_en <= '1';
        selec_regA <= "001";
        selec_regB <= "010";
        
        selec_regWrite <= "001"; -- escreve no reg 1
        data_input <= "0000000011111111";

        wait for 100 ns;
        selec_regWrite <= "010"; -- escreve no reg 2
        data_input <= "1111111100000000";
        
        wait for 100 ns;
        selec_regB <= "111"; -- mostra saida do reg 7
        selec_regWrite <= "111"; -- escreve no reg 7 
        data_input <= "1010101010101010";
        wait for 100 ns;
        wait;
    end process;

end architecture a_banco_8reg_tb;