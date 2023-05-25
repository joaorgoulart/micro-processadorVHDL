library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(clock        : in std_logic;
         address   : in unsigned(6 downto 0);
         data       : out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo
        0 => "0001" & "011" & "000000000",      -- MOV R3, 0
        1 => "0001" & "100" & "000000000",      -- MOV R4, 0 
        2 => "0011" & "100" & "011" & "000000", -- ADD R4, R3
        3 => "0001" & "001" & "000000001",      -- MOV R1, 1
        4 => "0011" & "011" & "001" & "000000", -- ADD R3, R1 
        5 => "0001" & "001" & "000011110",      -- MOV R1, 30
        6 => "0101" & "011" & "001" & "000000", -- CMP R3, R1
        7 => "1011" & "11" & "1111111011",      -- JMPR 3, -5 
        8 => "0010" & "101" & "100" & "000000", -- MOV R5, R4
        -- abaixo: casos omissos => (zero em todos os bits) 
        others => (others=>'0')
    );
begin
    process(clock)
    begin
        if(rising_edge(clock)) then
            data <= conteudo_rom(to_integer(address));
        end if;
    end process;
end architecture;