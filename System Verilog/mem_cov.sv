class mem_cov;
	mem_tx tx;
	event mem_cg_e;
	int cov_no;

	// covergroup is dynamic construct and needs to be allocated memory
	// explicity using new in constructor of coverage class only
	covergroup mem_cg @ (mem_cg_e);
		ADDR_CP : coverpoint tx.addr {
			option.auto_bin_max = 10; // more bins, more cases required to test
			// automatically dividies range of addr, last bin takes adjustment
		}
		WR_RD_CP : coverpoint tx.wr_en; // auto bins for each bit 
		// can do upto a limit. limit is probably 64
		
		// data coverpoint is not required. Here we are testing each feature of DUT

		WR_RD_ADDR_CROSS : cross WR_RD_CP, ADDR_CP { // cross meaning each possibility combined
			//option.weight = 3; // weightage of 3
		}
	endgroup

	function new(int i);
		mem_cg = new();
		cov_no = i;
	endfunction
	
	task run();
		forever begin
			mem_common::mon2cov.get(tx);
			-> mem_cg_e;
			// trigger event or mem_cg.sample();
		end
	endtask
endclass
