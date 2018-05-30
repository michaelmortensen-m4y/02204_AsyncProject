--------------------------------------------------------------------------
--! @file verification_circuit.vhdl
--! @brief Circuit used to verify the design on the FPGA
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.GCD_PACKAGE.all;

entity verification_circuit is
    port (
        start_test, clock, reset : in std_logic;

        -- GCD Circuit
        C_from_gcd  : in std_logic_vector(DATA_WIDTH-1 downto 0);    -- Output from GCD
        done : in std_logic;                                -- Done signal from GCD
        start_gcd : out std_logic;                          -- Start signal to GCD
        A_to_gcd, B_to_gcd: out std_logic_vector(DATA_WIDTH-1 downto 0);  -- Direct input to GCD

        count : out std_logic_vector(DATA_WIDTH-1 downto 0);-- Count for test time
        correct : out std_logic                             -- 0 if any value was wrong.

    );
end verification_circuit;

architecture behavioural of verification_circuit is


-- ROMs containing the test vectors
component rams_21a is
    port (
        clock : in std_logic;
        en: in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component;


component rams_21b is
    port (
        clock : in std_logic;
        en: in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component;


component rams_21c is
    port (
        clock : in std_logic;
        en: in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component;


-- signal declarations
type state_type is (idle, load, send_data, timing, verify);
signal state_reg, state_next: state_type;

signal count_int : std_logic_vector(DATA_WIDTH-1 downto 0); -- Counts number of clock cycles
signal test_addr : std_logic_vector(ADDR_WIDTH-1 downto 0); -- Current test vector

signal count_int_next : std_logic_vector(DATA_WIDTH-1 downto 0);
signal test_addr_next : std_logic_vector(ADDR_WIDTH-1 downto 0);

signal C_verification : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

--  Map Components

    romA : rams_21a 
    port map (
        clock => clock,
        en => '1',
        addr => test_addr,
        data => A_to_gcd
    );
    

    romB : rams_21b 
    port map (
        clock => clock,
        en => '1',
        addr => test_addr,
        data => B_to_gcd
    );
    

    romC : rams_21c 
    port map (
        clock => clock,
        en => '1',
        addr => test_addr,
        data => C_verification
    );
    

-- State and data registers
    process(clock, reset) is
    begin
        if reset = '1' then
            state_reg <= idle;
            count_int <= (others => '0');
            test_addr <= (others => '0');
        elsif(rising_edge(clock)) then 
            state_reg <= state_next;
            test_addr <= test_addr_next;
            -- If it just accumulates in the same state, this is better
            if (state_reg = timing) then
                count_int <= std_logic_vector(unsigned(count_int) + "1");
            else
                count_int <= count_int;
            end if;
        end if;
    end process;

-- Combinational circuit
    process(start_test, done, state_reg) is
    begin

        -- default values
        start_gcd <= '0';
        correct <= '1';


        count_int_next <= count_int;
        test_addr_next <= test_addr;

        case state_reg is

            when idle =>        -- Reset count

                count_int_next <= (others => '0');
                test_addr_next <= (others => '0');

                if (start_test = '1') then
                    state_next <= load;
                else
                    state_next <= idle;
                end if;

            when load =>        -- Load the input data (takes 1 clock cycle)

                state_next <= send_data;

            when send_data =>   -- Input data is now ready, start test

                start_gcd <= '1';
                state_next <= timing;

            when timing =>       -- Count number of clock cycles before test completion

                if(done = '0') then
                    state_next <= timing;
                else
                    state_next <= verify;
                end if;

            when verify =>      -- Verify correct output

                test_addr_next <= std_logic_vector(unsigned(test_addr) + "1");

                if (C_from_gcd /= C_verification) then
                    correct <= '1'; -- Error
                end if;

                if (unsigned(test_addr) < MAX_TESTS) then
                    state_next <= load;
                else
                    state_next <= idle; -- Test is complete
                end if;
            end case;
        
    end process;

    count <= count_int;

end behavioural;