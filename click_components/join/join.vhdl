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
    signal c_req_internal : std_logic := '0';

begin

    process(ff_clock)
    begin
        if rising_edge(ff_clock) then
            ff_value <= not ff_value;
        end if;
    end process;

                -- (a.req =/= c.ack) and (b.req =/= c.ack) and (c.ack = c.req)
    ff_clock <=  transport (a_req xor c_ack) and (b_req xor c_ack) and (c_ack xnor c_req_internal) after 1 ns;
    c_req_internal <= ff_value;

    b_ack <= ff_value;
    a_ack <= ff_value;
    c_req <= c_req_internal;

end behavioural;