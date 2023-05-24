library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uProc is
    port(
        clock           : in std_logic;
        reset           : in std_logic      
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

    component PC is
        port(
            clk		    : in std_logic;
		    rst		    : in std_logic;
		    wr_en		: in std_logic;
		    data_in	    : in unsigned(6 downto 0);
		    data_out	: out unsigned(6 downto 0)
        );
    end component;

    component control_unit is
        port(
            clk, rst                                : in std_logic;
            rom_in                                  : in unsigned(15 downto 0);
            ula_srcB, write_en, PC_wr_en, jump_en   : out std_logic;
            ula_selec_op                            : out unsigned(1 downto 0)
        );
    end component;

    component rom is
        port(
            clk        : in std_logic;
            endereco   : in unsigned(6 downto 0);
            dado       : out unsigned(15 downto 0)
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
    
    signal regOutA_ulaA, regOutB_muxA, saida_ula, muxOut_ulaB, const : unsigned(15 downto 0);
    signal rom_data : unsigned(15 downto 0);
    signal PC_data_in, PC_data_out, jump_address : unsigned(6 downto 0);
    signal opcode : unsigned(3 downto 0);
    signal selec_regA, selec_regB, selec_regWrite : unsigned(2 downto 0);
    signal selec_oper : unsigned(1 downto 0); 
    signal ula_srcB, write_en, PC_wr_en, jump_en : std_logic;
    signal jump_op : unsigned(1 downto 0);

begin   
    ula1: ula port map( inA => regOutA_ulaA, 
                        inB => muxOut_ulaB, 
                        out0 => saida_ula, 
                        selec_op => selec_oper);

    banco_reg1: banco_8reg port map(data_input => saida_ula, 
                                    selec_regA => selec_regA, 
                                    selec_regB => selec_regB, 
                                    selec_regWrite => selec_regWrite, 
                                    regA_out => regOutA_ulaA,
                                    regB_out => regOutB_muxA,
                                    write_en => write_en, 
                                    clock => clock, 
                                    reset => reset);    
    
    PC1: PC port map(clk => clock,
                     rst => reset,
                     wr_en => PC_wr_en,
                     data_in => PC_data_in,
                     data_out => PC_data_out);
                
    control_unit1: control_unit port map(clk => clock,
                                         rst => reset,
                                         rom_in => rom_data,
                                         ula_srcB => ula_srcB,
                                         write_en => write_en,
                                         PC_wr_en => PC_wr_en,
                                         jump_en => jump_en,
                                         ula_selec_op => selec_oper);
   
    rom1: rom port map(clk=>clock,
                       endereco=> PC_data_out,
                       dado=> rom_data);
                     
    mux1: mux port map(inA => const, 
                      inB => regOutB_muxA, 
                      out0 => muxOut_ulaB, 
                      selec => ula_srcB);
    
    opcode <= rom_data(15 downto 12);

    jump_op <= rom_data(11 downto 10) when (opcode = "1001" or opcode = "1011") else
               "00";

    
    

    selec_regA <= "000" when opcode = "0001" or opcode = "0010" else
                  rom_data(11 downto 9) when opcode = "0011" or opcode = "0100" else "000";
    selec_regB <= rom_data(8 downto 6) when opcode = "0010" or opcode = "0011" or opcode = "0100" else
                  "000";

    selec_regWrite <= rom_data(11 downto 9);

    const <= "0000000" & rom_data(8 downto 0) when rom_data(8) = '0' else "1111111" & rom_data(8 downto 0); 
    
    jump_address <= rom_data(6 downto 0);

    PC_data_in <= PC_data_out + "0000001" when jump_en = '0' else
                  jump_address;

end architecture;    