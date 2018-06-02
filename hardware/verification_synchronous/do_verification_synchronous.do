vsim work.test_tb -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave test_tb/clock
add wave test_tb/reset
add wave test_tb/start_button

#add wave test_tb/dut/first_done
add wave test_tb/dut/start_gcd
add wave test_tb/dut/done_gcd
add wave test_tb/dut/done_gcd_synchronized
#add wave test_tb/dut/done_gcd_verification
add wave test_tb/dut/start_button_synchronized
add wave test_tb/dut/correct
add wave test_tb/dut/test_complete_int
#add wave test_tb/dut/gcd_ring1/enable_ring

add wave test_tb/dut/result_gcd
add wave test_tb/dut/input1_gcd
add wave test_tb/dut/input2_gcd
add wave test_tb/dut/count_int


add wave test_tb/dut/verification_circuit1/state_reg
add wave test_tb/dut/verification_circuit1/test_addr_next


add wave test_tb/dut/GCDsynch1/done
add wave test_tb/dut/GCDsynch1/a_in
add wave test_tb/dut/GCDsynch1/b_in



run 1000