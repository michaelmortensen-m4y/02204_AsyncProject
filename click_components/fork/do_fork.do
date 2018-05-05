vsim work.click_fork -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave click_fork/a_req
add wave click_fork/b_req
add wave click_fork/c_req

add wave click_fork/a_ack
add wave click_fork/b_ack
add wave click_fork/c_ack

add wave click_fork/ff_clock
add wave click_fork/ff_value
add wave click_fork/a_ack_internal


# Nothing to do
force -drive click_fork/a_req 0
force -drive click_fork/b_ack 0
force -drive click_fork/c_ack 0

run 10

force -drive click_fork/a_req 1

run 10

force -drive click_fork/b_ack 1

run 10

force -drive click_fork/c_ack 1

run 10

force -drive click_fork/a_req 0

run 10