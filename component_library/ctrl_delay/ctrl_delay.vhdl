--------------------------------------------------------------------------
--! @file ctrl.vhdl
--! @brief Click-element controller using 2-phase and with signals delayed
--! and reset to initial values using enable going to 0
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity click_ctrl_delay is
    generic (
        a_req_delay : natural := 10;
        b_ack_delay : natural := 10;
        initialOutput : std_logic := '0'
    );
    port (
        a_req, b_ack, enable  : in  std_logic;
        a_ack, b_req, ff_clock  : out  std_logic
    );
end click_ctrl_delay;

architecture behavioural of click_ctrl_delay is

    signal ff_clock_int : std_logic := '0';
    signal ff_value : std_logic := initialOutput;
    signal b_req_internal : std_logic := '0';
    signal a_ack_internal : std_logic := '0';

    signal a_req_delayed : std_logic := '0';
    signal b_ack_delayed : std_logic := '0';

component delay_n_stage is
    generic (stages : natural := 10);
    port (
        input: in  std_logic;
        output : out  std_logic
    );
end component;


begin

    delay_a_req: delay_n_stage
        generic map (stages => a_req_delay)
        port map (
            input => a_req,
            output => a_req_delayed
        );

    delay_b_req: delay_n_stage
        generic map (stages => b_ack_delay)
        port map (
            input => b_ack,
            output => b_ack_delayed
        );


    process(ff_clock_int, enable)
    begin
        if enable = '0' then
            ff_value <= initialOutput;
        elsif rising_edge(ff_clock_int) and enable = '1' then
           ff_value <= not ff_value;
        end if;
    end process;

    ff_clock_int <=  ((not a_req_delayed) and a_ack_internal and b_ack_delayed) 
                or (a_req_delayed and (not a_ack_internal) and (not b_ack_delayed));

    b_req_internal <= ff_value and enable;
    a_ack_internal <= ff_value and enable;

    a_ack <= a_ack_internal;
    b_req <= b_req_internal;

    ff_clock <= ff_clock_int;

end behavioural;