--------------------------------------------------------------------------------
-- 4-phase bundled-data fork component
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bundledPhase4_Fork is
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
end bundledPhase4_Fork;

architecture arch of bundledPhase4_Fork is

component cElement
    port (
        in1, in2 : in std_logic;
        c        : out std_logic
    );
end component;

    signal reqSig : std_logic;
    signal dataInSig : std_logic_vector(DATAWIDTH-1 downto 0);

begin

    cElement1: cElement port map(
        in1 => ackIn1,
        in2 => ackIn2,
        c   => ackOut    
    );
    
    reqSig <= inReq;
    out1Req <= reqSig;
    out2Req <= reqSig;
    
    dataInSig <= dataIn;
    dataOut1 <= dataInSig;
    dataOut2 <= dataInSig;
   
end arch;

