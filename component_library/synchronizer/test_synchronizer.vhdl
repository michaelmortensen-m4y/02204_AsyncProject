--------------------------------------------------------------------------
--! @file test_synchronizer.vhdl
--! @brief Testbench file for the synchronizer when sending req/ack over
--! a clock-domain crossing or going from async to sync.
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_tb is
end test_tb;

architecture rtl of test_tb is

-- The design under test
component synchronizer is
    port (
        clock, reset, input  : in  std_logic;
        output  : out  std_logic
    );
end component;

    -- Internal test signals
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';
    signal input : std_logic := '0';
    signal output : std_logic;

    -- Delay used in combinational test
    constant clock_period : time := 10 ns;

begin 

dut: synchronizer 
    port map (
        clock => clock,
        reset => reset,
        input => input,
        output => output
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
        wait for clock_period;

        -- Verify initial values
        wait for clock_period;
        assert (output = '0') report "Result incorrect: output = " & std_logic'image(output) severity error;

        wait for clock_period;

        input <= '1';

        wait for clock_period;

        assert (output = '0') report "Result incorrect: output = " & std_logic'image(output) severity error;

        wait for clock_period;

        assert (output = '1') report "Result incorrect: output = " & std_logic'image(output) severity error;

        wait for clock_period;

        assert (output = '1') report "Result incorrect: output = " & std_logic'image(output) severity error;


        wait for clock_period;

        wait for clock_period;

        wait;
  end process;

end rtl;