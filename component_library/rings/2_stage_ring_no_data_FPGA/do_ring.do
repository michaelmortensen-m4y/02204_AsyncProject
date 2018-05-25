vsim work.test_tb -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave test_tb/button
add wave test_tb/clock
add wave test_tb/reset
add wave test_tb/led1
add wave test_tb/led2

add wave test_tb/dut/ctrl1_req
add wave test_tb/dut/ctrl1_ack
add wave test_tb/dut/ctrl2_req
add wave test_tb/dut/ctrl2_ack


run 200