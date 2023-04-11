library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port(
        in0 : in unsigned(15 downto 0);
        in1 : in unsigned(15 downto 0);
        out0 : out unsigned(15 downto 0);
        selec_op : in unsigned(1 downto 0)
    );
end entity;

architecture a_ula of ula is
	signal sum, subt, multip : unsigned(15 downto 0);
	signal maior : std_logic;
    begin
        maior <= '1' when in0>in1 else
                 '0' when in0<=in1 else
                 '0';
				 
		sum <= in0 + in1;
		subt <= in0 - in1;
		multip <= in0 and in1;

        out0 <= sum when selec_op="00" else
                subt when selec_op="01" else
                multip when selec_op="10" else
				"000000000000000" & maior when selec_op="11" else
				"0000000000000000";
end architecture;


