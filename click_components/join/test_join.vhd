--------------------------------------------------------------------------
--! @file join.vhdl
--! @brief Testbench file for the click join.
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_tb is
end test_tb;

architecture rtl of test_tb is

-- The design under test
component click_join is
    port (
        a_req, b_req, c_ack  : in  std_logic;
        a_ack, b_ack, c_req  : out  std_logic
    );
end component;


    -- Internal test signals
    signal a_req_int, b_req_int, c_ack_int : std_logic := '0';
    signal a_ack_int, b_ack_int, c_req_int : std_logic;

    -- Delay used in combinational test
    constant delay : time := 10 ns;

begin 

dut: click_join 
    port map (
        a_req => a_req_int,
        b_req => b_req_int,
        c_ack => c_ack_int,
        a_ack => a_ack_int,
        b_ack => b_ack_int,
        c_req => c_req_int
    );

    stim_proc: process
        begin

        wait for delay;

        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_req_int = '0') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        --########################################################
        -- Test of single handshake
        --########################################################

        wait for delay;

        a_req_int <= '1';
        wait for delay;

        -- First request 
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_req_int = '0') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        b_req_int <= '1';
        wait for delay;

        -- Second request arrives
        -- With 2 requests, we can now send the request to c, this also means that
        -- we acknowledge on a and b
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        c_ack_int <= '1';
        wait for delay;

        -- c acknowledges
        -- This should not change any of the other signal values, since the next handshake completes
        -- with both a and b request going low
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_ack_int = '1') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;



        a_req_int <= '0';
        wait for delay;

        -- First request 
        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_ack_int = '1') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        b_req_int <= '0';
        wait for delay;

        -- Second request arrives
        -- With 2 requests, we can now send the request to c, this also means that
        -- we acknowledge on a and b
        assert (a_req_int = '0') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_ack_int = '1') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_req_int = '0') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        --########################################################
        -- We now test that c request does not go high before c has acknowledged again
        --########################################################


        a_req_int <= '1';
        wait for delay;

        -- First request 
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_req_int = '0') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_ack_int = '1') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_req_int = '0') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;


        b_req_int <= '1';
        wait for delay;

        -- Second request arrives
        -- With 2 requests, we can now send the request to c, this also means that
        -- we acknowledge on a and b
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_ack_int = '1') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '0') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_ack_int = '0') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_req_int = '0') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;



        c_ack_int <= '0';
        wait for delay;

        -- C acknowledges next transition
        assert (a_req_int = '1') report "Result incorrect: a_req_int = " & std_logic'image(a_req_int) severity error;
        assert (b_req_int = '1') report "Result incorrect: b_req_int = " & std_logic'image(b_req_int) severity error;
        assert (c_ack_int = '0') report "Result incorrect: c_ack_int = " & std_logic'image(c_ack_int) severity error;

        assert (a_ack_int = '1') report "Result incorrect: a_ack_int = " & std_logic'image(a_ack_int) severity error;
        assert (b_ack_int = '1') report "Result incorrect: b_ack_int = " & std_logic'image(b_ack_int) severity error;
        assert (c_req_int = '1') report "Result incorrect: c_req_int = " & std_logic'image(c_req_int) severity error;





            wait;
  end process;

end rtl;