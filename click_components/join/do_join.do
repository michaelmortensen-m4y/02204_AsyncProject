vsim work.click_join -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave click_join/a_req
add wave click_join/b_req
add wave click_join/c_req

add wave click_join/a_ack
add wave click_join/b_ack
add wave click_join/c_ack

add wave click_join/ff_clock
add wave click_join/ff_value
add wave click_join/c_req_internal


# Nothing to do
force -drive click_join/a_req 0
force -drive click_join/b_req 0
force -drive click_join/c_ack 0


run 10

force -drive click_join/a_req 1

run 10

force -drive click_join/b_req 1

run 10

force -drive click_join/c_ack 1

run 10

force -drive click_join/b_req 0

run 10

force -drive click_join/a_req 0


run 10

force -drive click_join/b_req 1

run 10

force -drive click_join/a_req 1

# There can only happen something again if c_ack goes down!

run 10

force -drive click_join/c_ack 0

run 10