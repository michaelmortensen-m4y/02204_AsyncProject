--------------------------------------------------------------------------------
-- Entity: top_2stageRing
-- Date:2018-05-28  
-- Author: Michael Mortensen     
--
-- Description: Top module for 2-stage ring with clock controllers having internal delays
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_2stageRing is
    port (
        operandAIn, operandBIn  : in std_logic_vector(7 downto 0);
        start : in std_logic;
        done : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end top_2stageRing;

architecture behavioural of top_2stageRing is

component click_ctrl_withDelay is
    generic(forwardDelay : time := 2.0 ns;
            backwardDelay : time := 1.0 ns;
            initialOut : std_logic := '0');
    port (
        a_req, b_ack, enable : in  std_logic;
        a_ack, b_req, latchClock : out  std_logic
    );
end component;

component GCD is
    port (
        start : in std_logic;
        operandAIn : in std_logic_vector(7 downto 0);
        operandBIn : in std_logic_vector(7 downto 0);
        stage1_dataAin : in std_logic_vector(7 downto 0);
        stage1_dataBin : in std_logic_vector(7 downto 0);
        stage1_dataAout : out std_logic_vector(7 downto 0);
        stage1_dataBout : out std_logic_vector(7 downto 0);
        done : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end component;

signal stage1_ack, stage2_ack, stage3_ack : std_logic;
signal stage1_req, stage2_req, stage3_req : std_logic;

signal latchClk1, latchClk2, latchClk3 : std_logic;

signal stage1_dataAin, stage1_dataBin, stage1_dataAout, stage1_dataBout : std_logic_vector(7 downto 0) := (others => '0');
signal stage2_dataA, stage2_dataB : std_logic_vector(7 downto 0) := (others => '0');
signal stage3_dataA, stage3_dataB : std_logic_vector(7 downto 0) := (others => '0');

begin

    process (latchClk1, latchClk2, latchClk3, stage2_dataA, stage2_dataB, stage3_dataA, stage3_dataB, stage1_dataAout, stage1_dataBout)
    begin
        if (latchClk1 = '1') then
            stage1_dataAin <= stage3_dataA;
            stage1_dataBin <= stage3_dataB;
        end if;
        if (latchClk2 = '1') then
            stage2_dataA <= stage1_dataAout;
            stage2_dataB <= stage1_dataBout;
        end if;
        if (latchClk3 = '1') then
            stage3_dataA <= stage2_dataA;
            stage3_dataB <= stage2_dataB;
        end if;
    end process;

    ctrl1 : click_ctrl_withDelay 
    generic map (forwardDelay => 5.0 ns,
                 backwardDelay => 3.0 ns,
                 initialOut => '1') -- The phase is initialized to 1 so that the ring oscillates when enabled
    port map (
        a_req => stage3_req,
        b_ack => stage1_ack,
        a_ack => stage3_ack,
        b_req => stage1_req,
        latchClock => latchClk1,
        enable => start
    );
    
    ctrl2 : click_ctrl_withDelay 
    generic map (forwardDelay => 5.0 ns,
                 backwardDelay => 3.0 ns,
                 initialOut => '0')
    port map (
        a_req => stage1_req,
        b_ack => stage2_ack,
        a_ack => stage1_ack,
        b_req => stage2_req,
        latchClock => latchClk2,
        enable => start
    );
    
    ctrl3 : click_ctrl_withDelay 
    generic map (forwardDelay => 5.0 ns,
                 backwardDelay => 3.0 ns,
                 initialOut => '0')
    port map (
        a_req => stage2_req,
        b_ack => stage3_ack,
        a_ack => stage2_ack,
        b_req => stage3_req,
        latchClock => latchClk3,
        enable => start
    );
    
    gcd1 : GCD
    port map (
        start => start,
        operandAIn => operandAIn,
        operandBIn => operandBIn,
        stage1_dataAin => stage1_dataAin,
        stage1_dataBin => stage1_dataBin,
        stage1_dataAout => stage1_dataAout,
        stage1_dataBout => stage1_dataBout,
        done => done,
        result => result
    );


end behavioural;

