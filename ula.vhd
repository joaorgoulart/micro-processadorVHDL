library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port(
        inA : in unsigned(15 downto 0);
        inB : in unsigned(15 downto 0);
        out0 : out unsigned(15 downto 0);
        selec_op : in unsigned(1 downto 0)
    );
end entity;

architecture a_ula of ula is
	signal sum, subt, and_op : unsigned(15 downto 0);
	signal maior : std_logic;
    begin
        maior <= '1' when inA>inB else
                 '0' when inA<=inB else
                 '0';
				 
		sum <= inA + inB;
		subt <= inA - inB;
		and_op <= inA and inB;

        out0 <= sum when selec_op="00" else
                subt when selec_op="01" else
                and_op when selec_op="10" else
				"000000000000000" & maior when selec_op="11" else
				"0000000000000000";
end architecture;


