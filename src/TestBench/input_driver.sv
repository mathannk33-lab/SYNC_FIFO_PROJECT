	
class input_driver extends uvm_driver#(trans);
`uvm_component_utils(input_driver);

virtual fifo_if.INP_DRV vif;
fifo_config m_cfg;

function new(string name="driver",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
  if(!uvm_config_db #(fifo_config)::get(this,"","fifo_config",m_cfg))
   `uvm_fatal(get_type_name(),"input_driver getting failed")
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif=m_cfg.vif;
endfunction

  task run_phase(uvm_phase phase);

@(vif.inp_dr_cb);
vif.inp_dr_cb.rst<=1'b1;
@(vif.inp_dr_cb);
vif.inp_dr_cb.rst<=1'b0;

forever 
begin
seq_item_port.get_next_item(req);
drive(req);
seq_item_port.item_done();
end
endtask

task drive(trans t);
begin
@(vif.inp_dr_cb);
vif.inp_dr_cb.wr_cs<=t.wr_cs;
vif.inp_dr_cb.rd_cs<=t.rd_cs;
vif.inp_dr_cb.wr_en<=t.wr_en;
vif.inp_dr_cb.rd_en<=t.rd_en;
vif.inp_dr_cb.data_in<=t.data_in;
`uvm_info("input driver",$sformatf("input driver wr_cs=%0b|rd_cs=%0b|wr_en=%0b|rd_en=%0b|data_in=%0d\n",t.wr_cs,t.rd_cs,t.wr_en,t.rd_en,t.data_in),UVM_NONE)

end
endtask

endclass
