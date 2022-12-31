class mem_bfm;
	mem_tx tx;
	int bfm_no;
	virtual mem_intf.bfm_mp vif;

	function new(int i);
		//vif = mem_common::vif; doesn't work!!!
		vif = tb_top.pif;
		bfm_no = i;
	endfunction

	 task run();
	 	forever begin
			mem_common::gen2bfmDA[bfm_no].get(tx);
			mem_common::smp.get(1);
			drive_tx(tx);
			mem_common::smp.put(1);
			mem_common::tx_packets++; // counter logic to finish simulation
		end
	 endtask

	 task drive_tx(mem_tx tx);
		@ (vif.bfm_cb); // one clock after ready is zero, bcz ready is sampled before active edge
		vif.bfm_cb.addr <= tx.addr;
		if (tx.wr_en == 1) vif.bfm_cb.wdata <= tx.wdata;
		vif.bfm_cb.wr_en <= tx.wr_en;
		vif.bfm_cb.valid <= 1;
		wait (vif.bfm_cb.ready == 1); // it will stay here till its acutally sampled by clocking block
		vif.bfm_cb.addr <= 0;
		vif.bfm_cb.wdata <= 0;
		vif.bfm_cb.wr_en <= 0;
		vif.bfm_cb.valid <= 0;	 
		@(vif.bfm_cb); // one extra for ready to get zero
	 endtask
endclass
