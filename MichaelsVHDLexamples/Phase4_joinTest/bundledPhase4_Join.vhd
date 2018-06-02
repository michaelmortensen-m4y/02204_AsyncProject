--------------------------------------------------------------------------------
-- 4-phase bundled-data join component
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bundledPhase4_Join is
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
end bundledPhase4_Join;

architecture arch of bundledPhase4_Join is

component cElement
    port (
        in1, in2 : in std_logic;
        c        : out std_logic
    );
end component;

    signal ackSig : std_logic;
    signal dataOutSig : std_logic_vector(DATAWIDTH+DATAWIDTH-1 downto 0);

begin

    cElement1: cElement port map(
        in1 => inReq1,
        in2 => inReq2,
        c   => outReq    
    );
    
    ackSig <= ackIn;
    ackOut1 <= ackSig;
    ackOut2 <= ackSig;
    
    dataOutSig <= dataIn2 & dataIn1;
    dataOut <= dataOutSig;
   
end arch;

