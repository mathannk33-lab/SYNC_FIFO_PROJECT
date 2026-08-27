
class test extends uvm_test;
	`uvm_component_utils(test)
 env env_h;
 fifo_config m_cfg;
  random_sequence s1;

 function new(string name="test",uvm_component parent);
	super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);

  m_cfg=fifo_config::type_id::create("m_cfg");
  if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",m_cfg.vif))
	`uvm_fatal(get_type_name,"Can't get the interface")
  m_cfg.input_agent_is_active=UVM_ACTIVE;
  m_cfg.output_agent_is_active=UVM_PASSIVE;

   uvm_config_db#(fifo_config)::set(this,"*","fifo_config",m_cfg);
  env_h=env::type_id::create("env_h",this);

 endfunction

 function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
   uvm_top.print_topology();
 endfunction
 
 task run_phase(uvm_phase phase);
 phase.raise_objection(this);
   s1=random_sequence::type_id::create("s1");
   fork
     s1.start(env_h.inp_agt_h.seqr_h);
   join
 phase.drop_objection(this);
 #30;
endtask
endclass

