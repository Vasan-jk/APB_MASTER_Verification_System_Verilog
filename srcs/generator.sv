//`include "transaction.sv"
class generator;
transaction trans;
transaction copy;
mailbox #(transaction)gen2drv;

function new(mailbox #(transaction)gen2drv);
	this.gen2drv = gen2drv;
	trans = new();
	$display("GENERATOR started");
endfunction

task run();
	repeat(`num_of_transaction) begin
		copy = new trans;
		assert(copy.randomize());
		gen2drv.put(copy);
		$display("[GEN] PRDATA = %0h, PREADY = %0h, PSLVERR = %0b, transfer = %0b, write_read = %b, addr_in = %0h, wdata_in = %0h, strb_in = %0h",copy.PRDATA, copy.PREADY, copy.PSLVERR, copy.transfer, copy.write_read, copy.addr_in, copy.wdata_in, copy.strb_in);
	end
endtask

endclass
