vsim work.tb_2stagering -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave tb_2stagering/test_operandAIn
add wave tb_2stagering/test_operandBIn
add wave tb_2stagering/test_start
add wave tb_2stagering/test_done
add wave tb_2stagering/test_result

add wave tb_2stagering/dut/stage1_req
add wave tb_2stagering/dut/stage1_ack
add wave tb_2stagering/dut/stage2_req
add wave tb_2stagering/dut/stage2_ack

add wave tb_2stagering/dut/ctrl1/latchClock
add wave tb_2stagering/dut/ctrl1/ff_value
add wave tb_2stagering/dut/ctrl2/latchClock
add wave tb_2stagering/dut/ctrl2/ff_value

run 50

# Set operand A input to 00000001:
force -freeze sim:/tb_2stagering/test_operandAIn 8'h01 0

# Assert start signal
force -freeze sim:/tb_2stagering/test_start 1 0

run 50

# Deassert start signal
force -freeze sim:/tb_2stagering/test_start 0 0

run 50

# 