--------------------------------------------------------------------------
--! @file button_synchronizer.vhdl
--! @brief Synchronizer used for buttons.
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button_synchronizer is
    port (
        clock   : in  std_logic; -- Destination clock
        reset   : in  std_logic; -- Asynchronous, high-active
        button  : in  std_logic;
        output  : out  std_logic
    );
end button_synchronizer;

architecture behavioural of button_synchronizer is

    signal shift_reg : std_logic_vector(2 downto 0) := (others => '0');

begin

    process(clock, reset)
    begin
        if rising_edge(clock) then
            if(reset='1') then
                shift_reg <= (others => '0');
            else
                shift_reg(0) <= button; -- First register takes hit of possible
                                        -- timing errors
                shift_reg(1) <= shift_reg(0);
                shift_reg(2) <= shift_reg(1);
            end if;
        end if;
    end process;

    output <= shift_reg(2) and shift_reg(1);

end behavioural;