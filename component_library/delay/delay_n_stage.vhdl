--------------------------------------------------------------------------
--! @file delay.vhdl
--! @brief N-stage delay element for asynchronous circuits
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_n_stage is
    generic (stages : natural := 10);
    port (
        input: in  std_logic;
        output : out  std_logic
    );
end delay_n_stage;

architecture behavioural of delay_n_stage is

component delay_buffer is
    port (
        input: in  std_logic;
        output : out  std_logic
    );
end component;

type vector is array (0 to stages) of std_logic;

signal buffer_inputs : vector;
signal buffer_outputs : vector;

signal output_int : std_logic;


attribute DONT_TOUCH : string;
attribute DONT_TOUCH of buffer_inputs : signal is "true";
attribute DONT_TOUCH of buffer_outputs : signal is "true";

begin

    generate_delays: for i in 0 to stages generate

        initial_buffer: if i = 0 generate

            buffer_inputs(0) <= input;
            buffer_inputs(i+1) <= buffer_outputs(i);

            bufferStart: delay_buffer 
                port map (
                    buffer_inputs(i),
                    buffer_outputs(i)
                );
        end generate initial_buffer;

        final_buffer: if i = stages generate
            output_int <= buffer_outputs(stages);

            bufferEnd: delay_buffer 
                port map (
                    buffer_inputs(i),
                    buffer_outputs(i)
                );
        end generate final_buffer;

        internal_buffer: if (i > 0 and i < stages) generate

            buffer_inputs(i+1) <= buffer_outputs(i);

            bufferX: delay_buffer 
                port map (
                    buffer_inputs(i),
                    buffer_outputs(i)
                );

        end generate internal_buffer;

    end generate generate_delays;

    output <= output_int;

end behavioural;