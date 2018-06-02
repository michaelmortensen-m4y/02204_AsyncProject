--------------------------------------------------------------------------------
-- Entity: tb_2stageRing
-- Date:2018-05-28  
-- Author: Michael Mortensen     
--
-- Description: Testbench for 2-stage ring
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_3stageRing is
end tb_3stageRing;

architecture arch of tb_3stageRing is

component top_3stageRing is
    port (
        operandAIn, operandBIn  : in std_logic_vector(7 downto 0);
        --reset : in std_logic;
        start : in std_logic;
        done : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end component;

signal test_operandAIn, test_operandBIn : std_logic_vector(7 downto 0) := (others => '0');
--signal test_reset : std_logic := '1';
signal test_start : std_logic := '0';
signal test_done : std_logic;
signal test_result : std_logic_vector(7 downto 0);

begin
    
    dut: top_3stageRing 
    port map (
        operandAIn => test_operandAIn,
        operandBIn => test_operandBIn,
        --reset => test_reset,
        start => test_start,
        done => test_done,
        result => test_result
    );

end arch;
