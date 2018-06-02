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
        a_in, b_in  : in std_logic_vector(7 downto 0);
        start : in std_logic;
        clock : in std_logic;
        reset : in std_logic;
        done : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end GCDsynch;



architecture behavioural of GCDsynch is

type state_type is (idle, sub, completed); 
signal state_reg, state_next : state_type;
signal a_reg, a_next, b_reg, b_next: unsigned(7 downto 0);

signal done_reg, done_next : std_logic;

begin

-- state and data registers

    process(clock, reset)
	begin
        if reset = '1' then
            state_reg <= idle;
            a_reg <= (others => '0');
            b_reg <= (others => '0');
            done_reg <= '0';
        elsif rising_edge(clock) then
            state_reg <= state_next;
            done_reg <= done_next;
            a_reg <= a_next;
            b_reg <= b_next;
		end if;
    end process;

    -- Next-state logic and data path functional units/routing

    process(state_reg, a_reg, b_reg, start, a_in, b_in)
    begin
        a_next <= a_reg;
        b_next <= b_reg;
        done_next <= done_reg;

        case state_reg is
            when idle =>
                if start = '1' then
                    a_next <= unsigned(a_in);
                    b_next <= unsigned(b_in);
                    state_next <= sub;
                else
                    state_next <= idle;
                end if;
            when sub =>
                if (a_reg = b_reg) then
                    state_next <= completed;
                    done_next <= '1';
                else
                    if (a_reg < b_reg) then
                        a_next <= b_reg - a_reg;
                        b_next <= a_reg;
                    else
                        a_next <= a_reg - b_reg;
                        b_next <= b_reg;
                    end if;
                end if;
            when completed =>
                done_next <= '0'; -- We capture it since we are in timing mode,
                                  -- otherwise we have a problem with start going
                                  -- low a bit too fast, which better suited the
                                  -- async circuit
                if start = '0' then -- Wait for next request
                    state_next <= idle;
                else 
                    state_next <= completed;
                end if;
            end case;

        end process;
        -- output
        result <= std_logic_vector(a_reg);
        done <= done_reg;

end behavioural;