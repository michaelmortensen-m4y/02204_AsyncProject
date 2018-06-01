--------------------------------------------------------------------------
--! @file synchronizer.vhdl
--! @brief Synchronizer used for done signal from asynchronous GCD. 
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synchronizer is
    port (
        clock, reset, input : in std_logic;
        output : out std_logic
    );
end synchronizer;

architecture behavioural of synchronizer is

    signal shift_reg : std_logic_vector(2 downto 0) := (others => '0');

begin

    process(clock, reset)
    begin
        if rising_edge(clock) then
            if(reset='1') then
                shift_reg <= (others => '0');
            else
                shift_reg(0) <= input;
                shift_reg(1) <= shift_reg(0);
            end if;
        end if;
    end process;

    output <= shift_reg(1);

end behavioural;