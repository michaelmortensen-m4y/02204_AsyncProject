--------------------------------------------------------------------------------
-- Top module for C-element Altera DE2-115 test
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top is
    port  (
        SW        : in std_logic_vector(17 downto 0);
        LED_RED   : out std_logic_vector(17 downto 0)
    );
end top;

architecture arch of top is

component cElement
    port (
        in1, in2 : in std_logic;
        c        : out std_logic
    );
end component;

begin   

    unit1: cElement port map(
        in1 => SW(0),
        in2 => SW(1),
        c   => LED_RED(0)    
    );

end arch;

