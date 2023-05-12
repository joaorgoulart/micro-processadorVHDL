library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(clk        : in std_logic;
         endereco   : in unsigned(6 downto 0);
         dado       : out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo
        0 => "0000000000000000", 
        1 => "0001011000000101", -- MOV R3, #5
        2 => "0001100000001000", -- MOV R4, #8
        3 => "0001101000000000", -- MOV R5, #0
        4 => "0011101011000000", -- ADD R5, R3
        5 => "0011101100000000", -- ADD R5, R4
        6 => "0001001000000001", -- MOV R1, #1
        7 => "0100101000000001", -- SUB R5, R2
        8 => "1111000000010100", -- JMPS 20
        9 => "0000000000000000",
        10 => "0000000000000000",
        11 => "0000000000000000",
        12 => "0000000000000000",
        13 => "0000000000000000",
        14 => "0000000000000000",
        15 => "0000000000000000",
        16 => "0000000000000000",
        17 => "0000000000000000",
        18 => "0000000000000000",
        19 => "0000000000000000",
        20 => "0010011101000000", -- MOV R3, R5
        21 => "1111000000000011", -- JMPS 3
        -- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
    );
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;