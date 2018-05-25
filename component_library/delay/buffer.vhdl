--------------------------------------------------------------------------
--! @file buffer.vhdl
--! @brief Buffer used to delay signals for asynchronous circuits
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_buffer is
    port (
        input : in std_logic;
        output : out  std_logic
    );
end delay_buffer;

architecture behavioural of delay_buffer is

    signal output_int : std_logic;

    -- https://www.xilinx.com/support/answers/6431.html
    -- This has to be here!
    attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of output_int : signal is "true";

begin

    output_int <= not (not input) after 1 ns;
    output <= output_int;

end behavioural;