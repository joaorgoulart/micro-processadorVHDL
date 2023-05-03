library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port(
        clk     : in std_logic;
        rst     : in std_logic;
        rom_out : out unsigned(15 downto 0);
        PC_out  : out unsigned(6 downto 0)
    );
end entity;

architecture a_control_unit of control_unit is
    component PC is
        port(
            clk		    : in std_logic;
		    rst		    : in std_logic;
		    wr_en		: in std_logic;
		    data_in	    : in unsigned(6 downto 0);
		    data_out	: out unsigned(6 downto 0)
        );
    end component;

    component rom is
        port(
            clk        : in std_logic;
            endereco   : in unsigned(6 downto 0);
            dado       : out unsigned(15 downto 0)
        );
    end component;

    component state_mach is
        port(
            clk     : in std_logic;
            rst     : in std_logic;
            state   : out std_logic
        );
    end component;

    signal PC_out_sig, PC_data_in, jump_address : unsigned(6 downto 0);
    signal opcode                               : unsigned(3 downto 0);
    signal rom_out_sig                          : unsigned(15 downto 0);
    signal PC_wr_en, state_sig, jump_en         : std_logic;

begin 
    state_mach1: state_mach port map(
        clk => clk,
        rst => rst,
        state => state_sig
    );

    rom1: rom port map(
        clk => clk,
        endereco => PC_out_sig,
        dado => rom_out_sig
    );
    
    rom_out <= rom_out_sig

    PC1: PC port map(
        clk => clk,
        rst => rst,
        wr_en => PC_wr_en,
        data_in => PC_data_in,
        data_out => PC_out_sig
    );

    -- reads ROM when 0, increments PC when 1
    PC_wr_en <= '0' when state_sig = '0' else 
                '1';
            
    PC_out <= PC_out_sig;
    
    opcode <= rom_out_sig(15 downto 12);
    
    -- jump opcode = "1111", jumps to the jump_address when opcode = "1111"
    jump_en <= '1' when opcode = "1111" else
               '0';
    jump_address <= rom_out_sig(6 downto 0);

    -- when jump_en = '0', add 1 to PC, when jump_en = '1', jumps to jump_address
    PC_data_in <= PC_out_sig + "0000001" when jump_en = '0' else
                  jump_address;

end architecture;