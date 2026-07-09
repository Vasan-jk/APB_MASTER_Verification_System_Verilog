class monitor;
transaction trans;
mailbox #(transaction)mon2scb;
virtual intf vif;

function new(mailbox #(transaction)mon2scb, virtual intf vif);
	this.mon2scb = mon2scb;
	this.vif = vif;
	$display("MONITOR started");
endfunction
task run();
        repeat(4) @(vif.mon_cb);
        repeat(`num_of_transaction) begin
                @(vif.mon_cb);
                trans = new();
		vif.mon_cb.PRDATA = trans.PRDATA;
		vif.mon_cb.PREADY = trans.PREADY; 
		vif.mon_cb.PSLVERR = trans.PSLVERR;
		vif.mon_cb.transfer =  write_read, addr_in, wdata_in, strb_in;
input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB, rdata_out, transfer_done, error;               
                trans.data_out = vif.mon_cb.data_out;
        end
        @(vif.mon_cb);
endtask

endclass
