`timescale 1ns/100ps
`include "defines.svh"
`include "package.sv"
`include "interface.sv"
`include "apb_master.sv"
module top;

    import apb_package::*;

    logic clk;
    logic reset;

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        reset = 0;
        repeat (1) @(posedge clk);
        reset = 1;
        repeat (1) @(posedge clk);
  reset = 0;
        repeat (1) @(posedge clk);
  reset = 1;
    end


    intf intrf(clk, reset);
apb_master #(.ADDR_WIDTH(`ADDR_WIDTH),.DATA_WIDTH(`DATA_WIDTH)) 
dut (.PCLK(clk),.PRESETn(rst),.PADDR(intrf.PADDR),.PSEL(intrf.PSEL),.PENABLE(intrf.PENABLE),.PWRITE(intrf.PWRITE),.PWDATA(intrf.PWDATA),.PSTRB(intrf.PSTRB),.PRDATA(intrf.PRDATA),.PREADY(intrf.PREADY),.PSLVERR(intrf.PSLVERR),.transfer(intrf.transfer),.write_read(intrf.write_read),.addr_in(intrf.addr_in),.wdata_in(intrf.wdata_in),.strb_in(intrf.strb_in),.rdata_out(intrf.rdata_out),.transfer_done(intrf.transfer_done),.error(intrf.error));

    test tst;
    initial begin
        tst = new(intrf.drv, intrf.mon);
        $display("-------------------------BASE TEST-------------------------");
  tst.run();
  $finish();
    end
    initial begin
  $dumpfile("waveforms.fsdb"); // Create FSDB file
  $dumpvars(0, top); // Dump signals from top-level hierarchyi
     end
endmodule
