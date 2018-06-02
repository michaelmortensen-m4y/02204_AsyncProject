--------------------------------------------------------------------------------
-- Top module for 4-phase bundled-data join Altera DE2-115 test
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

component bundledPhase4_Join
    generic(DATAWIDTH: natural);
    port  (
        dataIn1 : in std_logic_vector(DATAWIDTH-1 downto 0);
        dataIn2 : in std_logic_vector(DATAWIDTH-1 downto 0);
        dataOut : out std_logic_vector(DATAWIDTH+DATAWIDTH-1 downto 0);
        inReq1  : in std_logic;
        inReq2  : in std_logic;
        outReq  : out std_logic;
        ackIn   : in std_logic;
        ackOut1 : out std_logic;
        ackOut2 : out std_logic
    );
end component;

begin   

    unit1: bundledPhase4_Join 
    generic map(DATAWIDTH => 4)
    port map (
        dataIn1 => SW(17 downto 14),
        dataIn2 => SW(13 downto 10),
        dataOut => LED_RED(17 downto 10),
        inReq1  => SW(0),
        inReq2  => SW(1),
        outReq  => LED_RED(0),
        ackIn   => SW(2),
        ackOut1 => LED_RED(1),
        ackOut2 => LED_RED(2)
    );

end arch;

