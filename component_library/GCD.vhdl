--------------------------------------------------------------------------
--! @file GCD.vhdl
--! @simple implemenation of greatest common divisor algorithm 
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



signal new_inputs, doneinside : std_logic;
signal a, b : std_logic_vector(7 downto 0);


begin

    --here we control the start of the GCD iterations by taking inputs
    initiate_gcd : process(doneinside,start) is
    begin
      if doneinside = '1' and start = '1' then
        new_inputs <= '1' ;
      end if;
    end process initiate_gcd;

    --multiplexor to determine whether new inputs or inputs from loop
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

    --check if finished, to set done signal
    check_finish : process(a, b) is
    begin
      if a = b then
        doneinside <= '1';
      end if;
    end process check_finish;

    --simple gcd computation
    compute_values : process(doneinside, a, b) is
    begin
      if doneinside = '1' then
        a_out <= a;
        b_out <= b;
      elsif a > b then
	a_out <= std_logic_vector(unsigned(a(7 downto 0)) - unsigned(b(7 downto 0)));
        b_out <= b;
      else
          b_out <= std_logic_vector(unsigned(b(7 downto 0)) - unsigned(a(7 downto 0)));
          a_out <= a;
      end if;
    end process;

    done <= doneinside;
    result <= a;


end behavioural;
