vsim work.test_tb -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave test_tb/a_req_int
add wave test_tb/b_req_int
add wave test_tb/c_req_int

add wave test_tb/a_ack_int
add wave test_tb/b_ack_int
add wave test_tb/c_ack_int

add wave test_tb/dut/ff_clock
add wave test_tb/dut/ff_value
add wave test_tb/dut/c_req_internal


run 200