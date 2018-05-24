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
component click_fork is
    port (
        b_ack, c_ack, a_req  : in  std_logic;
        a_ack, b_req, c_req: out  std_logic
    );
end component;

    -- Internal test signals
    signal test_signals : std_logic_vector(5 downto 0) := (others => '0');
    -- We first list all request signals, then the ackknowledge signals
    alias a_req : std_logic is test_signals(5);
    alias b_req : std_logic is test_signals(4);
    alias c_req : std_logic is test_signals(3);
    alias a_ack : std_logic is test_signals(2);
    alias b_ack : std_logic is test_signals(1);
    alias c_ack : std_logic is test_signals(0);

    -- Delay used in combinational test
    constant delay : time := 10 ns;

begin 

dut: click_fork 
    port map (
        b_ack => b_ack,
        c_ack => c_ack,
        a_req => a_req,
        a_ack => a_ack,
        b_req => b_req,
        c_req => c_req
    );

    stim_proc: process
        begin

        wait for delay; -- 10 ns

        assert (test_signals = "000000") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        --########################################################
        -- Test of single handshake
        --########################################################

        wait for delay; -- 20 ns

        a_req <= '1';
        wait for delay; -- 30 ns

        -- a requests which sends request to b and c
        assert (test_signals = "111100") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        b_ack <= '1';
        wait for delay; -- 40 ns

        -- Only b has acknowledged, so no other signals should change
        assert (test_signals = "111110") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        c_ack <= '1';
        wait for delay; -- 50 ns

        -- c acknowledges
        assert (test_signals = "111111") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        a_req <= '0';
        wait for delay; -- 60 ns

        -- a takes request down to initate a new transfer
        -- this should therefore result in outputs switching
        assert (test_signals = "000011") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        --########################################################
        -- Test that even with c being very slow to acknowledge
        -- and starting a new transfer, that signals do not switch
        -- before c later transitions to 0
        --########################################################

        b_ack <= '0';
        a_req <= '1';
        wait for delay; -- 70 ns

        -- Only b has acknowledged, so no other signals should change
        assert (test_signals = "100001") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        c_ack <= '0';
        wait for delay; -- 80 ns

        -- c acknowledges
        -- This should result in all the signals toggling
        assert (test_signals = "111100") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        --########################################################
        -- Test for glitch on a_req
        --########################################################

        a_req <= '0';
        wait for delay; -- 90 ns

        assert (test_signals = "011100") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        a_req <= '1';
        wait for delay; -- 100 ns

        assert (test_signals = "111100") report "Result incorrect: test_signals = " & to_bstring(test_signals) severity error;

        wait;

  end process;

end rtl;