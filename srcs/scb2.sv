class scoreboard;
transaction trans;
mailbox #(transaction) mon2scb;

int stall_cnt;
bit read_pending;
bit [`DATA_WIDTH-1:0] pending_prdata;

function new(mailbox #(transaction) mon2scb);
  this.mon2scb = mon2scb;
  $display("SCOREBOARD started");
endfunction

task run();
  repeat(`num_of_transaction) begin
    mon2scb.get(trans);
    $display("[SCB] %p", trans);

    if (trans.transfer && !trans.PSEL) begin
      stall_cnt++;
      if (stall_cnt > `TIMEOUT)
        $error("[SCB] PROTOCOL ERROR: PSEL never asserted, addr_in=%0h", trans.addr_in);
    end
    else if (trans.PSEL && !trans.PENABLE) begin
      stall_cnt++;
      if (stall_cnt > `TIMEOUT)
        $error("[SCB] PROTOCOL ERROR: PENABLE never asserted, addr_in=%0h", trans.addr_in);
    end
    else
      stall_cnt = 0;

    if (trans.PSEL && trans.PENABLE && trans.PREADY) begin
      if (trans.write_read) begin
        if (trans.write_read != trans.PWRITE)
          $error("[SCB] write_read = %0b, PWRITE = %0b", trans.write_read, trans.PWRITE);
        if (trans.addr_in != trans.PADDR)
          $error("[SCB] addr_in = %0h, PADDR = %0h", trans.addr_in, trans.PADDR);
        if (trans.wdata_in != trans.PWDATA)
          $error("[SCB] wdata_in = %0h, PWDATA = %0h", trans.wdata_in, trans.PWDATA);
        if (trans.strb_in != trans.PSTRB)
          $error("[SCB] strb_in = %0h, PSTRB = %0h", trans.strb_in, trans.PSTRB);
      end
      else begin
        pending_prdata = trans.PRDATA;
        read_pending    = 1;
      end
    end

    else if (read_pending) begin
      if (trans.PSLVERR !== trans.error)
        $error("[SCB] PSLVERR = %0b, error = %0b", trans.PSLVERR, trans.error);
      if (trans.rdata_out !== pending_prdata)
        $error("[SCB] PRDATA = %0h, rdata_out = %0h", pending_prdata, trans.rdata_out);
      if (!trans.transfer_done)
        $error("[SCB] transfer_done did not assert after completed read access");
      read_pending = 0;
    end
  end
endtask
endclass
