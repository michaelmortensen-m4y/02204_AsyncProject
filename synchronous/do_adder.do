vsim work.gcd

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave gcd/clk
add wave gcd/reset
add wave gcd/start
add wave gcd/a_in
add wave gcd/b_in
add wave gcd/ready
add wave gcd/r

add wave gcd/state_reg


force -freeze /gcd/clk 1 0, 0 {5 ns} -r 10


force -drive /gcd/reset 1
force -drive /gcd/a_in 8'h2a
force -drive /gcd/b_in 8'h21
force -drive /gcd/start 1

run 10

force -drive /gcd/reset 0

run 100

