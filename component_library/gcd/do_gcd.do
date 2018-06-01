vsim work.test_tb -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave test_tb/a_in
add wave test_tb/b_in
add wave test_tb/a_out
add wave test_tb/b_out
add wave test_tb/done

run 200