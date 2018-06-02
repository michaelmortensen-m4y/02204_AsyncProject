vsim work.test_tb -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave test_tb/a_req
add wave test_tb/b_req
add wave test_tb/c_req

add wave test_tb/a_ack
add wave test_tb/b_ack
add wave test_tb/c_ack

add wave test_tb/dut/ff_clock
add wave test_tb/dut/ff_value


# Nothing to do

run 200