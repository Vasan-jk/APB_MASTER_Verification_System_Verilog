//`include "transaction.sv"
//`include "interface.sv"
class driver;
transaction trans;
mailbox #(transaction)gen2drv;
virtual intf.drv vif;
//bit [`DATA_WIDTH - 1:0] mem [bit[`ADDR_WIDTH - 1:0]];

covergroup apb_cg;
  read_write_cg: coverpoint trans.write_read  {
                                        bins read = {0};
                                        bins write = {1};
}
  transfer_cg: coverpoint trans.transfer  {
                                        bins transfer_bin = {1};
}
  addr_cg: coverpoint trans.addr_in  {
                                        bins addr[4] = {[0:31]};
}
  wdata_cg: coverpoint trans.wdata_in  {
                                        bins wdata_in[8] = {[0:32'hFFFF_FFFF]};
}
  transfer_done_cg: coverpoint trans.transfer_done  {
                                        bins transfer_done = {1};
}
  prdata_cg: coverpoint trans.PRDATA  {
                                        bins PRDATA[8] = {[0:32'hFFFF_FFFF]};
}
  slverr_cg: coverpoint trans.PSLVERR  {
                                        bins SLVERR = {1};
}
  strbin_cg: coverpoint trans.strb_in  {
                                        bins strb_in = {1,3,7,15};
}
  pready_cg: coverpoint trans.PREADY  {
                                        bins pready = {1};
}
endgroup
function new(mailbox #(transaction)gen2drv, virtual intf.drv vif);
  this.gen2drv = gen2drv;
  this.vif = vif;
  apb_cg = new();
  $display("DRIVER started");
endfunction

task run();
  repeat(4) @(vif.drv_cb);
  repeat(`num_of_transaction) begin
    trans = new();
    gen2drv.get(trans);
    $display("[%0t][DRV]%p",$time,trans);
    apb_cg.sample();
    //begin
    //if(trans.write_read)
    //      mem[trans.addr_in] = trans.wdata_in;
    //else
          //if(mem[trans.addr_in].exist())
    //      trans.PRDATA = mem[trans.addr_in];
    //end
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
        //wait(vif.drv_cb.PSEL && vif.drv_cb.PENABLE);
        
        //for(int i = 0; i < trans.wait_state; i++) begin
        //@(vif.drv_cb);
        //vif.drv_cb.PRDATA <= trans.PRDATA;
        //vif.drv_cb.PREADY <= 0;
        //vif.drv_cb.PSLVERR <= trans.PSLVERR;
        //end
          vif.drv_cb.PRDATA <= trans.PRDATA;
          vif.drv_cb.PREADY <= trans.PREADY;
          vif.drv_cb.PSLVERR <= trans.PSLVERR;
          vif.drv_cb.PRDATA <= trans.PRDATA; 
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
