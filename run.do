vlib work 
vlog tb_memory.v 
vsim tb +testname=random_wr_rd
add wave -position insertpoint sim:/tb/*
run -all
