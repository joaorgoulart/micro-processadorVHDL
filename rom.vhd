
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

        0 => "0001" & "001" & "000100001",      
        1 => "0001" & "010" & "000000010",       
        2 => "0001" & "011" & "000000001", 

        3 => "0000000000000000", 
        4 => "0111" & "01" & "0000" & "010" & "010",  
        5 => "0011" & "010" & "011" & "000000", 
        6 => "0101" & "010" & "001" & "000000", 
        7 => "1101" & "11" & "000" & "0000100",      
        
        8 => "0000000000000000",
        9 => "0001" & "010" & "000000" & "100",
        10 => "0001" & "011" & "000000" & "010",
        11 => "0111" & "01" & "0000" & "010" & "000",
        12 => "0011" & "010" & "011" & "000000",
        13 => "0101" & "010" & "001" & "000000",
        14 => "1101" & "11" & "000" & "0001011",      
        
        15 => "0000000000000000",       
        16 => "0001" & "010" & "000000110", 
        17 => "0001" & "011" & "000000011", 
        18 => "0111" & "01" & "0000" & "010" & "000",  
        19 => "0011" & "010" & "011" & "000000", 
        20 => "0101" & "010" & "001" & "000000",     
        21 => "1101" & "11" & "000" & "0010010",      
        
        22 => "0000000000000000",       
        23 => "0001" & "010" & "000001010",       
        24 => "0001" & "011" & "000000101",      
        25 => "0111" & "01" & "0000" & "010" & "000",       
        26 => "0011" & "010" & "011" & "000000",
        27 => "0101" & "010" & "001" & "000000",      
        28 => "1101" & "11" & "000" & "0011001",     

        29 => "0000000000000000",     
        30 => "0001" & "001" & "000100000",     
        31 => "0001" & "010" & "000000010",         
        32 => "0001" & "011" & "000000001", 
        33 => "1000" & "100" & "010" & "000000", 
        34 => "0011" & "010" & "011" & "000000",
        35 => "0100" & "100" & "000" & "000000", 
        36 => "1101" & "10" & "000" & "0101000",
        37 => "0101" & "001" & "010" & "000000",  
        38 => "1101" & "11" & "000" & "1111111",
        39 => "1111" & "00000" & "0100001",
        40 => "0010" & "111" & "100" & "000000",
        41 => "1111" & "00000" & "0100001",
        
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

