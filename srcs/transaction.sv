`include "defines.svh"
class transaction;
rand bit [`DATA_WIDTH-1:0] PRDATA;
rand bit PREADY;
rand bit PSLVERR;
rand bit transfer;
rand bit write_read;
rand bit [`ADDR_WIDTH-1:0]addr_in;
rand bit [`DATA_WIDTH-1:0]wdata_in;
rand bit [`DATA_WIDTH/8 - 1:0]strb_in;
bit [`ADDR_WIDTH] PADDR;
bit PSEL;
bit PWRITE;
bit [`DATA_WIDTH-1:0]PWDATA;
bit [`DATA_WIDTH/8 -1:0]PSTRB;
bit [`DATA_WIDTH-1:0] rdata_out;
bit transfer_done;
bit error;

constraint base{
	PREADY == 1;
	transfer == 1;
	write_read == 1;
	strb_in == 4'b1111;
	PSLVERR == 0;
}
endclass
