--------------------------------------------------------------------------------
-- Top module for the 4-phase bundled-data fork Altera DE2-115 test
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

component bundledPhase4_Fork
    generic(DATAWIDTH: natural);
    port  (
        dataIn : in std_logic_vector(DATAWIDTH-1 downto 0);
        dataOut1 : out std_logic_vector(DATAWIDTH-1 downto 0);
        dataOut2 : out std_logic_vector(DATAWIDTH-1 downto 0);
        inReq    : in std_logic;
        out1Req  : out std_logic;
        out2Req  : out std_logic;
        ackIn1   : in std_logic;
        ackIn2   : in std_logic;
        ackOut   : out std_logic
    );
end component;

begin   

    unit1: bundledPhase4_Fork 
    generic map(DATAWIDTH => 4)
    port map(
        dataIn   => SW(17 downto 14),
        dataOut1 => LED_RED(13 downto 10),
        dataOut2 => LED_RED(9 downto 6),
        inReq    => SW(0),
        out1Req  => LED_RED(0),
        out2Req  => LED_RED(1),
        ackIn1   => SW(1),
        ackIn2   => SW(2),
        ackOut   => LED_RED(3) 
    );

end arch;

