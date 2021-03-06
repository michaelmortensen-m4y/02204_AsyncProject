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
component top_ring is
    port (
        init, clock, reset : in std_logic;
        output : out  std_logic
    );
end component;

    signal clock : std_logic := '0';
    signal reset : std_logic := '0';
    signal button : std_logic := '0';
    signal output : std_logic;

    -- Delay used in combinational test
    constant clock_period : time := 10 ns;

begin 

dut: top_ring 
    port map (
        init => button,
        clock => clock,
        reset => reset,
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

        button <= '1';

        wait for clock_period;

        wait for clock_period;

        wait for clock_period;

        wait for clock_period;


        wait for clock_period;
        
        wait for clock_period;

        wait;
  end process;

end rtl;