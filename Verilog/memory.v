// Simple SRAM synchronous positive edge code

/* 
INPUTS
	1. clk - Clock.
	2. rst - Reset.
	3. addr - Address bus
	4. wdata - Data bus to perform write operation
	5. wr_en - Write enable signal. HIGH to perfrom write operation and LOW for read.
	6. valid - Signal to request memory for a transaction
OUTPUTS
	1. ready - Signal indicating memory is ready to perfrom transcation in response to 'valid' request
	2. rdata - Data bus to perform read operation.
*/
module memory(clk, rst, addr, wdata, wr_en, valid, ready, rdata);

parameter ADDR_WIDTH=3; // addr bus width to access memory
parameter DEPTH=8; // total no of locations in memory
parameter WIDTH=8; // size of each location in memmory

// rst = Active high synchronous reset
input clk, rst, wr_en, valid; 
input [ADDR_WIDTH-1:0] addr;
input [WIDTH-1:0] wdata;
output reg [WIDTH-1:0] rdata;
output reg ready;

integer i;
reg [WIDTH-1:0] mem[DEPTH-1:0];

initial begin
	i = 0;
	rdata = 0;
	ready = 0;
end

always @ (posedge clk) begin
	if (rst == 1) begin
		rdata = 0;
		ready = 0;
		for (i=0; i<DEPTH; i=i+1) mem[i]= 0;
	end
	else begin
		if (valid == 1) begin
			ready = 1;
			if (wr_en == 1) mem[addr]= wdata;
			else rdata= mem[addr];
		end
		else ready = 0;
	end
end

/*initial begin
	$dumpvars;
	$dumpfile("1.vcd");
end*/
endmodule
