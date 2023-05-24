library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port(
        clk, rst                                : in std_logic;
        rom_in                                  : in unsigned(15 downto 0);
        ula_srcB, write_en, PC_wr_en, jump_en   : out std_logic;
        ula_selec_op                            : out unsigned(1 downto 0)
    );
end entity;

architecture a_control_unit of control_unit is
    component state_mach is
        port(
            clk     : in std_logic;
            rst     : in std_logic;
            state   : out unsigned(1 downto 0)
        );
    end component;

    component T_ff is
        port(
            clk     : in std_logic:
            rst     : in std_logic;
            state   : out std_logic
        );
    end component;

    signal opcode       : unsigned(3 downto 0);
    signal state_sig    : unsigned(1 downto 0);

    signal flag_eq_zero, flag_dif_zero, flag_geq : std_logic;

begin 
    state_mach1: state_mach port map(
        clk => clk,
        rst => rst,
        state => state_sig
    );

    ff_eq_zero: T_ff port map(
        clk => clk,
        rst => rst,
        state => flag_eq_zero
    ); 

    ff_dif_zero: T_ff port map(
        clk => clk,
        rst => rst,
        state => flag_dif_zero
    );

    ff_geq: T_ff port map(
        clk => clk,
        rst => rst,
        state => flag_geq
    );

    process(clk, rst, )

    -- Instruction Fetch -> reads ROM when 0, increments PC when 1
    PC_wr_en <= '1' when state_sig = "00" else 
                '0';
            
    -- Instruction Decode -> state_sig == 01
    opcode <= rom_in(15 downto 12);
        -- MOV (load constant) opcode = 0001
        -- MOV (copy) opcode = 0010
        -- ADD opcode = 0011
        -- SUB opcode = 0100
        -- JMPA opcode = 1001
        -- JMPR opcode = 1011
        -- JMPS opcode = 1111
            
    ula_selec_op <= "00" when opcode = "0001" else
                    "00" when opcode = "0011" else
                    "01" when opcode = "0100" else
                    "00";

    -- Execute -> 1 when 
    -- jump opcode = "1111", jumps to the jump_address when opcode = "1111"
    jump_en <= '1' when opcode = "1111" or (opcode "1011" and ) else
               '0';
    ula_srcB <= '0' when opcode = "0001" else
                '1';
    write_en <= '1' when state_sig = "10" and (opcode = "0001" or opcode="0010" or opcode = "0011" or opcode = "0100") else
                '0';

end architecture;