--------------------------------------------------------------------------
--! @file top_ring.vhdl
--! @brief Test a single ring running
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_ring is
    port (
        init, clock, reset : in std_logic;
        output : out  std_logic
    );
end top_ring;

architecture behavioural of top_ring is

component click_ctrl is
    port (
        a_req, b_ack  : in  std_logic;
        a_ack, b_req  : out  std_logic
    );
end component;

component delay_n_stage is
    generic (stages : natural := 10);
    port (
        input: in  std_logic;
        output : out  std_logic
    );
end component;

component button_synchronizer is
    port (
        clock, reset, button  : in  std_logic;
        output  : out  std_logic
    );
end component;


signal a_ack, b_ack, b_req : std_logic := '0';
signal a_req : std_logic := '1';
signal start : std_logic := '0';
signal a_req_and_start : std_logic := '0';

-- The delayed signal values
signal a_ack_delay, b_req_delay : std_logic := '0';

begin

    button_synchronizer1: button_synchronizer
        port map (
            clock => clock,
            reset => reset,
            button => init,
            output => start
        );


    delay1: delay_n_stage
        generic map (stages => 10)
        port map (
            input => a_ack,
            output => a_ack_delay
        );

    delay2: delay_n_stage
        generic map (stages => 10)
        port map (
            input => b_req,
            output => b_req_delay
        );

    ctrl1 : click_ctrl 
    port map (
        a_req => a_req_and_start,
        b_ack => b_ack,
        a_ack => a_ack,
        b_req => b_req
    );

    a_req_and_start <= a_req and start;
    a_req <= not a_ack_delay; -- An acknowledge means that request should change
    b_ack <= b_req_delay;

    output <= a_ack;

end behavioural;