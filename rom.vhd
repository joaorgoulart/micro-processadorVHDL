
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
        -- case: address => data,

        -- loading registers with constants
        0 => "0001" & "001" & "000110011",      
        1 => "0001" & "010" & "000100000",       
        2 => "0001" & "011" & "000001011", 
        3 => "0001" & "100" & "000010111", 
        4 => "0001" & "101" & "001001000",  
        5 => "0001" & "110" & "000001010", 
        6 => "0001" & "111" & "000010100", 
        
        -- storing constants in ram
        7 => "0111" & "00" & "0000000" & "001",      
        8 => "0111" & "00" & "0000111" & "010",
        9 => "0111" & "00" & "0001110" & "011",
        10 => "0111" & "00" & "0010101" & "100",
        11 => "0111" & "00" & "0011100" & "101",
        12 => "0111" & "00" & "0100011" & "110",
        13 => "0111" & "00" & "0101001" & "111",
                
        -- restarting registers
        14 => "0001" & "001" & "000000000",      
        15 => "0001" & "010" & "000000000",       
        16 => "0001" & "011" & "000000000", 
        17 => "0001" & "100" & "000000000", 
        18 => "0001" & "101" & "000000000",  
        19 => "0001" & "110" & "000000000", 
        20 => "0001" & "111" & "000000000",     
        
        -- charging registers with address
        21 => "0001" & "001" & "000000000",      
        22 => "0001" & "010" & "000000111",       
        23 => "0001" & "011" & "000001110",
                
        -- reading ram addresses
        24 => "1000" & "100" & "001" & "000000",      
        25 => "1000" & "101" & "010" & "000000",       
        26 => "1000" & "110" & "011" & "000000",
                
        -- charging registers with address
        27 => "0001" & "001" & "000010101",      
        28 => "0001" & "010" & "000011100",       
        29 => "0001" & "011" & "000100011",
                
        -- reading ram addresses
        30 => "1000" & "100" & "001" & "000000",      
        31 => "1000" & "101" & "010" & "000000",       
        32 => "1000" & "110" & "011" & "000000",
        
        -- charging register with address
        33 => "0001" & "001" & "000101001",

        -- reading ram address
        34 => "1000" & "111" & "001" & "000000",

        -- testing feature
        35 => "0001" & "001" & "000000001",
        36 => "0111" & "01" & "0000" & "001" & "001",
        37 => "1000" & "111" & "001" & "000000",

        -- below: missing cases => (zero in all bits);
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

