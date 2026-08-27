class trans extends uvm_sequence_item;
`uvm_object_utils(trans);
rand bit wr_cs,rd_cs,wr_en,rd_en;
rand bit[7:0] data_in;
logic rst,full,empty;
logic [7:0]data_out;

function new(string name="trans");
super.new(name);
endfunction

endclass
