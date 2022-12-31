`define DEPTH 64 // total no of locations in memory
`define ADDR_WIDTH $clog2(`DEPTH) // addr bus width to access memory
`define WIDTH 16// size of each location in memmory

class mem_common;
	static virtual mem_intf vif;
	static mailbox gen2bfmDA[]; // = new();
	static mailbox mon2ref = new();
	static mailbox mon2cov = new();
	static string testcase;
	static int count=10; // total number of readwrite txs
	static int tx_packets; // counter logic to finish simulation 
	static int agents = 3;
	static semaphore smp = new(1); 
	static int match, mismatch;

	function new();
		gen2bfmDA = new[agents];
		foreach (gen2bfmDA[i]) gen2bfmDA[i] = new();
	endfunction
endclass
