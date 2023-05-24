library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port(
        selec_op    : in unsigned(1 downto 0)    
        inA         : in unsigned(15 downto 0);
        inB         : in unsigned(15 downto 0);
        out0        : out unsigned(15 downto 0);
        carry_sum   : out std_logic;
        carry_subt  : out std_logic;
    );
end entity;

architecture a_ula of ula is
    component mux4x1 is
        port(
            selec   : in unsigned(1 downto 0);
            inA     : in unsigned(15 downto 0);
            inB     : in unsigned(15 downto 0);
            inC     : in unsigned(15 downto 0);
            inD     : in unsigned(15 downto 0);
            out0    : out unsigned(15 downto 0)
        );
    end component;

	signal sum_op, subt_op, geq_op, dif_op : unsigned(16 downto 0);

    constant ZERO: unsigned(16 downto 0) := "00000000000000000";
    constant ONE: unsigned(16 downto 0) := "00000000000000001"
	
    begin
        mux: mux4x1 port map(
            selec => selec_op,
            inA => sum_op(15 downto 0),
            inB => subt_op(15 downto 0),
            inC => geq_op(15 downto 0),
            inD => dif_op(15 downto 0),
            out0 => out0
        );
        
        --  operation   code
            
        --  inA + inB   00
        --  inA - inB   01
        --  inA >= inB  10
        --  inA /= inB  11

        sum_op <= ('0' & inA) + ('0' & inB);
        
        subt_op <= ('0' & inA) - ('0' & inB);

        geq_op <= ONE when (('0' & inA) >= ('0' & inB)) else ZERO;

        dif_op <= ONE when (('0' & inA) /= ('0' & inB)) else ZERO;

        carry_sum <= sum_op(16);

        carry_subt <= '0' when inB <= inA else 
                      '1';
end architecture;


