// Interface is bundling together all related signals in one unit
// A way to encapsulate signals into a block
// It can be reused in other projects and is used to 
// interface DUT with other verification components

interface mem_intf (input logic clk, rst);
// all memory dut ports with logic type
logic wr_en, valid, ready; 
logic [`ADDR_WIDTH-1:0] addr;
logic [`WIDTH-1:0] wdata;
logic [`WIDTH-1:0] rdata;

clocking bfm_cb @ (posedge clk);
	// directions with delay only
	// no bit size required 
	//
	//input clk; not required
	//input rst; not required
	//
	//inputs are sampled before active edge 
	//outputs are driven after active edge
	//generally inputs are #0 and outputs are #1
	//input at #0 means 0 delay before clock sampling, which is actually (transient after active edge)
	input #1 rdata;
	input #1 ready;

	output #2 addr;
	output #2 wdata;
	output #2 wr_en;
	output #2 valid;
endclocking

clocking mon_cb @ (posedge clk); 
	default input #1 output #2;
	input rdata;
	input ready;
	input addr;
	input wdata;
	input wr_en;
	input valid;
endclocking

modport bfm_mp (clocking bfm_cb);
modport mon_mp (clocking mon_cb);

endinterface
