--------------------------------------------------------------------------
--! @file test_fork.vhdl
--! @brief Testbench file for the click fork.
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_tb is
end test_tb;

architecture rtl of test_tb is

-- The design under test
component click_fork is
    port (
        b_ack, c_ack, a_req  : in  std_logic;
        a_ack, b_req, c_req: out  std_logic
    );
end component;


    -- Internal test signals
    signal b_ack_int, c_ack_int, a_req_int : std_logic := '0';
    signal a_ack_int, b_req_int, c_req_int : std_logic;

    -- Delay used in combinational test
    constant delay : time := 10 ns;

begin 

dut: click_fork 
    port map (
        b_ack => b_ack_int,
        c_ack => c_ack_int,
        a_req => a_req_int,
        a_ack => a_ack_int,
        b_req => b_req_int,
        c_req => c_req_int
    );

    stim_proc: process
        begin

        wait for delay; -- 10 ns

        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_req_int = '0') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        --########################################################
        -- Test of single handshake
        --########################################################

        wait for delay; -- 20 ns

        a_req_int <= '1';
        wait for delay; -- 30 ns

        -- a requests and sends request to b and c
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        b_ack_int <= '1';
        wait for delay; -- 40 ns

        -- Only b has acknowledged, so no other signals should change
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        c_ack_int <= '1';
        wait for delay; -- 50 ns

        -- c acknowledges
        -- This should result in all the signals toggling
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_ack_int = '1') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        a_req_int <= '0';
        wait for delay; -- 60 ns

        -- a takes request down to initate a new transfer
        -- this should therefore result in outputs switching
        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_ack_int = '1') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_req_int = '0') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        --########################################################
        -- Test that even with c being very slow to acknowledge
        -- and a starting a new transfer, that signals do not switch
        -- before c later transitions to 0
        --########################################################


        b_ack_int <= '0';
        a_req_int <= '1';
        wait for delay; -- 70 ns

        -- Only b has acknowledged, so no other signals should change
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_ack_int = '1') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_req_int = '0') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        c_ack_int <= '0';
        wait for delay; -- 80 ns

        -- c acknowledges
        -- This should result in all the signals toggling
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        --########################################################
        -- Test for glitch on a_req_int
        --########################################################

        a_req_int <= '0';
        wait for delay; -- 90 ns

        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        a_req_int <= '1';
        wait for delay; -- 100 ns

        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;



        wait;

  end process;

end rtl;