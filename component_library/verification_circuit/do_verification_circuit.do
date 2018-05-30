vsim work.test_tb -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave test_tb/clock
add wave test_tb/reset
add wave test_tb/start_test
add wave test_tb/C_from_gcd

add wave test_tb/done
add wave test_tb/start_gcd
add wave test_tb/A_to_gcd
add wave test_tb/B_to_gcd

add wave test_tb/count
add wave test_tb/correct


add wave test_tb/dut/test_addr
add wave test_tb/dut/count_int
add wave test_tb/dut/count_int_next


add wave test_tb/dut/state_reg



run 200