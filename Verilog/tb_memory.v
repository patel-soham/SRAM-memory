`include "memory.v" 
module tb;

parameter ADDR_WIDTH=6, // addr bus width to access memory
 	  DEPTH=64, // total no of locations in memory
	  WIDTH=16, // size of each location in memmory
	  MIN=1, // Min iterations for random read write test for either operation at a time
	  MAX=6, // Max iterations for random read write test for either operation at a time
	  TOTAL_CYCLES=10; // Total number of read and write random iterations for random wr/rd test case

// rst = Active high synchronous reset
reg clk, rst, wr_en, valid; 
reg [ADDR_WIDTH-1:0] addr;
reg [WIDTH-1:0] wdata;
wire [WIDTH-1:0] rdata;
wire ready;
integer i, j, k, random_address;
reg [30*8:1] testname;

memory #(.WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .DEPTH(DEPTH)) u0 (.clk(clk), .rst(rst), .wr_en(wr_en), .valid(valid), .addr(addr), .wdata(wdata), .rdata(rdata), .ready(ready));

always #5 clk = ~clk;

initial begin
	$value$plusargs("testname=%s",testname);
	$display("%s",testname);
	
	clk = 0;
	wr_en = 0;
	valid = 0;
	addr = 0;
	wdata = 0;
	i = 0;
	j = 0;
	k = 0;
	random_address = 0;

	rst = 1;
	#20
	rst = 0;
	case (testname) 
		// front door write and front door read 
		"fd_wr_fd_rd" : begin 
			fd_write_memory(0, DEPTH-1); // NOTE** DEPTH starts from 1
			fd_read_memory(0, DEPTH-1);
		end
		// back door write and back door read 
		"bd_wr_bd_rd" : begin
			bd_write_memory(0, DEPTH-1); 
			bd_read_memory(0, DEPTH-1);
		end
		// back door write and front door read 
		"bd_wr_fd_rd" : begin
			bd_write_memory(0, DEPTH-1); 
			fd_read_memory(0, DEPTH-1);
		end
		// front door write and back door read 
		"fd_wr_bd_rd" : begin
			fd_write_memory(0, DEPTH-1); 
			bd_read_memory(0, DEPTH-1);
		end
		// front door random read wrtie operations. 
		// total operations here are equal to TOTAL_CYCLES 
		// each operation can repeat anywhere from MIN to MAX time before another
		"random_wr_rd" : begin
				for (j = 0; j < TOTAL_CYCLES; j = j+1) begin
					repeat ($urandom_range(MIN, MAX)) begin
						random_address = $urandom_range(0, DEPTH-1); // pick any random address to write
						fd_write_memory(random_address, 0); // writing to only location at a time
						repeat (2) @ (posedge clk); // wait for # clock edge before performing another round
					end
					
					repeat ($urandom_range(MIN, MAX)) begin
						random_address = $urandom_range(0, DEPTH-1); // pick any random address to read
						fd_read_memory(random_address, 0); // reading from only one location at a time
						repeat (2) @ (posedge clk); // wait for # clock edge before performing another round
					end
				end
		end
	endcase
			
	#100
	$finish;
end

// Reads from image_wr.hex and writes to memory
task bd_write_memory(input [ADDR_WIDTH-1:0] start_loc, input [ADDR_WIDTH-1:0] num_loc);
begin
	$readmemh("image_wr.hex", u0.mem, start_loc, start_loc+num_loc);
end
endtask

//Reads from memory and writes to image_rd.hex
task bd_read_memory(input [ADDR_WIDTH-1:0] start_loc, input [ADDR_WIDTH-1:0] num_loc);
begin
	$writememh("image_rd.hex", u0.mem, start_loc, start_loc+num_loc);
end
endtask

// Writing random values to each memory location
task fd_write_memory(input [ADDR_WIDTH-1:0] start_loc, input [ADDR_WIDTH-1:0] num_loc);
begin
	for (i=start_loc; i<=(start_loc+num_loc); i=i+1) begin
		@(posedge clk);
		addr = i;
		wdata = $random;
		wr_en = 1;
		valid = 1;
		wait (ready == 1);
	end
	@(posedge clk);
	addr = 0;
	wdata = 0;
	wr_en = 0;
	valid = 0;
end
endtask

// Reading values from each memory location
task fd_read_memory(input [ADDR_WIDTH-1:0] start_loc, input [ADDR_WIDTH-1:0] num_loc);
begin
	for (k=start_loc; k<=(start_loc+num_loc); k=k+1) begin
		@(posedge clk);
		addr = k;
		wr_en = 0;
		valid = 1;
		wait (ready == 1);
	end
	@(posedge clk);
	addr = 0;
	wdata = 0;
	wr_en = 0;
	valid = 0;
end
endtask

endmodule	
