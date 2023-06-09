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
	);
end entity;

architecture a_banco_8reg of banco_8reg is
	component reg16bits is 
		port(clock		: in std_logic;
			 reset		: in std_logic;
			 write_en	: in std_logic;
			 data_in	: in unsigned(15 downto 0);
			 data_out	: out unsigned(15 downto 0)
		);
	end component;
	signal out_reg0, out_reg1, out_reg2, out_reg3, out_reg4, out_reg5, out_reg6, out_reg7 : unsigned(15 downto 0);
	signal write_en1, write_en2, write_en3, write_en4, write_en5, write_en6, write_en7 : std_logic;
begin
	reg16bits0: reg16bits port map(clock=>clock, reset=>'1', write_en=>'0', data_in=>data_input, data_out=>out_reg0);
	reg16bits1: reg16bits port map(clock=>clock, reset=>reset, write_en=>write_en1, data_in=>data_input, data_out=>out_reg1);
	reg16bits2: reg16bits port map(clock=>clock, reset=>reset, write_en=>write_en2, data_in=>data_input, data_out=>out_reg2);
	reg16bits3: reg16bits port map(clock=>clock, reset=>reset, write_en=>write_en3, data_in=>data_input, data_out=>out_reg3);
	reg16bits4: reg16bits port map(clock=>clock, reset=>reset, write_en=>write_en4, data_in=>data_input, data_out=>out_reg4);
	reg16bits5: reg16bits port map(clock=>clock, reset=>reset, write_en=>write_en5, data_in=>data_input, data_out=>out_reg5);
	reg16bits6: reg16bits port map(clock=>clock, reset=>reset, write_en=>write_en6, data_in=>data_input, data_out=>out_reg6);
	reg16bits7: reg16bits port map(clock=>clock, reset=>reset, write_en=>write_en7, data_in=>data_input, data_out=>out_reg7);
	
	--regisrador A sendo carregado com uns dos 8 registradores;
	regA_out <= out_reg0 when selec_regA ="000" else
				out_reg1 when selec_regA ="001" else
				out_reg2 when selec_regA ="010" else
				out_reg3 when selec_regA ="011" else
				out_reg4 when selec_regA ="100" else
				out_reg5 when selec_regA ="101" else
				out_reg6 when selec_regA ="110" else
				out_reg7 when selec_regA ="111" else
				"0000000000000000";
				
	--regisrador B sendo carregado com uns dos 8 registradores;			
	regB_out <= out_reg0 when selec_regB ="000" else
				out_reg1 when selec_regB ="001" else
				out_reg2 when selec_regB ="010" else
				out_reg3 when selec_regB ="011" else
				out_reg4 when selec_regB ="100" else
				out_reg5 when selec_regB ="101" else
				out_reg6 when selec_regB ="110" else
				out_reg7 when selec_regB ="111" else
				"0000000000000000";
				
	--todos os registradores recebem o 'data_input', 
	-- no entanto apenas o registrador selecionado receberá o sinal(write_en) para escrevê-lo;
	write_en1 <= write_en when selec_regWrite="001" else
				 '0';
	write_en2 <= write_en when selec_regWrite="010" else
				 '0';
	write_en3 <= write_en when selec_regWrite="011" else
				 '0';
	write_en4 <= write_en when selec_regWrite="100" else
				 '0';
	write_en5 <= write_en when selec_regWrite="101" else
				 '0';
	write_en6 <= write_en when selec_regWrite="110" else
				 '0';
	write_en7 <= write_en when selec_regWrite="111" else
				 '0';
	
end architecture;