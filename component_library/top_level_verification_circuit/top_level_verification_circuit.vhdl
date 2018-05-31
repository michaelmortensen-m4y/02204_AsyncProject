--------------------------------------------------------------------------
--! @file top_level_verification_circuit.vhdl
--! @brief Top-level circuit used to verify the design on the FPGA
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.GCD_PACKAGE.all;

entity top_level_verification_circuit is
    port (
        clock, reset, start_button : in std_logic
    );
end top_level_verification_circuit;

architecture behavioural of top_level_verification_circuit is

-- Components

component verification_circuit is
    port (
        clock, reset, start_test : in std_logic;

        -- GCD Circuit signals
        done : in std_logic;                                -- Done signal from GCD
        start_gcd : out std_logic;                          -- Start signal to GCD
        result_gcd  : in std_logic_vector(DATA_WIDTH-1 downto 0);    -- Output from GCD
        input1_gcd, input2_gcd: out std_logic_vector(DATA_WIDTH-1 downto 0);  -- Direct input to GCD

        -- Verification signals
        count : out std_logic_vector(DATA_WIDTH - 1 downto 0);-- Count for test time
        correct : out std_logic                             -- 0 if any value was wrong.

    );
end component;


component top_3stageRing is
    port (
        operandAIn, operandBIn  : in std_logic_vector(7 downto 0);
        start : in std_logic;
        done : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end component;

component synchronizer is
    port (
        clock, reset, input  : in  std_logic;
        output  : out  std_logic
    );
end component;

component button_synchronizer is
    port (
        clock, reset, button  : in  std_logic;
        output  : out  std_logic
    );
end component;


signal start_gcd, done_gcd, done_gcd_synchronized, done_gcd_verification, start_button_synchronized, correct : std_logic;
signal result_gcd, input1_gcd, input2_gcd, count : std_logic_vector(DATA_WIDTH-1 downto 0);

signal first_done, first_done_next : std_logic;

begin

--  Map Components

    verification_circuit1 : verification_circuit 
    port map (
        clock => clock,
        reset => reset,
        start_test => start_button_synchronized,
        done => done_gcd_verification,
        start_gcd => start_gcd,
        result_gcd => result_gcd,
        input1_gcd => input1_gcd,
        input2_gcd => input2_gcd,
        count => count,
        correct => correct
    );

    top_3stageRing1 : top_3stageRing 
    port map (
        operandAIn => input1_gcd,
        operandBIn => input2_gcd,
        start => start_gcd,
        done => done_gcd,
        result => result_gcd
    );


    synchronizer1 : synchronizer 
    port map (
        clock => clock,
        reset => reset,
        input => done_gcd,
        output => done_gcd_synchronized
    );


    button_synchronizer1 : button_synchronizer
        port map (
            clock => clock,
            reset => reset,
            button => start_button,
            output => start_button_synchronized
        );

-- State and data registers
    process(clock, reset) is
    begin
        if reset = '1' then
            first_done <= '0';
        elsif(rising_edge(clock)) then 
            first_done <= first_done_next;
        end if;
    end process;

-- Combinational circuit
    process(done_gcd_synchronized, first_done) is
    begin

        done_gcd_verification <= '0';
        first_done_next <= first_done;

        if rising_edge(done_gcd_synchronized) and first_done = '0' then
            first_done_next <= '1';
        elsif rising_edge(done_gcd_synchronized) and first_done = '1' then
            done_gcd_verification <= '1';
        end if;
    end process;



end behavioural;