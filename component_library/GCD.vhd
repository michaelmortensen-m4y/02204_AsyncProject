--------------------------------------------------------------------------
--! @file top_ring.vhdl
--! @brief Test a single ring running
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GCD is
    port (
        start : in std_logic;
        a_in , b_in, a_new, b_new: in std_logic_vector (7 downto 0);
        a_out, b_out, result: out std_logic_vector (7 downto 0);
        done : out  std_logic
    );
end GCD;

architecture behavioural of GCD is



signal new_inputs : std_logic;
signal a, b : std_logic_vector(7 downto 0);


begin

    --here we control the start of the GCD iterations
    initiate_gcd : process(done, start) is
    begin
      if done = '1' and start = '1' then
        new_inputs <= '1'
      end if;
    end process initiate_gcd;

    input_values : process(new_inputs, a_in, b_in, a_new, b_new) is
    begin
      if new_inputs = '1' then
        a <= a_new;
        b <= b_new;
      else
        a <= a_in;
        b <= b_in;
      end if;
    end process input_values;


    check_finish : process(a, b) is
    begin
      if a = b then
        done <= '1'
      end if;
    end process check_finish;

    compute_values : process(done, a, b) is
    begin
      if done = '1' then
        a_out <= a;
        b_out <= b;
      else if a > b then
          a_out <= a - b;
          b_out <= b;
      else
          b_out <= b - a;
          a_out <= a;
      end if;
    end process compute_values;

    result <= a;


end behavioural;
