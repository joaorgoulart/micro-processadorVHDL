library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_8reg is
	port(data_input		: in unsigned(15 downto 0);
		 selec_regA		: in unsigned(2 downto 0);
		 selec_regB		: in unsigned(2 downto 0);
		 selec_regWrite : in unsigned(2 downto 0);
		 regA_out		: out unsigned(15 downto 0);
		 regB_out		: out unsigned(15 downto 0);
		 write_en		: in std_logic;
		 clock			: in std_logic;
		 reset			: in std_logic
	)
end entity;

architecture a_banco_8reg of banco_8reg is
	component reg16bits is 
		port(clk		: in std_logic;
			 rst		: in std_logic;
			 wr_en		: in std_logic;
			 data_in	: in unsigned(15 downto 0);
			 data_out	: out unsigned(15 downto 0)
		);
	end component;
	signal --[TODO]
begin 
	--[TODO]
	
	
end architecture;