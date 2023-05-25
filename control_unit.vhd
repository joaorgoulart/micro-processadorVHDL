library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port(
        clock : in std_logic;
        reset : in std_logic;
        
        -- ROM Data
        rom_data : in unsigned(15 downto 0); -- Instruction

        -- ULA Data
        ULA_out         : in unsigned(15 downto 0); -- Result of past ULA operation
        ULA_inputB      : out std_logic; -- Either a constant or register B
        ULA_selec_op    : out unsigned(1 downto 0); -- Code for ULA operation selection

        PC_data_out : in unsigned(6 downto 0); -- Output data from PC
        PC_data_in  : out unsigned(6 downto 0); -- Current PC data

        -- Flags for Jump Conditions
        flag_zero       : in std_logic;
        flag_not_zero   : in std_logic;
        flag_less       : in std_logic;

        -- Conditions for setting flags
        is_zero         : out std_logic;
        is_not_zero     : out std_logic;
        is_less         : out std_logic;

        -- Register Selection
        -- registers A & B to get data, and a register to be written                                                        
        selec_regA      : out unsigned(2 downto 0);
        selec_regB      : out unsigned(2 downto 0);
        selec_regWrite  : out unsigned(2 downto 0); 

        not_jump_intruction : out std_logic; -- Flag used to indicate if current instruction is not a jump instruction, 
                                            -- if it's not then jump condition flags need to be updated
                                            -- it is used as a write enable for the jump condition flip flops

        carry_subt  : in std_logic;

        const : out unsigned(15 downto 0);

        write_en    : out std_logic;
        PC_write_en : out std_logic
    );
end entity;

architecture a_control_unit of control_unit is
    component state_mach is
        port(
            clock   : in std_logic;
            reset   : in std_logic;
            state   : out unsigned(1 downto 0)
        );
    end component;

    signal opcode       : unsigned(3 downto 0);
    signal state_sig    : unsigned(1 downto 0); 
    signal jump_address : unsigned(6 downto 0);
    signal jump_en      : std_logic;
    
    -- Receives the part of the instruction that indicates the condition for a conditional jump instruction
    signal jump_condition : unsigned(1 downto 0); 
    
    -- Constants for State Codes
    constant fetch_state        : unsigned(1 downto 0) := "00";
    constant decode_state       : unsigned(1 downto 0) := "01";
    constant execution_state    : unsigned(1 downto 0) := "10";

    -- Constants for opcodes
    constant load_opcode    : unsigned(3 downto 0) := "0001";   -- MOV <reg>, <value>
    constant copy_opcode    : unsigned(3 downto 0) := "0010";   -- MOV <reg>, <reg>
    constant add_opcode     : unsigned(3 downto 0) := "0011";   -- ADD <reg>, <reg>
    constant subt_opcode    : unsigned(3 downto 0) := "0100";   -- SUB <reg>, <reg>
    constant cmp_opcode     : unsigned(3 downto 0) := "0101";   -- CMP <reg>, <reg>
    constant jmpa_opcode    : unsigned(3 downto 0) := "1001";   -- JMPA <condition code>, <address>
    constant jmpr_opcode    : unsigned(3 downto 0) := "1011";   -- JMPR <condition code>, <value>
    constant jmps_opcode    : unsigned(3 downto 0) := "1111";   -- JMPS <address>

    -- Constants for ULA operations
    constant sum_operation  : unsigned(1 downto 0) := "00";
    constant subt_operation : unsigned(1 downto 0) := "01";
    constant less_operation : unsigned(1 downto 0) := "10";
    constant dif_operation  : unsigned(1 downto 0) := "11";

    -- Constants for Jump Conditions
    constant equal_zero  : unsigned(1 downto 0) := "01";
    constant not_zero    : unsigned(1 downto 0) := "10";
    constant less        : unsigned(1 downto 0) := "11";

    -- Constants for ULA InputB Mux Selection
    constant selec_const     : std_logic := '0';
    constant selec_mux_regB  : std_logic := '1';
    
