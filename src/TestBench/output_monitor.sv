
class output_monitor extends uvm_monitor;
`uvm_component_utils(output_monitor)
uvm_analysis_port#(trans) out_monitor_port;
virtual fifo_if.OUT_MON vif;
fifo_config m_cfg;
trans t;

function new(string name="output_monitor",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
  if(!uvm_config_db#(fifo_config)::get(this,"","fifo_config",m_cfg))
`uvm_fatal(get_type_name(),"output_monitor getting failed")
    out_monitor_port=new("out_monitor_port",this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif=m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
t=trans::type_id::create("t");
repeat(5) @(vif.out_mon_cb);
forever begin
collect_data();
`uvm_info("output_monitor",$sformatf("output monitor wr_cs=%0b|rd_cs=%0b|wr_en=%0b|rd_en=%0b|data_in=%0d",t.wr_cs,t.rd_cs,t.wr_en,t.rd_en,t.data_in),UVM_NONE)
end
endtask

virtual task collect_data();
begin
@(vif.out_mon_cb);
begin
t.full=vif.out_mon_cb.full;
t.empty=vif.out_mon_cb.empty;
t.data_out=vif.out_mon_cb.data_out;
out_monitor_port.write(t);
end
end
endtask
endclass
