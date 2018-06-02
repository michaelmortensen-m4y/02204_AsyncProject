vsim work.test_tb -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave test_tb/button
add wave test_tb/clock
add wave test_tb/reset
add wave test_tb/output

add wave test_tb/dut/a_req
add wave test_tb/dut/a_ack
add wave test_tb/dut/b_ack
add wave test_tb/dut/b_req


run 200