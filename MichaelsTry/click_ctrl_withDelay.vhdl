--------------------------------------------------------------------------
--! @file ctrl.vhdl
--! @brief Click-element controller with delays defined internally using 2-phase
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity click_ctrl_withDelay is
    generic(forwardDelay : time := 2.0 ns;
            backwardDelay : time := 1.0 ns;
            initialOut : std_logic := '1');
    port (
        a_req, b_ack  : in  std_logic;
        a_ack, b_req, latchClock : out  std_logic
    );
end click_ctrl_withDelay;

architecture behavioural of click_ctrl_withDelay is

    signal ff_clock : std_logic := '0';
    signal ff_value : std_logic := initialOut;
    signal a_req_internal : std_logic := '0';
    signal b_ack_internal : std_logic := '0';
    signal b_req_internal : std_logic := '0';
    signal a_ack_internal : std_logic := '0';

begin

    process(ff_clock)
    begin
        if rising_edge(ff_clock) then
            ff_value <= not ff_value;
        end if;
    end process;
    
    a_req_internal <= transport a_req after forwardDelay;
    b_ack_internal <= transport b_ack after backwardDelay;

    ff_clock <=  ((not a_req_internal) and a_ack_internal and b_ack_internal) 
                or (a_req_internal and (not a_ack_internal) and (not b_ack_internal));

    b_req_internal <= ff_value;
    a_ack_internal <= ff_value;

    a_ack <= a_ack_internal;
    b_req <= b_req_internal;

    latchClock <= ff_clock;
    
end behavioural;