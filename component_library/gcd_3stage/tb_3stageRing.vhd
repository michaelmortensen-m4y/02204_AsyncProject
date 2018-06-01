--------------------------------------------------------------------------------
-- Entity: tb_2stageRing
-- Date:2018-05-28  
-- Author: Michael Mortensen     
--
-- Description: Testbench for 2-stage ring
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_3stageRing is
end tb_3stageRing;

architecture arch of tb_3stageRing is

    component top_3stageRing is
        port (
            operandAIn, operandBIn  : in std_logic_vector(7 downto 0);
            start : in std_logic;
            done : out std_logic;
            result : out std_logic_vector(7 downto 0)
        );
    end component;

    signal test_operandAIn, test_operandBIn : std_logic_vector(7 downto 0) := (others => '0');
    signal test_start : std_logic := '0';
    signal test_done : std_logic;
    signal test_result : std_logic_vector(7 downto 0);


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
    
    dut: top_3stageRing 
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

        test_operandAIn <= std_logic_vector(xvec(0));
        test_operandBIn <= std_logic_vector(yvec(0));

        wait for delay;

        test_start <= '1';

        wait for delay;

    end process;




end arch;
