--------------------------------------------------------------------------------
-- Entity: top_2stageRing
-- Date:2018-05-28
--
-- Description: Top module for 3-stage ring with clock controllers having internal delays
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GCDsynch is
    port (
        operandAIn, operandBIn  : in std_logic_vector(7 downto 0);
        start : in std_logic;
        clock : in std_logic;
        reset : in std_logic;
        done : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end GCDsynch;



architecture behavioural of GCDsynch is

signal a, b, a_next, b_next, a_computed, b_computed : std_logic_vector(7 downto 0);
signal done_internal : std_logic;

begin

    process(clock, reset)
	begin
		if rising_edge(clock) then
			if reset = '1' then 
				a <= (others => '0');
				b <= (others => '0');
			else 
				a <= a_next;
				b <= b_next;
			end if;
		end if;
    end process;
			
    process(done_internal, start, operandAIn, operandBIn)
	begin
		if done_internal = '1' and start = '1' then
			a_next <= operandAIn;
			b_next <= operandBIn;
		else 
			a_next <= a_computed;
			b_next <= b_computed;
		end if;
    end process;


    process(a, b) is
    begin
      if a > b then
        a_computed <= std_logic_vector(unsigned(a(7 downto 0)) - unsigned(b(7 downto 0)));
        b_computed <= b;
        done_internal <='0';
      elsif a < b then
        b_computed <= std_logic_vector(unsigned(b(7 downto 0)) - unsigned(a(7 downto 0)));
        a_computed <= a;
        done_internal <='0';
      else
        a_computed <= a;
        b_computed <= b;
        if (unsigned(a(7 downto 0)) /= 0) and (unsigned(b(7 downto 0)) /= 0) then
          done_internal <= '1';
        else
          done_internal <= '0';
        end if;
      end if;
    end process;
	
	result <= a_computed;
        done <= done_internal;
	
end behavioural;