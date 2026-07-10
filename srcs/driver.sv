//`include "transaction.sv"
//`include "interface.sv"
class driver;
transaction trans;
mailbox #(transaction)gen2drv;
virtual intf.drv vif;
bit [`DATA_WIDTH - 1:0] mem [bit[`ADDR_WIDTH - 1:0]];

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
    begin
      if(trans.write_read)
          mem[trans.addr_in] = trans.wdata_in;
      else
          trans.PRDATA = mem[trans.addr_in];
    end
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
    else 
    fork 
    begin
    repeat(1) @(vif.drv_cb);
        vif.drv_cb.transfer <= trans.transfer;
        vif.drv_cb.write_read <= trans.write_read;
        vif.drv_cb.addr_in <= trans.addr_in;
        vif.drv_cb.wdata_in <= trans.wdata_in;
        vif.drv_cb.strb_in <= trans.strb_in;
        wait(vif.drv_cb.PSEL && vif.drv_cb.PENABLE);
        
        for(int i = 0; i < trans.wait_state; i++) begin
          @(vif.drv_cb);
          vif.drv_cb.PRDATA <= trans.PRDATA;
          vif.drv_cb.PREADY <= 0;
          vif.drv_cb.PSLVERR <= trans.PSLVERR;
        end
          vif.drv_cb.PRDATA <= trans.PRDATA;
          vif.drv_cb.PREADY <= 1;
          vif.drv_cb.PSLVERR <= trans.PSLVERR;
          vif.drv_cb.PRDATA <= trans.PRDATA; 
          wait(vif.drv_cb.transfer_done);
       $display("[%0t][DRV] PRDATA = %0h, PREADY = %0h, PSLVERR = %0b, transfer = %0b, write_read = %b, addr_in = %0h, wdata_in = %0h, strb_in = %0h",$time,trans.PRDATA, trans.PREADY, trans.PSLVERR, trans.transfer, trans.write_read, trans.addr_in, trans.wdata_in, trans.strb_in);
    repeat(1) @(vif.drv_cb);
    end
    begin
      wait(!(vif.PRESETn));
    end
    join_any
    if(!vif.PRESETn) begin
      vif.drv_cb.PRDATA <= 'b0;
      vif.drv_cb.PREADY <= 'b0; 
      vif.drv_cb.PSLVERR <= 'b0;
      vif.drv_cb.transfer <= 'b0;
      vif.drv_cb.write_read <= 'b0;
      vif.drv_cb.addr_in <= 'b0;
      vif.drv_cb.wdata_in <= 'b0;
      vif.drv_cb.strb_in <= 'b0;  
    end
    
  end
  

endtask
endclass
