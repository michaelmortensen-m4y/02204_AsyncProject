--------------------------------------------------------------------------
--! @file test_ctrl.vhdl
--! @brief Testbench file for the click-element controller.
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_tb is
end test_tb;

architecture rtl of test_tb is

-- The design under test
component click_ctrl is
    port (
        a_req, b_ack  : in  std_logic;
        a_ack, b_req  : out  std_logic
    );
end component;

    -- Internal test signals
    signal a_req_int, b_ack_int : std_logic := '0';
    signal a_ack_int, b_req_int : std_logic;

    -- Delay used in combinational test
    constant delay : time := 10 ns;

begin 

dut: click_ctrl 
    port map (
        a_req => a_req_int,
        b_ack => b_ack_int,
        a_ack => a_ack_int,
        b_req => b_req_int
    );

    stim_proc: process
        begin

        wait for delay;

        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;

        --########################################################
        -- Test of single handshake
        --########################################################

        wait for delay;

        a_req_int <= '1';
        wait for delay;

        -- When a changes, we expect b to receive a request 
        -- and a to get an acknowledge
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;


        b_ack_int <= '1';
        wait for delay;

        -- Signal values should remain the same since completion of handshake 
        -- requires a to take request down, which means a new handshake
        -- only b_ack_int changes
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;


        a_req_int <= '0';
        wait for delay;

        -- Request going down signifies a new handshake
        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;


        b_ack_int <= '0';
        wait for delay;

        -- A new handshake is now possible since b has gone down
        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;


        --########################################################
        -- We now test that a handshake cannot complete unless b_ack is signaled
        --########################################################

        a_req_int <= '1';
        wait for delay;

        -- When a changes, we expect b to receive a request 
        -- and a to get an acknowledge
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;

        a_req_int <= '0';
        wait for delay;

        -- When a changes, we expect b to receive a request 
        -- and a to get an acknowledge
        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;

        -- Only when b acknowledges, does the handshake complete


        b_ack_int <= '1';
        wait for delay;

        -- Signal values should remain the same since completion of handshake 
        -- requires a to take request down, which means a new handshake
        -- only b_ack_int changes
        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;


            wait;
  end process;

end rtl;