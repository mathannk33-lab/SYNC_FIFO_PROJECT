
class output_agent extends uvm_agent;
`uvm_component_utils(output_agent)
output_monitor mon_h;
fifo_config m_cfg;

  function new(string name="output_agent",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
  if(!uvm_config_db#(fifo_config)::get(this,"","fifo_config",m_cfg))
`uvm_fatal(get_type_name(),"output agent getting failed")

if(m_cfg.output_agent_is_active==UVM_PASSIVE)
mon_h=output_monitor::type_id::create("mon_h",this);
endfunction

endclass
