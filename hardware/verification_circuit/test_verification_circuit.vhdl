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
component verification_circuit is
    port (
        clock, reset, start_test : in std_logic;

        -- GCD Circuit signals
        done : in std_logic;                                -- Done signal from GCD
        start_gcd : out std_logic;                          -- Start signal to GCD
        result_gcd  : in std_logic_vector(DATA_WIDTH-1 downto 0);    -- Output from GCD
        input1_gcd, input2_gcd: out std_logic_vector(DATA_WIDTH-1 downto 0);  -- Direct input to GCD

        -- Verification signals
        count : out std_logic_vector(DATA_WIDTH-1 downto 0);-- Count for test time
        correct : out std_logic                             -- 0 if any value was wrong.

    );
end component;


    -- Internal test signals
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';
    signal start_test : std_logic := '0';

    signal result_gcd : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal done : std_logic := '0';
    signal start_gcd: std_logic;

    signal input1_gcd,  input2_gcd : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal count : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal correct :  std_logic;

    -- Delay used in combinational test
    constant clock_period : time := 10 ns;


begin 

dut: verification_circuit 
    port map (
        reset => reset,
        clock => clock,
        start_test => start_test,
        done => done,
        start_gcd => start_gcd,
        result_gcd => result_gcd,
        input1_gcd => input1_gcd,
        input2_gcd => input2_gcd,
        count => count,
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

        assert (start_gcd = '0') report "Result incorrect: output = " & std_logic'image(start_gcd) severity error;
        assert (input1_gcd = X"05") report "Result incorrect: test_signals = " & to_bstring(input1_gcd) severity error;
        assert (input2_gcd = X"0C") report "Result incorrect: test_signals = " & to_bstring(input1_gcd) severity error;


        wait for clock_period;

        start_test <= '1';

        -- Simulate reading FIRST input and providing data

        wait for clock_period;

        start_test <= '0';

        for i in 0 to 3 loop
            wait for clock_period;
        end loop;

        done <= '1';

        -- Simulate reading SECOND input and providing data

        wait for clock_period;

        done <= '0';

        for i in 0 to 3 loop
            wait for clock_period;
        end loop;

        done <= '1';

        -- Simulate reading THIRD input and providing data


        wait for clock_period;


        done <= '0';

        for i in 0 to 3 loop
            wait for clock_period;
        end loop;

        done <= '1';

        -- Simulate reading FOURTH input and providing data


        wait for clock_period;

        done <= '0';

        wait;
  end process;

end rtl;