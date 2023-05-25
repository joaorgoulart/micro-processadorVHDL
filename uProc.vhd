library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uProc is
    port(
        clock : in std_logic;
        reset : in std_logic;
        
        PC_out_data     : out unsigned(6 downto 0);
        rom_data        : out unsigned(15 downto 0);
        ULA_out_data    : out unsigned(15 downto 0)
    );
end entity;

architecture a_uProc of uProc is
    component ula is
        port(
            inA         : in unsigned(15 downto 0);
            inB         : in unsigned(15 downto 0);
            data_out    : out unsigned(15 downto 0);
            selec_op    : in unsigned(1 downto 0);
            carry_sum   : out std_logic;
            carry_subt  : out std_logic
        );
    end component;

    component banco_8reg is
        port(
            data_input 		: in unsigned(15 downto 0);
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
            clock		: in std_logic;
		    reset		: in std_logic;
		    write_en	: in std_logic;
		    data_in	    : in unsigned(6 downto 0);
		    data_out	: out unsigned(6 downto 0)
        );
    end component;

    component control_unit is
        port(
            clock               : in std_logic;
            reset               : in std_logic;
            rom_data            : in unsigned(15 downto 0);
            ULA_out             : in unsigned(15 downto 0);
            ULA_inputB          : out std_logic;
            ULA_selec_op        : out unsigned(1 downto 0);
            PC_data_out         : in unsigned(6 downto 0);
            PC_data_in          : out unsigned(6 downto 0);
            flag_zero           : std_logic;
            flag_not_zero       : std_logic;
            flag_less           : std_logic;
            is_zero             : std_logic;
            is_not_zero         : std_logic;
            is_less             : std_logic;
            is_zero_signal      : in std_logic;                                       
            selec_regA          : out unsigned(2 downto 0);
            selec_regB          : out unsigned(2 downto 0);
            selec_regWrite      : out unsigned(2 downto 0); 
            not_jump_intruction : in std_logic; 
            const               : out unsigned(15 downto 0);
            write_en            : out std_logic;
            PC_write_en         : out std_logic
        );
    end component;

    component rom is
        port(
            clock     : in std_logic;
            address   : in unsigned(6 downto 0);
            data      : out unsigned(15 downto 0)
        );
    end component;

    component mux is
        port(
            inA         : in unsigned(15 downto 0);
            inB         : in unsigned(15 downto 0);
            data_out    : out unsigned(15 downto 0);
            selec       : in std_logic
        );
    end component;

    component D_ff is
        port(
            clock       : in std_logic;
            reset       : in std_logic;
            write_en    : in std_logic;
            D           : in std_logic;
            Q           : out std_logic
        );
    end component;
    
    ----------------------------- SIGNALS -----------------------------    
       
    -- Register File Output Signals
    -- (Reg File outA -> ULA inA) (Reg File outB -> Mux inA)
    signal regOutA_ulaA, regOutB_muxA : unsigned(15 downto 0);

    -- Signal for register selection
    -- (Control Unit -> Register File)
    signal selec_regA_SIG, selec_regB_SIG, selec_regWrite_SIG : unsigned(2 downto 0);

    -- (Mux output -> ULA inB)
    signal muxOut_ulaB : unsigned(15 downto 0);
    
    -- Constant Signal (Control Unit -> ULA)
    signal const_SIG : unsigned(15 downto 0);

    -- ROM data signal (ROM -> Control Unit)
    signal rom_data_SIG : unsigned(15 downto 0);

    -- PC data (PC <-> Control Unit)
    signal PC_data_in_SIG, PC_data_out_SIG : unsigned(6 downto 0);

    -- Enable signals
    -- (Control Unit -> Reg File) (Control Unit -> PC) (Control Unit)
    signal write_en_SIG, PC_write_en_SIG : std_logic;

    -- Flags Flip Flop Signals 
    signal update_flag_ff : std_logic;
    signal is_zero_SIG, is_not_zero_SIG, is_less_SIG  : std_logic;
    signal flag_zero_SIG, flag_not_zero_SIG, flag_less_SIG : std_logic;

    -- Select ULA Operation
    -- (Control Unit -> ULA)
    signal ULA_selec_op_SIG : unsigned(1 downto 0); 

    -- Select ULA input B
    -- (Control Unit -> Mux)
    signal ULA_inputB_SIG : std_logic;

    signal ULA_output : unsigned(15 downto 0);

    signal carry_subt_SIG   : std_logic;
    signal carry_sum_SIG    : std_logic;

