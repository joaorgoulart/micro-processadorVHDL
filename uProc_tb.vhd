library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uProc_tb is
end;

architecture a_uProc_tb of uProc_tb is
    component uProc
        port(
            clock           : in std_logic;
            reset           : in std_logic;
            write_en        : in std_logic;
            ula_srcB        : in std_logic;
            selec_oper      : in unsigned(1 downto 0);
            selec_regA      : in unsigned(2 downto 0);
            selec_regB	    : in unsigned(2 downto 0);
            selec_regWrite	: in unsigned(2 downto 0);
            const           : in unsigned(15 downto 0);
            saida_ula       : out unsigned(15 downto 0)
            );
    end component;
    
	--signal finished         : std_logic := '0';
    signal clock, reset, write_en, ula_srcB, finished : std_logic;
    signal selec_oper : unsigned(1 downto 0);
    signal selec_regA, selec_regB, selec_regWrite : unsigned(2 downto 0);
    signal const : unsigned(15 downto 0);
    signal saida_ula : unsigned(15 downto 0);

    constant period_time 	: time		:= 25 ns;

begin
    uut: uProc port map(clock => clock,           
                        reset => reset,           
                        write_en => write_en,       
                        ula_srcB => ula_srcB,       
                        selec_oper => selec_oper,      
                        selec_regA => selec_regA,
                        selec_regB => selec_regB, 
                        selec_regWrite => selec_regWrite,
                        const => const,
                        saida_ula => saida_ula);

    reset_global: process
	begin	
		reset <= '1';
		wait for period_time * 2;
		reset <= '0';
        wait for 500 ns;
		wait;
	end process reset_global;

    sim_time_proc: process
	begin 
		wait for 700 us;
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
	end process;
	
    process
    begin
        wait for 100 ns;
        write_en <= '1';
        
        selec_oper <= "00"; -- operacao de soma
        selec_regA <= "000"; --reg0 zerado
        selec_regB <= "001"; --reg1 zerado

        ula_srcB <= '0'; --nesse momento os dados vindos de const serao utilizados;

            
        const <= "0000000000000001";
        selec_regWrite <= "010";--escrevemos o resultado no reg2
		wait for 100 ns;

            selec_regA <= "010";--lemos o reg2
           -- const <= "0000000000000001";
            selec_regWrite <= "011";--escrevemos reg2+const no reg3
        wait for 100 ns;
        
        selec_regA <= "001";--0
        selec_regB <= "010";--1
        ula_srcB <= '1'; --lemos o registrador e nao mais a const esxterna;
        selec_regWrite <= "100";--escrevemos a soma no reg4;
		wait for 100 ns;

        wait;
    end process;
end architecture;    