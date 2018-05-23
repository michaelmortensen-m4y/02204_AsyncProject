library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_ring is
end top_ring;

architecture behavioural of top_ring is

component click_ctrl is
    port (
        a_req, b_ack  : in  std_logic;
        a_ack, b_req  : out  std_logic
    );
end component;

signal b_ack, a_req, b_req : std_logic := '0';
signal a_ack : std_logic := '1';

begin

    ctrl1 : click_ctrl 
    port map (
        a_req => a_req,
        b_ack => b_ack,
        a_ack => a_ack,
        b_req => b_req
    );

    a_req <= transport not a_ack after 1 ns; -- An acknowledge means that request should change
    b_ack <= transport b_req after 1 ns;

end behavioural;