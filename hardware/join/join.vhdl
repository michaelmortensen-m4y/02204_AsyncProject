--------------------------------------------------------------------------
--! @file join.vhdl
--! @brief Implements a 2-phase Click join component.
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity click_join is
    port (
        a_req, b_req, c_ack  : in  std_logic;
        a_ack, b_ack, c_req  : out  std_logic
    );
end click_join;

architecture behavioural of click_join is

    signal ff_clock : std_logic := '0';
    signal ff_value : std_logic := '0';

begin

    process(ff_clock)
    begin
        if rising_edge(ff_clock) then
            ff_value <= not ff_value;
        end if;
    end process;

    ff_clock <=  (a_req and not c_ack and b_req and not c_ack) 
                or (not a_req and not b_req and ff_value and c_ack);

    b_ack <= ff_value;
    a_ack <= ff_value;
    c_req <= ff_value;

end behavioural;