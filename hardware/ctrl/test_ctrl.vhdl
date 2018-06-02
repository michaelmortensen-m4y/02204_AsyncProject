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

-- Taken from
-- https://stackoverflow.com/questions/24329155/is-there-a-way-to-print-the-values-of-a-signal-to-a-file-from-a-modelsim-simulat
function to_bstring(sl : std_logic) return string is
    variable sl_str_v : string(1 to 3);  -- std_logic image with quotes around
begin
    sl_str_v := std_logic'image(sl);
    return "" & sl_str_v(2);  -- "" & character to get string
end function;

function to_bstring(slv : std_logic_vector) return string is
    alias    slv_norm : std_logic_vector(1 to slv'length) is slv;
    variable sl_str_v : string(1 to 1);  -- String of std_logic
    variable res_v    : string(1 to slv'length);
begin
    for idx in slv_norm'range loop
        sl_str_v := to_bstring(slv_norm(idx));
        res_v(idx) := sl_str_v(1);
    end loop;
    return res_v;
end function;



-- The design under test
component click_ctrl is
    port (
        a_req, b_ack  : in  std_logic;
        a_ack, b_req  : out  std_logic
    );
end component;

    -- Internal test signals
    signal test_signals : std_logic_vector(3 downto 0) := (others => '0');
    -- We first list all request signals, then the ackknowledge signals
    alias a_req : std_logic is test_signals(3);
    alias b_req : std_logic is test_signals(2);
    alias a_ack : std_logic is test_signals(1);
    alias b_ack : std_logic is test_signals(0);

    -- Delay used in combinational test
    constant delay : time := 10 ns;

begin 

dut: click_ctrl 
    port map (
        a_req => a_req,
        b_ack => b_ack,
        a_ack => a_ack,
        b_req => b_req
    );

    stim_proc: process
        begin

        -- Verify initial values
        wait for delay;
        assert (test_signals = "0000") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        --########################################################
        -- Test of single handshake
        --########################################################

        wait for delay;
        a_req <= '1';

        wait for delay;

        -- a_req+ --> b_req+ 
        -- a_req+ --> a_ack+
        assert (test_signals = "1110") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        b_ack <= '1';
        wait for delay;

        -- All signal values should remain the same as completion of handshake
        -- requires a to take down request.
        assert (test_signals = "1111") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        a_req <= '0';
        wait for delay;

        -- Request going down signifies a new handshake
        -- a_req- --> b_req- 
        -- a_req- --> a_ack-
        assert (test_signals = "0001") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        b_ack <= '0';
        wait for delay;

        assert (test_signals = "0000") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        --########################################################
        -- We now test that a handshake cannot complete unless b_ack is signaled
        --########################################################

        a_req <= '1';
        wait for delay;

        -- a_req+ --> b_req+ 
        -- a_req+ --> a_ack+
        assert (test_signals = "1110") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        -- a takes down request early, but we have still not received b_ack
        a_req <= '0';
        wait for delay;

        assert (test_signals = "0110") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        b_ack <= '1';
        wait for delay;

        -- b_ack+ --> b_req-
        -- b_ack+ --> a_ack-
        assert (test_signals = "0001") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        wait;
  end process;

end rtl;