begin   
    ula_pm: ula port map(inA           => regOutA_ulaA, 
                      inB           => muxOut_ulaB, 
                      data_out      => ULA_output, 
                      selec_op      => ULA_selec_op_SIG,
                      carry_sum     => carry_sum_SIG,
                      carry_subt    => carry_subt_SIG);

    banco_reg_pm: banco_8reg port map(data_input       => ULA_output, 
                                   selec_regA       => selec_regA_SIG, 
                                   selec_regB       => selec_regB_SIG, 
                                   selec_regWrite   => selec_regWrite_SIG, 
                                   regA_out         => regOutA_ulaA,
                                   regB_out         => regOutB_muxA,
                                   write_en         => write_en_SIG, 
                                   clock            => clock, 
                                   reset            => reset);    
    
    PC_pm: PC port map(clock       => clock,
                    reset       => reset,
                    write_en    => PC_write_en_SIG,
                    data_in     => PC_data_in_SIG,
                    data_out    => PC_data_out_SIG);
                
    control_unit_pm: control_unit port map(clock               => clock,
                                        reset               => reset,
                                        rom_data            => rom_data_SIG,
                                        ULA_out             => ULA_output,     
                                        ULA_inputB          => ULA_inputB_SIG,      
                                        ULA_selec_op        => ULA_selec_op_SIG,   
                                        PC_data_out         => PC_data_out_SIG, 
                                        PC_data_in          => PC_data_in_SIG, 
                                        flag_zero           => flag_zero_SIG,      
                                        flag_not_zero       => flag_not_zero_SIG,  
                                        flag_less           => flag_less_SIG,
                                        is_zero             => is_zero_SIG,        
                                        is_not_zero         => is_not_zero_SIG,     
                                        is_less             => is_less_SIG,
                                        is_zero_signal      => is_zero_SIG,                                                    
                                        selec_regA          => selec_regA_SIG,    
                                        selec_regB          => selec_regB_SIG,     
                                        selec_regWrite      => selec_regWrite_SIG, 
                                        not_jump_intruction => update_flag_ff,
                                        const               => const_SIG,
                                        write_en            => write_en_SIG,    
                                        PC_write_en         => PC_write_en_SIG);
   
    rom_pm: rom port map(clock     => clock,
                      address   => PC_data_out_SIG,
                      data      => rom_data_SIG);
                     
    mux_ULA_inputB_pm: mux port map(inA        => const_SIG, 
                                 inB        => regOutB_muxA, 
                                 data_out   => muxOut_ulaB, 
                                 selec      => ULA_inputB_SIG);
    
    Dff_flag_zero_pm: D_ff port map(clock      => clock,
                                 reset      => reset,         
                                 write_en   => update_flag_ff,
                                 D          => is_zero_SIG,
                                 Q          => flag_zero_SIG);

    Dff_flag_not_zero_pm: D_ff port map(clock      => clock,
                                     reset      => reset, 
                                     write_en   => update_flag_ff,
                                     D          => is_not_zero_SIG,
                                     Q          => flag_not_zero_SIG);

    Dff_flag_less_pm: D_ff port map(clock       => clock,
                                 reset       => reset,
                                 write_en    => update_flag_ff,
                                 D           => is_less_SIG,
                                 Q           => flag_less_SIG);
          
    PC_out_data <= PC_data_out_SIG;
    rom_data <= rom_data_SIG;    
    ULA_out_data <= ULA_output;    

end architecture;    