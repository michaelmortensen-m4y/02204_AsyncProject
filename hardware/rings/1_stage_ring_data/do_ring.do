vsim work.click_ctrl -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave click_ctrl/a_req
add wave click_ctrl/b_ack
add wave click_ctrl/a_ack
add wave click_ctrl/b_req
add wave click_ctrl/ff_clock
add wave click_ctrl/ff_value
add wave click_ctrl/b_req_internal
add wave click_ctrl/a_ack_internal



# Nothing to do
force -drive click_ctrl/a_req 0
force -drive click_ctrl/b_ack 0

run 10

force -drive click_ctrl/a_req 1

run 10

force -drive click_ctrl/b_ack 1

run 10

# a has received its acknowledge and b has acknowledged

force -drive click_ctrl/a_req 0

run 10

force -drive click_ctrl/b_ack 0