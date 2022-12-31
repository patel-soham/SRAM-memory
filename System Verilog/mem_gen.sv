class mem_gen;
	int gen_no;
	mem_tx tx;
	bit [`ADDR_WIDTH-1:0] addrQ [$]; 

	function new(int i);
		gen_no = i;
	endfunction

	task run();
		case(mem_common::testcase)
			"test_wr_rd": begin
				// writing data
				tx = new();
				assert(tx.randomize() with {tx.wr_en == 1;});
				mem_common::gen2bfmDA[gen_no].put(tx);

				// read data
				tx = new();
				assert(tx.randomize() with {tx.wr_en == 0; tx.addr == tx.addr;});
				mem_common::gen2bfmDA[gen_no].put(tx);
			end
			"test_n_wr_rd": begin
				repeat(mem_common::count) begin
					// writing data
					tx = new();
					assert(tx.randomize() with {tx.wr_en == 1;});
					addrQ.push_back(tx.addr); 
					mem_common::gen2bfmDA[gen_no].put(tx);
				end
				repeat(mem_common::count) begin
					// read data
					tx = new();
					//assert(tx.randomize() with {tx.wr_en == 0; tx.addr == addrQ.pop_front()});
					// doesn't work. It doesn't pop just keeps peeking front
					//assert(tx.randomize() with {tx.wr_en == 0;}); use this OR
					tx.wr_en = 0;
					tx.addr = addrQ.pop_front();
					mem_common::gen2bfmDA[gen_no].put(tx);
				end
			end
		endcase
	endtask
endclass