begin 
    state_mach_pm: state_mach port map(
        clock => clock,
        reset => reset,
        state => state_sig
    );

    ----------------------------- INSTRUCTION FETCH  -----------------------------
    
    -- reads ROM when 0, increments PC when 1
    PC_write_en <= '1' when state_sig = fetch_state else 
                   '0';
            
    ----------------------------- INSTRUCTION DECODE -----------------------------

    opcode <= rom_data(15 downto 12);

    -- Set condition for jump
    jump_condition <= rom_data(11 downto 10) when (opcode = jmpa_opcode or opcode = jmpr_opcode) else
                     "00";

    -- Set address for jump
    -- > absolute and unconditional when JMPS
    -- > absolute and conditional when JMPA
    -- > relative and conditional when JMPR
    jump_address <= rom_data(6 downto 0)                 when (opcode = jmps_opcode or opcode = jmpa_opcode) else
                    (rom_data(6 downto 0) + PC_data_out) when (opcode = jmpr_opcode)                         else
                    "0000000";
    
    -- Jump Enable will be '1' when there is an unconditional jump opcode or 
    -- when there is a conditional jump opcode and the proper condition is selected and checked
    jump_en <= '1' when (opcode = jmps_opcode or ((opcode = jmpa_opcode or opcode = jmpr_opcode) and 
                                                   ((flag_zero = '1' and jump_condition = equal_zero)   or
                                                    (flag_not_zero = '1' and jump_condition = not_zero) or
                                                    (flag_less = '1' and jump_condition = less)))) else
               '0';          

    ULA_selec_op <= sum_operation when opcode = load_opcode else
                    sum_operation when opcode = add_opcode  else
                    subt_operation when opcode = subt_opcode  else
                    less_operation when opcode = cmp_opcode else
                    "00";

    ----------------------------- INSTRUCTION EXECUTION -----------------------------

    selec_regA <= "000"                 when (opcode = load_opcode or opcode = copy_opcode)                         else
                  rom_data(11 downto 9) when (opcode = add_opcode or opcode = subt_opcode or opcode = cmp_opcode)   else 
                  "000";
                  
    selec_regB <= rom_data(8 downto 6) when (opcode = copy_opcode) or 
                                            (opcode = add_opcode)  or
                                            (opcode = subt_opcode) or
                                            (opcode = cmp_opcode) else
                  "000";

    -- Concatenate constant to form 16 bit word for ULA
    const <= "0000000" & rom_data(8 downto 0) when rom_data(8) = '0' else 
             "1111111" & rom_data(8 downto 0); 

    selec_regWrite <= rom_data(11 downto 9);

    PC_data_in <= PC_data_out + "0000001"   when jump_en = '0' else
                  jump_address              when jump_en = '1';
    
    ULA_inputB <= selec_const when opcode = load_opcode else
                  selec_mux_regB;

    write_en <= '1' when (state_sig = execution_state and ((opcode = load_opcode) or 
                                                          (opcode = copy_opcode) or 
                                                          (opcode = add_opcode)  or 
                                                          (opcode = subt_opcode))) else
                '0';

    ----- Setting signals used for setting jump condition flags -----
    is_zero <= '1' when (state_sig = execution_state and ((opcode = load_opcode) or 
                                                         (opcode = copy_opcode) or 
                                                         (opcode = add_opcode)  or 
                                                         (opcode = subt_opcode)) and ULA_out = "0000000000000000") else
               '0';
    
    is_not_zero <= '0' when (state_sig = execution_state and ((opcode = load_opcode) or 
                                                              (opcode = copy_opcode) or 
                                                              (opcode = add_opcode)  or 
                                                              (opcode = subt_opcode)) and ULA_out = "0000000000000000") else
                   '1';

    is_less <= '1' when (state_sig = execution_state and ((opcode = cmp_opcode) and carry_subt = '1')) else
               '0';
    -----------------------------------------------------------------

    not_jump_intruction <= '1' when state_sig = execution_state and ((opcode = load_opcode) or 
                                                                     (opcode = copy_opcode) or 
                                                                     (opcode = add_opcode)  or 
                                                                     (opcode = subt_opcode)) else
                           '0';                                                    
end architecture;