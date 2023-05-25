library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_mach is
    port(
        clock     : in std_logic;
        reset     : in std_logic;
        state   : out unsigned(1 downto 0)
    );
end entity;

architecture a_state_mach of state_mach is
    signal state_sig : unsigned(1 downto 0);
begin
    process(clock, reset)
    begin
        if reset='1' then 
            state_sig <= "00";
        elsif rising_edge(clock) then 
            if state_sig = "10" then
                state_sig <= "00"; 
            else
                state_sig <= state_sig + 1;
            end if;
        end if;
    end process;
    
    state <= state_sig;

end architecture;