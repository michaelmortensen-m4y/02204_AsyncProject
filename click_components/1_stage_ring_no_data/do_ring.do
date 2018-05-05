vsim work.top_ring -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave top_ring/a_req
add wave top_ring/a_ack
add wave top_ring/b_ack
add wave top_ring/b_req

run 40