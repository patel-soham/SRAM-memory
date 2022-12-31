vlog headers.svh 
vsim -novopt tb_top +testcase=test_n_wr_rd -l logfile.log
# -voptargs=+acc=npr
add wave sim:tb_top/pif/*
run -all
