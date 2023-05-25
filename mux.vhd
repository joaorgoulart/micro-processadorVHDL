library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    port(
        inA         : in unsigned(15 downto 0);
        inB         : in unsigned(15 downto 0);
        data_out    : out unsigned(15 downto 0);
        selec       : in std_logic
    );
end entity;

architecture a_mux of mux is
begin
    data_out <= inA when selec='0' else
            inB when selec='1' else
            "0000000000000000";
end architecture;