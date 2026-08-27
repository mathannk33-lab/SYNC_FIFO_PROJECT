class scoreboard extends uvm_scoreboard;
 
	`uvm_component_utils(scoreboard)
 
  uvm_tlm_analysis_fifo #(trans) inp_mon_fifo;

  uvm_tlm_analysis_fifo #(trans) out_mon_fifo;
 
	trans expected_data;

	trans actual_data;
 
	trans exp_data_queue[$];
 
	bit [7:0] fifo_mem[0:255];
 
	bit exp_full;

	bit exp_empty;
 
	int status_count;

	int wr_pointer;

	int rd_pointer;
 
	int pass_count;

	int fail_count;
 
	function new(string name="scoreboard", uvm_component parent);

		super.new(name, parent);
 
		inp_mon_fifo  = new("input_seq", this);

		out_mon_fifo = new("output_seq", this);
 
		status_count = 0;

		wr_pointer   = 0;

		rd_pointer   = 0;

		pass_count   = 0;

		fail_count   = 0;

	endfunction
 
  function void ref_model(ref trans s);

		bit can_write = s.wr_cs && s.wr_en && (status_count < 256);

		bit can_read  = s.rd_cs && s.rd_en && (status_count > 0);
 
		if(can_read) begin

			s.data_out = fifo_mem[rd_pointer];

			rd_pointer = (rd_pointer + 1) % 256;

		end

		else

			s.data_out = '0;
 
		if(can_write) begin

			fifo_mem[wr_pointer] = s.data_in;

			wr_pointer = (wr_pointer + 1) % 256;

		end
 
		case({can_write, can_read})

			2'b10: status_count++;

			2'b01: status_count--;

			2'b11: status_count = status_count;

			2'b00: status_count = status_count;

		endcase
 
		s.full  = (status_count == 256);

		s.empty = (status_count == 0);

	endfunction
 
	task run_phase(uvm_phase phase);

		forever begin

			inp_mon_fifo.get(expected_data);
 
			ref_model(expected_data);

			$display("[%0t] SCOREBOARD : EXPECTED VALUES", $time);

			$display("EXP_DATA=0x%0h EXP_FULL=%0b EXP_EMPTY=%0b",

				expected_data.data_out,

				expected_data.full,

				expected_data.empty);
 
			exp_data_queue.push_front(expected_data);
 
			out_mon_fifo.get(actual_data);

			$display("[%0t] SCOREBOARD : ACTUAL DUT OUTPUT", $time);

			$display("ACT_DATA=0x%0h ACT_FULL=%0b ACT_EMPTY=%0b",

				actual_data.data_out,

				actual_data.full,

				actual_data.empty);
 
			compare(exp_data_queue.pop_back(), actual_data);

		end

	endtask
 
  task compare(trans exp_data, trans act_data);

		bit test_fail = 0;
 
		if(exp_data.rd_cs && exp_data.rd_en) begin

			if(exp_data.data_out == act_data.data_out)

				$display("[%0t] DATA MATCH     EXP=0x%0h  ACT=0x%0h", $time, exp_data.data_out, act_data.data_out);

			else begin

				$display("[%0t] DATA MISMATCH  EXP=0x%0h  ACT=0x%0h", $time, exp_data.data_out, act_data.data_out);

				test_fail = 1;

			end

		end
 
		if(exp_data.full == act_data.full)

			$display("[%0t] FULL FLAG  MATCH      EXP=%0b ACT=%0b",

				$time,

				exp_data.full,

				act_data.full);

		else begin

			$display("[%0t] FULL FLAG  MISMATCH   EXP=%0b ACT=%0b",

				$time,

				exp_data.full,

				act_data.full);

			test_fail = 1;

		end
 
		if(exp_data.empty == act_data.empty)

			$display("[%0t] EMPTY FLAG MATCH      EXP=%0b ACT=%0b",

				$time,

				exp_data.empty,

				act_data.empty);

		else begin

			$display("[%0t] EMPTY FLAG MISMATCH   EXP=%0b ACT=%0b",

				$time,

				exp_data.empty,

				act_data.empty);

			test_fail = 1;

		end
 
		if(test_fail) begin

			fail_count++;

			$display("[%0t]TRANSACTION FAILED ", $time);

		end

		else begin

			pass_count++;

			$display("[%0t] TRANSACTION PASSED ", $time);

		end

	endtask
 
	function void report_phase(uvm_phase phase);

		super.report_phase(phase);
 
		`uvm_info("SCOREBOARD",

			$sformatf("\n=============================================\n\

           SCOREBOARD FINAL REPORT\n\

=============================================\n\

TOTAL PASSED = %0d\n\

TOTAL FAILED = %0d\n\

TOTAL CHECKS = %0d\n\

=============================================",

				pass_count,

				fail_count,

				pass_count+fail_count),

			UVM_NONE)
 
		if(fail_count == 0)

			`uvm_info("SCOREBOARD",

				"************* TEST PASSED *************",

				UVM_NONE)

		else

			`uvm_error("SCOREBOARD",

				$sformatf("************* TEST FAILED (%0d Errors) *************",

				fail_count))

	endfunction
 
endclass
 
