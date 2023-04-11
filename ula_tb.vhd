library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
	component ula
		port(
			in0 : in unsigned(15 downto 0);
			in1 : in unsigned(15 downto 0);
			out0 : out unsigned(15 downto 0);
			selec_op : in unsigned(1 downto 0)
		);
	end component;
	signal in0, in1, out0 : unsigned(15 downto 0);
	signal selec_op : unsigned(1 downto 0);
	signal sum, subt, multip : unsigned(15 downto 0);
	signal maior : std_logic;
    begin
		uut: ula port map(in0 => in0,
						  in1 => in1,
						  out0 => out0,
						  selec_op => selec_op
						 );
	process
	begin
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "00";
		wait for 50 ns;
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "01";
		wait for 50 ns;
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "10";
		wait for 50 ns;
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "11";
		wait for 50 ns;
		
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "00";
		wait for 50 ns;
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "01";
		wait for 50 ns;
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "10";
		wait for 50 ns;
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "11";
		wait for 50 ns;
		
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "00";
		wait for 50 ns;
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "01";
		wait for 50 ns;
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "10";
		wait for 50 ns;
		in0 <= "0000000000000000";
		in1 <= "0000000000000000";
		selec_op <= "11";
		wait for 50 ns;'
		wait;
	end process;
end architecture;


