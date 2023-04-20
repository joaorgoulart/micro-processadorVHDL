library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uProc is
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
end entity;

architecture a_uProc of uProc is
    component ula is
        port(
            inA         : in unsigned(15 downto 0);
            inB         : in unsigned(15 downto 0);
            out0        : out unsigned(15 downto 0);
            selec_op    : in unsigned(1 downto 0)
        );
    end component;

    component banco_8reg is
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

    component mux is
        port(
            inA : in unsigned(15 downto 0);
            inB : in unsigned(15 downto 0);
            out0 : out unsigned(15 downto 0);
            selec : in std_logic
        );
    end component;
    
    signal regOutA_ulaA, regOutB_muxB, muxOut_ulaB : unsigned(15 downto 0);
begin
    ula: ula port map(inA => regOutA_ulaA, 
                      inB => muxOut_ulaB, 
                      out0 => saida_ula, 
                      selec_op => selec_oper);

    banco_reg: banco_8reg port map(data_input => saida_ula, 
                                   selec_regA => selec_regB, 
                                   selec_regB => selec_regB, 
                                   selec_regWrite => selec_regWrite, 
                                   regA_out => regOutA_ulaA,
                                   regB_out => regOutB_muxA,
                                   write_en => write_en, 
                                   clock => clock, 
                                   reset => reset);

    mux: mux port map(inA => const, 
                      inB => regOutB_muxB, 
                      out0 => muxOut_ulaB, 
                      selec => ula_srcB);

end architecture;    