// scoreboard acts as reference to check whether DUT is working fine or not
// here we make reference memory and inset data during write 
// and check data during read with refrence memory and DUT data
class mem_scb;
	// Associative array behaves as reference memory
 	logic [`WIDTH-1:0] ref_mem [logic [`ADDR_WIDTH-1:0]];
	mem_tx tx;

	task run();
		forever begin
			mem_common::mon2ref.get(tx);
			if (tx.wr_en == 1) begin
				ref_mem[tx.addr] = tx.wdata;
			end
			else begin
				if (ref_mem[tx.addr] == tx.rdata) 
					mem_common::match++;
				else begin
					mem_common::mismatch++;
					$display("Missmatch at Addr=%0h DUT Data=%0h Reference Data=%0h",tx.addr, tx.rdata, ref_mem[tx.addr]);
				end
			end
		end
	endtask
endclass
