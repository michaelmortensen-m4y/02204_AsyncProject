--------------------------------------------------------------------------------
-- Muller C-element
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cElement is
	port  (
		in1, in2 : in std_logic;
        c        : out std_logic
	);
end cElement;

architecture rtl of cElement is

begin
process (in1, in2)  is
    variable state : std_logic;
    variable in_cat : std_logic_vector (1 downto 0);
  begin
    in_cat := (in2, in1);
    case (in_cat) is
      when "00" =>  state := '0';
      when "01" =>  state := state;
      when "10" =>  state := state;
      when "11" =>  state := '1';
      when others => null;
    end case;
    c <= state;
end process;

end rtl;

