class test;
virtual intf.drv drv_vif;
virtual intf.mon mon_vif;
environment env;

function new(virtual intf.drv drv_vif, virtual intf.mon mon_vif);
         this.drv_vif = drv_vif;
         this.mon_vif = mon_vif;
          $display("TEST started");
endfunction

task run();
 env=new(drv_vif,mon_vif);
 env.build;
 env.run;
endtask
endclass

class write_check extends test;
writ_check wc;

function new(virtual intf.drv drv_vif, virtual intf.mon mon_vif);
    super.new(drv_vif, mon_vif);
endfunction

task run();
 env=new(drv_vif,mon_vif);
 env.build;
 begin
  wc = new();
  env.gen.trans = wc;
 end 
 env.run;
endtask
endclass

class read_check extends test;
rd_check rd;

function new(virtual intf.drv drv_vif, virtual intf.mon mon_vif);
    super.new(drv_vif, mon_vif);
endfunction

task run();
 env=new(drv_vif,mon_vif);
 env.build;
 begin
  rd = new();
  env.gen.trans = rd;
 end 
 env.run;
endtask
endclass

class back_to_back_write extends test;
b2b_wr b2bwr;

function new(virtual intf.drv drv_vif, virtual intf.mon mon_vif);
    super.new(drv_vif, mon_vif);
endfunction

task run();
 env=new(drv_vif,mon_vif);
 env.build;
 begin
  b2bwr = new();
  env.gen.trans = b2bwr;
 end 
 env.run;
endtask
endclass

class back_to_back_read extends test;
b2b_rd b2brd;

function new(virtual intf.drv drv_vif, virtual intf.mon mon_vif);
    super.new(drv_vif, mon_vif);
endfunction

task run();
 env=new(drv_vif,mon_vif);
 env.build;
 begin
  b2brd = new();
  env.gen.trans = b2brd;
 end 
 env.run;
endtask
endclass
