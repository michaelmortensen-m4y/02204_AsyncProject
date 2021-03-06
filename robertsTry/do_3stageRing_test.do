vsim work.tb_3stagering -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave tb_3stagering/test_operandAIn
add wave tb_3stagering/test_operandBIn
add wave tb_3stagering/test_start
add wave tb_3stagering/test_done
add wave tb_3stagering/test_result

add wave tb_3stagering/dut/stage1_req
add wave tb_3stagering/dut/stage1_ack
add wave tb_3stagering/dut/stage2_req
add wave tb_3stagering/dut/stage2_ack
add wave tb_3stagering/dut/stage3_req
add wave tb_3stagering/dut/stage3_ack

add wave tb_3stagering/dut/stage1_dataAin
add wave tb_3stagering/dut/stage1_dataBin
add wave tb_3stagering/dut/stage1_dataAout
add wave tb_3stagering/dut/stage1_dataBout
add wave tb_3stagering/dut/stage2_dataAin
add wave tb_3stagering/dut/stage2_dataBin
add wave tb_3stagering/dut/stage2_dataAout
add wave tb_3stagering/dut/stage2_dataBout
add wave tb_3stagering/dut/stage3_dataA
add wave tb_3stagering/dut/stage3_dataB


add wave tb_3stagering/dut/ctrl1/latchClock
add wave tb_3stagering/dut/ctrl1/ff_value
add wave tb_3stagering/dut/ctrl2/latchClock
add wave tb_3stagering/dut/ctrl2/ff_value
add wave tb_3stagering/dut/ctrl3/latchClock
add wave tb_3stagering/dut/ctrl3/ff_value

run 50

# Set operand A input to 00000001:
force -freeze sim:/tb_3stagering/test_operandAIn 8'h7E 0
force -freeze sim:/tb_3stagering/test_operandBIn 8'h60 0

# Assert start signal
force -freeze sim:/tb_3stagering/test_start 1 0

run 300

# Deassert start signal
force -freeze sim:/tb_3stagering/test_start 0 0

run 30

# 