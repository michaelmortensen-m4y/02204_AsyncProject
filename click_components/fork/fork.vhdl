--------------------------------------------------------------------------
--! @file fork.vhdl
--! @brief Implements a 2-phase bundled data fork for click-elements
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
    signal a_ack_internal : std_logic := '0';

begin

    process(ff_clock)
    begin
        if rising_edge(ff_clock) then
            ff_value <= not ff_value;
        end if;
    end process;

                -- (b.ack =/= a.req) and (c.ack =/= a.req) and (b.ack = c.ack)
    ff_clock <=  transport (b_ack xor a_req) and (c_ack xor a_req) and (b_ack xnor c_ack) after 1 ns;
    a_ack_internal <= ff_value;

    a_ack <= a_ack_internal;
    b_req <= ff_value;
    c_req <= ff_value;

end behavioural;