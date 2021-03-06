--
-- ROMs Using Block RAM Resources.
-- VHDL code for a ROM with registered output 
-- See UG627 (v 11.3)
-- Modified from source
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.GCD_PACKAGE.all;

entity rams_21a is
    port (
        clock : in std_logic;
        en: in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end rams_21a;

architecture syn of rams_21a is

    type rom_type is array (MAX_TESTS-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
    signal ROM : rom_type:= (X"0f",
X"4a",
X"25",
X"05",
X"70",
X"31",
X"76",
X"0b",
X"60",
X"5b",
X"07",
X"5b",
X"57",
X"7b",
X"1a",
X"21",
X"75",
X"34",
X"0a",
X"65",
X"46",
X"64",
X"28",
X"25",
X"51",
X"30",
X"54",
X"7c",
X"33",
X"49",
X"34",
X"53",
X"03",
X"75",
X"23",
X"19",
X"30",
X"3d",
X"3e",
X"3d",
X"0f",
X"15",
X"48",
X"46",
X"3e",
X"35",
X"1b",
X"3f",
X"52",
X"78",
X"78",
X"43",
X"15",
X"5c",
X"10",
X"31",
X"4c",
X"5f",
X"3d",
X"04",
X"44",
X"57",
X"01",
X"2b",
X"7a",
X"1b",
X"27",
X"68",
X"5c",
X"4c",
X"05",
X"26",
X"28",
X"6d",
X"42",
X"6f",
X"76",
X"2b",
X"39",
X"0b",
X"31",
X"3a",
X"28",
X"2b",
X"19",
X"70",
X"2b",
X"3d",
X"0c",
X"1b",
X"73",
X"1c",
X"60",
X"3c",
X"09",
X"32",
X"3a",
X"15",
X"7d",
X"2c",
X"27",
X"41",
X"0e",
X"7a",
X"1f",
X"79",
X"0c",
X"1f",
X"7b",
X"7b",
X"51",
X"50",
X"01",
X"49",
X"2e",
X"34",
X"12",
X"59",
X"19",
X"0a",
X"29",
X"4a",
X"45",
X"0e",
X"7b",
X"0a",
X"24",
X"07",
X"61",
X"36",
X"62",
X"65",
X"69",
X"3b",
X"0c",
X"0b",
X"47",
X"5d",
X"54",
X"5b",
X"16",
X"3a",
X"3d",
X"4a",
X"74",
X"11",
X"6e",
X"48",
X"33",
X"76",
X"33",
X"44",
X"1f",
X"24",
X"07",
X"68",
X"71",
X"3a",
X"77",
X"5f",
X"75",
X"65",
X"7c",
X"5f",
X"34",
X"36",
X"3c",
X"52",
X"21",
X"02",
X"18",
X"26",
X"2f",
X"41",
X"37",
X"19",
X"0f",
X"1d",
X"6b",
X"47",
X"6b",
X"6c",
X"53",
X"5c",
X"70",
X"23",
X"7e",
X"1d",
X"58",
X"02",
X"64",
X"4d",
X"02",
X"0f",
X"5c",
X"35",
X"6b",
X"12",
X"3a",
X"40",
X"54",
X"0f",
X"6e",
X"34",
X"09",
X"68",
X"56",
X"14",
X"33",
X"05",
X"64",
X"6e",
X"0a",
X"11",
X"75",
X"70",
X"63",
X"77",
X"2e",
X"69",
X"5d",
X"24",
X"15",
X"37",
X"72",
X"1d",
X"21",
X"5c",
X"50",
X"5a",
X"44",
X"51",
X"42",
X"4d",
X"35",
X"15",
X"1f",
X"09",
X"2a",
X"17",
X"0d",
X"66",
X"7d",
X"57",
X"05",
X"17",
X"02",
X"22",
X"1f",
X"03",
X"2c",
X"42",
X"78",
X"67",
X"44",
X"25",
X"7c",
X"1a",
X"21",
X"3c",
X"06",
X"3b",
X"64",
X"35",
X"54",
X"1b",
X"7a",
X"2b",
X"2a",
X"19",
X"1c",
X"30",
X"72",
X"07",
X"1b",
X"55",
X"73",
X"05",
X"5c",
X"75",
X"59",
X"1a",
X"31",
X"0e",
X"6e",
X"0b",
X"0c",
X"79",
X"56",
X"5a",
X"70",
X"3c",
X"3c",
X"64",
X"71",
X"2a",
X"67",
X"28",
X"48",
X"1c",
X"2e",
X"0b",
X"5c",
X"22",
X"41",
X"7c",
X"36",
X"06",
X"3e",
X"38",
X"68",
X"56",
X"31",
X"11",
X"3a",
X"47",
X"59",
X"0f",
X"1e",
X"5b",
X"31",
X"22",
X"08",
X"41",
X"5a",
X"53",
X"5d",
X"69",
X"54",
X"40",
X"08",
X"50",
X"09",
X"4d",
X"28",
X"2a",
X"73",
X"66",
X"34",
X"1a",
X"0f",
X"13",
X"61",
X"2c",
X"41",
X"02",
X"7c",
X"1f",
X"5f",
X"61",
X"3c",
X"48",
X"23",
X"07",
X"60",
X"6d",
X"49",
X"52",
X"7e",
X"67",
X"2f",
X"07",
X"5b",
X"67",
X"3b",
X"0a",
X"45",
X"49",
X"0b",
X"4d",
X"7b",
X"18",
X"77",
X"18",
X"62",
X"0e",
X"11",
X"51",
X"43",
X"66",
X"3e",
X"6d",
X"51",
X"0c",
X"7a",
X"46",
X"5d",
X"70",
X"0b",
X"17",
X"45",
X"72",
X"50",
X"4d",
X"04",
X"18",
X"7d",
X"76",
X"68",
X"3c",
X"1c",
X"22",
X"5f",
X"5c",
X"7e",
X"77",
X"50",
X"19",
X"51",
X"64",
X"2a",
X"3e",
X"3d",
X"1b",
X"46",
X"2d",
X"19",
X"0c",
X"31",
X"3c",
X"08",
X"35",
X"0d",
X"0e",
X"74",
X"05",
X"47",
X"6a",
X"63",
X"7e",
X"27",
X"7a",
X"7c",
X"5c",
X"08",
X"7d",
X"4f",
X"0f",
X"16",
X"2a",
X"07",
X"2e",
X"54",
X"2b",
X"70",
X"24",
X"5d",
X"1f",
X"70",
X"55",
X"1d",
X"2a",
X"53",
X"5b",
X"5e",
X"15",
X"61",
X"30",
X"5d",
X"12",
X"38",
X"16",
X"38",
X"49",
X"45",
X"45",
X"3d",
X"42",
X"3d",
X"60",
X"5e",
X"6f",
X"10",
X"01",
X"08",
X"03",
X"67",
X"30",
X"61",
X"4f",
X"58",
X"5a",
X"76",
X"03",
X"2a",
X"6d",
X"23",
X"50",
X"63",
X"73",
X"45",
X"3c",
X"5e",
X"2f",
X"3d",
X"0d",
X"5c",
X"26",
X"4f",
X"22",
X"52",
X"0c",
X"65",
X"17",
X"66",
X"1c",
X"2b",
X"54",
X"4b",
X"74",
X"37",
X"0f",
X"7b",
X"4b",
X"39",
X"46",
X"29",
X"20",
X"1c",
X"31",
X"72",
X"16",
X"21",
X"07",
X"33",
X"5c",
X"11",
X"6a",
X"1b",
X"4f",
X"22",
X"3c",
X"64",
X"4c",
X"6b",
X"5d",
X"25",
X"0c",
X"56",
X"4a",
X"19",
X"33",
X"0d",
X"60",
X"08",
X"4b",
X"6a",
X"05",
X"09",
X"61",
X"68",
X"3e",
X"17",
X"09",
X"3a",
X"5a",
X"78",
X"02",
X"62",
X"44",
X"19",
X"6e",
X"63",
X"55",
X"05",
X"14",
X"04",
X"77",
X"36",
X"72",
X"42",
X"2f",
X"39",
X"07",
X"73",
X"62",
X"4f",
X"16",
X"75",
X"1f",
X"6b",
X"51",
X"75",
X"13",
X"23",
X"56",
X"19",
X"0c",
X"51",
X"02",
X"7b",
X"1b",
X"63",
X"3a",
X"59",
X"67",
X"1a",
X"16",
X"1a",
X"60",
X"5a",
X"33",
X"5f",
X"34",
X"66",
X"7b",
X"75",
X"7d",
X"49",
X"28",
X"03",
X"3e",
X"08",
X"45",
X"29",
X"71",
X"69",
X"04",
X"02",
X"78",
X"5e",
X"20",
X"55",
X"66",
X"7e",
X"0c",
X"16",
X"28",
X"0a",
X"2d",
X"2b",
X"13",
X"0c",
X"23",
X"33",
X"68",
X"56",
X"68",
X"67",
X"5b",
X"5e",
X"36",
X"1f",
X"2a",
X"75",
X"33",
X"43",
X"29",
X"2e",
X"6c",
X"56",
X"72",
X"1c",
X"5f",
X"0b",
X"51",
X"22",
X"38",
X"21",
X"56",
X"05",
X"65",
X"3a",
X"35",
X"2f",
X"75",
X"11",
X"69",
X"42",
X"51",
X"2b",
X"1e",
X"25",
X"74",
X"1c",
X"25",
X"70",
X"75",
X"18",
X"0b",
X"1b",
X"5f",
X"11",
X"28",
X"2d",
X"39",
X"13",
X"07",
X"53",
X"4c",
X"19",
X"52",
X"67",
X"23",
X"5b",
X"38",
X"20",
X"6b",
X"03",
X"14",
X"15",
X"12",
X"77",
X"30",
X"13",
X"12",
X"0a",
X"6d",
X"6e",
X"4f",
X"45",
X"3f",
X"16",
X"12",
X"17",
X"16",
X"72",
X"15",
X"64",
X"08",
X"24",
X"6b",
X"1a",
X"1a",
X"4d",
X"04",
X"58",
X"09",
X"0b",
X"24",
X"73",
X"4f",
X"47",
X"0a",
X"69",
X"4d",
X"43",
X"02",
X"37",
X"21",
X"65",
X"46",
X"20",
X"71",
X"3e",
X"24",
X"50",
X"7b",
X"1d",
X"2f",
X"52",
X"4a",
X"6b",
X"74",
X"18",
X"62",
X"2e",
X"42",
X"67",
X"5a",
X"13",
X"19",
X"65",
X"73",
X"31",
X"41",
X"02",
X"55",
X"41",
X"49",
X"03",
X"5c",
X"29",
X"3c",
X"11",
X"02",
X"59",
X"17",
X"04",
X"70",
X"56",
X"60",
X"78",
X"32",
X"2c",
X"71",
X"69",
X"73",
X"5f",
X"6e",
X"14",
X"05",
X"46",
X"64",
X"41",
X"55",
X"38",
X"3b",
X"42",
X"10",
X"77",
X"7d",
X"02",
X"5c",
X"46",
X"5f",
X"29",
X"35",
X"7b",
X"11",
X"07",
X"10",
X"1b",
X"67",
X"38",
X"4d",
X"54",
X"49",
X"1b",
X"11",
X"09",
X"33",
X"4a",
X"7b",
X"7a",
X"22",
X"47",
X"62",
X"1f",
X"5e",
X"2a",
X"5a",
X"1b",
X"3a",
X"35",
X"0b",
X"07",
X"65",
X"0d",
X"40",
X"1c",
X"5b",
X"5d",
X"2d",
X"7c",
X"40",
X"1b",
X"44",
X"3d",
X"38",
X"30",
X"77",
X"3d",
X"46",
X"44",
X"13",
X"6b",
X"5a",
X"4b",
X"28",
X"04",
X"46",
X"6f",
X"77",
X"08",
X"59",
X"78",
X"58",
X"1f",
X"5e",
X"2f",
X"4d",
X"40",
X"19",
X"68",
X"06",
X"62",
X"65",
X"68",
X"62",
X"31",
X"2c",
X"48",
X"11",
X"3b",
X"4c",
X"09",
X"16",
X"08",
X"69",
X"1f",
X"5c",
X"53",
X"1d",
X"01",
X"72",
X"2e",
X"7a",
X"32",
X"1a",
X"22",
X"56",
X"4a",
X"29",
X"1b",
X"37",
X"7d",
X"32",
X"78",
X"01",
X"53",
X"09",
X"5e",
X"1b",
X"0a",
X"48",
X"7a",
X"2d",
X"4c",
X"5b",
X"0b",
X"27",
X"3f",
X"08",
X"14",
X"69",
X"06",
X"14",
X"02",
X"0a",
X"56",
X"35",
X"5a",
X"0e",
X"30",
X"10",
X"79",
X"57",
X"17",
X"2f",
X"3e",
X"43",
X"0c",
X"61",
X"09",
X"59",
X"47",
X"70",
X"70",
X"3f",
X"25",
X"1e",
X"7b",
X"13",
X"0c",
X"0e",
X"01",
X"0f",
X"3d",
X"70",
X"51",
X"08",
X"61",
X"3a",
X"45",
X"03",
X"65",
X"31",
X"79",
X"29",
X"3f",
X"21",
X"17",
X"56",
X"4c",
X"6a",
X"0b",
X"51",
X"65",
X"48",
X"6a",
X"35",
X"49",
X"3e",
X"6b",
X"4a",
X"13",
X"2b",
X"49",
X"79",
X"4b",
X"09",
X"23",
X"48",
X"07",
X"35",
X"66",
X"5a",
X"69",
X"32");

begin
    process (clock)
    begin
        if rising_edge(clock) then
            if (en = '1') then
                data <= ROM(conv_integer(addr));
            end if;
        end if;
    end process;
end syn;