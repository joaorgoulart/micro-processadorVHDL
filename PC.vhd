library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clock		: in std_logic;
		reset		: in std_logic;
		write_en	: in std_logic;
		data_in	    : in unsigned(6 downto 0);
		data_out	: out unsigned(6 downto 0)
    );
end entity;

architecture a_PC of PC is
    signal registro: unsigned(6 downto 0);
begin
    process(clock, reset, write_en)
    begin 
        if reset='1' then
            registro <= "1111111";
        elsif write_en='1' then
            if rising_edge(clock) then
                registro  <= data_in;
            end if;
        end if;
    end process;
    
    data_out <= registro;
end architecture;