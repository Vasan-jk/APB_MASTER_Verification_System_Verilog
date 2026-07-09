`include "transaction.sv"
`include "interface.sv"
class driver;
transaction trans;
mailbox #(transaction)gen2drv;
virtual intf.drv vif;

function new(mailbox #(transaction)gen2drv, virtual intf.drv vif);
	this.gen2drv = gen2drv;
	this.vif = vif;
	$display("DRIVER started");
endfunction

task run();
	repeat(4) @(vif.drv_cb);
	repeat(`num_of_transaction) begin
		trans = new();
		gen2drv.get(trans);
		repeat(1) @(vif.drv_cb);
		if(vif.PRESETn == 0) begin
			vif.drv_cb.PRDATA <= 'b0;
			vif.drv_cb.PREADY <= 'b0; 
			vif.drv_cb.PSLVERR <= 'b0;
			vif.drv_cb.transfer <= 'b0;
			vif.drv_cb.write_read <= 'b0;
			vif.drv_cb.addr_in <= 'b0;
			vif.drv_cb.wdata_in <= 'b0;
			vif.drv_cb.strb_in <= 'b0;
		repeat(1) @(vif.drv_cb);
		end
		else begin
		repeat(1) @(vif.drv_cb);
                        vif.drv_cb.PRDATA <= trans.PRDATA;
                        vif.drv_cb.PREADY <= trans.PREADY;
                        vif.drv_cb.PSLVERR <= trans.PSLVERR;
                        vif.drv_cb.transfer <= trans.transfer;
                        vif.drv_cb.write_read <= trans.write_read;
                        vif.drv_cb.addr_in <= trans.addr_in;
                        vif.drv_cb.wdata_in <= trans.wdata_in;
                        vif.drv_cb.strb_in <= trans.strb_in;
			 $display("[MON] PRDATA = %0h, PREADY = %0h, PSLVERR = %0b, transfer = %0b, write_read = %b, addr_in = %0h, wdata_in = %0h, strb_in = %0h",trans.PRDATA, trans.PREADY, trans.PSLVERR, trans.transfer, trans.write_read, trans.addr_in, trans.wdata_in, trans.strb_in);
		repeat(1) @(vif.drv_cb);
		end
		
	end
	

endtask
endclass
