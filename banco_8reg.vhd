library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_8reg is
	port(reg1_in 	: in unsigned(15 downto 0);
		 reg2_out	: in unsigned(15 downto 0);
		 data_input	: in unsigned(15 downto 0);
		 selec_reg	: in std_logic;
		 write_en	: in std_logic;
		 clock		: in std_logic;
		 reset		: in std_logic;
		 reg1_in	: out unsigned(15 downto 0);
		 reg2_out	: out unsigned(15 downto 0);
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