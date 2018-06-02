vsim work.test_tb -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave test_tb/a_req
add wave test_tb/b_ack
add wave test_tb/a_ack
add wave test_tb/b_req

add wave test_tb/dut/ff_clock
add wave test_tb/dut/ff_value
add wave test_tb/dut/b_req_internal
add wave test_tb/dut/a_ack_internal


run 200