class mem_agent;
	int agent_no;
	mem_bfm bfm;
	mem_gen gen;

	function new(int i);
		agent_no = i;
		bfm = new(agent_no);
		gen = new(agent_no);
	endfunction

	
	task run();
		fork
			bfm.run();
			gen.run();
		join_none
	endtask
endclass
