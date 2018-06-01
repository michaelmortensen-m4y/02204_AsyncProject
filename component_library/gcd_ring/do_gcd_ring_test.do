vsim work.tb_gcd_ring -t ns

# Restart simulation and remove waves

restart -f -nowave

config wave -signalnamewidth 1

# Add inputs

add wave tb_gcd_ring/test_operandAIn
add wave tb_gcd_ring/test_operandBIn
add wave tb_gcd_ring/test_start
add wave tb_gcd_ring/test_done
add wave tb_gcd_ring/test_result

add wave tb_gcd_ring/dut/stage1_req
add wave tb_gcd_ring/dut/stage1_ack
add wave tb_gcd_ring/dut/stage2_req
add wave tb_gcd_ring/dut/stage2_ack
add wave tb_gcd_ring/dut/stage3_req
add wave tb_gcd_ring/dut/stage3_ack

add wave tb_gcd_ring/dut/stage1_dataAin
add wave tb_gcd_ring/dut/stage1_dataBin
add wave tb_gcd_ring/dut/stage1_dataAout
add wave tb_gcd_ring/dut/stage1_dataBout
add wave tb_gcd_ring/dut/stage2_dataAin
add wave tb_gcd_ring/dut/stage2_dataBin
add wave tb_gcd_ring/dut/stage2_dataAout
add wave tb_gcd_ring/dut/stage2_dataBout
add wave tb_gcd_ring/dut/stage3_dataA
add wave tb_gcd_ring/dut/stage3_dataB


add wave tb_gcd_ring/dut/ctrl1/ff_clock
add wave tb_gcd_ring/dut/ctrl1/ff_value
add wave tb_gcd_ring/dut/ctrl2/ff_clock
add wave tb_gcd_ring/dut/ctrl2/ff_value
add wave tb_gcd_ring/dut/ctrl3/ff_clock
add wave tb_gcd_ring/dut/ctrl3/ff_value


run 400 ns