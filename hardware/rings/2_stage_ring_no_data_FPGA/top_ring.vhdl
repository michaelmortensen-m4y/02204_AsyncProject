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
        led1, led2 : out  std_logic
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


signal ctrl1_req, ctrl1_ack, ctrl2_ack : std_logic := '0';
signal ctrl2_req : std_logic := '0';

-- For controller 1
signal start : std_logic := '0';
signal ctr2_req_and_start : std_logic := '0';

-- The delayed signal values
signal ctrl1_req_delay, ctrl2_req_delay : std_logic;
signal ctrl1_ack_delay, ctrl2_ack_delay : std_logic;


begin

    button_synchronizer1: button_synchronizer
        port map (
            clock => clock,
            reset => reset,
            button => init,
            output => start
        );


    delay_ctrl1_req: delay_n_stage
        generic map (stages => 10)
        port map (
            input => ctrl1_req,
            output => ctrl1_req_delay
        );

    delay_ctrl1_ack: delay_n_stage
        generic map (stages => 10)
        port map (
            input => ctrl1_ack,
            output => ctrl1_ack_delay
        );


    delay_ctrl2_req: delay_n_stage
        generic map (stages => 10)
        port map (
            input => ctrl2_req,
            output => ctrl2_req_delay
        );

    delay_ctrl2_ack: delay_n_stage
        generic map (stages => 10)
        port map (
            input => ctrl2_ack,
            output => ctrl2_ack_delay
        );


    ctrl1 : click_ctrl 
    port map (
        a_req => ctr2_req_and_start,
        b_ack => ctrl2_ack_delay,
        a_ack => ctrl1_ack,
        b_req => ctrl1_req
    );


    ctrl2 : click_ctrl 
    port map (
        a_req => ctrl1_req_delay,
        b_ack => ctrl1_ack_delay,
        a_ack => ctrl2_ack,
        b_req => ctrl2_req
    );


    ctr2_req_and_start <= ctrl1_ack and start;

    led1 <= ctrl1_req;
    led2 <= ctrl2_req;

end behavioural;