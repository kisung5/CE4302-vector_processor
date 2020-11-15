`timescale 1 ps / 1 ps
module data_memory_tb;

logic clk, wren;
logic [18:0] addr;
logic [7:0] data, q;

// address, clock, data, wren, q
data_memory DUT (.address(addr), .clock(~clk), .wren(wren), .data(data), .q(q));

always #10 clk <= ~clk;

initial begin
	clk = 0;
	wren = 0;
	data = 8'b0;
	#5 addr = 19'h0;
	#50;
	#5 addr = 19'h1;
	#50;
	#5 addr = 19'h2;
	#50;
	#5 addr = 19'h3;
	#50;
	#5 addr = 19'h4;
	#50;
	#5 addr = 19'h4afff;
	#50;
	#5 addr = 19'h4b000;
end

endmodule 