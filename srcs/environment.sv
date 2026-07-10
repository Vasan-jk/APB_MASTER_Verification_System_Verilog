class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;

transaction trans;
mailbox #(transaction) gen2drv;
mailbox #(transaction) mon2scb;

virtual intf.mon mon_vif;
virtual intf.drv drv_vif;

event ev;

function new(virtual intf.drv drv_vif, virtual intf.mon mon_vif);
  this.drv_vif = drv_vif;
  this.mon_vif = mon_vif;
  $display("ENVIRONMENT started");
endfunction

task build();
  gen2drv = new();
  mon2scb = new();
  gen = new(gen2drv);
  drv = new(gen2drv, drv_vif);
  mon = new(mon2scb, mon_vif);
  scb = new(mon2scb);
  $display("ENVIRONMENT components built");
endtask

task run();
  fork
    gen.run();
    drv.run();
    mon.run();
    scb.run();
  join_any
  wait(scb.cnt == `num_of_transaction*2);
  $display("number of transaction: %0d", scb.cnt);
  repeat(2) @(drv_vif.drv_cb);
  -> ev;  
endtask
endclass
