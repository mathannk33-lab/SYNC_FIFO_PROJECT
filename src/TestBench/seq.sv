class random_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(random_sequence)
 
	trans req;
 
	function new(string name="random_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(10000) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize());
			finish_item(req);
		end
	endtask
 
endclass
 
class idle_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(idle_sequence)
 
	trans req;
 
	function new(string name="idle_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(2000) begin
			req = trans::type_id::create("req");
			start_item(req);
			req.wr_cs   = 0;
			req.wr_en   = 0;
			req.rd_cs   = 0;
			req.rd_en   = 0;
			req.data_in = $urandom;
			finish_item(req);
		end
	endtask
 
endclass
 
class write_only_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(write_only_sequence)
 
	trans req;
 
	function new(string name="write_only_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(5000) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 0; rd_en == 0;});
			finish_item(req);
		end
	endtask
 
endclass
 
class read_only_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(read_only_sequence)
 
	trans req;
 
	function new(string name="read_only_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(500) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 0; wr_en == 0; rd_cs == 1; rd_en == 1;});
			finish_item(req);
		end
	endtask
 
endclass
 
class write_read_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(write_read_sequence)
 
	trans req;
 
	function new(string name="write_read_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(500) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 0; rd_en == 0;});
			finish_item(req);
 
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 0; wr_en == 0; rd_cs == 1; rd_en == 1;});
			finish_item(req);
		end
	endtask
 
endclass
 
class read_write_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(read_write_sequence)
 
trans req;
 
	function new(string name="read_write_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(500) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 0; wr_en == 0; rd_cs == 1; rd_en == 1;});
			finish_item(req);
 
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 0; rd_en == 0;});
			finish_item(req);
		end
	endtask
 
endclass
 
class mixed_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(mixed_sequence)
 
	trans req;
 
	function new(string name="mixed_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(500) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 0; rd_en == 0;});
			finish_item(req);
		end
 
		repeat(500) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 0; wr_en == 0; rd_cs == 1; rd_en == 1;});
			finish_item(req);
		end
 
		repeat(500) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 1; rd_en == 1;});
			finish_item(req);
		end
	endtask
 
endclass
 
class simul_wr_rd_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(simul_wr_rd_sequence)
 
	trans req;
  
 	function new(string name="simul_wr_rd_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(1000) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 1; rd_en == 1;});
			finish_item(req);
		end
	endtask
 
endclass
 
class fifo_full_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(fifo_full_sequence)
 
	trans req;
 
	function new(string name="fifo_full_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(256) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 0; rd_en == 0;});
			finish_item(req);
		end
 
		req = trans::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 0; rd_en == 0;});
		finish_item(req);
	endtask
 
endclass
 
class fifo_empty_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(fifo_empty_sequence)
 
	trans req;
 
	function new(string name="fifo_empty_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(257) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 0; rd_en == 0;});
			finish_item(req);
		end
 
		repeat(257) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 0; wr_en == 0; rd_cs == 1; rd_en == 1;});
			finish_item(req);
		end
 
		req = trans::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {wr_cs == 0; wr_en == 0; rd_cs == 1; rd_en == 1;});
		finish_item(req);
	endtask
 
endclass
 
class write_idle_read_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(write_idle_read_sequence)
 
	trans req;
 
	function new(string name="write_idle_read_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(500) begin
			req = trans::type_id::create("req");
			start_item(req);
			req.wr_cs   = 1;
			req.wr_en   = 1;
			req.rd_cs   = 0;
			req.rd_en   = 0;
			req.data_in = $urandom_range(0, 255);
			finish_item(req);
		end
 
		repeat(300) begin
			req = trans::type_id::create("req");
			start_item(req);
			req.wr_cs   = 0;
			req.wr_en   = 0;
			req.rd_cs   = 0;
			req.rd_en   = 0;
			finish_item(req);
		end
 
		repeat(500) begin
			req = trans::type_id::create("req");
			start_item(req);
			req.wr_cs   = 0;
			req.wr_en   = 0;
			req.rd_cs   = 1;
			req.rd_en   = 1;
			finish_item(req);
		end
	endtask
 
endclass
 
class full_empty_max_sequence extends uvm_sequence #(trans);
 
	`uvm_object_utils(full_empty_max_sequence)
 
	trans req;
 
	function new(string name="full_empty_max_sequence");
		super.new(name);
	endfunction
 
	task body();
		repeat(256) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 1; wr_en == 1; rd_cs == 0; rd_en == 0;});
			finish_item(req);
		end
 
		repeat(256) begin
			req = trans::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {wr_cs == 0; wr_en == 0; rd_cs == 1; rd_en == 1;});
			finish_item(req);
		end
	endtask
 
endclass
