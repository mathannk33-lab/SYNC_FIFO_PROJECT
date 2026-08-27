  class input_monitor extends uvm_monitor;
`uvm_component_utils(input_monitor)

uvm_analysis_port#(trans) inp_monitor_port;
virtual fifo_if.INP_MON vif;
fifo_config m_cfg;
trans t;

function new(string name="input_monitor",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(fifo_config)::get(this,"","fifo_config",m_cfg))
`uvm_fatal(get_type_name(),"input_monitor getting failed")
inp_monitor_port=new("inp_monitor_port",this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif=m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
t=trans::type_id::create("t");
repeat(3)@(vif.inp_mon_cb);
forever begin
collect_input_monitor();
`uvm_info("input monitor",$sformatf("input monitor wr_cs=%0b|rd_cs=%0b|wr_en=%0b|rd_en=%0b|data_in=%0d",t.wr_cs,t.rd_cs,t.wr_en,t.rd_en,t.data_in),UVM_NONE)
end
endtask

virtual task collect_input_monitor();
begin
@(vif.inp_mon_cb);
t.wr_cs=vif.inp_mon_cb.wr_cs;
t.rd_cs=vif.inp_mon_cb.rd_cs;
t.wr_en=vif.inp_mon_cb.wr_en;
t.rd_en=vif.inp_mon_cb.rd_en;
t.data_in=vif.inp_mon_cb.data_in;
inp_monitor_port.write(t);
end
endtask

endclass
