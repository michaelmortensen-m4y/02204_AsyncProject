--------------------------------------------------------------------------
--! @file gcd.vhdl
--! @brief The combinational circuit for GCD adapted for an asynchronous
--! circuit
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.GCD_PACKAGE.all;

entity GCD is
    port (
        a_in , b_in: in std_logic_vector (DATA_WIDTH-1 downto 0);
        a_out, b_out: out std_logic_vector (DATA_WIDTH-1 downto 0);
        done : out  std_logic
    );
end GCD;

architecture behavioural of GCD is

begin
    --here we control the start of the GCD iterations by taking inputs
    process(a_in, b_in) is
    begin
      if a_in > b_in then
        a_out <= std_logic_vector(unsigned(a_in) - unsigned(b_in));
        b_out <= b_in;
        done <='0';
      elsif a_in < b_in then
        b_out <= std_logic_vector(unsigned(b_in) - unsigned(a_in));
        a_out <= a_in;
        done <='0';
      else
        a_out <= a_in;
        b_out <= b_in;

        -- First conditional check ensures that when we reset the circuit,
        -- that done is not accidentally put high
        if (unsigned(a_in) /= 0) and (unsigned(b_in) /= 0) then
          done <= '1';
        else
          done <= '0';
        end if;
      end if;
    end process;


end behavioural;