//`include "interface.sv"
//`include "transaction.sv"
class monitor;
transaction trans;
mailbox #(transaction)mon2scb;
virtual intf.mon vif;

function new(mailbox #(transaction)mon2scb, virtual intf.mon vif);
	this.mon2scb = mon2scb;
	this.vif = vif;
	$display("INPUT MONITOR started");
endfunction
task run();
        repeat(4) @(vif.mon_cb);
        repeat(`num_of_transaction) begin
                @(vif.mon_cb);
                trans = new();
		trans.PRDATA = vif.mon_cb.PRDATA;
		trans.PSLVERR = vif.mon_cb.PSLVERR;
		trans.transfer = vif.mon_cb.transfer;
		trans.write_read = vif.mon_cb.write_read;
		trans.addr_in = vif.mon_cb.addr_in;
		trans.wdata_in = vif.mon_cb.wdata_in; 
		trans.strb_in = vif.mon_cb.strb_in;
    trans.PADDR = vif.mon_cb.PADDR;
    trans.PSEL = vif.mon_cb.PSEL;
    trans.PENABLE = vif.mon_cb.PENABLE;
    trans.PWRITE = vif.mon_cb.PWRITE;
    trans.PWDATA = vif.mon_cb.PWDATA;
    trans.PSTRB = vif.mon_cb.PSTRB;
    trans.rdata_out = vif.mon_cb.rdata_out;
    trans.transfer_done = vif.mon_cb.transfer_done;
    trans.error = vif.mon_cb.error;
    if(trans.PENABLE && trans.PREADY && trans.PSEL) begin
        mon2scb.put(trans);
    $display("[%0t][MONITOR] APB   : PADDR=%0h PSEL=%0b PENABLE=%0b PWRITE=%0b PWDATA=%0h PSTRB=%0h",$time,trans.PADDR,trans.PSEL,trans.PENABLE,trans.PWRITE,trans.PWDATA,trans.PSTRB);

    $display("[%0t][MONITOR] OUTPUT: rdata_out=%0h transfer_done=%0b error=%0b",$time,trans.rdata_out,trans.transfer_done,trans.error);
    
    $display("[%0t][MONITOR] INPUT : transfer=%0b write_read=%0b addr_in=%0h wdata_in=%0h strb_in=%0h",$time,trans.transfer,trans.write_read,trans.addr_in,trans.wdata_in,trans.strb_in);

		$display("[%0t][MONITOR] SLAVE : PRDATA=%0h PREADY=%0b PSLVERR=%0b",$time,trans.PRDATA,trans.PREADY,trans.PSLVERR);
    end
	end
        @(vif.mon_cb);
endtask

endclass
