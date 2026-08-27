interface fifo_if(input bit clk);

logic rst,wr_cs,rd_cs,wr_en,rd_en,full,empty;
logic [7:0] data_in;
logic [7:0] data_out;

clocking inp_dr_cb@(posedge clk);
	default input #1 output #1;
	output rst,wr_cs,rd_cs,wr_en,rd_en,data_in;
endclocking

clocking inp_mon_cb@(posedge clk);
	default input #1 output #1;
	input rst,wr_cs,rd_cs,wr_en,rd_en,data_in;
endclocking

clocking out_mon_cb @(posedge clk);
	default input #0 output #0;
	input rst,wr_cs,rd_cs,wr_en,rd_en,full,empty,data_in,data_out;
endclocking

modport INP_DRV(clocking inp_dr_cb);
modport INP_MON(clocking inp_mon_cb);
modport OUT_MON(clocking out_mon_cb);

endinterface
