--------------------------------------------------------------------------
--! @file buffer.vhdl
--! @brief Delay buffer for asynchronous circuits
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

    -- https://www.xilinx.com/support/answers/6431.html
    attribute DONT_TOUCH : string;

    signal output_int : std_logic;

    attribute DONT_TOUCH of output_int : signal is "true";

begin

    output_int <= not (not input);
    output <= output_int;

end behavioural;