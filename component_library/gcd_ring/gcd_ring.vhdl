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
signal stage1_done, stage2_doneIn, stage2_doneOut, stage3_done : std_logic := '0';

signal enable_ring : std_logic;

begin

    process (start, ffClk1, ffClk2, ffClk3, stage2_dataAout, stage2_dataBout, stage3_dataA, stage3_dataB, stage1_dataAout, stage1_dataBout)
    begin
       if (start = '0') then
            stage1_dataAin <= (others => '0');
            stage1_dataBin <= (others => '0');
            stage1_done <= '0';
            stage2_dataAin <= (others => '0');
            stage2_dataBin <= (others => '0');
            stage2_doneIn <= '0';
            stage3_dataA <= (others => '0');
            stage3_dataB <= (others => '0');
            stage3_done <= '0';
            --stage2_doneOut <= '0';
        else
        if (ffClk1 = '1') then
            stage1_dataAin <= stage3_dataA;
            stage1_dataBin <= stage3_dataB;
        stage1_done <= stage3_done;
        end if;
        if (ffClk2 = '1') then
            stage2_dataAin <= stage1_dataAout;
            stage2_dataBin <= stage1_dataBout;
            stage2_doneIn <= stage1_done;
        end if;
        if (ffClk3 = '1') then
            stage3_dataA <= stage2_dataAout;
            stage3_dataB <= stage2_dataBout;
            stage3_done <= stage2_doneOut;
        end if;
        end if;
    end process;

    enable_ring <= start AND (NOT stage1_done);

    --Robert: this stage 1 determines the output
    process (start, operandAIn, operandBIn, stage1_dataAin, stage1_dataBin, start, stage1_done)
    begin
      if (start = '0') then
         stage1_dataAout <= (others => '0');
         stage1_dataBout <= (others => '0');   
      else
          if enable_ring = '0' then
            stage1_dataAout <= operandAIn;
            stage1_dataBout <= operandBIn;
          else
            stage1_dataAout <= stage1_dataAin;
            stage1_dataBout <= stage1_dataBin;
          end if;
      end if;
   end process;




    ctrl1 : click_ctrl_delay
    generic map (a_req_delay => 50,
                 b_ack_delay => 50,
                 initialOutput => '1') -- The phase is initialized to 1 so that the ring oscillates when enabled
    port map (
        a_req => stage3_req,
        b_ack => stage1_ack,
        a_ack => stage3_ack,
        b_req => stage1_req,
        ff_clock => ffClk1,
        enable => enable_ring
    );

    ctrl2 : click_ctrl_delay
    generic map (a_req_delay => 50,
                 b_ack_delay => 50,
                 initialOutput => '0')
    port map (
        a_req => stage1_req,
        b_ack => stage2_ack,
        a_ack => stage1_ack,
        b_req => stage2_req,
        ff_clock => ffClk2,
        enable => enable_ring
    );

    ctrl3 : click_ctrl_delay
    generic map (a_req_delay => 50,
                 b_ack_delay => 50,
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