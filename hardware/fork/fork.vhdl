--------------------------------------------------------------------------
--! @file fork.vhdl
--! @brief Implements a 2-phase Click fork element.
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity click_fork is
    port (
        b_ack, c_ack, a_req  : in  std_logic;
        a_ack, b_req, c_req: out  std_logic
    );
end click_fork;

architecture behavioural of click_fork is

    signal ff_clock : std_logic := '0';
    signal ff_value : std_logic := '0';

begin

    process(ff_clock)
    begin
        if rising_edge(ff_clock) then
            ff_value <= not ff_value;
        end if;
    end process;

    ff_clock <= (a_req and not b_ack and not c_ack and not ff_value) 
                or (not a_req and b_ack and c_ack and ff_value);

    a_ack <= ff_value;
    b_req <= ff_value;
    c_req <= ff_value;

end behavioural;