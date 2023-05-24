library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    port(
        selec   : in unsigned(1 downto 0);
        inA     : in unsigned(15 downto 0);
        inB     : in unsigned(15 downto 0);
        inC     : in unsigned(15 downto 0);
        inD     : in unsigned(15 downto 0);
        out0    : out unsigned(15 downto 0)
    );
end entity;

architecture a_mux of mux is
begin
    out0 <= inA when selec="00" else
            inB when selec="01" else
            inC when selec="10" else
            inD when selec="11" else
            "0000000000000000";
end architecture;