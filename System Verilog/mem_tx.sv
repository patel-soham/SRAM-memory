class mem_tx;
	rand bit wr_en; 
	rand bit [`ADDR_WIDTH-1:0] addr;
	rand bit [`WIDTH-1:0] wdata;
	bit [`WIDTH-1:0] rdata;

	function void print (string name= "mem_tx");
		$display("Printing %s fields", name);
		$display("\taddr = %h", addr);
		$display("\twdata = %h", wdata);
		$display("\twr_en = %h", wr_en);
	endfunction
endclass
