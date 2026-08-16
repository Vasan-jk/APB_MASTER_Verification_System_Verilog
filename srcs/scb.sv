//`include "transaction.sv"
class scoreboard;
transaction trans;
mailbox #(transaction)mon2scb;


function new(mailbox #(transaction)mon2scb);
	this.mon2scb = mon2scb;
	$display("SCOREBOARD started");
endfunction

task run();
  int n, pass, fail;
  repeat(3) begin
  mon2scb.get(trans);
  n = 1;
  $display("[SCB] %p",trans);
  if(trans.PREADY && trans.PENABLE && trans.PSEL) begin
  if(trans.write_read) begin
    if(trans.write_read != trans.PWRITE)begin
      $error("[SCB] write_read = %0b, PWRITE = %0b", trans.write_read, trans.PWRITE);
      n = 0;  
    end
    if(trans.addr_in != trans.PADDR) begin
      $error("[SCB] addr_in = %0h, PADDR = %0h", trans.addr_in, trans.PADDR);
      n = 0;
    end

    if(trans.wdata_in != trans.PWDATA) begin
      $error("[SCB] wdata_in = %0h, PWDATA = %0h", trans.wdata_in, trans.PWDATA);
      n = 0;
    end

    if(trans.strb_in != trans.PSTRB) begin
      $error("[SCB] strb_in = %0h, PSTRB = %0h",trans.strb_in, trans.PSTRB);
      n = 0;
    end
    
  end
  else if(!trans.write_read) begin
    if((!trans.write_read) != (!trans.PWRITE)) begin
      $error("[SCB] write_read = %0b, PWRITE = %0b", trans.write_read, trans.PWRITE);
      n = 0;
    end

    if(trans.PSLVERR != trans.error) begin
      $error("[SCB] PSLVERR = %0b, error = %0b", trans.PSLVERR, trans.error);
      n = 0;
    end
  
    if(trans.PRDATA != trans.rdata_out) begin
      $error("[SCB] PRDATA = %0h, rdata_out = %0h", trans.PRDATA, trans.rdata_out);
      n = 0;
    end
  end

  if(n == 0)
    fail++;
  else
    pass++;
  end
  else begin
    $display("THIS TRANSACTION IS NOT CHECKED");
  end
  $display("PASS COUNT: %0d, FAIL COUNT: %0d", pass, fail);
end
endtask
endclass
