--------------------------------------------------------------------------------
--! @file tb_gcd.vhdl
--! @brief Testbench for the combinational GCD circuit
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.GCD_PACKAGE.all;


entity test_tb is
end test_tb;

architecture arch of test_tb is


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




component GCD is
    port (
        a_in , b_in: in std_logic_vector (DATA_WIDTH-1 downto 0);
        a_out, b_out: out std_logic_vector (DATA_WIDTH-1 downto 0);
        done : out  std_logic
    );
end component;

    signal a_in, b_in, a_out, b_out : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal done : std_logic := '0';

    -- Delay used in combinational test
    constant delay : time := 5 ns;

    type test_signal is array (0 to 1) of unsigned(7 downto 0);

    -- Test vectors
    signal xvec : test_signal := (resize(x"32", 8), -- Test input x
                                 resize(x"58", 8));

    signal yvec : test_signal := (resize(x"0A", 8), -- Test input y
                                 resize(x"0C", 8));

    signal svec : test_signal := (resize(x"0A", 8), -- True values
                                    resize(x"04", 8));

begin
    
    dut: GCD 
    port map (
        a_in => a_in,
        b_in => b_in,
        a_out => a_out,
        b_out => b_out,
        done => done
    );

    stim_proc: process
    begin

        wait for delay;

        --for i in 0 to 1 loop

        --    a_in <= std_logic_vector(xvec(i));
        --    b_in <= std_logic_vector(yvec(i));

        --    wait for delay;

        --    while (done = '0') loop
        --        a_in <= transport a_out after delay;
        --        b_in <= transport b_out after delay;

        --    end loop;

        --    assert (unsigned(a_out) = svec(i)) report "Result incorrect: a_out = " & to_bstring(a_out) severity error;

        --    wait for delay;

        --end loop;

        wait;

    end process;




end arch;
