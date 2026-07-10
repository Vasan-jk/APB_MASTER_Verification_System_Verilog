//`include "transaction.sv"
class scoreboard;
transaction trans;
mailbox #(transaction)mon2scb;
bit [`DATA_WIDTH - 1:0] mem [bit[`ADDR_WIDTH - 1:0]];


function new(mailbox #(transaction)mon2scb);
	this.mon2scb = mon2scb;
	$display("SCOREBOARD started");
endfunction

task run();
  repeat(`num_of_transaction) begin
  mon2scb.get(trans);
  if(trans.write_read) begin
    mem[trans.PADDR] = trans.PWDATA;
    if(trans.write_read != trans.PWRITE)begin
      $error("[SCB] write_read = %0b, PWRITE = %0b", trans.write_read, trans.PWRITE);
    end
    
    if(trans.addr_in != trans.PADDR) begin
      $error("[SCB] addr_in = %0h, PADDR = %0h", trans.addr_in, trans.PADDR);
    end

    if(trans.wdata_in != trans.PWDATA) begin
      $error("[SCB] wdata_in = %0h, PWDATA = %0h", trans.wdata_in, trans.PWDATA);
    end

    if(trans.strb_in != trans.PSTRB) begin
      $error("[SCB] strb_in = %0h, PSTRB = %0h",trans.strb_in, trans.PSTRB);
    end

  end
  else if(!trans.write_read) begin
    trans.PRDATA = mem[trans.PADDR];
    if((!trans.write_read) != (!trans.PWRITE)) begin
      $error("[SCB] write_read = %0b, PWRITE = %0b", trans.write_read, trans.PWRITE);
    end

    if(trans.PSLVERR != trans.error) begin
      $error("[SCB] PSLVERR = %0b, error = %0b", trans.PSLVERR, trans.error);
    end
  
    if(trans.PRDATA != trans.rdata_out) begin
      $error("[SCB] PRDATA = %0h, rdata_out = %0h", trans.PRDATA, trans.rdata_out);
    end
  end
  end
endtask
endclass
