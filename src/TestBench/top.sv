// Code your testbench here
// or browse Examples
	`include "uvm_macros.svh"
	`include "fifo_if.sv"
	`include "ram_dp_ar_aw.sv"
	`include "design.sv"
	`include "test_pkg.sv"

 module top();       
	import uvm_pkg::*;
	import test_pkg::*;
	bit clk;

	fifo_if dut_if(clk);
       
	syn_fifo DUV(.clk(clk),.rst(dut_if.rst),.wr_cs(dut_if.wr_cs),.rd_cs(dut_if.rd_cs),.data_in(dut_if.data_in),.rd_en(dut_if.rd_en),.wr_en(dut_if.wr_en),.data_out(dut_if.data_out),.empty(dut_if.empty),.full(dut_if.full));

 	initial
	begin
		uvm_config_db#(virtual fifo_if)::set(null,"*","fifo_if",dut_if);
		$dumpfile("waves.fsdb");
		  $dumpvars;
	     	run_test("test");
	end
	initial
	begin
		clk=1'b0;
		forever 
		   #5 clk=~clk;
	end

endmodule
