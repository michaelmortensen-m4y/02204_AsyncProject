----------------------------------------------------------------------------
--! @file gcd_ring.vhdl
--! @brief Top module for 3-stage ring with clock controllers 
--! having internal delays
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.GCD_PACKAGE.all;

entity gcd_ring is
    port (
        operandAIn, operandBIn  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        start : in std_logic;
        done : out std_logic;
        result : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end gcd_ring;

architecture behavioural of gcd_ring is

    component click_ctrl_delay is
        generic(
            a_req_delay : natural := 10;
            b_ack_delay : natural := 10;
            initialOutput : std_logic := '0'
        );
        port (
            a_req, b_ack, enable : in  std_logic;
            a_ack, b_req, ff_clock : out  std_logic
        );
    end component;

    component GCD is
        port (
            a_in , b_in: in std_logic_vector (DATA_WIDTH-1 downto 0);
            a_out, b_out: out std_logic_vector (DATA_WIDTH-1 downto 0);
            done : out  std_logic
        );
    end component;

    signal stage1_ack, stage2_ack, stage3_ack : std_logic := '0';
    signal stage1_req, stage2_req, stage3_req : std_logic := '0';

    signal ffClk1, ffClk2, ffClk3 : std_logic;

    signal stage1_dataAin, stage1_dataBin, stage1_dataAout, stage1_dataBout : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal stage2_dataAin, stage2_dataBin, stage2_dataAout, stage2_dataBout : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal stage3_dataA, stage3_dataB : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal stage1_done, stage2_doneOut, stage3_done : std_logic := '0';
    --signal stage1_done, stage2_doneIn, stage2_doneOut, stage3_done : std_logic := '0';


    signal enable_ring : std_logic;


    attribute DONT_TOUCH : string;
    attribute MARK_DEBUG : string;


    --attribute DONT_TOUCH of stage1_ack : signal is "true";
    --attribute DONT_TOUCH of stage2_ack : signal is "true";
    --attribute DONT_TOUCH of stage3_ack : signal is "true";
    --attribute DONT_TOUCH of stage1_req : signal is "true";
    --attribute DONT_TOUCH of stage2_req : signal is "true";
    --attribute DONT_TOUCH of stage3_req : signal is "true";


    --attribute DONT_TOUCH of ffClk1 : signal is "true";
    --attribute DONT_TOUCH of ffClk2 : signal is "true";
    --attribute DONT_TOUCH of ffClk3 : signal is "true";

    --attribute DONT_TOUCH of stage1_done : signal is "true";
    --attribute DONT_TOUCH of stage2_doneOut : signal is "true";
    --attribute DONT_TOUCH of stage3_done : signal is "true";



    --attribute MARK_DEBUG of stage1_dataAin : signal is "true";
    --attribute DONT_TOUCH of stage1_dataBin : signal is "true";
    --attribute DONT_TOUCH of stage1_dataAout : signal is "true";
    --attribute DONT_TOUCH of stage1_dataBout : signal is "true";

    --attribute DONT_TOUCH of stage2_dataAin : signal is "true";
    --attribute DONT_TOUCH of stage2_dataBin : signal is "true";
    --attribute DONT_TOUCH of stage2_dataAout : signal is "true";
    --attribute DONT_TOUCH of stage2_dataBout : signal is "true";


    --attribute DONT_TOUCH of stage3_dataA : signal is "true";
    --attribute DONT_TOUCH of stage3_dataB : signal is "true";

    --attribute MARK_DEBUG of enable_ring : signal is "true";


begin

    process (start, ffClk1, ffClk2, ffClk3, stage2_dataAout, stage2_dataBout, stage3_dataA, stage3_dataB, stage1_dataAout, stage1_dataBout, operandAIn, operandBIn, enable_ring)
    begin
       if (start = '0') then
            stage1_dataAin <= operandAIn;
            stage1_dataBin <= operandBIn;
            stage2_dataAin <= (others => '0');
            stage2_dataBin <= (others => '0');
            stage3_dataA <= (others => '0');
            stage3_dataB <= (others => '0');
            stage1_done <= '0';
            stage3_done <= '0';
        else
            if rising_edge(ffClk1) then
                stage1_dataAin <= stage3_dataA;
                stage1_dataBin <= stage3_dataB;
                stage1_done <= stage3_done;
            end if;
            if rising_edge(ffClk2) then
                stage2_dataAin <= stage1_dataAout;
                stage2_dataBin <= stage1_dataBout;
                --stage2_doneIn <= stage1_done; -- Not used since it is always overwritten by GCD
            end if;
            if rising_edge(ffClk3) then
                stage3_dataA <= stage2_dataAout;
                stage3_dataB <= stage2_dataBout;
                stage3_done <= stage2_doneOut;
            end if;
        end if;
    end process;

    enable_ring <= start AND (NOT stage1_done);

    --Robert: this stage 1 determines the output
    process (start, operandAIn, operandBIn, stage1_dataAin, stage1_dataBin, start, enable_ring)
    begin
      if (start = '0') then
            stage1_dataAout <= operandAIn;
            stage1_dataBout <= operandBIn;
      else
          if enable_ring = '1' then
            stage1_dataAout <= stage1_dataAin;
            stage1_dataBout <= stage1_dataBin;
          end if;
      end if;
   end process;



    -- Needs at least around 2
    ctrl1 : click_ctrl_delay
    generic map (a_req_delay => 2,
                 b_ack_delay => 2,
                 initialOutput => '1') -- The phase is initialized to 1 so that the ring oscillates when enabled
    port map (
        a_req => stage3_req,
        b_ack => stage1_ack,
        a_ack => stage3_ack,
        b_req => stage1_req,
        ff_clock => ffClk1,
        enable => enable_ring
    );

    -- Needs at least around 25, lower if we increase the one above
    ctrl2 : click_ctrl_delay
    generic map (a_req_delay => 2,
                 b_ack_delay => 2,
                 initialOutput => '0')
    port map (
        a_req => stage1_req,
        b_ack => stage2_ack,
        a_ack => stage1_ack,
        b_req => stage2_req,
        ff_clock => ffClk2,
        enable => enable_ring
    );

    -- Needs at least around 15
    ctrl3 : click_ctrl_delay
    generic map (a_req_delay => 2,
                 b_ack_delay => 2,
                 initialOutput => '0')
    port map (
        a_req => stage2_req,
        b_ack => stage3_ack,
        a_ack => stage2_ack,
        b_req => stage3_req,
        ff_clock => ffClk3,
        enable => enable_ring
    );

    gcd1 : GCD
    port map (
        a_in => stage2_dataAin,
        b_in => stage2_dataBin,
        a_out => stage2_dataAout,
        b_out => stage2_dataBout,
        done => stage2_doneOut
    );

    result <= stage1_dataAin; --reassigning result since GCD has been changed
    done <= stage1_done;
end behavioural;