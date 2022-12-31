// Converts signals to tx packets for scoreboard, reference model, coverage 
class mem_mon;
	int mon_no;
	mem_tx tx;
	virtual mem_intf.mon_mp vif;

	function new(int i);
		//vif = mem_common::vif; doesn't work!!!
		vif = tb_top.pif;
		mon_no = i;
	endfunction
	
	task run();
		forever begin
			@ (vif.mon_cb);
			if (vif.mon_cb.valid == 1 && vif.mon_cb.ready == 1) begin
				tx = new();
				tx.addr = vif.mon_cb.addr;
				tx.wr_en = vif.mon_cb.wr_en;
				if (vif.mon_cb.wr_en == 1) tx.wdata = vif.mon_cb.wdata;
				else tx.rdata = vif.mon_cb.rdata;
				mem_common::mon2ref.put(tx); // sending tx packet to reference model 
				mem_common::mon2cov.put(tx); // sending tx packet to coverage model
			end
		end
	endtask

endclass
