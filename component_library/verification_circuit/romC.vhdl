--
-- ROMs Using Block RAM Resources.
-- VHDL code for a ROM with registered output 
-- See UG627 (v 11.3)
-- Modified from source
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.GCD_PACKAGE.all;

entity rams_21c is
    port (
        clock : in std_logic;
        en: in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end rams_21c;

architecture syn of rams_21c is

    type rom_type is array (MAX_TESTS-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
    signal ROM : rom_type:= (X"0A", X"04", X"01" ,X"01");

begin
    process (clock)
    begin
        if rising_edge(clock) then
            if (en = '1') then
                data <= ROM(conv_integer(addr));
            end if;
        end if;
    end process;
end syn;