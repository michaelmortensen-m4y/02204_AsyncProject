--------------------------------------------------------------------------------
-- Entity: GCD
-- Date:2018-05-28  
-- Author: Michael Mortensen     
--
-- Description: GCD component to be placed in a 2-stage ring
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity GCD is
	port (
        start : in std_logic;
        operandAIn : in std_logic_vector(7 downto 0);
        operandBIn : in std_logic_vector(7 downto 0);
        stage1_dataAin : in std_logic_vector(7 downto 0);
        stage1_dataBin : in std_logic_vector(7 downto 0);
        stage1_dataAout : out std_logic_vector(7 downto 0);
        stage1_dataBout : out std_logic_vector(7 downto 0);
        done : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end GCD;

architecture arch of GCD is

signal dataAin : std_logic_vector(7 downto 0);
signal dataBin : std_logic_vector(7 downto 0);

begin

    process(start)
    begin
        if start = '1' then
            dataAin <= operandAIn;
            dataBin <= operandBIn;
        else
            dataAin <= stage1_dataAin;
            dataBin <= stage1_dataBin;
        end if;
    end process;
    
    stage1_dataAout <= dataAin;
    stage1_dataBout <= dataBin;
    result <= dataAin;
    done <= '1';

end arch;

