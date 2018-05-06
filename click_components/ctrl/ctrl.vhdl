--------------------------------------------------------------------------
--! @file delay.vhdl
--! @brief N-stage delay element for asynchronous circuits
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity click_ctrl is
    port (
        a_req, b_ack  : in  std_logic;
        a_ack, b_req  : out  std_logic
    );
end click_ctrl;

architecture behavioural of click_ctrl is

    signal ff_clock : std_logic := '0';
    signal ff_value : std_logic := '0';
    signal b_req_internal : std_logic := '0';
    signal a_ack_internal : std_logic := '0';

begin

    process(ff_clock)
    begin
        if rising_edge(ff_clock) then
            ff_value <= not ff_value;
        end if;
    end process;

    -- Remove this delay
    ff_clock <=  transport ((not a_req) and a_ack_internal and b_ack) 
                or (a_req and (not a_ack_internal) and (not b_ack)) after 1 ns;
    b_req_internal <= ff_value;
    a_ack_internal <= ff_value;

    a_ack <= a_ack_internal;
    b_req <= b_req_internal;

end behavioural;