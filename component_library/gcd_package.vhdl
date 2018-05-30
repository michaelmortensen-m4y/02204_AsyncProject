-------------------------------------------------------------------------
-- Package to simplify interfacing to BRAM and specify generics for all 
-- circuits
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real."ceil";
use ieee.math_real."log2";

package GCD_PACKAGE is

    constant MAX_TESTS : natural := 100; 
    constant DATA_WIDTH : natural := 8; 
    constant ADDR_WIDTH : natural := integer(ceil(log2(real(MAX_TESTS))) + 1);

    -- Record definitions
    type mem_master is record
        wr   : std_logic;
        addr : std_logic_vector(ADDR_WIDTH - 1 downto 0);
        din  : std_logic_vector(DATA_WIDTH - 1 downto 0);
    end record;    

    type mem_slave is record
        dout : std_logic_vector(DATA_WIDTH - 1 downto 0);
    end record;       

end GCD_PACKAGE;