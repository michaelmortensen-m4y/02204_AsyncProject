--------------------------------------------------------------------------------
-- Entity: top_2stageRing
-- Date:2018-05-28
-- Author: Robert Fanning & Michael Mortensen
--
-- Description: Top module for 3-stage ring with clock controllers having internal delays
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_3stageRing is
    port (
        operandAIn, operandBIn  : in std_logic_vector(7 downto 0);
        start : in std_logic;
        done : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end top_3stageRing;

architecture behavioural of top_3stageRing is

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
        a_in , b_in: in std_logic_vector (7 downto 0);
        a_out, b_out: out std_logic_vector (7 downto 0);
        done : out  std_logic
    );
end component;

signal stage1_ack, stage2_ack, stage3_ack : std_logic;
signal stage1_req, stage2_req, stage3_req : std_logic;

signal latchClk1, latchClk2, latchClk3 : std_logic;

signal stage1_dataAin, stage1_dataBin, stage1_dataAout, stage1_dataBout : std_logic_vector(7 downto 0) := (others => '0');
signal stage2_dataAin, stage2_dataBin, stage2_dataAout, stage2_dataBout : std_logic_vector(7 downto 0) := (others => '0');
signal stage3_dataA, stage3_dataB : std_logic_vector(7 downto 0) := (others => '0');
signal stage1_done, stage2_doneIn, stage2_doneOut, stage3_done : std_logic;

begin

    process (latchClk1, latchClk2, latchClk3, stage2_dataAout, stage2_dataBout, stage3_dataA, stage3_dataB, stage1_dataAout, stage1_dataBout)
    begin
        if (latchClk1 = '1') then
            stage1_dataAin <= stage3_dataA;
            stage1_dataBin <= stage3_dataB;
	    stage1_done <= stage3_done;
        end if;
        if (latchClk2 = '1') then
            stage2_dataAin <= stage1_dataAout;
            stage2_dataBin <= stage1_dataBout;
            stage2_doneIn <= stage1_done;
        end if;
        if (latchClk3 = '1') then
            stage3_dataA <= stage2_dataAout;
            stage3_dataB <= stage2_dataBout;
            stage3_done <= stage2_doneOut;
        end if;
    end process;

    --Robert: this stage 1 determines the output
    process (operandAIn, operandBIn, stage1_dataAin, stage1_dataBin, start, stage1_done)
    begin
      if stage1_done = '1' and start = '1' then
        stage1_dataAout <= operandAIn;
        stage1_dataBout <= operandBIn;
      else
        stage1_dataAout <= stage1_dataAin;
        stage1_dataBout <= stage1_dataBin;
      end if;
   end process;




    ctrl1 : click_ctrl_delay
    generic map (a_req_delay => 2,
                 b_ack_delay => 2,
                 initialOutput => '1') -- The phase is initialized to 1 so that the ring oscillates when enabled
    port map (
        a_req => stage3_req,
        b_ack => stage1_ack,
        a_ack => stage3_ack,
        b_req => stage1_req,
        ff_clock => latchClk1,
        enable => start
    );

    ctrl2 : click_ctrl_delay
    generic map (a_req_delay => 2,
                 b_ack_delay => 2,
                 initialOutput => '0')
    port map (
        a_req => stage1_req,
        b_ack => stage2_ack,
        a_ack => stage1_ack,
        b_req => stage2_req,
        ff_clock => latchClk2,
        enable => start
    );

    ctrl3 : click_ctrl_delay
    generic map (a_req_delay => 2,
                 b_ack_delay => 2,
                 initialOutput => '0')
    port map (
        a_req => stage2_req,
        b_ack => stage3_ack,
        a_ack => stage2_ack,
        b_req => stage3_req,
        ff_clock => latchClk3,
        enable => start
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