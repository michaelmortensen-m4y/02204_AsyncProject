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

    constant MAX_TESTS : natural := 64; 
    constant DATA_WIDTH : natural := 20; 
    constant ADDR_WIDTH : natural := integer(ceil(log2(real(MAX_TESTS)))) + 1;

end GCD_PACKAGE;