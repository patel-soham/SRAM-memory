module tb_top;

// clock and reset intantiation
reg clk, rst;
// Clock generation
initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

mem_intf pif (clk, rst);

// DUT instantiation
memory #(.ADDR_WIDTH(`ADDR_WIDTH), .DEPTH(`DEPTH), .WIDTH(`WIDTH)) dut (.clk(pif.clk), .rst(pif.rst), .addr(pif.addr), .wdata(pif.wdata), .wr_en(pif.wr_en), .valid(pif.valid), .ready(pif.ready), .rdata(pif.rdata));

task reset_inputs();
	pif.addr = 0;
	pif.wdata = 0;
	pif.wr_en = 0;
	pif.valid = 0;
endtask

// Reset apply, hold and release
// Then create env and run env
// end env logic (seperate not in same block)
mem_env env;
mem_common common = new();
initial begin
	rst = 1;
	// applying all design inputs to be zero
	reset_inputs();
	repeat (2) @ (posedge clk);
	rst = 0;
	
	assert($value$plusargs("testcase=%s",mem_common::testcase));

	env = new();
	env.run(); // starting env after reset

	//#200 $finish; This will never get chance and sim will run forever
end
initial begin
	fork
		wait (mem_common::tx_packets == mem_common::count*mem_common::agents*2);
		#50000;
	join_any
	disable fork;
	repeat (2) @ (posedge clk); // to view last read cycle outcome
	if (mem_common::mismatch == 0)
		$display("********** Test PASSED *****************");
	else
		$display("********** Test FAILED *****************");
	$display("Missmatch count : %0d   Match count = %0d",mem_common::mismatch, mem_common::match); 
	$finish;
end

final begin

end

endmodule
