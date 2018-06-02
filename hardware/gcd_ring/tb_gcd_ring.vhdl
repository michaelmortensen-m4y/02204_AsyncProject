----------------------------------------------------------------------------
--! @file tb_gcd_ring.vhdl
--! @brief Testbench for 3-stage ring
----------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.GCD_PACKAGE.all;

entity tb_gcd_ring is
end tb_gcd_ring;

architecture arch of tb_gcd_ring is


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



    component gcd_ring is
        port (
            operandAIn, operandBIn  : in std_logic_vector(DATA_WIDTH-1 downto 0);
            start : in std_logic;
            done : out std_logic;
            result : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    signal test_operandAIn, test_operandBIn : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal test_start : std_logic := '0';
    signal test_done : std_logic;
    signal test_result : std_logic_vector(DATA_WIDTH-1 downto 0);


    -- Delay used in combinational test
    constant delay : time := 5 ns;

    type test_signal is array (0 to 1) of unsigned(DATA_WIDTH-1 downto 0);

    -- Test vectors
    signal xvec : test_signal := (resize(x"32", 8), -- Test input x
                                 resize(x"58", 8));

    signal yvec : test_signal := (resize(x"0A", 8), -- Test input y
                                 resize(x"0C", 8));

    signal svec : test_signal := (resize(x"0A", 8), -- True values
                                    resize(x"04", 8));

begin
    
    dut: gcd_ring 
    port map (
        operandAIn => test_operandAIn,
        operandBIn => test_operandBIn,
        start => test_start,
        done => test_done,
        result => test_result
    );

    stim_proc: process
    begin

        wait for delay;

        for i in 0 to 1 loop

            test_operandAIn <= std_logic_vector(xvec(i));
            test_operandBIn <= std_logic_vector(yvec(i));

            wait for delay;

            test_start <= '1';

            while (test_done = '0') loop
                wait for delay;
            end loop;

            assert (unsigned(test_result) = svec(i)) report "Result incorrect: test_result = " & to_bstring(test_result) severity error;

            wait for delay;

            test_start <= '0';

        end loop;

        wait;

    end process;




end arch;
