--------------------------------------------------------------------------
--! @file test_ctrl.vhdl
--! @brief Testbench file for the click-element controller.
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.GCD_PACKAGE.all;


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
component top_level_verification_circuit is
    port (
        clock, reset, start_button : in std_logic;
        correct : out std_logic -- just used for testing
    );
end component;


    -- Internal test signals
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';
    signal start_button : std_logic := '0';
    signal correct : std_logic := '0';

    -- Delay used in combinational test
    constant clock_period : time := 10 ns;


begin 

dut: top_level_verification_circuit 
    port map (
        reset => reset,
        clock => clock,
        start_button => start_button,
        correct => correct
    );


    -- Clock process definitions
    clock_process :process
    begin
    clock <= '0';
        wait for clock_period/2;
    clock <= '1';
        wait for clock_period/2;
    end process;


    stim_proc: process
        begin

        -- hold reset state ns.
        wait for clock_period;
        reset <= '1';
        wait for clock_period;
        reset <= '0';

        -- Verify initial values
        wait for clock_period;

        start_button <= '1';

        wait;
  end process;

end rtl;