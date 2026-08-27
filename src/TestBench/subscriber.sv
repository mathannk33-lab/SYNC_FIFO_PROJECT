class subscriber extends uvm_subscriber #(trans);
`uvm_component_utils(subscriber)
trans in_mon;

covergroup cg;
wr_cs:coverpoint in_mon.wr_cs {bins b[]={0,1};}
rd_cs:coverpoint in_mon.rd_cs {bins b[]={0,1};}
wr_en:coverpoint in_mon.rd_en {bins b[]={0,1};}
rd_en:coverpoint in_mon.rd_en {bins b[]={0,1};}
datai:coverpoint in_mon.data_in {bins b[10]={[0:255]};}

endgroup

function new(string name="subscriber",uvm_component parent);
super.new(name,parent);
cg=new();
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

function void write(trans t);
in_mon =t ;
cg.sample();
`uvm_info(get_name(),"[subsceriber]:input received",UVM_HIGH);
endfunction

endclass

