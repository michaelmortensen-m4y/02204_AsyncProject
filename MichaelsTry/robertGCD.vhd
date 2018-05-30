--------------------------------------------------------------------------
--! @file top_ring.vhdl
--! @brief Test a single ring running
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GCD is
    port (
        a_in , b_in: in std_logic_vector (7 downto 0);
        a_out, b_out: out std_logic_vector (7 downto 0);
        done : out  std_logic
    );
end GCD;

architecture behavioural of GCD is



begin
    --here we control the start of the GCD iterations by taking inputs
    process(a_in, b_in) is
    begin
      if a_in > b_in then
        a_out <= std_logic_vector(unsigned(a_in(7 downto 0)) - unsigned(b_in(7 downto 0)));
        b_out <= b_in;
        done <='0';
      elsif a_in < b_in then
        b_out <= std_logic_vector(unsigned(b_in(7 downto 0)) - unsigned(a_in(7 downto 0)));
        a_out <= a_in;
        done <='0';
      else
        a_out <= a_in;
        b_out <= b_in;
        done <= '1';
      end if;
    end process;


end behavioural;
